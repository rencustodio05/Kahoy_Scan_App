import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/captured_photo.dart';
import '../../data/services/image_capture_service.dart';
import '../../widgets/overlay_circle_button.dart';
import 'review_screen.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key, this.captureService});

  final ImageCaptureService? captureService;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late final ImageCaptureService _service;

  @override
  void initState() {
    super.initState();
    _service = widget.captureService ?? ImageCaptureService();
  }

  Future<void> _openSource(Future<CapturedPhoto?> Function() pick) async {
    try {
      final photo = await pick();
      if (!mounted || photo == null) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => ReviewScreen(photo: photo)),
      );
    } on CaptureDeniedException catch (error) {
      if (!mounted) return;
      await _showPermissionDialog(error.message);
    } on FormatException {
      if (!mounted) return;
      _showFriendlyMessage(
        'We could not read that image. Please choose another photo.',
      );
    } catch (_) {
      if (!mounted) return;
      _showFriendlyMessage(
        'Something went wrong while opening the image. Please try again.',
      );
    }
  }

  Future<void> _showPermissionDialog(String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('Permission needed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              await openAppSettings();
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );

    if (result == false || result == null) {
      return;
    }
  }

  void _showFriendlyMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.forest,
        content: Text(message, style: AppTextStyles.captureTip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/capture_viewfinder.png',
              fit: BoxFit.cover,
            ),
            const ColoredBox(color: AppColors.overlayScrim),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ViewfinderFrame(),
                    SizedBox(height: AppSpacing.xxl),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.overlayCaption,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppRadii.pill),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.sm,
                        ),
                        child: Text(
                          'Fill the frame with bark',
                          style: AppTextStyles.captureHint,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OverlayCircleButton(
                      iconAsset: 'assets/icons/back.svg',
                      iconWidth: 15.75,
                      iconHeight: 18,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    OverlayCircleButton(
                      iconAsset: 'assets/icons/flash.svg',
                      iconWidth: 15.75,
                      iconHeight: 18,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(bottom: padding.bottom + 40),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: OverlayPill(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _AssetIcon(
                              asset: 'assets/icons/bulb.svg',
                              width: 10.5,
                              height: 14,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              'Use good lighting and keep the camera\nsteady',
                              style: AppTextStyles.captureTip,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _GalleryButton(
                            onTap: () => _openSource(_service.pickFromGallery),
                          ),
                          _ShutterButton(
                            onTap: () => _openSource(_service.takePhoto),
                          ),
                          const SizedBox(
                            width: 56,
                            height: 56,
                            child: Center(
                              child: IgnorePointer(
                                child: _AssetIcon(
                                  asset: 'assets/icons/flip_camera.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
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

class _AssetIcon extends StatelessWidget {
  const _AssetIcon({
    required this.asset,
    required this.width,
    required this.height,
  });

  final String asset;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(asset, width: width, height: height);
  }
}

class _ViewfinderFrame extends StatelessWidget {
  const _ViewfinderFrame();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 288,
      height: 288,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: _Corner(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
              border: Border(
                top: BorderSide(color: AppColors.white, width: 4),
                left: BorderSide(color: AppColors.white, width: 4),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _Corner(
              borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
              border: Border(
                top: BorderSide(color: AppColors.white, width: 4),
                right: BorderSide(color: AppColors.white, width: 4),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _Corner(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: AppColors.white, width: 4),
                left: BorderSide(color: AppColors.white, width: 4),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _Corner(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: AppColors.white, width: 4),
                right: BorderSide(color: AppColors.white, width: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.borderRadius, required this.border});

  final BorderRadius borderRadius;
  final BoxBorder border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: borderRadius, border: border),
      ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  const _GalleryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.galleryFill,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: AppColors.galleryBorder, width: 2),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/gallery.svg',
            width: 22.5,
            height: 20,
          ),
        ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.cream,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.shutterRing, width: 4),
          boxShadow: const [
            BoxShadow(
              color: AppColors.captureShadow,
              offset: Offset(0, 20),
              blurRadius: 25,
              spreadRadius: -5,
            ),
            BoxShadow(
              color: AppColors.captureShadow,
              offset: Offset(0, 8),
              blurRadius: 10,
              spreadRadius: -6,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.forest, width: 2),
          ),
        ),
      ),
    );
  }
}
