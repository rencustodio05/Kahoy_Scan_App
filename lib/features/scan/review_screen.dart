import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/captured_photo.dart';
import '../../widgets/overlay_circle_button.dart';


import 'analyzing_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key, required this.photo, this.onConfirm});

  final CapturedPhoto photo;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: AppColors.black,
                    child: Image.memory(photo.bytes, fit: BoxFit.cover),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.reviewGradientTop,
                          AppColors.reviewGradientMid,
                          AppColors.reviewGradientBottom,
                        ],
                        stops: [0, 0.5, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        padding.top + AppSpacing.xxl,
                        AppSpacing.xl,
                        0,
                      ),
                      child: Row(
                        children: [
                          OverlayCircleButton(
                            iconAsset: 'assets/icons/review_back.svg',
                            iconWidth: 15.75,
                            iconHeight: 18,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                          const OverlayPill(
                            padding: EdgeInsets.fromLTRB(16, 13.5, 16, 10.5),
                            child: Text(
                              'Review Photo',
                              style: AppTextStyles.reviewBadge,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 44, height: 44),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ColoredBox(
              color: AppColors.cream,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  28,
                  AppSpacing.xxl,
                  padding.bottom + 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Looks good?', style: AppTextStyles.reviewHeading),
                    const SizedBox(height: 4),
                    const Text(
                      'Make sure the bark pattern is sharp and well-lit before analyzing.',
                      style: AppTextStyles.reviewBody,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    _FileCard(photo: photo),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _RetakeButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: _AnalyzeButton(
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
       builder: (_) => AnalyzingScreen(
  image: MemoryImage(photo.bytes),
  photoBytes: photo.bytes,
),
      ),
    );
  },
),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  const _FileCard({required this.photo});

  final CapturedPhoto photo;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.md),
              child: Image.memory(
                photo.bytes,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(photo.fileName, style: AppTextStyles.fileName),
                  Text(photo.metaLabel, style: AppTextStyles.fileMeta),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/check.svg',
              width: 18,
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _RetakeButton extends StatelessWidget {
  const _RetakeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: AppColors.brown,
          side: const BorderSide(color: AppColors.brown, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/retake.svg',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Retake', style: AppTextStyles.retakeButton),
          ],
        ),
      ),
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  const _AnalyzeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.analyzeShadow,
            offset: Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
          BoxShadow(
            color: AppColors.analyzeShadow,
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4,
          ),
        ],
      ),
      child: SizedBox(
        height: 56,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: AppColors.forest,
            foregroundColor: AppColors.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/analyze.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text('Analyze', style: AppTextStyles.analyzeButton),
            ],
          ),
        ),
      ),
    );
  }
}
