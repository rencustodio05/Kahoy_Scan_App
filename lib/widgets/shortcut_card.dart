import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';

class ShortcutCard extends StatelessWidget {
  const ShortcutCard({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    this.onTap,
  });

  final String title;
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mint,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Container(
          constraints: const BoxConstraints(minHeight: 120),
          width: double.infinity,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.forestOverlay,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconAsset,
                  width: iconWidth,
                  height: iconHeight,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(title, style: AppTextStyles.shortcutTitle),
            ],
          ),
        ),
      ),
    );
  }
}
