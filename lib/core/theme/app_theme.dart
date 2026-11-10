import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Spacing and radii taken from Figma frame "Figure 7. Home Screen" (node 2:4).
abstract final class AppSpacing {
  static const double xs = 2;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double section = 48;
}

abstract final class AppRadii {
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 9999;
}

abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.forest,
        onPrimary: AppColors.cream,
        secondary: AppColors.brown,
        onSecondary: AppColors.cream,
        surface: AppColors.cream,
        onSurface: AppColors.forestDeep,
        outline: AppColors.mint,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heroHeading,
        headlineSmall: AppTextStyles.appTitle,
        titleLarge: AppTextStyles.sectionTitle,
        titleMedium: AppTextStyles.speciesName,
        titleSmall: AppTextStyles.shortcutTitle,
        bodyMedium: AppTextStyles.banner,
        bodySmall: AppTextStyles.timestamp,
        labelLarge: AppTextStyles.scanButton,
        labelMedium: AppTextStyles.viewAll,
        labelSmall: AppTextStyles.confidenceHigh,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.forest,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.cream,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
    );
  }
}
