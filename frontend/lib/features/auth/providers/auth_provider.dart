// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/api_endpoints.dart' as api;

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storage = StorageService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  Map<String, dynamic>? _user;
  String? _token;
  String? _error;

  // Development mode flag - set to false when backend is ready
  static const bool _useMockAuth = kDebugMode;

  AuthProvider(this._apiService) {
    _initializeAuth();
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  String? get error => _error;

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
    _clearError();

    try {
      if (_useMockAuth) {
        // Mock authentication for development
        await _mockLogin(email, password);
      } else {
        // Real API call
        final response = await _apiService.post(api.ApiEndpoints.login, data: {
          'email': email,
          'password': password,
        });

        final data = response.data;
        _token = data['access_token'];
        _user = data['user'];

        await _storage.saveToken(_token!);
        await _storage.saveUserData(_user!);

        _isAuthenticated = true;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      if (kDebugMode) print('Login error: $e');

      // Fallback to mock auth if API fails
      if (!_useMockAuth) {
        try {
          await _mockLogin(email, password);
        } catch (mockError) {
          rethrow;
        }
      } else {
        rethrow;
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required List<String> interests,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (_useMockAuth) {
        // Mock registration for development
        await _mockSignUp(email, password, firstName, lastName, interests);
      } else {
        // Real API call
        final response = await _apiService.post(api.ApiEndpoints.register, data: {
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
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      if (kDebugMode) print('SignUp error: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      if (!_useMockAuth) {
        await _apiService.post(api.ApiEndpoints.logout);
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      if (kDebugMode) print('Logout API error: $e');
    }
    await _storage.clearToken();
    await _storage.clearUserData();
    _token = null;
    _user = null;
    _isAuthenticated = false;
    _clearError();
    _setLoading(false);
  }

  Future<void> refreshToken() async {
    if (_useMockAuth) {
      if (_token != null) {
        _token = 'mock_refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
        await _storage.saveToken(_token!);
        notifyListeners();
      }
      return;
    }
    try {
      final response = await _apiService.post(api.ApiEndpoints.refreshToken);
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
    _clearError();
    try {
      if (_useMockAuth) {
        await Future.delayed(const Duration(seconds: 1));
        _user = {..._user!, ...profileData};
        await _storage.saveUserData(_user!);
      } else {
        final response = await _apiService.put(api.ApiEndpoints.updateProfile, data: profileData);
        _user = response.data['user'];
        await _storage.saveUserData(_user!);
      }
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    _clearError();
    try {
      if (_useMockAuth) {
        await Future.delayed(const Duration(seconds: 1));
        if (email.isEmpty || !email.contains('@')) {
          throw Exception('Please enter a valid email address');
        }
      } else {
        await _apiService.post(api.ApiEndpoints.forgotPassword, data: {
          'email': email,
        });
      }
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please enter email and password');
    }
    final userData = {
      'id': '12345',
      'email': email,
      'first_name': 'Ubuntu',
      'last_name': 'User',
      'interests': ['Culture', 'History', 'Art', 'Traditional Crafts'],
      'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'profile_completed': true,
      'cultural_points': 250,
      'experiences_count': 5,
      'places_visited': 8,
      'avatar_url': '',
      'phone': '+27 11 123 4567',
      'location': 'Johannesburg, South Africa',
      'bio': 'Passionate about Wanders philosophy and South African culture.',
    };
    final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _user = userData;
    _token = mockToken;
    await _storage.saveToken(_token!);
    await _storage.saveUserData(_user!);
    _isAuthenticated = true;
    if (kDebugMode) print('Mock login successful for: $email');
  }

  Future<void> _mockSignUp(
    String email,
    String password,
    String firstName,
    String lastName,
    List<String> interests
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      throw Exception('All fields are required');
    }
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }

    final userData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'interests': interests,
      'created_at': DateTime.now().toIso8601String(),
      'profile_completed': false,
      'cultural_points': 0,
      'experiences_count': 0,
      'places_visited': 0,
      'avatar_url': '',
      'phone': '',
      'location': '',
      'bio': '',
    };
    final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _user = userData;
    _token = mockToken;
    await _storage.saveToken(_token!);
    await _storage.saveUserData(_user!);
    _isAuthenticated = true;
    if (kDebugMode) print('Mock registration successful for: $email');
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  bool get isUsingMockAuth => _useMockAuth;
}