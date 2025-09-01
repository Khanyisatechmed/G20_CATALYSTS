// features/home/providers/home_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_endpoints.dart';

class HomeProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Map<String, dynamic>> _popularExperiences = [];
  List<Map<String, dynamic>> _arPackages = [];
  bool _isLoading = false;
  String? _error;

  HomeProvider(this._apiService);

  // Getters
  List<Map<String, dynamic>> get popularExperiences => _popularExperiences;
  List<Map<String, dynamic>> get arPackages => _arPackages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData() async {
    _setLoading(true);
    _error = null;

    try {
      await Future.wait([
        _loadPopularExperiences(),
        _loadARPackages(),
      ]);
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) print('Error loading home data: $e');
    }

    _setLoading(false);
  }

  Future<void> _loadPopularExperiences() async {
    try {
      final response = await _apiService.get(ApiEndpoints.popularExperiences);
      _popularExperiences = List<Map<String, dynamic>>.from(response.data['experiences']);
    } catch (e) {
      // Mock data for development
      _popularExperiences = [
        {
          'id': 1,
          'title': 'Pottery Workshop',
          'price': 150.0,
          'currency': 'ZAR',
          'imageUrl': '',
          'location': 'Mpumalanga',
          'rating': 4.5,
        },
        {
          'id': 2,
          'title': 'Safari Ride',
          'price': 150.0,
          'currency': 'ZAR',
          'imageUrl': '',
          'location': 'Kruger National Park',
          'rating': 4.8,
        },
      ];
    }
  }

  Future<void> _loadARPackages() async {
    try {
      final response = await _apiService.get('${ApiEndpoints.experiences}?has_ar=true');
      _arPackages = List<Map<String, dynamic>>.from(response.data['experiences']);
    } catch (e) {
      // Mock data for development
      _arPackages = [
        {
          'id': 1,
          'title': 'Museum AR Tour',
          'description': 'Interactive cultural experience',
          'imageUrl': '',
          'hasAR': true,
        },
        {
          'id': 2,
          'title': 'Lion Anatomy',
          'description': 'Educational wildlife experience',
          'imageUrl': '',
          'hasAR': true,
        },
      ];
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}


