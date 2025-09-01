// features/accommodation/providers/accommodation_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_endpoints.dart';

class AccommodationProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Map<String, dynamic>> _accommodations = [];
  List<Map<String, dynamic>> _filteredAccommodations = [];
  bool _isLoading = false;
  String _selectedType = 'all';
  RangeValues _priceRange = const RangeValues(0, 2000);
  final Set<String> _selectedAmenities = {};
  int _maxGuests = 2;
  String _searchQuery = '';

  AccommodationProvider(this._apiService);

  // Getters
  List<Map<String, dynamic>> get accommodations => _accommodations;
  List<Map<String, dynamic>> get filteredAccommodations => _filteredAccommodations;
  bool get isLoading => _isLoading;
  String get selectedType => _selectedType;
  RangeValues get priceRange => _priceRange;
  Set<String> get selectedAmenities => _selectedAmenities;
  int get maxGuests => _maxGuests;

  Future<void> loadAccommodations() async {
    _setLoading(true);

    try {
      final response = await _apiService.get(ApiEndpoints.accommodations);
      _accommodations = List<Map<String, dynamic>>.from(response.data['accommodations']);
      _applyFilters();
    } catch (e) {
      // Mock data for development
      _accommodations = [
        {
          'id': 1,
          'name': 'Cozy Riverside Cottage',
          'description': 'Wake up to the sound of birdsong by the tranquil river. Perfect for couples seeking peace and privacy.',
          'location': 'Sabie, Mpumalanga',
          'pricePerNight': 850.0,
          'currency': 'ZAR',
          'maxGuests': 2,
          'bedrooms': 1,
          'rating': 4.8,
          'reviewCount': 45,
          'amenities': ['WiFi', 'Breakfast', 'River View'],
          'imageUrls': [''],
          'hasARTour': true,
          'type': 'cottage',
        },
      ];
      _applyFilters();
      if (kDebugMode) print('Error loading accommodations: $e');
    }

    _setLoading(false);
  }

  void selectType(String type) {
    _selectedType = type;
    _applyFilters();
  }

  void updatePriceRange(RangeValues range) {
    _priceRange = range;
    _applyFilters();
  }

  void toggleAmenity(String amenity) {
    if (_selectedAmenities.contains(amenity)) {
      _selectedAmenities.remove(amenity);
    } else {
      _selectedAmenities.add(amenity);
    }
    _applyFilters();
  }

  void updateMaxGuests(int guests) {
    _maxGuests = guests;
    _applyFilters();
  }

  void searchAccommodations(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void clearFilters() {
    _selectedType = 'all';
    _priceRange = const RangeValues(0, 2000);
    _selectedAmenities.clear();
    _maxGuests = 2;
    _searchQuery = '';
    _applyFilters();
  }

  void _applyFilters() {
    _filteredAccommodations = _accommodations.where((accommodation) {
      // Type filter
      if (_selectedType != 'all' && accommodation['type'] != _selectedType) {
        return false;
      }

      // Price filter
      final price = accommodation['pricePerNight']?.toDouble() ?? 0.0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Guest capacity filter
      final maxGuests = accommodation['maxGuests'] ?? 0;
      if (maxGuests < _maxGuests) {
        return false;
      }

      // Amenities filter
      if (_selectedAmenities.isNotEmpty) {
        final amenities = List<String>.from(accommodation['amenities'] ?? []);
        if (!_selectedAmenities.every((amenity) => amenities.contains(amenity))) {
          return false;
        }
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final name = accommodation['name']?.toLowerCase() ?? '';
        final location = accommodation['location']?.toLowerCase() ?? '';
        if (!name.contains(_searchQuery) && !location.contains(_searchQuery)) {
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
