import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../catalog/species_catalog_screen.dart';

const Color _cardFill = Color.fromRGBO(255, 255, 255, 0.7);
const Color _amberBorder = Color.fromRGBO(232, 163, 61, 0.3);

class LowConfidenceScreen extends StatelessWidget {
  const LowConfidenceScreen({super.key, required this.image});

  /// Ang bark photo na na-scan.
  final ImageProvider image;

  static const List<(IconData, String)> _tips = [
    (Icons.wb_sunny_outlined, 'Ensure good, even lighting'),
    (Icons.search, 'Move closer to the bark surface'),
    (Icons.pan_tool_outlined, 'Hold the camera steady'),
    (Icons.eco_outlined, 'Avoid heavy moss, lichen, or shadows'),
  ];

  /// Bumabalik sa Capture screen: isinasara ang Low-Confidence at Review.
  void _retake(BuildContext context) {
    final nav = Navigator.of(context);
    nav.pop(); // Low-Confidence
    nav.pop(); // Review -> Capture na ang lalabas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(onBack: () => Navigator.of(context).maybePop()),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _amberBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            size: 26,
                            color: AppColors.cream,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Low Confidence Result',
                            style: AppTextStyles.speciesName.copyWith(
                              fontSize: 17,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No exact match found. Please capture a clearer image '
                      'under better lighting and try again.',
                      style: AppTextStyles.reviewBody.copyWith(
                        color: AppColors.forestDeep.withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 192,
                  width: double.infinity,
                  child: Image(image: image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tips for a better photo',
                style: AppTextStyles.speciesName.copyWith(letterSpacing: 0),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _tips.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AppColors.mint,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _tips[i].$1,
                              size: 18,
                              color: AppColors.forest,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _tips[i].$2,
                              style: AppTextStyles.reviewBody.copyWith(
                                color: AppColors.forestDeep,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: AppColors.cream,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => _retake(context),
                  icon: const Icon(Icons.photo_camera_outlined, size: 20),
                  label: Text('Retake Photo', style: AppTextStyles.analyzeButton),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.forest,
                    side: const BorderSide(color: AppColors.forest, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SpeciesCatalogScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book_rounded, size: 20),
                  label: Text(
                    'Browse Catalog',
                    style: AppTextStyles.analyzeButton.copyWith(
                      color: AppColors.forest,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: AppColors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: AppColors.forestShadow,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBack,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: AppColors.forestDeep,
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Scan Result',
            style: AppTextStyles.speciesName.copyWith(letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}