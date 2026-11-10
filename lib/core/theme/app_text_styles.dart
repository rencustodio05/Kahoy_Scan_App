import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Text styles taken from Figma frame "Figure 7. Home Screen" (node 2:4).
abstract final class AppTextStyles {
  static const String _poppins = 'Poppins';
  static const String _inter = 'Inter';

  static const TextStyle appTitle = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 25 / 20,
    letterSpacing: 0.0977,
    color: AppColors.forest,
  );

  static const TextStyle campusSubtitle = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.brown,
  );

  static const TextStyle heroHeading = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 33 / 24,
    color: AppColors.forestDeep,
  );

  static const TextStyle banner = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.0137,
    color: AppColors.forestDeep,
  );

  static const TextStyle scanButton = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 28 / 18,
    letterSpacing: 0.0176,
    color: AppColors.cream,
  );

  static const TextStyle shortcutTitle = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: 0.0469,
    color: AppColors.forestDeep,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 28 / 18,
    letterSpacing: 0.0352,
    color: AppColors.forestDeep,
  );

  static const TextStyle viewAll = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.0547,
    color: AppColors.brown,
  );

  static const TextStyle speciesName = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.1406,
    color: AppColors.forestDeep,
  );

  static const TextStyle confidenceHigh = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.forest,
  );

  static const TextStyle confidenceLow = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.amber,
  );

  static const TextStyle timestamp = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.brown,
  );

  static const TextStyle captureHint = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.0156,
    color: AppColors.cream,
  );

  static const TextStyle captureTip = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16.5 / 12,
    letterSpacing: 0.0117,
    color: AppColors.cream,
  );

  static const TextStyle reviewBadge = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.3,
    color: AppColors.cream,
  );

  static const TextStyle reviewHeading = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 28 / 20,
    color: AppColors.forestDeep,
  );

  static const TextStyle reviewBody = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14,
    color: AppColors.mutedForest,
  );

  static const TextStyle fileName = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
    color: AppColors.forestDeep,
  );

  static const TextStyle fileMeta = TextStyle(
    fontFamily: _inter,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.mutedForestSoft,
  );

  static const TextStyle retakeButton = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.1094,
    color: AppColors.brown,
  );

  static const TextStyle analyzeButton = TextStyle(
    fontFamily: _poppins,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.0625,
    color: AppColors.cream,
  );
}
