import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/app/router.dart';
import 'package:nextbills/features/printer/printer_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for phones, allow both for tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A0F),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Intercept all Flutter framework errors (prevents white screen / crash)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Log but do not rethrow — keeps the app running
    debugPrint('[FlutterError] ${details.exceptionAsString()}');
  };

  // Intercept all async/platform errors (prevents process kill)
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[PlatformError] $error\n$stack');
    return true; // true = handled, do not crash
  };

  runZonedGuarded(
    () {
      runApp(
        const ProviderScope(
          child: NextBillsApp(),
        ),
      );
    },
    (error, stack) {
      debugPrint('[ZoneError] $error\n$stack');
    },
  );
}

class NextBillsApp extends ConsumerWidget {
  const NextBillsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize printer autoconnect on app start
    ref.listen(printerStateProvider, (_, __) {});

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Sync static colors for screens still using AppColors properties
    AppColors.isDarkMode = themeMode == ThemeMode.dark;

    return MaterialApp.router(
      title: 'NextBills',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
