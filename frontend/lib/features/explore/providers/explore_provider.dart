// features/explore/providers/explore_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_endpoints.dart';

class ExploreProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Map<String, dynamic>> _destinations = [];
  List<Map<String, dynamic>> _filteredDestinations = [];
  bool _isLoading = false;
  bool _showMapView = false;
  String _selectedCategory = 'all';
  final Set<String> _selectedProvinces = {};
  RangeValues _priceRange = const RangeValues(0, 1000);
  String _searchQuery = '';

  ExploreProvider(this._apiService);

  // Getters
  List<Map<String, dynamic>> get destinations => _destinations;
  List<Map<String, dynamic>> get filteredDestinations => _filteredDestinations;
  bool get isLoading => _isLoading;
  bool get showMapView => _showMapView;
  String get selectedCategory => _selectedCategory;
  Set<String> get selectedProvinces => _selectedProvinces;
  RangeValues get priceRange => _priceRange;
  bool get hasActiveFilters => _selectedCategory != 'all' ||
                               _selectedProvinces.isNotEmpty ||
                               _priceRange != const RangeValues(0, 1000);

  Future<void> loadDestinations() async {
    _setLoading(true);

    try {
      final response = await _apiService.get(ApiEndpoints.destinations);
      _destinations = List<Map<String, dynamic>>.from(response.data['destinations']);
      _applyFilters();
    } catch (e) {
      // Mock data for development
      _destinations = [
        {
          'id': 1,
          'title': 'The Bantus',
          'location': '2199, Extension 2',
          'rating': 4.5,
          'reviewCount': 120,
          'price': 150.0,
          'imageUrl': '',
          'category': 'culture',
          'province': 'Mpumalanga',
        },
        {
          'id': 2,
          'title': 'Kruger National Park',
          'location': '2199, Extension 2',
          'rating': 4.5,
          'reviewCount': 120,
          'price': 150.0,
          'imageUrl': '',
          'category': 'wildlife',
          'province': 'Mpumalanga',
        },
      ];
      _applyFilters();
      if (kDebugMode) print('Error loading destinations: $e');
    }

    _setLoading(false);
  }

  void toggleMapView() {
    _showMapView = !_showMapView;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void toggleProvince(String province) {
    if (_selectedProvinces.contains(province)) {
      _selectedProvinces.remove(province);
    } else {
      _selectedProvinces.add(province);
    }
    _applyFilters();
  }

  void updatePriceRange(RangeValues range) {
    _priceRange = range;
    _applyFilters();
  }

  void searchDestinations(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void clearFilters() {
    _selectedCategory = 'all';
    _selectedProvinces.clear();
    _priceRange = const RangeValues(0, 1000);
    _searchQuery = '';
    _applyFilters();
  }

  void _applyFilters() {
    _filteredDestinations = _destinations.where((destination) {
      // Category filter
      if (_selectedCategory != 'all' &&
          destination['category'] != _selectedCategory) {
        return false;
      }

      // Province filter
      if (_selectedProvinces.isNotEmpty &&
          !_selectedProvinces.contains(destination['province'])) {
        return false;
      }

      // Price filter
      final price = destination['price']?.toDouble() ?? 0.0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final title = destination['title']?.toLowerCase() ?? '';
        final location = destination['location']?.toLowerCase() ?? '';
        if (!title.contains(_searchQuery) && !location.contains(_searchQuery)) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
