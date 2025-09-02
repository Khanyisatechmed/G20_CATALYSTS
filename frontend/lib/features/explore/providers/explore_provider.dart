// features/explore/providers/explore_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';

class ExploreProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _destinations = [];
  List<String> _selectedCategories = [];
  List<String> _selectedFeatures = [];
  RangeValues _priceRange = const RangeValues(0, 2000);
  double _minimumRating = 0.0;
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get destinations => _destinations;
  List<String> get selectedCategories => _selectedCategories;
  List<String> get selectedFeatures => _selectedFeatures;
  RangeValues get priceRange => _priceRange;
  double get minimumRating => _minimumRating;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get categories => [
    'Cultural',
    'Adventure',
    'Nature',
    'Beach',
    'City',
    'Mountain',
    'Wildlife',
    'Historical',
  ];

  List<Map<String, dynamic>> get filteredDestinations {
    List<Map<String, dynamic>> filtered = _destinations.where((destination) {
      // Category filter
      if (_selectedCategories.isNotEmpty &&
          !_selectedCategories.contains(destination['category'])) {
        return false;
      }

      // Price filter
      final price = (destination['price'] as num?)?.toDouble() ?? 0.0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Rating filter
      final rating = (destination['rating'] as num?)?.toDouble() ?? 0.0;
      if (rating < _minimumRating) {
        return false;
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final title = (destination['title'] ?? destination['name'] ?? '').toString().toLowerCase();
        final location = (destination['location'] ?? '').toString().toLowerCase();
        final description = (destination['description'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();

        if (!title.contains(query) &&
            !location.contains(query) &&
            !description.contains(query)) {
          return false;
        }
      }

      // Features filter
      if (_selectedFeatures.isNotEmpty) {
        final features = destination['features'] as List<String>? ?? [];
        final hasAllFeatures = _selectedFeatures.every((feature) => features.contains(feature));
        if (!hasAllFeatures) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort the filtered results
    _sortDestinations(filtered);

    return filtered;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadDestinations() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock Ubuntu-focused destinations
      _destinations = [
        {
          'id': '1',
          'title': 'Ubuntu Village Experience',
          'name': 'Ubuntu Village Experience',
          'location': 'Eastern Cape, South Africa',
          'category': 'Cultural',
          'rating': 4.8,
          'reviewCount': 127,
          'price': 450.0,
          'currency': 'ZAR',
          'description': 'Immerse yourself in authentic Ubuntu philosophy through community interaction, traditional storytelling, and shared meals with local families.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['cultural_tours', 'ubuntu_philosophy', 'local_community', 'traditional_food'],
        },
        {
          'id': '2',
          'title': 'Drakensberg Ubuntu Retreat',
          'location': 'KwaZulu-Natal, South Africa',
          'category': 'Mountain',
          'rating': 4.6,
          'reviewCount': 89,
          'price': 680.0,
          'description': 'Mountain retreat focusing on Ubuntu principles with traditional Zulu cultural experiences and breathtaking views.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['ubuntu_philosophy', 'cultural_tours', 'local_community'],
        },
        {
          'id': '3',
          'title': 'Cape Town Cultural AR Tour',
          'location': 'Western Cape, South Africa',
          'category': 'City',
          'rating': 4.7,
          'reviewCount': 156,
          'price': 320.0,
          'description': 'Explore Cape Town\'s rich cultural heritage through augmented reality, learning about Ubuntu values in urban settings.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['ar_experience', 'cultural_tours', 'ubuntu_philosophy'],
        },
        {
          'id': '4',
          'title': 'Kruger Wildlife & Culture',
          'location': 'Mpumalanga, South Africa',
          'category': 'Wildlife',
          'rating': 4.9,
          'reviewCount': 203,
          'price': 1200.0,
          'description': 'Combine wildlife viewing with local community visits, learning how Ubuntu principles guide conservation efforts.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['cultural_tours', 'ubuntu_philosophy', 'local_community'],
        },
        {
          'id': '5',
          'title': 'Garden Route Ubuntu Journey',
          'location': 'Western Cape, South Africa',
          'category': 'Beach',
          'rating': 4.5,
          'reviewCount': 78,
          'price': 850.0,
          'description': 'Coastal adventure combining beach activities with visits to local communities practicing Ubuntu hospitality.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['ubuntu_philosophy', 'local_community', 'traditional_food'],
        },
        {
          'id': '6',
          'title': 'Blyde River Cultural Hike',
          'location': 'Mpumalanga, South Africa',
          'category': 'Nature',
          'rating': 4.4,
          'reviewCount': 92,
          'price': 400.0,
          'description': 'Hiking experience with local guides sharing traditional knowledge and Ubuntu wisdom about nature connection.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['cultural_tours', 'ubuntu_philosophy', 'local_community'],
        },
        {
          'id': '7',
          'title': 'Johannesburg Ubuntu Heritage',
          'location': 'Gauteng, South Africa',
          'category': 'Historical',
          'rating': 4.3,
          'reviewCount': 145,
          'price': 280.0,
          'description': 'Historical tour exploring how Ubuntu philosophy influenced South African history and continues to shape communities.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['cultural_tours', 'ubuntu_philosophy', 'ar_experience'],
        },
        {
          'id': '8',
          'title': 'Free Ubuntu Philosophy Workshop',
          'location': 'Online/Various locations',
          'category': 'Cultural',
          'rating': 4.7,
          'reviewCount': 312,
          'price': 0.0,
          'description': 'Free introductory workshop on Ubuntu philosophy: "I am because we are" - understanding interconnectedness and community.',
          'imageUrl': '',
          'hasUbuntuExperience': true,
          'features': ['ubuntu_philosophy', 'cultural_tours'],
        },
      ];

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load destinations: $e');
      _setLoading(false);
    }
  }

  void selectCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void clearCategorySelection() {
    _selectedCategories.clear();
    notifyListeners();
  }

  void toggleFeature(String feature) {
    if (_selectedFeatures.contains(feature)) {
      _selectedFeatures.remove(feature);
    } else {
      _selectedFeatures.add(feature);
    }
    notifyListeners();
  }

  void updatePriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void updateMinimumRating(double rating) {
    _minimumRating = rating;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategories.clear();
    _selectedFeatures.clear();
    _priceRange = const RangeValues(0, 2000);
    _minimumRating = 0.0;
    _searchQuery = '';
    _sortBy = 'name';
    notifyListeners();
  }

  void _sortDestinations(List<Map<String, dynamic>> destinations) {
    switch (_sortBy) {
      case 'name':
        destinations.sort((a, b) => (a['title'] ?? a['name'] ?? '').compareTo(b['title'] ?? b['name'] ?? ''));
        break;
      case 'price_low':
        destinations.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
        break;
      case 'price_high':
        destinations.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
        break;
      case 'rating':
        destinations.sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
        break;
      case 'popular':
        destinations.sort((a, b) => (b['reviewCount'] ?? 0).compareTo(a['reviewCount'] ?? 0));
        break;
    }
  }

  // Get destination by ID
  Map<String, dynamic>? getDestinationById(String id) {
    try {
      return _destinations.firstWhere((destination) => destination['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get popular destinations
  List<Map<String, dynamic>> getPopularDestinations() {
    return _destinations
        .where((destination) => ((destination['rating'] as num?)?.toDouble() ?? 0.0) >= 4.5)
        .take(5)
        .toList();
  }

  // Get destinations by category
  List<Map<String, dynamic>> getDestinationsByCategory(String category) {
    return _destinations
        .where((destination) => destination['category'] == category)
        .toList();
  }

  // Get unique locations
  List<String> getUniqueLocations() {
    return _destinations
        .map((destination) => destination['location'] as String? ?? '')
        .where((location) => location.isNotEmpty)
        .toSet()
        .toList()..sort();
  }

  // Clear error
  void clearError() {
    _setError(null);
  }
}
