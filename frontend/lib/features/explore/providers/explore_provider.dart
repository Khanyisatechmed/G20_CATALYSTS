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
          'title': 'Tsitsikamma National Park',
          'name': 'Tsitsikamma National Park',
          'location': 'Eastern Cape, South Africa',
          'category': 'Marine & Forest Reserve',
          'rating': 4.8,
          'reviewCount': 127,
          'price': 450.0,
          'currency': 'ZAR',
          'description': 'Africa\'s first Marine National Park (established 1964), featuring 80km of pristine coastline, ancient indigenous forests, and one of the world\'s largest "no-take" Marine Protected Areas. Originally inhabited by Khoi and San people, the name means "place of much water" in Khoikhoi. Experience the famous Otter Trail, Storms River Mouth suspension bridge, and rich historical heritage including Thomas Bain\'s 1879-1885 wagon road construction.',
          'image': 'assets/images/tsistsikama.png',
          'hasHistoricalSignificance': true,
          'features': ['marine_protected_area', 'indigenous_forest', 'otter_trail', 'storms_river_mouth', 'historical_sites'],
        },
        {
          'id': '2',
          'title': 'eMakhosini Ophathe Heritage Park',
          'location': 'KwaZulu-Natal, South Africa',
          'category': 'Cultural',
          'rating': 4.6,
          'reviewCount': 89,
          'price': 280.0,
          'description': 'Sacred "Valley of the Kings" near Ulundi, birthplace of the Zulu nation where ancestors lived and early Zulu kings are buried. Features burial sites of King Senzangakhona (Shaka\'s father), King Dingane, and King Mpande. Includes historic battle sites like KwaGqokli Hill where King Shaka defeated the Ndwandwe, and uMgungundlovu royal capital where Piet Retief was killed.',
          'image': 'assets/images/kingshakagrave.png',
          'hasHistoricalSignificance': true,
          'features': ['zulu_royal_history', 'cultural_heritage', 'historical_battles', 'royal_burial_sites'],
        },
        {
          'id': '3',
          'title': 'Robben Island',
          'location': 'Western Cape, South Africa',
          'category': 'Cultural',
          'rating': 4.7,
          'reviewCount': 156,
          'price': 320.0,
          'description': 'Famous as the place where Nelson Mandela was imprisoned for 18 years. Historic island with 400 years of history as a place of exile, imprisonment, and isolation. From Dutch colonial prison (17th century) to leper colony and mental asylum (19th century), to apartheid-era maximum security prison for political prisoners (1961-1996). Now a UNESCO World Heritage Site and living museum with tours led by former political prisoners.',
          'image': 'assets/images/robbenisland.png',
          'hasHistoricalSignificance': true,
          'features': ['political_prison_history', 'mandela_cell_tour', 'former_prisoner_guides', 'unesco_heritage_site'],
        },
        {
          'id': '4',
          'title': 'Kruger National Park',
          'location': 'Mpumalanga, South Africa',
          'category': 'Wildlife',
          'rating': 4.9,
          'reviewCount': 203,
          'price': 1200.0,
          'description': 'South Africa\'s first national park (1926), established from Sabie Game Reserve (1898) by President Paul Kruger. Home to Africa\'s Big Five across 19,485 km² of pristine wilderness. Built through the vision of Paul Kruger and dedication of first warden James Stevenson-Hamilton, who spent 44 years transforming it from a small reserve into a world-renowned conservation success story.',
          'image': 'assets/images/kruger.png',
          'hasHistoricalSignificance': true,
          'features': ['big_five_wildlife', 'conservation_history', 'paul_kruger_legacy', 'stevenson_hamilton_heritage'],
        },
        {
          'id': '5',
          'title': 'Golden Gate Highlands National Park',
          'location': 'Free State, South Africa',
          'category': 'Mountain',
          'rating': 4.5,
          'reviewCount': 78,
          'price': 850.0,
          'description': 'Named by farmer J.N.R. van Reenen in 1875 for the golden glow of sandstone cliffs at sunset. Officially proclaimed September 13, 1963, to protect dramatic geological formations and grassland biome. Features Brandwag Buttress, Cathedral Cave, San rock art, and paleontological sites with fossilized dinosaur eggs. Home to endangered bearded vultures and Basotho Cultural Village showcasing traditional heritage.',
          'image': 'assets/images/golden.png',
          'hasHistoricalSignificance': true,
          'features': ['geological_formations', 'san_rock_art', 'dinosaur_fossils', 'basotho_culture'],
        },
       {
          'id': '6',
          'title': 'ǂKhomani Cultural Landscape',
          'location': 'Northern Cape, South Africa',
          'category': 'Cultural Heritage',
          'rating': 4.4,
          'reviewCount': 92,
          'price': 580.0,
          'description': 'UNESCO World Heritage Site (2017) representing 150,000 years of continuous San occupation in the Kalahari Desert. Home to the ǂKhomani San people, among the last indigenous communities in South Africa. After forced removal in 1931 when Kalahari Gemsbok National Park was established, the community won landmark land rights restoration in 1999. Features ancient ethnobotanical knowledge, traditional tracking skills, and living hunter-gatherer culture.',
          'image': 'assets/images/khoi.png',
          'hasHistoricalSignificance': true,
          'features': ['san_culture', 'traditional_tracking', 'ethnobotanical_knowledge', 'land_rights_restoration'],
        },
       {
          'id': '7',
          'title': 'Apartheid Museum',
          'location': 'Gauteng, South Africa',
          'category': 'Historical',
          'rating': 4.6,
          'reviewCount': 145,
          'price': 280.0,
          'description': 'World\'s pre-eminent museum on 20th century South Africa, opened November 2001. Built by Gold Reef City consortium as R80 million social responsibility project. Features 22 exhibition areas taking visitors through apartheid\'s rise and fall, from segregated entrance experience to democratic liberation. Includes powerful Mandela Exhibition and uses film footage, photographs, and personal artifacts to illustrate human stories behind political events.',
          'image': 'assets/images/soweto.png',
          'hasHistoricalSignificance': true,
          'features': ['apartheid_history', 'mandela_exhibition', 'segregated_entrance_experience', 'human_rights_education'],
        },
        {
          'id': '8',
          'title': 'Magoebaskloof',
          'location': 'Limpopo, South Africa',
          'category': 'Mountain Heritage',
          'rating': 4.7,
          'reviewCount': 312,
          'price': 650.0,
          'description': 'Named "Makgoba\'s Valley" after King Mamphoku Makgoba of the Tlou people who resisted ZAR taxation and land annexation from 1888-1895. This lush, misty mountain pass between Tzaneen and Haenertsburg preserves the legacy of fierce resistance against colonial forces. Known as "Land of Silver Mist," featuring indigenous forests, Debengeni Falls, and the tragic history where King Makgoba was beheaded by Swazi mercenaries in 1895.',
          'image': 'assets/images/magoebaskloof.png',
          'hasHistoricalSignificance': true,
          'features': ['king_makgoba_history', 'tlou_people_heritage', 'indigenous_forests', 'resistance_legacy'],
        }
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
