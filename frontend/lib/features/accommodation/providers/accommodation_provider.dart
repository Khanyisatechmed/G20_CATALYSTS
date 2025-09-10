// features/accommodation/providers/accommodation_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class AccommodationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _accommodations = [];
  List<Map<String, dynamic>> _filteredAccommodations = [];
  Map<String, dynamic>? _selectedAccommodation;
  bool _isLoading = false;
  String? _error;

  // Filter properties - keeping your existing ones and adding missing ones
  String _selectedType = 'all';
  RangeValues _priceRange = const RangeValues(0, 2000);
  final Set<String> _selectedAmenities = {};
  int _maxGuests = 2;
  String _searchQuery = '';

  // Additional filter properties needed by the UI
  String _selectedLocation = '';
  double _minPrice = 0;
  double _maxPrice = 5000;
  int _guests = 1;
  List<String> _amenities = [];
  String _propertyType = '';

  AccommodationProvider(ApiService read);

  // Getters - your existing ones
  List<Map<String, dynamic>> get accommodations => _accommodations;
  List<Map<String, dynamic>> get filteredAccommodations => _filteredAccommodations;
  Map<String, dynamic>? get selectedAccommodation => _selectedAccommodation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedType => _selectedType;
  RangeValues get priceRange => _priceRange;
  Set<String> get selectedAmenities => _selectedAmenities;
  int get maxGuests => _maxGuests;
  String get searchQuery => _searchQuery;

  // Additional getters needed by the UI
  String get selectedLocation => _selectedLocation;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  int get guests => _guests;
  List<String> get amenities => _amenities;
  String get propertyType => _propertyType;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> fetchAccommodations() async {
    await loadAccommodations();
  }

  Future<void> loadAccommodations() async {
    _setLoading(true);
    _setError(null);

    try {
      // Your existing API call logic
      final response = await _apiService.get('/accommodations');
      _accommodations = List<Map<String, dynamic>>.from(response.data['accommodations']);
      _applyFilters();
    } catch (e) {
      // Enhanced mock data for development
      _accommodations = [
        {
          'id': '1',
          'name': 'Wanders Village Homestay',
          'description': 'Experience authentic Wandershospitality in this traditional homestead. Wake up to the sound of birdsong and enjoy home-cooked meals with your host family.',
          'location': 'Eastern Cape, South Africa',
          'price': 450.0,
          'pricePerNight': 450.0,
          'currency': 'ZAR',
          'rating': 4.8,
          'reviews': 127,
          'reviewCount': 127,
          'maxGuests': 4,
          'bedrooms': 2,
          'bathrooms': 1,
          'propertyType': 'Homestay',
          'type': 'homestay',
          'amenities': ['WiFi', 'Kitchen', 'Cultural Tours', 'Traditional Meals'],
          'images': [
            'https://example.com/ubuntu-homestay1.jpg',
            'https://example.com/ubuntu-homestay2.jpg',
            'https://example.com/ubuntu-homestay3.jpg',
          ],
          'imageUrls': ['https://example.com/ubuntu-homestay1.jpg'],
          'host': {
            'name': 'Mama Nomsa',
            'bio': 'Traditional healer and storyteller with 30 years of hospitality experience',
            'avatar': 'https://example.com/mama-nomsa.jpg',
          },
          'culturalExperiences': ['Traditional cooking', 'Storytelling', 'Craft making'],
          'hasARTour': true,
        },
        {
          'id': '2',
          'name': 'Rondavel Cultural Lodge',
          'description': 'Stay in traditional round huts with modern amenities. Experience authentic Zulu culture through dance, music, and storytelling.',
          'location': 'KwaZulu-Natal, South Africa',
          'price': 680.0,
          'pricePerNight': 680.0,
          'currency': 'ZAR',
          'rating': 4.6,
          'reviews': 89,
          'reviewCount': 89,
          'maxGuests': 6,
          'bedrooms': 3,
          'bathrooms': 2,
          'propertyType': 'Lodge',
          'type': 'lodge',
          'amenities': ['WiFi', 'Pool', 'Restaurant', 'Cultural Shows', 'Nature Walks'],
          'images': [
            'https://example.com/rondavel-lodge1.jpg',
            'https://example.com/rondavel-lodge2.jpg',
            'https://example.com/rondavel-lodge3.jpg',
          ],
          'imageUrls': ['https://example.com/rondavel-lodge1.jpg'],
          'host': {
            'name': 'Chief Mbeki',
            'bio': 'Community leader passionate about sharing Zulu traditions',
            'avatar': 'https://example.com/chief-mbeki.jpg',
          },
          'culturalExperiences': ['Zulu dancing', 'Beadwork', 'Traditional ceremonies'],
          'hasARTour': true,
        },
        {
          'id': '3',
          'name': 'Karoo Farm Stay',
          'description': 'Peaceful retreat on a working farm with spectacular mountain views. Learn about sustainable farming and enjoy star-filled nights.',
          'location': 'Northern Cape, South Africa',
          'price': 320.0,
          'pricePerNight': 320.0,
          'currency': 'ZAR',
          'rating': 4.7,
          'reviews': 156,
          'reviewCount': 156,
          'maxGuests': 8,
          'bedrooms': 4,
          'bathrooms': 3,
          'propertyType': 'Farm Stay',
          'type': 'farmstay',
          'amenities': ['WiFi', 'Kitchen', 'Game Drives', 'Star Gazing', 'Farm Tours'],
          'images': [
            'https://example.com/karoo-farm1.jpg',
            'https://example.com/karoo-farm2.jpg',
            'https://example.com/karoo-farm3.jpg',
          ],
          'imageUrls': ['https://example.com/karoo-farm1.jpg'],
          'host': {
            'name': 'Tante Anna',
            'bio': 'Third-generation farmer specializing in sustainable agriculture',
            'avatar': 'https://example.com/tante-anna.jpg',
          },
          'culturalExperiences': ['Farm life experience', 'Traditional cooking', 'Astronomy'],
          'hasARTour': false,
        },
      ];
      _applyFilters();
      if (kDebugMode) print('Error loading accommodations: $e');
    }

    _setLoading(false);
  }

  // Your existing methods
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

  // Additional methods needed by the UI
  void setSelectedAccommodation(Map<String, dynamic> accommodation) {
    _selectedAccommodation = accommodation;
    notifyListeners();
  }

  void searchAccommodations(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void setLocationFilter(String location) {
    _selectedLocation = location;
    _applyFilters();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _priceRange = RangeValues(min, max);
    _applyFilters();
  }

  void setGuestsFilter(int guestCount) {
    _guests = guestCount;
    _maxGuests = guestCount;
    _applyFilters();
  }

  void setAmenitiesFilter(List<String> selectedAmenities) {
    _amenities = selectedAmenities;
    _selectedAmenities.clear();
    _selectedAmenities.addAll(selectedAmenities);
    _applyFilters();
  }

  void setPropertyTypeFilter(String type) {
    _propertyType = type;
    _selectedType = type == '' ? 'all' : type.toLowerCase();
    _applyFilters();
  }

  void clearFilters() {
    _selectedType = 'all';
    _priceRange = const RangeValues(0, 2000);
    _selectedAmenities.clear();
    _maxGuests = 2;
    _searchQuery = '';
    _selectedLocation = '';
    _minPrice = 0;
    _maxPrice = 5000;
    _guests = 1;
    _amenities.clear();
    _propertyType = '';
    _applyFilters();
  }

  // Get accommodation by ID
  Map<String, dynamic>? getAccommodationById(String id) {
    try {
      return _accommodations.firstWhere((accommodation) => accommodation['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get unique locations
  List<String> getUniqueLocations() {
    return _accommodations
        .map((accommodation) => accommodation['location'] as String? ?? '')
        .where((location) => location.isNotEmpty)
        .toSet()
        .toList()..sort();
  }

  // Get unique property types
  List<String> getUniquePropertyTypes() {
    return _accommodations
        .map((accommodation) => accommodation['propertyType'] as String? ?? '')
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList()..sort();
  }

  // Get all unique amenities
  List<String> getAllAmenities() {
    final Set<String> allAmenities = {};
    for (final accommodation in _accommodations) {
      final amenities = accommodation['amenities'] as List<String>? ?? [];
      allAmenities.addAll(amenities);
    }
    return allAmenities.toList()..sort();
  }

  void _applyFilters() {
    _filteredAccommodations = _accommodations.where((accommodation) {
      // Type filter (your existing logic)
      if (_selectedType != 'all' && accommodation['type'] != _selectedType) {
        return false;
      }

      // Price filter (enhanced to work with both ranges)
      final price = accommodation['pricePerNight']?.toDouble() ??
                   accommodation['price']?.toDouble() ?? 0.0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Guest capacity filter (your existing logic)
      final maxGuests = accommodation['maxGuests'] ?? 0;
      if (maxGuests < _maxGuests) {
        return false;
      }

      // Amenities filter (your existing logic)
      if (_selectedAmenities.isNotEmpty) {
        final amenities = List<String>.from(accommodation['amenities'] ?? []);
        if (!_selectedAmenities.every((amenity) => amenities.contains(amenity))) {
          return false;
        }
      }

      // Search filter (your existing logic)
      if (_searchQuery.isNotEmpty) {
        final name = accommodation['name']?.toLowerCase() ?? '';
        final location = accommodation['location']?.toLowerCase() ?? '';
        if (!name.contains(_searchQuery) && !location.contains(_searchQuery)) {
          return false;
        }
      }

      // Location filter (additional)
      if (_selectedLocation.isNotEmpty &&
          accommodation['location'] != _selectedLocation) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Clear data (for logout, etc.)
  void clearData() {
    _accommodations.clear();
    _filteredAccommodations.clear();
    _selectedAccommodation = null;
    _error = null;
    _isLoading = false;
    clearFilters();
    notifyListeners();
  }
}
