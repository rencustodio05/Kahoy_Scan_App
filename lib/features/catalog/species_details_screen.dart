import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/species.dart';
import '../../data/services/photo_storage.dart';

const Color _cardBorder = Color.fromRGBO(27, 67, 50, 0.08);
const Color _emptyThumb = Color(0xFFE9EAF0);

class SpeciesDetailsScreen extends StatefulWidget {
  const SpeciesDetailsScreen({super.key, required this.species});

  final Species species;

  @override
  State<SpeciesDetailsScreen> createState() => _SpeciesDetailsScreenState();
}

class _SpeciesDetailsScreenState extends State<SpeciesDetailsScreen> {
  final PageController _pages = PageController();
  int _index = 0;
  bool _bookmarked = false; // UI lang muna, hindi sine-save

  Species get _s => widget.species;
  List<String> get _images => _s.gallery.isEmpty ? [_s.imagePath] : _s.gallery;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    if (i < 0 || i >= _images.length) return;
    _pages.animateToPage(
      i,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildCarousel(),
              const SizedBox(height: 12),
              _buildThumbnails(),
              const SizedBox(height: 24),
              _buildTitleRow(),
              const SizedBox(height: 4),
              Text(
                _s.scientificName,
                style: AppTextStyles.reviewBody.copyWith(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: AppColors.brown,
                ),
              ),
              if (_s.highlight != null) ...[
                const SizedBox(height: 12),
                _HighlightBadge(text: _s.highlight!),
              ],
              const SizedBox(height: 24),
              _InfoSection(
                icon: Icons.notes,
                title: 'Description',
                body: _s.description,
              ),
              const SizedBox(height: 24),
              _InfoSection(
                icon: Icons.landscape,
                title: 'Habitat',
                body: _s.habitat,
              ),
              const SizedBox(height: 24),
              _InfoSection(icon: Icons.hardware, title: 'Uses', body: _s.uses),
              const SizedBox(height: 24),
              const Divider(height: 1, thickness: 1, color: _cardBorder),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
            'Species Details',
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    final count = _images.length;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 224,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pages,
              itemCount: count,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => Image(
                image: imageFromPath(_images[i]),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: AppColors.mint,
                  child: Center(
                    child: Icon(
                      Icons.park_outlined,
                      size: 56,
                      color: AppColors.forest,
                    ),
                  ),
                ),
              ),
            ),
            if (count > 1) ...[
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _ArrowButton(
                    icon: Icons.chevron_left,
                    onTap: () => _goTo(_index - 1),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _ArrowButton(
                    icon: Icons.chevron_right,
                    onTap: () => _goTo(_index + 1),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < count; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _index ? 8 : 6,
                        height: i == _index ? 8 : 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _index
                              ? AppColors.white
                              : const Color.fromRGBO(255, 255, 255, 0.55),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnails() {
    return Row(
      children: [
        for (int i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _goTo(i),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _emptyThumb,
                border: i == _index
                    ? Border.all(color: AppColors.forest, width: 2)
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: i < _images.length
                    ? Image(
                        image: imageFromPath(_images[i]),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const ColoredBox(color: _emptyThumb),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _s.commonName,
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Material(
          color: AppColors.mint,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => setState(() => _bookmarked = !_bookmarked),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                _bookmarked ? Icons.bookmark : Icons.bookmark_border,
                size: 22,
                color: AppColors.forestDeep,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.overlayScrim,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 22, color: AppColors.white),
        ),
      ),
    );
  }
}

class _HighlightBadge extends StatelessWidget {
  const _HighlightBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.forest),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.fileName.copyWith(
              fontSize: 12,
              height: 16 / 12,
              color: AppColors.forest,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.forest),
            ),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.sectionTitle),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: AppTextStyles.reviewBody.copyWith(
            fontSize: 15,
            height: 1.6,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }
}
