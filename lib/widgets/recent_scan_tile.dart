import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_theme.dart';
import '../data/models/scan_history.dart';
import '../data/services/photo_storage.dart';

class RecentScanTile extends StatelessWidget {
  const RecentScanTile({
    super.key,
    required this.scan,
    required this.speciesName,
    this.onTap,
  });

  final ScanHistory scan;
  final String speciesName;
  final VoidCallback? onTap;

  static const double _highConfidenceThreshold = 0.9;

  @override
  Widget build(BuildContext context) {
    final percent = (scan.confidenceScore * 100).round();
    final isHigh = scan.confidenceScore >= _highConfidenceThreshold;

    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: const BorderSide(color: AppColors.mint),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.md),
                child: Image(
                  image: imageFromPath(scan.imagePath),
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 64,
                    height: 64,
                    child: ColoredBox(color: AppColors.mint),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            speciesName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.speciesName,
                          ),
                        ),
                        const SizedBox(width: 8),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: isHigh
                                ? AppColors.mint
                                : AppColors.amberSoft,
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: Text(
                              '$percent%',
                              style: isHigh
                                  ? AppTextStyles.confidenceHigh
                                  : AppTextStyles.confidenceLow,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatScanTimestamp(scan.timestamp),
                      style: AppTextStyles.timestamp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatScanTimestamp(DateTime timestamp) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final hour12 = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
  final minute = timestamp.minute.toString().padLeft(2, '0');
  final period = timestamp.hour >= 12 ? 'PM' : 'AM';
  return '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year} · $hour12:$minute $period';
}
