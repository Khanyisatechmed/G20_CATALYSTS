// core/services/storage_service.dart
import 'dart:convert';
import 'dart:html' as html;

/// Storage service for web-based data persistence
/// Uses localStorage for web applications
class StorageService {
  static const String _tokenKey = 'ubuntu_auth_token';
  static const String _userKey = 'ubuntu_user_data';
  static const String _settingsKey = 'ubuntu_settings';

  /// Save authentication token
  Future<void> saveToken(String token) async {
    try {
      html.window.localStorage[_tokenKey] = token;
    } catch (e) {
      throw StorageException('Failed to save token: $e');
    }
  }

  /// Get authentication token
  Future<String?> getToken() async {
    try {
      return html.window.localStorage[_tokenKey];
    } catch (e) {
      throw StorageException('Failed to get token: $e');
    }
  }

  /// Clear authentication token
  Future<void> clearToken() async {
    try {
      html.window.localStorage.remove(_tokenKey);
    } catch (e) {
      throw StorageException('Failed to clear token: $e');
    }
  }

  /// Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      html.window.localStorage[_userKey] = jsonString;
    } catch (e) {
      throw StorageException('Failed to save user data: $e');
    }
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final jsonString = html.window.localStorage[_userKey];
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw StorageException('Failed to get user data: $e');
    }
  }

  /// Clear user data
  Future<void> clearUserData() async {
    try {
      html.window.localStorage.remove(_userKey);
    } catch (e) {
      throw StorageException('Failed to clear user data: $e');
    }
  }

  /// Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final jsonString = jsonEncode(settings);
      html.window.localStorage[_settingsKey] = jsonString;
    } catch (e) {
      throw StorageException('Failed to save settings: $e');
    }
  }

  /// Get app settings
  Future<Map<String, dynamic>?> getSettings() async {
    try {
      final jsonString = html.window.localStorage[_settingsKey];
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw StorageException('Failed to get settings: $e');
    }
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      await clearToken();
      await clearUserData();
      html.window.localStorage.remove(_settingsKey);
    } catch (e) {
      throw StorageException('Failed to clear all data: $e');
    }
  }

  /// Save generic data with custom key
  Future<void> saveData(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      html.window.localStorage[key] = jsonString;
    } catch (e) {
      throw StorageException('Failed to save data with key $key: $e');
    }
  }

  /// Get generic data with custom key
  Future<Map<String, dynamic>?> getData(String key) async {
    try {
      final jsonString = html.window.localStorage[key];
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw StorageException('Failed to get data with key $key: $e');
    }
  }

  /// Save string data
  Future<void> saveString(String key, String value) async {
    try {
      html.window.localStorage[key] = value;
    } catch (e) {
      throw StorageException('Failed to save string with key $key: $e');
    }
  }

  /// Get string data
  Future<String?> getString(String key) async {
    try {
      return html.window.localStorage[key];
    } catch (e) {
      throw StorageException('Failed to get string with key $key: $e');
    }
  }

  /// Remove data with custom key
  Future<void> removeData(String key) async {
    try {
      html.window.localStorage.remove(key);
    } catch (e) {
      throw StorageException('Failed to remove data with key $key: $e');
    }
  }

  /// Check if key exists
  Future<bool> hasKey(String key) async {
    try {
      return html.window.localStorage.containsKey(key);
    } catch (e) {
      throw StorageException('Failed to check key $key: $e');
    }
  }

  /// Get all storage keys
  Future<List<String>> getAllKeys() async {
    try {
      return html.window.localStorage.keys.toList();
    } catch (e) {
      throw StorageException('Failed to get all keys: $e');
    }
  }

  /// Get storage size (approximate)
  Future<int> getStorageSize() async {
    try {
      int totalSize = 0;
      for (final key in html.window.localStorage.keys) {
        final value = html.window.localStorage[key];
        if (value != null) {
          totalSize += key.length + value.length;
        }
      }
      return totalSize;
    } catch (e) {
      throw StorageException('Failed to calculate storage size: $e');
    }
  }

  /// Check if localStorage is available
  bool isAvailable() {
    try {
      final testKey = '__storage_test__';
      html.window.localStorage[testKey] = 'test';
      html.window.localStorage.remove(testKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get storage info
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final keys = await getAllKeys();
      final size = await getStorageSize();

      return {
        'isAvailable': isAvailable(),
        'keyCount': keys.length,
        'totalSize': size,
        'keys': keys,
      };
    } catch (e) {
      throw StorageException('Failed to get storage info: $e');
    }
  }
}

/// Custom exception for storage-related errors
class StorageException implements Exception {
  final String message;

  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
