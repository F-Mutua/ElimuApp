import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/resource_model.dart';

class DownloadService {
  final Dio _dio = Dio();

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return false;
    }
    return true; // iOS doesn't need explicit storage permission
  }

  // Get download directory
  Future<String> getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Create elimuapp/downloads directory
        final downloadPath = '${directory.path}/elimuapp/downloads';
        final downloadDir = Directory(downloadPath);
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadPath;
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      final downloadPath = '${directory.path}/downloads';
      final downloadDir = Directory(downloadPath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      return downloadPath;
    }

    throw Exception('Could not get download directory');
  }

  // Download file with progress callback
  Future<String?> downloadFile(
    ResourceModel resource,
    Function(int, int)? onProgress,
  ) async {
    try {
      // Request permission
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Get download directory
      final downloadDir = await getDownloadDirectory();

      // Create filename
      final extension = resource.type == 'video'
          ? '.mp4'
          : resource.type == 'pdf' ||
                resource.type == 'textbook' ||
                resource.type == 'note'
          ? '.pdf'
          : '.file';

      final fileName =
          '${resource.grade}_${resource.subject}_${resource.title.replaceAll(' ', '_')}$extension';
      final filePath = '$downloadDir/$fileName';

      // Download file
      await _dio.download(
        resource.url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received, total);
          }
        },
      );

      return filePath;
    } catch (e) {
      debugPrint('Error downloading file: $e');
      return null;
    }
  }

  // Check if file exists locally
  Future<bool> isFileDownloaded(String? localPath) async {
    if (localPath == null || localPath.isEmpty) return false;
    final file = File(localPath);
    return await file.exists();
  }

  // Delete downloaded file
  Future<bool> deleteFile(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }

  // Get file size
  Future<int?> getFileSize(String localPath) async {
    try {
      final file = File(localPath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting file size: $e');
      return null;
    }
  }

  // Get all downloaded files
  Future<List<FileSystemEntity>> getAllDownloadedFiles() async {
    try {
      final downloadDir = await getDownloadDirectory();
      final directory = Directory(downloadDir);

      if (await directory.exists()) {
        return directory.listSync();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting downloaded files: $e');
      return [];
    }
  }

  // Calculate total download size
  Future<int> getTotalDownloadSize() async {
    try {
      final files = await getAllDownloadedFiles();
      int totalSize = 0;

      for (var file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      return totalSize;
    } catch (e) {
      debugPrint('Error calculating total size: $e');
      return 0;
    }
  }

  // Format bytes to readable string
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
