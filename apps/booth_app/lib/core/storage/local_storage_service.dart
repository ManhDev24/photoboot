import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Active Session Persistence (For crash recovery - Requirement 103)
  static Future<void> saveActiveSession(Map<String, dynamic> sessionJson) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.activeSessionKey, jsonEncode(sessionJson));
  }

  static Future<Map<String, dynamic>?> getActiveSession() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final data = prefs.getString(AppConstants.activeSessionKey);
    if (data != null && data.isNotEmpty) {
      try {
        return jsonDecode(data) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Error parsing active session: $e');
      }
    }
    return null;
  }

  static Future<void> clearActiveSession() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.activeSessionKey);
  }

  // Save Session to Local Gallery Database
  static Future<void> saveCompletedSession(Map<String, dynamic> sessionJson) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final existingRaw = prefs.getString(AppConstants.sessionsStorageKey);
    List<dynamic> list = [];
    if (existingRaw != null && existingRaw.isNotEmpty) {
      try {
        list = jsonDecode(existingRaw) as List<dynamic>;
      } catch (e) {
        list = [];
      }
    }
    list.add(sessionJson);
    await prefs.setString(AppConstants.sessionsStorageKey, jsonEncode(list));
    await clearActiveSession();
  }

  static Future<List<Map<String, dynamic>>> getAllSessions() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final existingRaw = prefs.getString(AppConstants.sessionsStorageKey);
    if (existingRaw != null && existingRaw.isNotEmpty) {
      try {
        final List<dynamic> rawList = jsonDecode(existingRaw) as List<dynamic>;
        return rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      } catch (e) {
        debugPrint('Error reading session gallery: $e');
      }
    }
    return [];
  }

  // Save Image File Locally
  static Future<String> saveImageBytes(List<int> bytes, String filename) async {
    if (kIsWeb) {
      // On web, convert to base64 data URI or blob URL representation
      final base64Str = base64Encode(bytes);
      return 'data:image/png;base64,$base64Str';
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${appDir.path}/photobooth_photos');
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }
      final file = File('${photosDir.path}/$filename');
      await file.writeAsBytes(bytes);
      return file.path;
    }
  }
}
