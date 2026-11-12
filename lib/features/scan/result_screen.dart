import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/services/classification_result.dart';
import '../../data/store/kahoy_store.dart';
import '../catalog/species_details_screen.dart';

const Color _cardFill = Color.fromRGBO(255, 255, 255, 0.7);

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.image, required this.result});

  final ImageProvider image;
  final ClassificationResult result;

  @override
  Widget build(BuildContext context) {
    final percent = (result.confidence * 100).round();

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
              _HeroImage(image: image),
              const SizedBox(height: 24),
              Text(
                result.commonName,
                style: AppTextStyles.heroHeading.copyWith(
                  fontSize: 32,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                result.scientificName,
                style: AppTextStyles.reviewBody.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$percent% confidence',
                      style: AppTextStyles.fileName,
                    ),
                  ),
                  const Icon(Icons.eco, size: 18, color: AppColors.forest),
                ],
              ),
              const SizedBox(height: 8),
              _Bar(
                value: result.confidence,
                color: AppColors.forest,
                height: 10,
              ),
              const SizedBox(height: 24),
              Text(
                'Other possible species',
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
                    for (int i = 0; i < result.others.length; i++) ...[
                      _OtherRow(candidate: result.others[i]),
                      if (i != result.others.length - 1)
                        const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (result.note.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.amberSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.park,
                          size: 18,
                          color: AppColors.cream,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          result.note,
                          style: AppTextStyles.reviewBody.copyWith(
                            color: AppColors.forestDeep,
                            height: 1.5,
                          ),
                        ),
                      ),
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
                  onPressed: () {
                    final species = KahoyStore.instance.speciesByCommonName(
                      result.commonName,
                    );
                    if (species == null) return;
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SpeciesDetailsScreen(species: species),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book_rounded, size: 20),
                  label: Text(
                    'View Species Details',
                    style: AppTextStyles.analyzeButton,
                  ),
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
                  // Bumabalik sa Home. Mula doon, "Scan Bark" ulit.
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.photo_camera_outlined, size: 20),
                  label: Text(
                    'Scan Again',
                    style: AppTextStyles.analyzeButton.copyWith(
                      color: AppColors.forest,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: AppColors.forest,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Saved to Scan History',
                      style: AppTextStyles.fileMeta,
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

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 192,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(image: image, fit: BoxFit.cover),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.forest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.cream,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'High Confidence',
                      style: AppTextStyles.reviewBadge.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
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

class _OtherRow extends StatelessWidget {
  const _OtherRow({required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    final percent = (candidate.confidence * 100).round();

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.mint,
            image: candidate.thumbnail == null
                ? null
                : DecorationImage(
                    image: candidate.thumbnail!,
                    fit: BoxFit.cover,
                  ),
          ),
          child: candidate.thumbnail == null
              ? const Icon(
                  Icons.park_outlined,
                  size: 20,
                  color: AppColors.forest,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      candidate.name,
                      style: AppTextStyles.fileName.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: AppTextStyles.confidenceHigh.copyWith(
                      color: AppColors.mutedForest,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _Bar(
                value: candidate.confidence,
                color: AppColors.brown,
                height: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.color, required this.height});

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: radius,
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, borderRadius: radius),
            ),
          ),
        ],
      ),
    );
  }
}
