import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/scan_history.dart';
import '../../data/services/photo_storage.dart';
import '../../data/services/tflite_classifier_service.dart';
import '../../data/store/kahoy_store.dart';
import 'low_confidence_screen.dart';
import 'result_screen.dart';

const Color _cardFill = Color.fromRGBO(255, 255, 255, 0.7);
const Color _pendingText = Color.fromRGBO(18, 46, 34, 0.4);

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({
    super.key,
    required this.image,
    required this.photoBytes,
  });

  /// Ang bark photo na kinuha o pinili ng student (para sa display).
  final ImageProvider image;

  /// Ang parehong larawan bilang bytes (para i-save sa device).
  final Uint8List photoBytes;

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  final List<Timer> _timers = [];
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _timers.add(Timer(const Duration(milliseconds: 650), () => _setStep(1)));
    _timers.add(Timer(const Duration(milliseconds: 1300), () => _setStep(2)));
    _runClassifier();
  }

  void _setStep(int value) {
    if (mounted) setState(() => _step = value);
  }

  Future<void> _runClassifier() async {
    final result = await TfliteClassifierService.instance.classify(
      widget.photoBytes,
    );
    final savedPath = await PhotoStorage.save(widget.photoBytes);
    if (!mounted) return;

    // Sa ilalim ng 70%, null ang species (ayon sa paper).
    final species = result.isHighConfidence
        ? KahoyStore.instance.speciesByCommonName(result.commonName)
        : null;

    await KahoyStore.instance.addScan(
      ScanHistory(
        id: 'scan-${DateTime.now().microsecondsSinceEpoch}',
        speciesId: species?.id,
        imagePath: savedPath,
        confidenceScore: result.confidence,
        timestamp: DateTime.now(),
      ),
    );

    if (!mounted) return;

    if (result.isHighConfidence) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(image: widget.image, result: result),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LowConfidenceScreen(image: widget.image),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 56),
              _buildRing(),
              const SizedBox(height: 40),
              Text(
                'Analyzing bark on\nyour device…',
                textAlign: TextAlign.center,
                style: AppTextStyles.heroHeading.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco, size: 16, color: AppColors.forest),
                    const SizedBox(width: 8),
                    Text('No internet needed', style: AppTextStyles.banner),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _cardFill,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.forestOverlay,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _StepRow(
                      icon: Icons.search,
                      label: 'Detecting bark texture',
                      stepIndex: 0,
                      currentStep: _step,
                    ),
                    const _StepDivider(),
                    _StepRow(
                      icon: Icons.layers,
                      label: 'Matching catalog',
                      stepIndex: 1,
                      currentStep: _step,
                    ),
                    const _StepDivider(),
                    _StepRow(
                      icon: Icons.pie_chart,
                      label: 'Calculating confidence',
                      stepIndex: 2,
                      currentStep: _step,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRing() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(200, 200), painter: _RingPainter(_spin)),
          Container(
            width: 152,
            height: 152,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [
                BoxShadow(color: AppColors.forestOverlay, blurRadius: 16),
              ],
            ),
            child: ClipOval(
              child: Image(
                image: widget.image,
                fit: BoxFit.cover,
                width: 144,
                height: 144,
              ),
            ),
          ),
          Positioned(
            left: 152,
            top: 11,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.eco, size: 14, color: AppColors.cream),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress) : super(repaint: progress);

  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = AppColors.mint;
    canvas.drawCircle(center, radius, base);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = AppColors.forest;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + progress.value * 2 * math.pi,
      math.pi * 1.5,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => false;
}

class _StepDivider extends StatelessWidget {
  const _StepDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 52),
      child: Divider(height: 1, thickness: 1, color: AppColors.mint),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.icon,
    required this.label,
    required this.stepIndex,
    required this.currentStep,
  });

  final IconData icon;
  final String label;
  final int stepIndex;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final isDone = currentStep > stepIndex;
    final isActive = currentStep == stepIndex;
    final isPending = currentStep < stepIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPending ? AppColors.mint : AppColors.forest,
            ),
            child: Icon(
              icon,
              size: 18,
              color: isPending ? _pendingText : AppColors.cream,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: isPending
                  ? AppTextStyles.reviewBody.copyWith(color: _pendingText)
                  : AppTextStyles.fileName.copyWith(fontSize: 15),
            ),
          ),
          if (isActive)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.forest,
              ),
            ),
          if (isDone)
            const Icon(Icons.check_circle, size: 20, color: AppColors.forest),
        ],
      ),
    );
  }
}
