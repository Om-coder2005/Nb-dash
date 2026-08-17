import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

DateTime? _lastLaunch;

void launchWindowsVirtualKeyboard() {
  if (kIsWeb || !Platform.isWindows) return;

  final now = DateTime.now();
  if (_lastLaunch != null && now.difference(_lastLaunch!) < const Duration(milliseconds: 500)) {
    return; // Throttle double launches
  }
  _lastLaunch = now;

  Future.microtask(() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final autoLaunch = prefs.getBool('auto_launch_keyboard') ?? true;
      if (!autoLaunch) return; // User has toggled keyboard auto-launch off

      // 1. Get temporary directory to store our compiled executable
      final tempDir = await getTemporaryDirectory();
      final helperExePath = p.join(tempDir.path, 'nextbills_keyboard_helper.exe');

      // 2. Check if the executable already exists
      if (!File(helperExePath).existsSync()) {
        // Create helper source code
        final helperCsPath = p.join(tempDir.path, 'nextbills_keyboard_helper.cs');
        const csSource = '''
using System;
using System.Runtime.InteropServices;

public class Program {
    [DllImport("user32.dll")]
    public static extern IntPtr GetDesktopWindow();

    [ComImport, Guid("4ce576fa-83dc-4f88-951c-9d0782b4e376")]
    public class UIHostNoLaunch {}

    [ComImport, Guid("37c994e7-432b-4834-a2f7-dce1f13b834b")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface ITipInvocation {
        void Toggle(IntPtr hwnd);
    }

    public static void Main() {
        try {
            var ui = new UIHostNoLaunch();
            ((ITipInvocation)ui).Toggle(GetDesktopWindow());
            Marshal.ReleaseComObject(ui);
        } catch (Exception ex) {
            Console.WriteLine("COM Error: " + ex.Message);
        }
    }
}
''';
        await File(helperCsPath).writeAsString(csSource);

        // Find csc.exe in standard Windows locations
        String cscPath = r'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe';
        if (!File(cscPath).existsSync()) {
          cscPath = r'C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe';
        }

        if (File(cscPath).existsSync()) {
          // Compile the source code to an executable
          await Process.run(cscPath, [
            '/target:winexe',
            '/out:$helperExePath',
            helperCsPath,
          ]);
        }
      }

      // 3. Execute the compiled helper to show the keyboard
      bool ranHelper = false;
      if (File(helperExePath).existsSync()) {
        final result = await Process.run(helperExePath, []);
        if (result.exitCode == 0) {
          ranHelper = true;
        }
      }

      if (!ranHelper) {
        // Fallback: If helper fails or is blocked by antivirus, try launching TabTip.exe via explorer.exe
        var tabTipPath = r'C:\Program Files\Common Files\Microsoft Shared\ink\TabTip.exe';
        if (!File(tabTipPath).existsSync()) {
          final commonFiles = Platform.environment['CommonProgramFiles'] ?? r'C:\Program Files\Common Files';
          tabTipPath = '$commonFiles\\Microsoft Shared\\ink\\TabTip.exe';
        }

        if (File(tabTipPath).existsSync()) {
          // Running TabTip.exe via explorer.exe resolves COM shell activation restrictions on Win10/Win11
          await Process.run('explorer.exe', [tabTipPath]);
        } else {
          // Final fallback to on-screen keyboard
          await Process.run('osk.exe', []);
        }
      }
    } catch (e) {
      debugPrint('Failed to launch Windows virtual keyboard: $e');
    }
  });
}
