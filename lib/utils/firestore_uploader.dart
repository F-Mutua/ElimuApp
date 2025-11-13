import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/resource_model.dart';
import '../services/firebase_service.dart';

/// Utility class to upload local JSON data to Firestore
/// This is a one-time setup utility to populate Firestore with initial data
class FirestoreUploader {
  final FirebaseService _firebaseService;

  FirestoreUploader(this._firebaseService);

  /// Upload all resources from local JSON files to Firestore
  Future<void> uploadAllGrades() async {
    try {
      debugPrint('Starting Firestore upload...');

      for (int grade = 6; grade <= 9; grade++) {
        await uploadGrade(grade.toString());
      }

      debugPrint('✅ All grades uploaded successfully!');
    } catch (e) {
      debugPrint('❌ Error uploading to Firestore: $e');
      rethrow;
    }
  }

  /// Upload resources for a specific grade
  Future<void> uploadGrade(String grade) async {
    try {
      debugPrint('Uploading Grade $grade...');

      // Load from local JSON file
      final String jsonString = await rootBundle.loadString(
        'data/grade$grade.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<ResourceModel> resources = [];

      // Parse textbooks
      if (jsonData['textbooks'] != null) {
        for (var item in jsonData['textbooks']) {
          resources.add(
            ResourceModel.fromJson({
              ...item,
              'type': 'textbook',
              'grade': grade,
            }),
          );
        }
      }

      // Parse notes
      if (jsonData['notes'] != null) {
        for (var item in jsonData['notes']) {
          resources.add(
            ResourceModel.fromJson({...item, 'type': 'note', 'grade': grade}),
          );
        }
      }

      // Parse PDFs
      if (jsonData['pdfs'] != null) {
        for (var item in jsonData['pdfs']) {
          resources.add(
            ResourceModel.fromJson({...item, 'type': 'pdf', 'grade': grade}),
          );
        }
      }

      // Parse videos
      if (jsonData['videos'] != null) {
        for (var item in jsonData['videos']) {
          resources.add(
            ResourceModel.fromJson({...item, 'type': 'video', 'grade': grade}),
          );
        }
      }

      // Upload to Firestore
      await _firebaseService.batchUploadResources(resources);

      debugPrint('✅ Grade $grade: ${resources.length} resources uploaded');
    } catch (e) {
      debugPrint('❌ Error uploading Grade $grade: $e');
      rethrow;
    }
  }

  /// Clear all resources from Firestore (use with caution!)
  Future<void> clearAllResources() async {
    debugPrint('⚠️ This will delete all resources from Firestore!');
    // Implementation would require admin SDK or manual deletion
    // Not recommended for production use
  }
}
