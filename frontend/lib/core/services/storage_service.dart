// core/services/storage_service.dart
import 'dart:convert';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Token management
  Future<void> saveToken(String token) async {
    await init();
    await _prefs!.setString(AppConstants.userTokenKey, token);
  }

  Future<String?> getToken() async {
    await init();
    return _prefs!.getString(AppConstants.userTokenKey);
  }

  Future<void> clearToken() async {
    await init();
    await _prefs!.remove(AppConstants.userTokenKey);
  }

  // User data management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await init();
    await _prefs!.setString(AppConstants.userDataKey, jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    await init();
    final userDataString = _prefs!.getString(AppConstants.userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearUserData() async {
    await init();
    await _prefs!.remove(AppConstants.userDataKey);
  }

  // Settings
  Future<void> saveLanguage(String languageCode) async {
    await init();
    await _prefs!.setString(AppConstants.languageKey, languageCode);
  }

  Future<String> getLanguage() async {
    await init();
    return _prefs!.getString(AppConstants.languageKey) ?? 'en';
  }

  Future<void> saveTheme(String theme) async {
    await init();
    await _prefs!.setString(AppConstants.themeKey, theme);
  }

  Future<String> getTheme() async {
    await init();
    return _prefs!.getString(AppConstants.themeKey) ?? 'system';
  }

  // Onboarding
  Future<void> setOnboardingCompleted() async {
    await init();
    await _prefs!.setBool(AppConstants.onboardingCompletedKey, true);
  }

  Future<bool> isOnboardingCompleted() async {
    await init();
    return _prefs!.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  // Generic methods
  Future<void> saveString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  Future<void> saveBool(String key, bool value) async {
    await init();
    await _prefs!.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    await init();
    return _prefs!.getBool(key) ?? false;
  }

  Future<void> saveInt(String key, int value) async {
    await init();
    await _prefs!.setInt(key, value);
  }

  Future<int> getInt(String key) async {
    await init();
    return _prefs!.getInt(key) ?? 0;
  }

  Future<void> remove(String key) async {
    await init();
    await _prefs!.remove(key);
  }

  Future<void> clear() async {
    await init();
    await _prefs!.clear();
  }
}
