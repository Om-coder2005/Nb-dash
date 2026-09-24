import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:qr/qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'esc_pos_printer.dart';

class ReceiptRenderer {
  /// Builds the ESC/POS raw bytes for a receipt.
  Future<List<int>> renderRawBill({
    required String hotelName,
    required String hotelAddress,
    required String hotelPhone,
    required String tableNumber,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double total,
    required String paymentMethod,
    required double cashReceived,
    required double change,
    double splitCash = 0.0,
    double splitOnline = 0.0,
    int? billNumber,
    String? logoBase64,
    String? footer,
    int paperWidth = 80,
  }) async {
    final profile = await CapabilityProfile.load();
    final escPrinter = EscPosPrinter(
      paperSize: paperWidth == 80 ? PaperSize.mm80 : PaperSize.mm58,
      profile: profile,
    );

    List<int> bytes = [];
    bytes += escPrinter.reset();

    // Drawer Kick command at start
    bytes += escPrinter.openCashDrawer(pin: 2);

    // Print Logo if provided
    if (logoBase64 != null && logoBase64.isNotEmpty) {
      try {
        String cleanBase64 = logoBase64;
        if (cleanBase64.contains(',')) {
          cleanBase64 = cleanBase64.split(',').last;
        }
        final logoBytes = base64Decode(cleanBase64.trim());
        var image = img.decodeImage(logoBytes);
        if (image != null) {
          final targetWidth = (paperWidth == 80) ? 360 : 256;
          image = img.copyResize(image, width: targetWidth, interpolation: img.Interpolation.cubic);
          
          // Flatten to white background
          final whiteBg = img.Image(width: image.width, height: image.height, numChannels: 3);
          img.fill(whiteBg, color: img.ColorRgb8(255, 255, 255));
          img.compositeImage(whiteBg, image);

          var processed = img.grayscale(whiteBg);
          processed = img.convolution(processed, filter: [0, -2, 0, -2, 9, -2, 0, -2, 0]);
          processed = img.contrast(processed, contrast: 150);
          processed = img.luminanceThreshold(processed, threshold: 0.45);

          bytes += escPrinter.image(processed, align: PosAlign.center);
          bytes += escPrinter.feed(1);
        }
      } catch (e) {
        debugPrint('RAW Logo print error: $e');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final String gstin = (prefs.getString('gstin_number') ?? '').trim();
    final bool enableGst = prefs.getBool('enable_gst') ?? false;
    final double cgstRate = prefs.getDouble('cgst_rate') ?? 2.5;
    final double sgstRate = prefs.getDouble('sgst_rate') ?? 2.5;

    final double netSubtotal = (subtotal - discount).clamp(0.0, double.infinity);
    final double cgstAmount = enableGst ? netSubtotal * (cgstRate / 100) : 0.0;
    final double sgstAmount = enableGst ? netSubtotal * (sgstRate / 100) : 0.0;

    // Hotel Info Header
    if (hotelName.isNotEmpty) {
      bytes += escPrinter.text(
        hotelName,
        styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1),
      );
    }
    if (gstin.isNotEmpty) {
      bytes += escPrinter.text('GSTIN: $gstin', styles: const PosStyles(align: PosAlign.center, bold: true));
    }
    if (hotelAddress.isNotEmpty) {
      bytes += escPrinter.text(hotelAddress, styles: const PosStyles(align: PosAlign.center));
    }
    if (hotelPhone.isNotEmpty) {
      bytes += escPrinter.text('Tel: $hotelPhone', styles: const PosStyles(align: PosAlign.center));
    }

    bytes += escPrinter.hr();

    // Table / Time / Bill No
    bytes += escPrinter.row([
      PosColumn(text: 'Table: $tableNumber', width: 5, styles: const PosStyles(bold: true)),
      PosColumn(text: DateTime.now().toString().substring(0, 16), width: 7, styles: const PosStyles(align: PosAlign.right)),
    ]);
    if (billNumber != null) {
      bytes += escPrinter.text('Bill No: $billNumber', styles: const PosStyles(bold: true));
    }

    bytes += escPrinter.hr();

    // Items table header
    bytes += escPrinter.row([
      PosColumn(text: 'ITEM', width: 7, styles: const PosStyles(bold: true)),
      PosColumn(text: 'QTY', width: 2, styles: const PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(text: 'PRICE', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += escPrinter.hr(ch: '-');

    // Item rows
    for (var item in items) {
      final safeName = _safeRawText(item['name'].toString());
      bytes += escPrinter.row([
        PosColumn(text: safeName, width: 7),
        PosColumn(text: item['qty'].toString(), width: 2, styles: const PosStyles(align: PosAlign.center)),
        PosColumn(text: (item['price'] * item['qty']).toStringAsFixed(2), width: 3, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += escPrinter.hr(ch: '-');

    // Totals section
    bytes += escPrinter.row([
      PosColumn(text: 'SUBTOTAL', width: 8, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: subtotal.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    if (discount > 0) {
      bytes += escPrinter.row([
        PosColumn(text: 'DISCOUNT', width: 8, styles: const PosStyles(align: PosAlign.right)),
        PosColumn(text: '-${discount.toStringAsFixed(2)}', width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    if (enableGst && cgstAmount > 0) {
      bytes += escPrinter.row([
        PosColumn(text: 'CGST (${cgstRate.toStringAsFixed(1)}%)', width: 8, styles: const PosStyles(align: PosAlign.right)),
        PosColumn(text: cgstAmount.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    if (enableGst && sgstAmount > 0) {
      bytes += escPrinter.row([
        PosColumn(text: 'SGST (${sgstRate.toStringAsFixed(1)}%)', width: 8, styles: const PosStyles(align: PosAlign.right)),
        PosColumn(text: sgstAmount.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes += escPrinter.hr();

    bytes += escPrinter.row([
      PosColumn(text: 'TOTAL AMOUNT', width: 8, styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(text: total.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);

    bytes += escPrinter.hr();

    // Cash / Payment info
    bytes += escPrinter.text('Payment Mode: ${paymentMethod.toUpperCase()}', styles: const PosStyles(bold: true));
    if (paymentMethod.toLowerCase() == 'cash') {
      bytes += escPrinter.row([
        PosColumn(text: 'CASH RECEIVED', width: 8, styles: const PosStyles(align: PosAlign.left)),
        PosColumn(text: cashReceived.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.left)),
      ]);
      bytes += escPrinter.row([
        PosColumn(text: 'CHANGE DUE', width: 8, styles: const PosStyles(align: PosAlign.left)),
        PosColumn(text: change.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.left)),
      ]);
    } else if (paymentMethod.toLowerCase() == 'split') {
      bytes += escPrinter.row([
        PosColumn(text: 'CASH PAID', width: 8, styles: const PosStyles(align: PosAlign.left)),
        PosColumn(text: splitCash.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.left)),
      ]);
      bytes += escPrinter.row([
        PosColumn(text: 'ONLINE/UPI PAID', width: 8, styles: const PosStyles(align: PosAlign.left)),
        PosColumn(text: splitOnline.toStringAsFixed(2), width: 4, styles: const PosStyles(align: PosAlign.left)),
      ]);
    }

    // Print Dynamic UPI Payment QR Code if enabled
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool enableUpiQr = prefs.getBool('enable_print_upi_qr') ?? false;
      final String upiId = (prefs.getString('upi_id') ?? '').trim();
      final String soundboxTr = (prefs.getString('soundbox_tr') ?? '').trim();

      final double qrAmount = paymentMethod.toLowerCase() == 'split' ? splitOnline : total;
      if (enableUpiQr && upiId.isNotEmpty && qrAmount > 0) {
        final payeeName = soundboxTr.isNotEmpty ? soundboxTr : hotelName;
        final String upiUri = 'upi://pay?pa=$upiId&pn=${Uri.encodeComponent(payeeName)}&am=${qrAmount.toStringAsFixed(2)}&cu=INR${soundboxTr.isNotEmpty ? '&tr=${Uri.encodeComponent(soundboxTr)}' : ''}';
        
        final qrCode = QrCode.fromData(data: upiUri, errorCorrectLevel: QrErrorCorrectLevel.M);
        final qrImage = QrImage(qrCode);
        const int scaleFactor = 6;
        final int qrDimension = qrImage.moduleCount * scaleFactor;

        final qrBitmap = img.Image(width: qrDimension, height: qrDimension, numChannels: 3);
        img.fill(qrBitmap, color: img.ColorRgb8(255, 255, 255));

        final blackColor = img.ColorRgb8(0, 0, 0);
        for (int x = 0; x < qrImage.moduleCount; x++) {
          for (int yModule = 0; yModule < qrImage.moduleCount; yModule++) {
            if (qrImage.isDark(yModule, x)) {
              img.fillRect(
                qrBitmap,
                x1: x * scaleFactor,
                y1: yModule * scaleFactor,
                x2: (x + 1) * scaleFactor - 1,
                y2: (yModule + 1) * scaleFactor - 1,
                color: blackColor,
              );
            }
          }
        }

        bytes += escPrinter.feed(1);
        bytes += escPrinter.text('Scan QR to Pay Rs.${total.toStringAsFixed(2)} via UPI', styles: const PosStyles(align: PosAlign.center, bold: true));
        bytes += escPrinter.image(qrBitmap, align: PosAlign.center);
        bytes += escPrinter.feed(1);
      }
    } catch (e) {
      debugPrint('UPI QR Raw print error: $e');
    }

    // Footer
    bytes += escPrinter.text(footer ?? 'Thank you! Visit Again..', styles: const PosStyles(align: PosAlign.center));
    bytes += escPrinter.text('Powered by NextBills : 9172961047', styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size1, fontType: PosFontType.fontB));

    // Paper Cut
    bytes += escPrinter.cut();

    return bytes;
  }

  String _safeRawText(String input) {
    return input.codeUnits.every((c) => c <= 127)
        ? input
        : input.replaceAll(RegExp(r'[^\x00-\x7F]'), '?');
  }

  /// Renders a receipt image and converts it into ESC/POS bitmap raw bytes.
  /// Perfect for Marathi/Devanagari text printing on Bluetooth/RAW thermal printers!
  Future<List<int>> renderBitmapBillBytes({
    required String hotelName,
    required String hotelAddress,
    required String hotelPhone,
    required String tableNumber,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double total,
    required String paymentMethod,
    required double cashReceived,
    required double change,
    double splitCash = 0.0,
    double splitOnline = 0.0,
    int? billNumber,
    String? logoBase64,
    String? footer,
    int paperWidth = 80,
  }) async {
    final imagePath = await renderGdiBillImage(
      hotelName: hotelName,
      hotelAddress: hotelAddress,
      hotelPhone: hotelPhone,
      tableNumber: tableNumber,
      items: items,
      subtotal: subtotal,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      cashReceived: cashReceived,
      change: change,
      splitCash: splitCash,
      splitOnline: splitOnline,
      billNumber: billNumber,
      logoBase64: logoBase64,
      footer: footer,
      paperWidth: paperWidth,
    );

    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final escPrinter = EscPosPrinter(
      paperSize: paperWidth == 80 ? PaperSize.mm80 : PaperSize.mm58,
      profile: profile,
    );

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        final imgBytes = await file.readAsBytes();
        var image = img.decodeImage(imgBytes);
        if (image != null) {
          final targetWidth = paperWidth == 80 ? 512 : 384;
          image = img.copyResize(image, width: targetWidth, interpolation: img.Interpolation.cubic);
          
          var processed = img.grayscale(image);
          processed = img.contrast(processed, contrast: 140);
          processed = img.luminanceThreshold(processed, threshold: 0.5);

          bytes += escPrinter.reset();
          bytes += escPrinter.openCashDrawer(pin: 2);
          bytes += escPrinter.image(processed, align: PosAlign.center);
          bytes += escPrinter.feed(2);
          bytes += escPrinter.cut();
        }
        await file.delete();
      }
    } catch (e) {
      debugPrint('Bitmap bill render error: $e');
    }

    return bytes;
  }

  /// Renders a KOT image and converts it into ESC/POS bitmap raw bytes.
  Future<List<int>> renderBitmapKotBytes({
    required String tableNumber,
    required int kotNumber,
    required List<Map<String, dynamic>> items,
    int paperWidth = 80,
  }) async {
    final imagePath = await renderGdiKotImage(
      tableNumber: tableNumber,
      kotNumber: kotNumber,
      items: items,
      paperWidth: paperWidth,
    );

    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final escPrinter = EscPosPrinter(
      paperSize: paperWidth == 80 ? PaperSize.mm80 : PaperSize.mm58,
      profile: profile,
    );

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        final imgBytes = await file.readAsBytes();
        var image = img.decodeImage(imgBytes);
        if (image != null) {
          final targetWidth = paperWidth == 80 ? 512 : 384;
          image = img.copyResize(image, width: targetWidth, interpolation: img.Interpolation.cubic);
          
          var processed = img.grayscale(image);
          processed = img.contrast(processed, contrast: 140);
          processed = img.luminanceThreshold(processed, threshold: 0.5);

          bytes += escPrinter.reset();
          bytes += escPrinter.image(processed, align: PosAlign.center);
          bytes += escPrinter.feed(2);
          bytes += escPrinter.cut();
        }
        await file.delete();
      }
    } catch (e) {
      debugPrint('Bitmap KOT render error: $e');
    }

    return bytes;
  }

  /// Renders a receipt as a pixel-perfect image using Canvas and returns the path to the saved image file.
  Future<String> renderGdiBillImage({
    required String hotelName,
    required String hotelAddress,
    required String hotelPhone,
    required String tableNumber,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double total,
    required String paymentMethod,
    required double cashReceived,
    required double change,
    double splitCash = 0.0,
    double splitOnline = 0.0,
    int? billNumber,
    String? logoBase64,
    String? footer,
    int paperWidth = 80,
  }) async {
    const double scale = 2.0; // 2.0x scale factor for sharper GDI text/layout rendering
    final double width = (paperWidth == 80 ? 576.0 : 384.0) * scale;
    const double padding = 16.0 * scale;
    final double contentWidth = width - (padding * 2);

    // Decode logo if present
    ui.Image? logoImage;
    if (logoBase64 != null && logoBase64.isNotEmpty) {
      try {
        String cleanBase64 = logoBase64;
        if (cleanBase64.contains(',')) {
          cleanBase64 = cleanBase64.split(',').last;
        }
        final logoBytes = base64Decode(cleanBase64.trim());
        final Completer<ui.Image> completer = Completer();
        ui.decodeImageFromList(logoBytes, (img) => completer.complete(img));
        logoImage = await completer.future.timeout(const Duration(seconds: 2));
      } catch (e) {
        debugPrint('GDI Logo decode error: $e');
      }
    }

    // Read preferences
    final prefs = await SharedPreferences.getInstance();
    final bool enableUpiQr = prefs.getBool('enable_print_upi_qr') ?? false;
    final String upiId = (prefs.getString('upi_id') ?? '').trim();
    final String soundboxTr = (prefs.getString('soundbox_tr') ?? '').trim();
    final String gstin = (prefs.getString('gstin_number') ?? '').trim();
    final bool enableGst = prefs.getBool('enable_gst') ?? false;
    final double cgstRate = prefs.getDouble('cgst_rate') ?? 2.5;
    final double sgstRate = prefs.getDouble('sgst_rate') ?? 2.5;

    final double netSubtotal = (subtotal - discount).clamp(0.0, double.infinity);
    final double cgstAmount = enableGst ? netSubtotal * (cgstRate / 100) : 0.0;
    final double sgstAmount = enableGst ? netSubtotal * (sgstRate / 100) : 0.0;

    double calculatedHeight = 0.0;

    double measureHeight(Canvas? canvas) {
      double y = 20.0 * scale;

      // Draw Logo
      if (logoImage != null) {
        final double logoSize = (paperWidth == 80 ? 100.0 : 80.0) * scale;
        if (canvas != null) {
          final x = (width - logoSize) / 2;
          canvas.drawImageRect(
            logoImage,
            Rect.fromLTWH(0, 0, logoImage.width.toDouble(), logoImage.height.toDouble()),
            Rect.fromLTWH(x, y, logoSize, logoSize),
            Paint(),
          );
        }
        y += logoSize + (4 * scale);
      }

      // Hotel Header
      if (hotelName.isNotEmpty) {
        y += _drawText(canvas, hotelName, y, contentWidth, padding, fontSize: paperWidth == 80 ? 22 : 18, bold: true, align: TextAlign.center, scale: scale);
        y += 1 * scale;
      }
      if (gstin.isNotEmpty) {
        y += _drawText(canvas, 'GSTIN: $gstin', y, contentWidth, padding, fontSize: 12, bold: true, align: TextAlign.center, scale: scale);
        y += 1 * scale;
      }
      if (hotelAddress.isNotEmpty) {
        y += _drawText(canvas, hotelAddress, y, contentWidth, padding, fontSize: 13, align: TextAlign.center, scale: scale);
        y += 1 * scale;
      }
      if (hotelPhone.isNotEmpty) {
        y += _drawText(canvas, 'Tel: $hotelPhone', y, contentWidth, padding, fontSize: 13, align: TextAlign.center, scale: scale);
        y += 1 * scale;
      }

      // Divider
      y += _drawDivider(canvas, y, width, padding, scale: scale);

      // Table details
      y += _drawRow(canvas, ['Table: $tableNumber', DateTime.now().toString().substring(0, 16)], [6, 6], y, contentWidth, padding, fontSize: 13, bold: true, scale: scale);
      if (billNumber != null) {
        y += 1 * scale;
        y += _drawText(canvas, 'Bill No: $billNumber', y, contentWidth, padding, fontSize: 13, bold: true, scale: scale);
      }

      // Divider
      y += _drawDivider(canvas, y, width, padding, scale: scale);

      // Table headers
      y += _drawRow(canvas, ['ITEM', 'QTY', 'PRICE'], [7, 2, 3], y, contentWidth, padding, fontSize: 13, bold: true, aligns: [TextAlign.left, TextAlign.center, TextAlign.right], scale: scale);
      y += _drawDivider(canvas, y, width, padding, isDashed: true, scale: scale);

      // Item rows
      for (var item in items) {
        final double itemTotal = item['price'] * item['qty'];
        y += _drawRow(
          canvas,
          [item['name'].toString(), item['qty'].toString(), itemTotal.toStringAsFixed(2)],
          [7, 2, 3],
          y,
          contentWidth,
          padding,
          fontSize: 13,
          aligns: [TextAlign.left, TextAlign.center, TextAlign.right],
          scale: scale,
        );
        y += 1 * scale;
      }

      y += _drawDivider(canvas, y, width, padding, isDashed: true, scale: scale);

      // Subtotal
      y += _drawRow(canvas, ['SUBTOTAL', subtotal.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.right, TextAlign.right], scale: scale);
      y += 1 * scale;

      // Discount
      if (discount > 0) {
        y += _drawRow(canvas, ['DISCOUNT', '-${discount.toStringAsFixed(2)}'], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.right, TextAlign.right], scale: scale);
        y += 1 * scale;
      }

      // CGST & SGST
      if (enableGst && cgstAmount > 0) {
        y += _drawRow(canvas, ['CGST (${cgstRate.toStringAsFixed(1)}%)', cgstAmount.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.right, TextAlign.right], scale: scale);
        y += 1 * scale;
      }
      if (enableGst && sgstAmount > 0) {
        y += _drawRow(canvas, ['SGST (${sgstRate.toStringAsFixed(1)}%)', sgstAmount.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.right, TextAlign.right], scale: scale);
        y += 1 * scale;
      }

      y += _drawDivider(canvas, y, width, padding, scale: scale);

      // Total
      y += _drawRow(canvas, ['TOTAL AMOUNT', total.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: paperWidth == 80 ? 17 : 15, bold: true, aligns: [TextAlign.right, TextAlign.right], scale: scale);
      y += 1 * scale;

      y += _drawDivider(canvas, y, width, padding, scale: scale);

      // Payment Method
      y += _drawText(canvas, 'Payment Mode: ${paymentMethod.toUpperCase()}', y, contentWidth, padding, fontSize: 13, bold: true, scale: scale);
      y += 1 * scale;

      if (paymentMethod.toLowerCase() == 'cash') {
        y += _drawRow(canvas, ['Cash Received', cashReceived.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.left, TextAlign.left], scale: scale);
        y += 1 * scale;
        y += _drawRow(canvas, ['Change Due', change.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.left, TextAlign.left], scale: scale);
        y += 1 * scale;
      } else if (paymentMethod.toLowerCase() == 'split') {
        y += _drawRow(canvas, ['Cash Paid', splitCash.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.left, TextAlign.left], scale: scale);
        y += 1 * scale;
        y += _drawRow(canvas, ['Online/UPI Paid', splitOnline.toStringAsFixed(2)], [8, 4], y, contentWidth, padding, fontSize: 13, aligns: [TextAlign.left, TextAlign.left], scale: scale);
        y += 1 * scale;
      }

      // Print Dynamic UPI Payment QR Code if enabled
      final double qrAmount = paymentMethod.toLowerCase() == 'split' ? splitOnline : total;
      if (enableUpiQr && upiId.isNotEmpty && qrAmount > 0) {
        try {
          final payeeName = soundboxTr.isNotEmpty ? soundboxTr : hotelName;
          final String upiUri = 'upi://pay?pa=$upiId&pn=${Uri.encodeComponent(payeeName)}&am=${qrAmount.toStringAsFixed(2)}&cu=INR${soundboxTr.isNotEmpty ? '&tr=${Uri.encodeComponent(soundboxTr)}' : ''}';
          
          final qrCode = QrCode.fromData(data: upiUri, errorCorrectLevel: QrErrorCorrectLevel.M);
          final qrImage = QrImage(qrCode);
          const double moduleSize = 4.0 * scale;
          final double qrPixelSize = qrImage.moduleCount * moduleSize;

          y += 4 * scale;
          y += _drawText(canvas, 'Scan QR to Pay Rs.${qrAmount.toStringAsFixed(2)} via UPI', y, contentWidth, padding, fontSize: 13, bold: true, align: TextAlign.center, scale: scale);
          y += 4 * scale;

          if (canvas != null) {
            final double qrX = (width - qrPixelSize) / 2;
            final qrPaint = Paint()..color = Colors.black;
            for (int x = 0; x < qrImage.moduleCount; x++) {
              for (int yModule = 0; yModule < qrImage.moduleCount; yModule++) {
                if (qrImage.isDark(yModule, x)) {
                  canvas.drawRect(
                    Rect.fromLTWH(qrX + (x * moduleSize), y + (yModule * moduleSize), moduleSize, moduleSize),
                    qrPaint,
                  );
                }
              }
            }
          }
          y += qrPixelSize + (10 * scale);
        } catch (e) {
          debugPrint('UPI QR GDI print error: $e');
        }
      }

      y += 4 * scale;

      // Footer
      y += _drawText(canvas, footer ?? 'Thank you! Visit Again..', y, contentWidth, padding, fontSize: 12, italic: true, align: TextAlign.center, scale: scale);
      y += 1 * scale;
      y += _drawText(canvas, 'Powered by NextBills : 9172961047', y, contentWidth, padding, fontSize: 9, align: TextAlign.center, scale: scale);
      
      y += 1 * scale;
      return y;
    }

    // 1st Pass: Measure height
    calculatedHeight = measureHeight(null);

    // 2nd Pass: Render to actual Canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, calculatedHeight));
    
    // Draw white background
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, calculatedHeight), bgPaint);

    measureHeight(canvas);

    final picture = recorder.endRecording();
    final imgObj = await picture.toImage(width.toInt(), calculatedHeight.toInt());
    final byteData = await imgObj.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    // Save PNG to temporary file
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/nb_receipt_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);

    return file.path;
  }

  /// Renders a KOT as raw ESC/POS bytes.
  Future<List<int>> renderRawKot({
    required String tableNumber,
    required int kotNumber,
    required List<Map<String, dynamic>> items,
    int paperWidth = 80,
  }) async {
    final profile = await CapabilityProfile.load();
    final escPrinter = EscPosPrinter(
      paperSize: paperWidth == 80 ? PaperSize.mm80 : PaperSize.mm58,
      profile: profile,
    );

    List<int> bytes = [];
    bytes += escPrinter.reset();

    // KOT Header
    bytes += escPrinter.text(
      '*** KITCHEN ORDER TICKET ***',
      styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size1, width: PosTextSize.size1),
    );
    bytes += escPrinter.text(
      'KOT #: $kotNumber',
      styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2),
    );
    bytes += escPrinter.hr();

    bytes += escPrinter.row([
      PosColumn(text: 'Table: $tableNumber', width: 6, styles: const PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: DateTime.now().toString().substring(11, 16), width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += escPrinter.hr();

    bytes += escPrinter.row([
      PosColumn(text: 'ITEM', width: 9, styles: const PosStyles(bold: true)),
      PosColumn(text: 'QTY', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += escPrinter.hr(ch: '-');

    for (var item in items) {
      bytes += escPrinter.row([
        PosColumn(text: item['name'].toString(), width: 9, styles: const PosStyles(bold: true)),
        PosColumn(text: item['qty'].toString(), width: 3, styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size1, width: PosTextSize.size1)),
      ]);
    }

    bytes += escPrinter.hr();
    bytes += escPrinter.cut();

    return bytes;
  }

  /// Renders a KOT as a pixel-perfect image using Canvas and returns the file path.
  Future<String> renderGdiKotImage({
    required String tableNumber,
    required int kotNumber,
    required List<Map<String, dynamic>> items,
    int paperWidth = 80,
  }) async {
    const double scale = 2.0;
    final double width = (paperWidth == 80 ? 576.0 : 384.0) * scale;
    const double padding = 16.0 * scale;
    final double contentWidth = width - (padding * 2);

    double measureHeight(Canvas? canvas) {
      double y = 20.0 * scale;

      // KOT Header
      y += _drawText(canvas, '*** KITCHEN ORDER TICKET ***', y, contentWidth, padding, fontSize: 14, bold: true, align: TextAlign.center, scale: scale);
      y += 2 * scale;
      y += _drawText(canvas, 'KOT #: $kotNumber', y, contentWidth, padding, fontSize: 18, bold: true, align: TextAlign.center, scale: scale);
      y += 4 * scale;

      y += _drawDivider(canvas, y, width, padding, scale: scale);

      y += _drawRow(canvas, ['Table: $tableNumber', DateTime.now().toString().substring(11, 16)], [6, 6], y, contentWidth, padding, fontSize: 14, bold: true, scale: scale);
      y += 2 * scale;

      y += _drawDivider(canvas, y, width, padding, scale: scale);

      y += _drawRow(canvas, ['ITEM', 'QTY'], [9, 3], y, contentWidth, padding, fontSize: 14, bold: true, aligns: [TextAlign.left, TextAlign.right], scale: scale);
      y += _drawDivider(canvas, y, width, padding, isDashed: true, scale: scale);

      for (var item in items) {
        y += _drawRow(
          canvas,
          [item['name'].toString(), item['qty'].toString()],
          [9, 3],
          y,
          contentWidth,
          padding,
          fontSize: 14,
          bold: true,
          aligns: [TextAlign.left, TextAlign.right],
          scale: scale,
        );
        y += 2 * scale;
      }

      y += _drawDivider(canvas, y, width, padding, scale: scale);
      y += 4 * scale;
      return y;
    }

    final double calculatedHeight = measureHeight(null);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, calculatedHeight));
    
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, calculatedHeight), bgPaint);

    measureHeight(canvas);

    final picture = recorder.endRecording();
    final imgObj = await picture.toImage(width.toInt(), calculatedHeight.toInt());
    final byteData = await imgObj.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/nb_kot_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);

    return file.path;
  }

  /// Helper to draw a single text line on Canvas
  double _drawText(
    Canvas? canvas,
    String text,
    double y,
    double contentWidth,
    double padding, {
    double fontSize = 13.0,
    bool bold = false,
    bool italic = false,
    TextAlign align = TextAlign.left,
    required double scale,
  }) {
    final style = TextStyle(
      color: Colors.black,
      fontSize: fontSize * scale,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      fontFamily: 'monospace',
    );

    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: align,
    );

    textPainter.layout(maxWidth: contentWidth);

    if (canvas != null) {
      double x = padding;
      if (align == TextAlign.center) {
        x = padding + (contentWidth - textPainter.width) / 2;
      } else if (align == TextAlign.right) {
        x = padding + contentWidth - textPainter.width;
      }
      textPainter.paint(canvas, Offset(x, y));
    }

    return textPainter.height;
  }

  /// Helper to draw a table row with column shares (out of 12)
  double _drawRow(
    Canvas? canvas,
    List<String> texts,
    List<int> colShares,
    double y,
    double width,
    double padding, {
    double fontSize = 13.0,
    bool bold = false,
    List<TextAlign>? aligns,
    required double scale,
  }) {
    final style = TextStyle(
      color: Colors.black,
      fontSize: fontSize * scale,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontFamily: 'monospace',
    );

    final List<TextAlign> resolvedAligns = aligns ?? List.filled(texts.length, TextAlign.left);
    double maxHeight = 0.0;
    double currentX = padding;
    final List<TextPainter> painters = [];

    // Pre-calculate heights
    for (int i = 0; i < texts.length; i++) {
      final colWidth = width * (colShares[i] / 12.0);
      final textSpan = TextSpan(text: texts[i], style: style);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: resolvedAligns[i],
      );
      textPainter.layout(maxWidth: colWidth);
      painters.add(textPainter);
      if (textPainter.height > maxHeight) {
        maxHeight = textPainter.height;
      }
    }

    // Actual paint
    if (canvas != null) {
      for (int i = 0; i < texts.length; i++) {
        final colWidth = width * (colShares[i] / 12.0);
        double paintX = currentX;
        final painter = painters[i];

        if (resolvedAligns[i] == TextAlign.center) {
          paintX += (colWidth - painter.width) / 2;
        } else if (resolvedAligns[i] == TextAlign.right) {
          paintX += colWidth - painter.width;
        }

        painter.paint(canvas, Offset(paintX, y));
        currentX += colWidth;
      }
    }

    return maxHeight;
  }

  double _drawDivider(Canvas? canvas, double y, double totalWidth, double padding, {bool isDashed = false, double scale = 1.0}) {
    if (canvas != null) {
      final paint = Paint()
        ..color = Colors.black87
        ..strokeWidth = 1.0 * scale
        ..style = PaintingStyle.stroke;

      final startX = padding;
      final endX = totalWidth - padding;

      if (!isDashed) {
        canvas.drawLine(Offset(startX, y + 2 * scale), Offset(endX, y + 2 * scale), paint);
      } else {
        double curX = startX;
        final double dashWidth = 4.0 * scale;
        final double spaceWidth = 3.0 * scale;
        while (curX < endX) {
          canvas.drawLine(
            Offset(curX, y + 2 * scale),
            Offset((curX + dashWidth).clamp(startX, endX), y + 2 * scale),
            paint,
          );
          curX += dashWidth + spaceWidth;
        }
      }
    }
    return 5.0 * scale;
  }
}
