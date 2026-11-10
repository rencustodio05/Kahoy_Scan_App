import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.75),
              child: SizedBox(
                width: 14,
                height: 14,
                child: SvgPicture.asset(
                  'assets/icons/info.svg',
                  width: 13.5352,
                  height: 13.5352,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Offline ready – scanning works without\ninternet',
              style: AppTextStyles.banner,
            ),
          ],
        ),
      ),
    );
  }
}
