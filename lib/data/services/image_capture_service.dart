import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/captured_photo.dart';

enum CapturePermission { camera, gallery }

class CaptureDeniedException implements Exception {
  const CaptureDeniedException(this.message);

  final String message;
}

class ImageCaptureService {
  ImageCaptureService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<CapturedPhoto?> takePhoto() {
    return _pick(ImageSource.camera, CapturePermission.camera);
  }

  Future<CapturedPhoto?> pickFromGallery() {
    return _pick(ImageSource.gallery, CapturePermission.gallery);
  }

  Future<CapturedPhoto?> _pick(
    ImageSource source,
    CapturePermission permission,
  ) async {
    await _ensurePermission(permission);

    XFile? file;
    try {
      file = await _picker.pickImage(source: source, imageQuality: 95);
    } on PlatformException catch (error) {
      if (_isAccessDenied(error)) {
        throw CaptureDeniedException(_deniedMessage(permission));
      }
      rethrow;
    }

    if (file == null) return null;
    return _fromXFile(file);
  }

  Future<void> _ensurePermission(CapturePermission permission) async {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }
    if (permission == CapturePermission.gallery &&
        defaultTargetPlatform == TargetPlatform.android) {
      return;
    }

    final status = await _permissionFor(permission).request();
    if (status.isGranted || status.isLimited) return;
    throw CaptureDeniedException(_deniedMessage(permission));
  }

  Permission _permissionFor(CapturePermission permission) {
    return permission == CapturePermission.camera
        ? Permission.camera
        : Permission.photos;
  }

  bool _isAccessDenied(PlatformException error) {
    const deniedCodes = {
      'camera_access_denied',
      'photo_access_denied',
      'camera_access_restricted',
      'photo_access_restricted',
    };
    return deniedCodes.contains(error.code);
  }

  String _deniedMessage(CapturePermission permission) {
    return permission == CapturePermission.camera
        ? 'Camera permission is required to scan bark.'
        : 'Photo library permission is required to choose a bark image.';
  }

  Future<CapturedPhoto> _fromXFile(XFile file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    try {
      return CapturedPhoto(
        bytes: bytes,
        fileName: file.name.isEmpty ? 'Bark_Scan.jpg' : file.name,
        byteSize: bytes.length,
        width: image.width,
        height: image.height,
      );
    } finally {
      image.dispose();
    }
  }
}
