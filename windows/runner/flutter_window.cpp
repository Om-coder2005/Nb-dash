#include "flutter_window.h"

#include <optional>
#include <windows.h>
#include <winspool.h>
#include <setupapi.h>
#include <initguid.h>
#include <gdiplus.h>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <algorithm>
#include <iostream>

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

// GUID_DEVINTERFACE_USBPRINT
DEFINE_GUID(GUID_DEVINTERFACE_USBPRINT, 0x28d272b6, 0x2367, 0x4513, 0x96, 0xb0, 0xd5, 0xa2, 0x79, 0x9a, 0x01, 0xa3);

static ULONG_PTR g_gdiplusToken = 0;

// Helper function to convert std::wstring to std::string (UTF-8)
static std::string WideToUtf8(const std::wstring& wstr) {
  if (wstr.empty()) return std::string();
  int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), NULL, 0, NULL, NULL);
  std::string strTo(size_needed, 0);
  WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), &strTo[0], size_needed, NULL, NULL);
  return strTo;
}

// Helper to convert std::string to std::wstring
static std::wstring Utf8ToWide(const std::string& str) {
  if (str.empty()) return std::wstring();
  int size_needed = MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), NULL, 0);
  std::wstring wstrTo(size_needed, 0);
  MultiByteToWideChar(CP_UTF8, 0, &str[0], (int)str.size(), &wstrTo[0], size_needed);
  return wstrTo;
}

// Helper to retrieve all Windows Spooler Printers
static std::vector<flutter::EncodableValue> GetPrintersList() {
  std::vector<flutter::EncodableValue> printers;
  DWORD cbNeeded = 0;
  DWORD dwReturned = 0;

  EnumPrintersW(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS, nullptr, 2, nullptr, 0, &cbNeeded, &dwReturned);
  if (cbNeeded == 0) {
    return printers;
  }

  std::vector<BYTE> buffer(cbNeeded);
  if (!EnumPrintersW(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS, nullptr, 2, buffer.data(), cbNeeded, &cbNeeded, &dwReturned)) {
    return printers;
  }

  PRINTER_INFO_2W* pPrinterInfo = reinterpret_cast<PRINTER_INFO_2W*>(buffer.data());
  for (DWORD i = 0; i < dwReturned; ++i) {
    flutter::EncodableMap printerMap;
    
    std::wstring name = pPrinterInfo[i].pPrinterName ? pPrinterInfo[i].pPrinterName : L"";
    std::wstring port = pPrinterInfo[i].pPortName ? pPrinterInfo[i].pPortName : L"";
    std::wstring driver = pPrinterInfo[i].pDriverName ? pPrinterInfo[i].pDriverName : L"";
    std::wstring comment = pPrinterInfo[i].pComment ? pPrinterInfo[i].pComment : L"";
    DWORD status = pPrinterInfo[i].Status;

    printerMap[flutter::EncodableValue("name")] = flutter::EncodableValue(WideToUtf8(name));
    printerMap[flutter::EncodableValue("port")] = flutter::EncodableValue(WideToUtf8(port));
    printerMap[flutter::EncodableValue("driver")] = flutter::EncodableValue(WideToUtf8(driver));
    printerMap[flutter::EncodableValue("comment")] = flutter::EncodableValue(WideToUtf8(comment));
    printerMap[flutter::EncodableValue("status")] = flutter::EncodableValue(static_cast<int64_t>(status));

    printers.push_back(flutter::EncodableValue(printerMap));
  }

  return printers;
}

