// features/home/providers/home_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend/core/services/api_service.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _featuredExperiences = [];
  List<Map<String, dynamic>> _arPackages = [];
  Map<String, dynamic>? _userStats;

  HomeProvider(ApiService read);

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get featuredExperiences => _featuredExperiences;
  List<Map<String, dynamic>> get arPackages => _arPackages;
  Map<String, dynamic>? get userStats => _userStats;

  // Load all data needed for the home screen
  Future<void> loadData() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Load mock data
      await _loadFeaturedExperiences();
      await _loadARPackages();
      await _loadUserStats();

      debugPrint('Home data loaded successfully');
    } catch (e) {
      _setError('Failed to load home data: ${e.toString()}');
      debugPrint('Home data loading error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadFeaturedExperiences() async {
    _featuredExperiences = [
      {
        'id': '1',
        'title': 'Tsitsikamma National Park',
        'location': 'Eastern Cape',
        'price': 450,
        'currency': 'ZAR',
        'rating': 4.8,
        'reviewCount': 127,
        'duration': 480, // minutes (full day experience)
        'description': 'Africa\'s first Marine National Park (established 1964), featuring 80km of pristine coastline, ancient indigenous forests, and one of the world\'s largest "no-take" Marine Protected Areas. Originally inhabited by Khoi and San people, the name means "place of much water" in Khoikhoi. Experience the famous Otter Trail, Storms River Mouth suspension bridge, and rich historical heritage including Thomas Bain\'s 1879-1885 wagon road construction.',
        'image': 'assets/images/tsistsikama.png',
        'category': 'Marine & Forest Reserve',
        'difficulty': 'Moderate',
        'groupSize': 'Up to 12 people',
        'includes': ['Park entrance fees', 'Historical guide', 'Suspension bridge access', 'Forest trail maps', 'Marine life viewing'],
      },
     {
        'id': '2',
        'title': 'eMakhosini Ophathe Heritage Park',
        'location': 'KwaZulu-Natal',
        'price': 280,
        'currency': 'ZAR',
        'rating': 4.6,
        'reviewCount': 89,
        'duration': 280, // minutes (full day heritage experience)
        'description': 'Sacred "Valley of the Kings" near Ulundi, birthplace of the Zulu nation where ancestors lived and early Zulu kings are buried. Features burial sites of King Senzangakhona (Shaka\'s father), King Dingane, and King Mpande. Includes historic battle sites like KwaGqokli Hill where King Shaka defeated the Ndwandwe, and uMgungundlovu royal capital where Piet Retief was killed.',
        'image': 'assets/images/kingshakagrave.png',
        'category': 'Cultural',
        'difficulty': 'Easy to Moderate',
        'groupSize': 'Up to 15 people',
        'includes': ['Heritage park entrance', 'Zulu cultural guide', 'Royal grave sites visit', 'Spirit of eMakhosini monument', 'Historical battle sites', 'Wildlife viewing'],
      },
      {
        'id': '3',
        'title': 'Robben Island',
        'location': 'Western Cape',
        'price': 660,
        'currency': 'ZAR',
        'rating': 4.7,
        'reviewCount': 156,
        'duration': 210, // minutes (3.5 hour tour including ferry)
        'description': 'UNESCO World Heritage Site where Nelson Mandela was imprisoned for 18 years. Historic prison island with 400 years of history from Dutch colonial prison to apartheid-era maximum security facility. Tours led by former political prisoners sharing firsthand accounts of the struggle for freedom and democracy.',
        'image': 'assets/images/robben-island.png',
        'category': 'Cultural Heritage',
        'difficulty': 'Easy',
        'groupSize': 'Ferry capacity groups',
        'includes': ['Return ferry from V&A Waterfront', 'Former political prisoner guide', 'Mandela\'s cell visit', 'Prison complex tour', 'Island bus tour', 'Historical exhibitions'],
      },
      {
        'id': '4',
        'title': 'Ubuntu Philosophy Circle',
        'location': 'Johannesburg',
        'price': 150,
        'currency': 'ZAR',
        'rating': 4.7,
        'reviewCount': 42,
        'duration': 90,
        'description': 'Explore the deep meaning of Ubuntu philosophy',
        'image': null,
        'category': 'Philosophy',
        'difficulty': 'Easy',
        'groupSize': 'Up to 12 people',
        'includes': ['Discussion circle', 'Traditional tea', 'Philosophy guide'],
      },
    ];
  }

  Future<void> _loadARPackages() async {
    _arPackages = [
      {
        'id': 'ar_1',
        'title': 'Museum AR Tour',
        'location': 'Johannesburg',
        'description': 'Explore ancient artifacts through AR technology',
        'price': 150,
        'currency': 'ZAR',
        'rating': 4.8,
        'reviewCount': 67,
        'duration': 45,
        'type': 'museum',
        'difficulty': 'Easy',
        'ageRange': '8+',
        'features': ['3D artifacts', 'Interactive exhibits', 'Audio guide'],
        'requirements': ['Smartphone', 'AR app'],
        'isActive': true,
      },
      {
        'id': 'ar_2',
        'title': 'Cultural Heritage AR',
        'location': 'Cape Town',
        'description': 'Experience traditional culture through AR immersion',
        'price': 200,
        'currency': 'ZAR',
        'rating': 4.6,
        'reviewCount': 43,
        'duration': 60,
        'type': 'cultural',
        'difficulty': 'Easy',
        'ageRange': '10+',
        'features': ['Cultural ceremonies', 'Traditional stories', 'Virtual guides'],
        'requirements': ['VR headset provided', 'Comfortable shoes'],
        'isActive': true,
      },
      {
        'id': 'ar_3',
        'title': 'Historical Sites AR',
        'location': 'Pretoria',
        'description': 'Walk through history with AR reconstruction',
        'price': 0, // Free experience
        'currency': 'ZAR',
        'rating': 4.5,
        'reviewCount': 89,
        'duration': 30,
        'type': 'historical',
        'difficulty': 'Easy',
        'ageRange': 'All ages',
        'features': ['Historical recreation', 'Timeline view', 'Educational content'],
        'requirements': ['Mobile device', 'GPS enabled'],
        'isActive': true,
      },
      {
        'id': 'ar_4',
        'title': 'Wildlife AR Safari',
        'location': 'Kruger National Park',
        'description': 'Virtual wildlife encounters with AR animals',
        'price': 350,
        'currency': 'ZAR',
        'rating': 4.9,
        'reviewCount': 156,
        'duration': 90,
        'type': 'wildlife',
        'difficulty': 'Moderate',
        'ageRange': '6+',
        'features': ['AR animals', 'Conservation education', 'Photo opportunities'],
        'requirements': ['AR device provided', 'Outdoor activity'],
        'isActive': true,
      },
    ];
  }

  Future<void> _loadUserStats() async {
    _userStats = {
      'experiencesBooked': 5,
      'placesVisited': 8,
      'culturalPoints': 250,
      'totalSpent': 1240,
      'currency': 'ZAR',
      'favoriteCategory': 'Cultural',
      'memberSince': DateTime.now().subtract(const Duration(days: 90)),
      'achievements': [
        'First Ubuntu Experience',
        'Cultural Explorer',
        'AR Pioneer',
      ],
      'upcomingBookings': 2,
      'wishlistItems': 7,
    };
  }

  // Search functionality
  Future<List<Map<String, dynamic>>> searchExperiences(String query) async {
    if (query.isEmpty) return [];

    try {
      _setLoading(true);

      // Simulate search delay
      await Future.delayed(const Duration(milliseconds: 500));

      final allExperiences = [..._featuredExperiences, ..._arPackages];
      final results = allExperiences.where((experience) {
        final title = experience['title']?.toString().toLowerCase() ?? '';
        final location = experience['location']?.toString().toLowerCase() ?? '';
        final description = experience['description']?.toString().toLowerCase() ?? '';
        final searchTerm = query.toLowerCase();

        return title.contains(searchTerm) ||
               location.contains(searchTerm) ||
               description.contains(searchTerm);
      }).toList();

      return results;
    } catch (e) {
      _setError('Search failed: ${e.toString()}');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Get recommendations based on user preferences
  List<Map<String, dynamic>> getRecommendations() {
    final recommendations = <Map<String, dynamic>>[];

    // Add experience-based recommendations
    if (_featuredExperiences.isNotEmpty) {
      recommendations.add({
        'id': 'rec_1',
        'type': 'experience',
        'title': 'Recommended Experience',
        'subtitle': _featuredExperiences.first['title'],
        'icon': 'local_activity',
        'color': 'green',
        'data': _featuredExperiences.first,
      });
    }

    // Add AR-based recommendations
    if (_arPackages.isNotEmpty) {
      recommendations.add({
        'id': 'rec_2',
        'type': 'ar_experience',
        'title': 'Try AR Experience',
        'subtitle': _arPackages.first['title'],
        'icon': 'view_in_ar',
        'color': 'purple',
        'data': _arPackages.first,
      });
    }

    return recommendations;
  }

  // Refresh data
  Future<void> refresh() async {
    await loadData();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get popular categories
  List<String> getPopularCategories() {
    final categories = <String>{};
    for (final experience in _featuredExperiences) {
      final category = experience['category'] as String?;
      if (category != null) {
        categories.add(category);
      }
    }
    return categories.toList();
  }

  // Get experiences by category
  List<Map<String, dynamic>> getExperiencesByCategory(String category) {
    return _featuredExperiences.where((experience) =>
      experience['category'] == category
    ).toList();
  }

  // Get AR experiences by type
  List<Map<String, dynamic>> getARExperiencesByType(String type) {
    return _arPackages.where((experience) =>
      experience['type'] == type
    ).toList();
  }
}
