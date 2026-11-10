import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/scan_history.dart';
import '../../data/services/photo_storage.dart';
import '../../data/store/kahoy_store.dart';
import '../../widgets/recent_scan_tile.dart' show formatScanTimestamp;
import 'scan_detail_screen.dart';

const Color _cardBorder = Color.fromRGBO(27, 67, 50, 0.08);
const Color _lowRed = Color(0xFFC2503D);
const Color _lowRedSoft = Color(0xFFFBE4E1);

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
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
                      'Scan History',
                      style: AppTextStyles.heroHeading.copyWith(
                        fontSize: 20,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: _PrivacyBanner(),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: KahoyStore.instance,
                builder: (context, _) {
                  final scans = KahoyStore.instance.scans;
                  if (scans.isEmpty) return const _EmptyHistory();
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: scans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final scan = scans[i];
                      return _HistoryCard(
                        scan: scan,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ScanDetailScreen(scan: scan),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  const _PrivacyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lock, size: 18, color: AppColors.forest),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Scan history is stored only on this device.',
              style: AppTextStyles.timestamp.copyWith(
                fontSize: 13,
                color: AppColors.brown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.scan, required this.onTap});

  final ScanHistory scan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final species = KahoyStore.instance.speciesById(scan.speciesId);
    final hasMatch = species != null;
    final percent = (scan.confidenceScore * 100).round();

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _cardBorder),
          ),
          child: Row(
            children: [
              _Thumb(scan: scan, hasMatch: hasMatch),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            hasMatch ? species.commonName : 'No exact match',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.speciesName.copyWith(
                              fontSize: 18,
                              letterSpacing: 0,
                              fontStyle:
                                  hasMatch ? FontStyle.normal : FontStyle.italic,
                              color: hasMatch
                                  ? AppColors.forestDeep
                                  : AppColors.brown,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: hasMatch ? AppColors.mint : _lowRedSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '$percent%',
                            style: AppTextStyles.confidenceHigh.copyWith(
                              color: hasMatch ? AppColors.forest : _lowRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.brown,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            formatScanTimestamp(scan.timestamp),
                            style: AppTextStyles.timestamp.copyWith(fontSize: 13),
                          ),
                        ),
                      ],
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

class _Thumb extends StatelessWidget {
  const _Thumb({required this.scan, required this.hasMatch});

  final ScanHistory scan;
  final bool hasMatch;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (!hasMatch) {
      child = const ColoredBox(
        color: AppColors.mint,
        child: Center(
          child: Icon(Icons.warning_amber_rounded, size: 28, color: _lowRed),
        ),
      );
    } else {
      child = Image(
        image: imageFromPath(scan.imagePath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const ColoredBox(
          color: AppColors.mint,
          child: Center(
            child: Icon(Icons.park_outlined, size: 28, color: AppColors.forest),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(width: 64, height: 64, child: child),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 148,
              height: 148,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 144,
                    height: 144,
                    decoration: const BoxDecoration(
                      color: AppColors.mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  CustomPaint(
                    size: const Size(116, 116),
                    painter: _DashedCirclePainter(),
                  ),
                  const Icon(Icons.schedule, size: 52, color: AppColors.forest),
                  Positioned(
                    right: -4,
                    bottom: 4,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.amberSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco,
                        size: 22,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No scans yet',
              style: AppTextStyles.speciesName.copyWith(
                fontSize: 18,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.reviewBody.copyWith(
                  color: AppColors.brown,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Tap '),
                  TextSpan(
                    text: 'Scan',
                    style: AppTextStyles.fileName.copyWith(
                      color: AppColors.forestDeep,
                    ),
                  ),
                  const TextSpan(
                    text: ' to start identifying tree bark around you.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.forest.withValues(alpha: 0.35);

    final path = Path()..addOval(Offset.zero & size);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
        distance += 9;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