// Helper to retrieve USB device VID/PID and link to Spooler Ports
static std::vector<flutter::EncodableValue> GetUsbDevicesList() {
  std::vector<flutter::EncodableValue> usbDevices;
  HDEVINFO hDevInfo = SetupDiGetClassDevsW(&GUID_DEVINTERFACE_USBPRINT, nullptr, nullptr, DIGCF_DEVICEINTERFACE | DIGCF_PRESENT);
  if (hDevInfo == INVALID_HANDLE_VALUE) {
    return usbDevices;
  }

  SP_DEVICE_INTERFACE_DATA interfaceData;
  interfaceData.cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);

  for (DWORD i = 0; SetupDiEnumDeviceInterfaces(hDevInfo, nullptr, &GUID_DEVINTERFACE_USBPRINT, i, &interfaceData); ++i) {
    DWORD requiredSize = 0;
    SetupDiGetDeviceInterfaceDetailW(hDevInfo, &interfaceData, nullptr, 0, &requiredSize, nullptr);
    if (requiredSize == 0) continue;

    auto detailData = (PSP_DEVICE_INTERFACE_DETAIL_DATA_W)malloc(requiredSize);
    if (!detailData) continue;
    detailData->cbSize = sizeof(SP_DEVICE_INTERFACE_DETAIL_DATA_W);

    SP_DEVINFO_DATA devInfoData;
    devInfoData.cbSize = sizeof(SP_DEVINFO_DATA);

    if (SetupDiGetDeviceInterfaceDetailW(hDevInfo, &interfaceData, detailData, requiredSize, nullptr, &devInfoData)) {
      std::wstring path(detailData->DevicePath);
      
      std::wstring vid = L"";
      std::wstring pid = L"";
      
      size_t vidPos = path.find(L"vid_");
      if (vidPos != std::wstring::npos && vidPos + 8 <= path.length()) {
        vid = path.substr(vidPos + 4, 4);
      }
      size_t pidPos = path.find(L"pid_");
      if (pidPos != std::wstring::npos && pidPos + 8 <= path.length()) {
        pid = path.substr(pidPos + 4, 4);
      }

      std::transform(vid.begin(), vid.end(), vid.begin(), ::towupper);
      std::transform(pid.begin(), pid.end(), pid.begin(), ::towupper);

      std::wstring portName = L"";
      HKEY hKey = SetupDiOpenDevRegKey(hDevInfo, &devInfoData, DICS_FLAG_GLOBAL, 0, DIREG_DEV, KEY_READ);
      if (hKey != INVALID_HANDLE_VALUE) {
        wchar_t valueBuf[256] = {0};
        DWORD valueBufSize = sizeof(valueBuf);
        if (RegQueryValueExW(hKey, L"PortName", nullptr, nullptr, (LPBYTE)valueBuf, &valueBufSize) == ERROR_SUCCESS) {
          portName = valueBuf;
        }
        RegCloseKey(hKey);
      }

      flutter::EncodableMap usbMap;
      usbMap[flutter::EncodableValue("path")] = flutter::EncodableValue(WideToUtf8(path));
      usbMap[flutter::EncodableValue("vendorId")] = flutter::EncodableValue(WideToUtf8(vid));
      usbMap[flutter::EncodableValue("productId")] = flutter::EncodableValue(WideToUtf8(pid));
      usbMap[flutter::EncodableValue("port")] = flutter::EncodableValue(WideToUtf8(portName));

      usbDevices.push_back(flutter::EncodableValue(usbMap));
    }
    free(detailData);
  }

  SetupDiDestroyDeviceInfoList(hDevInfo);
  return usbDevices;
}

// Print Raw bytes to a named Windows Spooler printer
static bool PrintRawBytes(const std::wstring& printerName, const std::vector<uint8_t>& bytes) {
  HANDLE hPrinter = nullptr;
  PRINTER_DEFAULTSW defaults = { nullptr, nullptr, PRINTER_ACCESS_USE };
  if (!OpenPrinterW(const_cast<LPWSTR>(printerName.c_str()), &hPrinter, &defaults)) {
    return false;
  }

  DOC_INFO_1W docInfo = { const_cast<LPWSTR>(L"NextBills RAW Receipt"), nullptr, const_cast<LPWSTR>(L"RAW") };
  DWORD dwJob = StartDocPrinterW(hPrinter, 1, reinterpret_cast<LPBYTE>(&docInfo));
  if (dwJob == 0) {
    ClosePrinter(hPrinter);
    return false;
  }

  if (!StartPagePrinter(hPrinter)) {
    EndDocPrinter(hPrinter);
    ClosePrinter(hPrinter);
    return false;
  }

  DWORD dwWritten = 0;
  BOOL success = WritePrinter(hPrinter, const_cast<LPVOID>(reinterpret_cast<const void*>(bytes.data())), static_cast<DWORD>(bytes.size()), &dwWritten);

  EndPagePrinter(hPrinter);
  EndDocPrinter(hPrinter);
  ClosePrinter(hPrinter);

  return success && (dwWritten == bytes.size());
}

