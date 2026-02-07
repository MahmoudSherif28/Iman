import 'dart:io';

import 'package:flutter/services.dart';

class DownloadsStorageService {
  static const MethodChannel _channel = MethodChannel('iman/downloads');

  static Future<bool> needsLegacyStoragePermission() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('needsLegacyStoragePermission');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<String?> findInDownloads({
    required String relativePath,
    required String fileName,
    String mimeType = 'audio/mpeg',
  }) async {
    if (!Platform.isAndroid) return null;
    try {
      final result = await _channel.invokeMethod<String>('findInDownloads', {
        'relativePath': relativePath,
        'fileName': fileName,
        'mimeType': mimeType,
      });
      return result;
    } on PlatformException {
      return null;
    }
  }

  static Future<String> saveToDownloads({
    required String sourcePath,
    required String relativePath,
    required String fileName,
    String mimeType = 'audio/mpeg',
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('DownloadsStorageService is only supported on Android');
    }

    final result = await _channel.invokeMethod<String>('saveToDownloads', {
      'sourcePath': sourcePath,
      'relativePath': relativePath,
      'fileName': fileName,
      'mimeType': mimeType,
    });

    if (result == null || result.isEmpty) {
      throw StateError('Failed to save file to Downloads');
    }
    return result;
  }
}
