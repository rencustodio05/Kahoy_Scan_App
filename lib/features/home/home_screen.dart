import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/scan_history.dart';
import '../../data/store/kahoy_store.dart';
import '../../widgets/app_header.dart';
import '../../widgets/offline_banner.dart';
import '../../widgets/recent_scan_tile.dart';
import '../../widgets/scan_bark_button.dart';
import '../../widgets/shortcut_card.dart';
import '../catalog/species_catalog_screen.dart';
import '../history/scan_detail_screen.dart';
import '../history/scan_history_screen.dart';
import '../scan/capture_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),
            Expanded(
              child: ListenableBuilder(
                listenable: KahoyStore.instance,
                builder: (context, _) => _HomeBody(
                  scans: KahoyStore.instance.scans.take(3).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _open(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.scans});

  final List<ScanHistory> scans;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ready for your field work today?',
            style: AppTextStyles.heroHeading,
          ),
          const SizedBox(height: AppSpacing.lg),
          const OfflineBanner(),
          const SizedBox(height: AppSpacing.xxl),
          ScanBarkButton(
            onPressed: () => _open(context, const CaptureScreen()),
          ),
          const SizedBox(height: AppSpacing.xxl),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ShortcutCard(
                    title: 'Species\nCatalog',
                    iconAsset: 'assets/icons/book.svg',
                    iconWidth: 20.25,
                    iconHeight: 18,
                    onTap: () => _open(context, const SpeciesCatalogScreen()),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: ShortcutCard(
                    title: 'Scan History',
                    iconAsset: 'assets/icons/clock.svg',
                    iconWidth: 18,
                    iconHeight: 18,
                    onTap: () => _open(context, const ScanHistoryScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.section),
          Row(
            children: [
              const Expanded(
                child: Text('Recent Scans', style: AppTextStyles.sectionTitle),
              ),
              GestureDetector(
                onTap: () => _open(context, const ScanHistoryScreen()),
                child: const Text('View all', style: AppTextStyles.viewAll),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (scans.isEmpty)
            const Text(
              'No scans yet. Tap Scan Bark to start.',
              style: AppTextStyles.timestamp,
            ),
          for (var i = 0; i < scans.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            RecentScanTile(
              scan: scans[i],
              speciesName: KahoyStore.instance
                      .speciesById(scans[i].speciesId)
                      ?.commonName ??
                  'No exact match',
              onTap: () => _open(context, ScanDetailScreen(scan: scans[i])),
            ),
          ],
        ],
      ),
    );
  }
}