// Print GDI+ Image file to printer Device Context (DC)
static bool PrintGDIImage(const std::wstring& printerName, const std::wstring& imagePath, int paperWidth) {
  HDC hdc = CreateDCW(L"WINSPOOL", printerName.c_str(), nullptr, nullptr);
  if (!hdc) {
    return false;
  }

  bool printSuccess = false;
  Gdiplus::Image* image = Gdiplus::Image::FromFile(imagePath.c_str());
  if (image && image->GetLastStatus() == Gdiplus::Ok) {
    int pageWidth = GetDeviceCaps(hdc, HORZRES);

    DOCINFOW docInfo = { sizeof(DOCINFOW) };
    docInfo.lpszDocName = L"NextBills GDI Receipt";

    if (StartDocW(hdc, &docInfo) > 0) {
      if (StartPage(hdc) > 0) {
        Gdiplus::Graphics graphics(hdc);
        
        float imgWidth = static_cast<float>(image->GetWidth());
        float imgHeight = static_cast<float>(image->GetHeight());

        // Target printable pixel boundaries at 203 DPI:
        // 80mm ~ 576 pixels, 58mm ~ 384 pixels
        int targetPaperPixels = (paperWidth == 80) ? 576 : 384;
        
        // Scale receipt to fit within printable dimensions
        float drawWidth = static_cast<float>((pageWidth < targetPaperPixels) ? pageWidth : targetPaperPixels);
        float scale = drawWidth / imgWidth;
        float drawHeight = imgHeight * scale;

        graphics.DrawImage(image, 0.0f, 0.0f, drawWidth, drawHeight);

        if (EndPage(hdc) > 0) {
          printSuccess = true;
        }
      }
      EndDoc(hdc);
    }
    delete image;
  }

  DeleteDC(hdc);
  return printSuccess;
}

