import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef PlaySoundNative = Int32 Function(
    Pointer<Utf16> pszSound, Pointer<Void> hmod, Uint32 fdwSound);
typedef PlaySoundDart = int Function(
    Pointer<Utf16> pszSound, Pointer<Void> hmod, int fdwSound);

class SoundService {
  // Pre-load winmm.dll and look up PlaySoundW immediately on class load (0ms delay)
  static final DynamicLibrary? _winmm = Platform.isWindows ? DynamicLibrary.open('winmm.dll') : null;
  static final PlaySoundDart? _playSound = _winmm != null
      ? (_winmm as DynamicLibrary).lookupFunction<PlaySoundNative, PlaySoundDart>('PlaySoundW')
      : null;

  static void _playSystemWav(String soundName) {
    if (_playSound != null) {
      final path = 'C:\\Windows\\Media\\$soundName';
      if (File(path).existsSync()) {
        final ptr = path.toNativeUtf16();
        // SND_FILENAME = 0x00020000, SND_ASYNC = 0x00000001, SND_NODEFAULT = 0x00000002
        _playSound!(ptr, nullptr, 0x00020000 | 0x00000001 | 0x00000002);
        malloc.free(ptr);
      }
    }
  }

  /// Plays a professional app opening sound instantly (loud startup chime).
  static void playAppOpen() {
    _playSystemWav('Windows Logon.wav');
  }

  /// Plays a professional printer starting sound instantly (crisp ding sound).
  static void playPrintChime() {
    _playSystemWav('ding.wav');
  }

  /// Plays a professional success/checkout sound instantly (loud tada sound).
  static void playSuccessChime() {
    _playSystemWav('tada.wav');
  }
}
