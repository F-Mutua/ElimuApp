import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/resource_model.dart';

class OfflineService {
  static const String _downloadedResourcesKey = 'downloaded_resources';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _selectedGradeKey = 'selected_grade';
  static const String _languageKey = 'language';

  late Box<dynamic> _resourceBox;
  late SharedPreferences _prefs;

  // Initialize Hive and SharedPreferences
  Future<void> initialize() async {
    try {
      if (kIsWeb) {
        // For web, Hive uses IndexedDB
        await Hive.initFlutter();
      } else {
        // For mobile, Hive uses local storage
        await Hive.initFlutter();
      }
      _resourceBox = await Hive.openBox('resources');
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Error initializing offline service: $e');
      // Initialize prefs at minimum
      _prefs = await SharedPreferences.getInstance();
    }
  }

  // Save downloaded resource info
  Future<void> saveDownloadedResource(ResourceModel resource) async {
    try {
      final resources = await getDownloadedResources();
      resources.add(resource);

      final jsonList = resources.map((r) => r.toJson()).toList();
      await _prefs.setString(_downloadedResourcesKey, json.encode(jsonList));

      // Also save to Hive for faster access
      await _resourceBox.put(resource.id, resource.toJson());
    } catch (e) {
      debugPrint('Error saving downloaded resource: $e');
    }
  }

  // Get all downloaded resources
  Future<List<ResourceModel>> getDownloadedResources() async {
    try {
      final jsonString = _prefs.getString(_downloadedResourcesKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => ResourceModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting downloaded resources: $e');
      return [];
    }
  }

  // Remove downloaded resource info
  Future<void> removeDownloadedResource(String resourceId) async {
    try {
      final resources = await getDownloadedResources();
      resources.removeWhere((r) => r.id == resourceId);

      final jsonList = resources.map((r) => r.toJson()).toList();
      await _prefs.setString(_downloadedResourcesKey, json.encode(jsonList));

      // Remove from Hive
      await _resourceBox.delete(resourceId);
    } catch (e) {
      debugPrint('Error removing downloaded resource: $e');
    }
  }

  // Check if resource is downloaded
  Future<bool> isResourceDownloaded(String resourceId) async {
    try {
      final resources = await getDownloadedResources();
      return resources.any((r) => r.id == resourceId);
    } catch (e) {
      debugPrint('Error checking if resource is downloaded: $e');
      return false;
    }
  }

  // Get downloaded resource by ID
  Future<ResourceModel?> getDownloadedResourceById(String resourceId) async {
    try {
      final resources = await getDownloadedResources();
      return resources.firstWhere(
        (r) => r.id == resourceId,
        orElse: () => throw Exception('Resource not found'),
      );
    } catch (e) {
      debugPrint('Error getting downloaded resource by ID: $e');
      return null;
    }
  }

  // Save user preferences
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      await _prefs.setString(_userPreferencesKey, json.encode(preferences));
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
    }
  }

  // Get user preferences
  Future<Map<String, dynamic>?> getUserPreferences() async {
    try {
      final jsonString = _prefs.getString(_userPreferencesKey);
      if (jsonString != null) {
        return json.decode(jsonString);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user preferences: $e');
      return null;
    }
  }

  // Check if first time user
  Future<bool> isFirstTime() async {
    return _prefs.getBool(_isFirstTimeKey) ?? true;
  }

  // Set first time flag
  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(_isFirstTimeKey, value);
  }

  // Save selected grade
  Future<void> saveSelectedGrade(String grade) async {
    await _prefs.setString(_selectedGradeKey, grade);
  }

  // Get selected grade
  Future<String?> getSelectedGrade() async {
    return _prefs.getString(_selectedGradeKey);
  }

  // Save language preference
  Future<void> saveLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  // Get language preference
  Future<String> getLanguage() async {
    return _prefs.getString(_languageKey) ?? 'English';
  }

  // Clear all offline data
  Future<void> clearAllData() async {
    await _prefs.clear();
    await _resourceBox.clear();
  }

  // Get cache size
  Future<int> getCacheSize() async {
    try {
      int size = 0;
      final keys = _resourceBox.keys;
      for (var key in keys) {
        final value = _resourceBox.get(key);
        if (value != null) {
          size += json.encode(value).length;
        }
      }
      return size;
    } catch (e) {
      debugPrint('Error getting cache size: $e');
      return 0;
    }
  }

  // Save survey data
  Future<void> saveSurveyData(Map<String, dynamic> surveyData) async {
    try {
      await _prefs.setString('survey_data', json.encode(surveyData));
    } catch (e) {
      debugPrint('Error saving survey data: $e');
    }
  }

  // Get survey data
  Future<Map<String, dynamic>?> getSurveyData() async {
    try {
      final jsonString = _prefs.getString('survey_data');
      if (jsonString != null) {
        return json.decode(jsonString);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting survey data: $e');
      return null;
    }
  }
}
