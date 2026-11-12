import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/scan_history.dart';
import '../../data/services/photo_storage.dart';
import '../../data/store/kahoy_store.dart';
import '../../widgets/recent_scan_tile.dart' show formatScanTimestamp;
import '../catalog/species_details_screen.dart';

const Color _cardBorder = Color.fromRGBO(27, 67, 50, 0.08);
const Color _lowRed = Color(0xFFC2503D);
const Color _lowRedSoft = Color(0xFFFBE4E1);

class ScanDetailScreen extends StatelessWidget {
  const ScanDetailScreen({super.key, required this.scan});

  final ScanHistory scan;

  @override
  Widget build(BuildContext context) {
    final species = KahoyStore.instance.speciesById(scan.speciesId);
    final hasMatch = species != null;
    final accent = hasMatch ? AppColors.forest : _lowRed;
    final percent = (scan.confidenceScore * 100).round();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _cardBorder),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 22,
                          color: AppColors.forestDeep,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Scan Detail',
                      style: AppTextStyles.heroHeading.copyWith(
                        fontSize: 20,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 286,
                  width: double.infinity,
                  child: Image(
                    image: imageFromPath(scan.imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: AppColors.mint,
                      child: Center(
                        child: Icon(
                          Icons.park_outlined,
                          size: 64,
                          color: AppColors.forest,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasMatch ? species.commonName : 'No exact match',
                          style: AppTextStyles.heroHeading.copyWith(
                            fontSize: hasMatch ? 32 : 26,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            fontStyle:
                                hasMatch ? FontStyle.normal : FontStyle.italic,
                            color:
                                hasMatch ? AppColors.forestDeep : AppColors.brown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasMatch
                              ? species.scientificName
                              : 'Below the 70% confidence threshold',
                          style: AppTextStyles.reviewBody.copyWith(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppColors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: hasMatch ? AppColors.mint : _lowRedSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hasMatch ? Icons.eco : Icons.warning_amber_rounded,
                      size: 22,
                      color: accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _InfoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Confidence Score',
                            style: AppTextStyles.reviewBody.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.brown,
                            ),
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _Bar(value: scan.confidenceScore, color: accent),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _InfoCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const _IconBox(icon: Icons.access_time),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        formatScanTimestamp(scan.timestamp),
                        style: AppTextStyles.reviewBody.copyWith(
                          fontSize: 15,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasMatch) ...[
                const SizedBox(height: 12),
                _InfoCard(
                  padding: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SpeciesDetailsScreen(species: species),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const _IconBox(icon: Icons.menu_book_rounded),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'View Species Details',
                              style: AppTextStyles.fileName.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 22,
                            color: AppColors.forestDeep,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.amberSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        size: 20,
                        color: AppColors.amber,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tip: take a closer, sharper photo of the bark in '
                          'good daylight, and avoid moss or shadows.',
                          style: AppTextStyles.reviewBody.copyWith(
                            color: AppColors.forestDeep,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cardBorder),
        ),
        child: child,
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: AppColors.forest),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(999);
    return SizedBox(
      height: 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: AppColors.mint, borderRadius: radius),
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
