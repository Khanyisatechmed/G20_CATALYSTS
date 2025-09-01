// features/auth/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/api_endpoints.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storage = StorageService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  Map<String, dynamic>? _user;
  String? _token;

  AuthProvider(this._apiService) {
    _initializeAuth();
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  Future<void> _initializeAuth() async {
    _token = await _storage.getToken();
    _user = await _storage.getUserData();
    _isAuthenticated = _token != null && _user != null;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final response = await _apiService.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      _token = data['access_token'];
      _user = data['user'];

      await _storage.saveToken(_token!);
      await _storage.saveUserData(_user!);

      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required List<String> interests,
  }) async {
    _setLoading(true);

    try {
      final response = await _apiService.post(ApiEndpoints.register, data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'interests': interests,
      });

      final data = response.data;
      _token = data['access_token'];
      _user = data['user'];

      await _storage.saveToken(_token!);
      await _storage.saveUserData(_user!);

      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);
  }

  Future<void> logout() async {
    try {
      await _apiService.post(ApiEndpoints.logout);
    } catch (e) {
      // Continue with logout even if API call fails
      if (kDebugMode) print('Logout API error: $e');
    }

    await _storage.clearToken();
    await _storage.clearUserData();

    _token = null;
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> refreshToken() async {
    try {
      final response = await _apiService.post(ApiEndpoints.refreshToken);
      final data = response.data;

      _token = data['access_token'];
      await _storage.saveToken(_token!);

      notifyListeners();
    } catch (e) {
      await logout();
      rethrow;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    _setLoading(true);

    try {
      final response = await _apiService.put(ApiEndpoints.updateProfile, data: profileData);
      _user = response.data['user'];
      await _storage.saveUserData(_user!);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }

    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

