import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 12.0;
  static const double md = 24.0;
  static const double lg = 32.0; // 32px padding for cards
  static const double xl = 48.0;
  static const double xxl = 64.0;
  static const double gutter = 24.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0; // Inner elements
  static const double lg = 24.0; // Card radius and sidebar
  static const double pill = 999.0; // Buttons, inputs, chips
  static const BorderRadius smBorder = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdBorder = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgBorder = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillBorder = BorderRadius.all(Radius.circular(pill));
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350); // 350ms ease-out-expo
  static const Duration slow = Duration(milliseconds: 500);
}

class AppShadows {
  // Culinary OS Ambient Shadow (15% warm-tinted)
  static List<BoxShadow> get ambientLight => [
        const BoxShadow(color: Color(0x265A413B), offset: Offset(0, 8), blurRadius: 24),
      ];

  static List<BoxShadow> get ambientDark => [
        const BoxShadow(color: Color(0x66000000), offset: Offset(0, 8), blurRadius: 24),
      ];

  static List<BoxShadow> ambient(bool isDark) => isDark ? ambientDark : ambientLight;
  
  // Kept for backward compatibility if used anywhere, but we map it to ambient
  static List<BoxShadow> neumorphic(bool isDark) => ambient(isDark);
  static List<BoxShadow> innerSink(bool isDark) => []; // Inner sinks are removed in Culinary OS
  static List<BoxShadow> lift(bool isDark) => ambient(isDark);
}

class AppColors {
  static bool isDarkMode = false; // Toggled by main.dart

  // --- Dynamic Getters ---
  static Color get bg => isDarkMode ? bgDark : bgLight;
  static Color get surface => isDarkMode ? surfaceDark : surfaceLight;
  static Color get card => isDarkMode ? cardDark : cardLight;
  static Color get border => isDarkMode ? borderDark : borderLight;
  static Color get primary => isDarkMode ? primaryDarkMode : primaryLightMode;
  static Color get primaryDark => primary;
  static Color get primaryGlow => primary.withValues(alpha: 0.2);
  static Color get textPrimary => isDarkMode ? textPrimaryDark : textPrimaryLight;
  static Color get textSecondary => isDarkMode ? textSecondaryDark : textSecondaryLight;
  static Color get textMuted => isDarkMode ? textMutedDark : textMutedLight;

  // --- Light Theme Colors (Culinary OS) ---
  static const bgLight = Color(0xFFFFF8F6); // Cream
  static const surfaceLight = Color(0xFFFFF8F6);
  static const cardLight = Color(0xFFFFFFFF); // Pure white cards
  static const borderLight = Color(0xFFE2BEB7); // outline_variant
  static const primaryLightMode = Color(0xFFAF280E); // Tomato / Persimmon
  static const textPrimaryLight = Color(0xFF261815); // Charcoal / on_surface
  static const textSecondaryLight = Color(0xFF5A413B); // on_surface_variant
  static const textMutedLight = Color(0xFF8E706A); // outline

  // --- Dark Theme Colors ---
  static const bgDark = Color(0xFF1E1C1A);
  static const surfaceDark = Color(0xFF1E1C1A);
  static const cardDark = Color(0xFF2C2A28);
  static const borderDark = Color(0xFF3A3735);
  static const primaryDarkMode = Color(0xFFAF280E);
  static const textPrimaryDark = Color(0xFFFFF8F6);
  static const textSecondaryDark = Color(0xFFE2BEB7);
  static const textMutedDark = Color(0xFF8E706A);

  // --- Semantic & Status Colors ---
  static const success = Color(0xFF34C759); 
  static const warning = Color(0xFFF5B335); 
  static const error = Color(0xFFBA1A1A);   
  static const info = Color(0xFF3B82F6);
  
  static const tableFree = Color(0xFF34C759);
  static const tableOccupied = Color(0xFFF5B335);
  static const tableBilled = Color(0xFF3B82F6);
  static const tableReserved = Color(0xFF8B5CF6);
}

class AppTheme {
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: GoogleFonts.epilogue(textStyle: base.displayLarge, color: textColor),
      displayMedium: GoogleFonts.epilogue(textStyle: base.displayMedium, color: textColor),
      displaySmall: GoogleFonts.epilogue(textStyle: base.displaySmall, color: textColor),
      headlineLarge: GoogleFonts.epilogue(textStyle: base.headlineLarge, color: textColor),
      headlineMedium: GoogleFonts.epilogue(textStyle: base.headlineMedium, color: textColor),
      headlineSmall: GoogleFonts.epilogue(textStyle: base.headlineSmall, color: textColor),
      titleLarge: GoogleFonts.epilogue(textStyle: base.titleLarge, color: textColor),
      titleMedium: GoogleFonts.epilogue(textStyle: base.titleMedium, color: textColor),
      titleSmall: GoogleFonts.epilogue(textStyle: base.titleSmall, color: textColor),
      
      bodyLarge: GoogleFonts.manrope(textStyle: base.bodyLarge, color: textColor),
      bodyMedium: GoogleFonts.manrope(textStyle: base.bodyMedium, color: textColor),
      bodySmall: GoogleFonts.manrope(textStyle: base.bodySmall, color: textColor),
      
      labelLarge: GoogleFonts.hankenGrotesk(textStyle: base.labelLarge, color: textColor, letterSpacing: 0.5),
      labelMedium: GoogleFonts.hankenGrotesk(textStyle: base.labelMedium, color: textColor),
      labelSmall: GoogleFonts.hankenGrotesk(textStyle: base.labelSmall, color: textColor),
    );
  }

  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme: _buildTextTheme(base.textTheme, AppColors.textPrimaryLight),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLightMode,
        secondary: AppColors.success,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgBorder, // 24px
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgDark,
      textTheme: _buildTextTheme(base.textTheme, AppColors.textPrimaryDark),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDarkMode,
        secondary: AppColors.success,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgBorder, // 24px
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
