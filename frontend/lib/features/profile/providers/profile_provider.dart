// features/profile/providers/profile_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/routes/route_names.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  final ApiService _apiService;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  ProfileProvider(this._apiService);

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserProfile() async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.get(ApiEndpoints.profile);
      _user = UserModel.fromJson(response.data['user']);
    } catch (e) {
      _error = e.toString();
      // Mock data for development
      _user = UserModel(
        id: 1,
        email: 'teboho@example.com',
        firstName: 'Teboho',
        lastName: 'Selepe',
        interests: ['History', 'Art', 'Local Culture'],
        createdAt: DateTime(2025, 9, 1),
        experiences: 7,
        reviews: 2,
        points: 100,
      );
      if (kDebugMode) print('Error loading profile: $e');
    }

    _setLoading(false);
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.put(ApiEndpoints.updateProfile, data: updates);
      _user = UserModel.fromJson(response.data['user']);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }

    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