// Get Printer status/spool info
static flutter::EncodableMap GetPrinterStatusInfo(const std::wstring& printerName) {
  flutter::EncodableMap resultMap;
  HANDLE hPrinter = nullptr;
  PRINTER_DEFAULTSW defaults = { nullptr, nullptr, PRINTER_ACCESS_USE };
  
  if (!OpenPrinterW(const_cast<LPWSTR>(printerName.c_str()), &hPrinter, &defaults)) {
    resultMap[flutter::EncodableValue("success")] = flutter::EncodableValue(false);
    resultMap[flutter::EncodableValue("error")] = flutter::EncodableValue("Failed to open printer");
    return resultMap;
  }

  DWORD cbNeeded = 0;
  GetPrinterW(hPrinter, 2, nullptr, 0, &cbNeeded);
  if (cbNeeded == 0) {
    ClosePrinter(hPrinter);
    resultMap[flutter::EncodableValue("success")] = flutter::EncodableValue(false);
    resultMap[flutter::EncodableValue("error")] = flutter::EncodableValue("Failed to get printer status buffer size");
    return resultMap;
  }

  std::vector<BYTE> buffer(cbNeeded);
  if (!GetPrinterW(hPrinter, 2, buffer.data(), cbNeeded, &cbNeeded)) {
    ClosePrinter(hPrinter);
    resultMap[flutter::EncodableValue("success")] = flutter::EncodableValue(false);
    resultMap[flutter::EncodableValue("error")] = flutter::EncodableValue("Failed to read printer details");
    return resultMap;
  }

  PRINTER_INFO_2W* pPrinterInfo = reinterpret_cast<PRINTER_INFO_2W*>(buffer.data());
  DWORD status = pPrinterInfo->Status;
  
  bool isOffline = (status & PRINTER_STATUS_OFFLINE) != 0;
  bool isPaperOut = (status & PRINTER_STATUS_PAPER_OUT) != 0;
  bool isPaperJam = (status & PRINTER_STATUS_PAPER_JAM) != 0;
  bool isPaused = (status & PRINTER_STATUS_PAUSED) != 0;
  bool isBusy = (status & PRINTER_STATUS_BUSY) != 0;
  bool isError = (status & PRINTER_STATUS_ERROR) != 0;

  resultMap[flutter::EncodableValue("success")] = flutter::EncodableValue(true);
  resultMap[flutter::EncodableValue("status")] = flutter::EncodableValue(static_cast<int64_t>(status));
  resultMap[flutter::EncodableValue("isOffline")] = flutter::EncodableValue(isOffline);
  resultMap[flutter::EncodableValue("isPaperOut")] = flutter::EncodableValue(isPaperOut);
  resultMap[flutter::EncodableValue("isPaperJam")] = flutter::EncodableValue(isPaperJam);
  resultMap[flutter::EncodableValue("isPaused")] = flutter::EncodableValue(isPaused);
  resultMap[flutter::EncodableValue("isBusy")] = flutter::EncodableValue(isBusy);
  resultMap[flutter::EncodableValue("isError")] = flutter::EncodableValue(isError);
  resultMap[flutter::EncodableValue("jobsCount")] = flutter::EncodableValue(static_cast<int64_t>(pPrinterInfo->cJobs));

  ClosePrinter(hPrinter);
  return resultMap;
}

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  // Initialize GDI+ Context
  Gdiplus::GdiplusStartupInput gdiplusStartupInput;
  Gdiplus::GdiplusStartup(&g_gdiplusToken, &gdiplusStartupInput, nullptr);

  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  
  // Set up MethodChannel for printer native tasks
  auto messenger = flutter_controller_->engine()->messenger();
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      messenger, "com.nextbills.printer",
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (call.method_name() == "getPrinters") {
          result->Success(flutter::EncodableValue(GetPrintersList()));
        } else if (call.method_name() == "getUsbDevices") {
          result->Success(flutter::EncodableValue(GetUsbDevicesList()));
        } else if (call.method_name() == "printRaw") {
          const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
          if (!arguments) {
            result->Error("BAD_ARGUMENT", "Expected map arguments");
            return;
          }
          auto printerNameIt = arguments->find(flutter::EncodableValue("printerName"));
          auto bytesIt = arguments->find(flutter::EncodableValue("bytes"));
          
          if (printerNameIt == arguments->end() || bytesIt == arguments->end()) {
            result->Error("BAD_ARGUMENT", "Missing printerName or bytes");
            return;
          }

          std::string printerName = std::get<std::string>(printerNameIt->second);
          std::vector<uint8_t> bytes;
          if (std::holds_alternative<std::vector<uint8_t>>(bytesIt->second)) {
            bytes = std::get<std::vector<uint8_t>>(bytesIt->second);
          } else if (std::holds_alternative<std::vector<int64_t>>(bytesIt->second)) {
            auto intVec = std::get<std::vector<int64_t>>(bytesIt->second);
            bytes.reserve(intVec.size());
            for (int64_t val : intVec) {
              bytes.push_back(static_cast<uint8_t>(val));
            }
          } else {
            auto encList = std::get<std::vector<flutter::EncodableValue>>(bytesIt->second);
            for (const auto& val : encList) {
              bytes.push_back(static_cast<uint8_t>(std::get<int64_t>(val)));
            }
          }

          bool success = PrintRawBytes(Utf8ToWide(printerName), bytes);
          result->Success(flutter::EncodableValue(success));
        } else if (call.method_name() == "printGDI") {
          const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
          if (!arguments) {
            result->Error("BAD_ARGUMENT", "Expected map arguments");
            return;
          }
          auto printerNameIt = arguments->find(flutter::EncodableValue("printerName"));
          auto imagePathIt = arguments->find(flutter::EncodableValue("imagePath"));
          auto paperWidthIt = arguments->find(flutter::EncodableValue("paperWidth"));
          
          if (printerNameIt == arguments->end() || imagePathIt == arguments->end()) {
            result->Error("BAD_ARGUMENT", "Missing printerName or imagePath");
            return;
          }

          std::string printerName = std::get<std::string>(printerNameIt->second);
          std::string imagePath = std::get<std::string>(imagePathIt->second);
          int paperWidth = 80;
          if (paperWidthIt != arguments->end()) {
            if (std::holds_alternative<int>(paperWidthIt->second)) {
              paperWidth = std::get<int>(paperWidthIt->second);
            } else if (std::holds_alternative<double>(paperWidthIt->second)) {
              paperWidth = static_cast<int>(std::get<double>(paperWidthIt->second));
            } else if (std::holds_alternative<int64_t>(paperWidthIt->second)) {
              paperWidth = static_cast<int>(std::get<int64_t>(paperWidthIt->second));
            }
          }

          bool success = PrintGDIImage(Utf8ToWide(printerName), Utf8ToWide(imagePath), paperWidth);
          result->Success(flutter::EncodableValue(success));
        } else if (call.method_name() == "getPrinterStatus") {
          const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
          if (!arguments) {
            result->Error("BAD_ARGUMENT", "Expected map arguments");
            return;
          }
          auto printerNameIt = arguments->find(flutter::EncodableValue("printerName"));
          if (printerNameIt == arguments->end()) {
            result->Error("BAD_ARGUMENT", "Missing printerName");
            return;
          }

          std::string printerName = std::get<std::string>(printerNameIt->second);
          result->Success(flutter::EncodableValue(GetPrinterStatusInfo(Utf8ToWide(printerName))));
        } else {
          result->NotImplemented();
        }
      });

  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  // Shutdown GDI+ Context
  if (g_gdiplusToken) {
    Gdiplus::GdiplusShutdown(g_gdiplusToken);
    g_gdiplusToken = 0;
  }

  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
