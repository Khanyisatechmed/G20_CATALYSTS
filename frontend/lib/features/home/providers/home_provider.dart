// features/home/providers/home_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend/core/services/api_service.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _featuredExperiences = [];
  List<Map<String, dynamic>> _hologramShows = [];
  Map<String, dynamic>? _userStats;
  List<Map<String, dynamic>> _kznArtisans = [];

  HomeProvider(ApiService read);

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get featuredExperiences => _featuredExperiences;
  List<Map<String, dynamic>> get hologramShows => _hologramShows;
  Map<String, dynamic>? get userStats => _userStats;
  List<Map<String, dynamic>> get kznArtisans => _kznArtisans;

  get arPackages => null;

  // Load all data needed for the home screen
  Future<void> loadData() async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Load mock data
      await _loadFeaturedExperiences();
      await _loadHologramShows();
      await _loadUserStats();
      await _loadKZNArtisans();

      debugPrint('Catalystic Wanders data loaded successfully');
    } catch (e) {
      _setError('Failed to load heritage hub data: ${e.toString()}');
      debugPrint('Heritage hub data loading error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadFeaturedExperiences() async {
    _featuredExperiences = [
      {
        'id': '1',
        'title': 'eMakhosini Ophathe Heritage Park',
        'subtitle': 'Valley of the Kings Virtual Journey',
        'location': 'KwaZulu-Natal',
        'price': 261, // Regular adult price from financial projections
        'studentPrice': 209,
        'seniorPrice': 222,
        'childPrice': 100,
        'currency': 'ZAR',
        'rating': 4.9,
        'reviewCount': 156,
        'duration': 90, // Hologram show duration
        'description': 'Walk with King Shaka through the sacred Valley of the Kings via immersive holographic technology. Experience the birthplace of the Zulu nation where early kings are buried and witness the historic battle at KwaGqokli Hill.',
        'image': 'assets/images/emakhosini_hologram.png',
        'category': 'Cultural Heritage',
        'difficulty': 'Family Friendly',
        'groupSize': 'Up to 20 people per show',
        'accessibility': 'Wheelchair accessible with audio descriptions',
        'includes': ['Holographic experience', 'Cultural guide', 'Traditional welcome ceremony', 'Educational materials', 'Ubuntu philosophy session'],
        'hologramFeatures': ['360-degree projections', 'Multi-language support', 'Interactive elements', 'Biometric engagement'],
        'availableShows': ['10:00', '12:00', '14:00', '16:00', '18:00'],
      },
      {
        'id': '2',
        'title': 'Ubuntu Philosophy Circle',
        'subtitle': 'I Am Because We Are Experience',
        'location': 'Heritage Innovation Hub',
        'price': 261,
        'studentPrice': 209,
        'seniorPrice': 222,
        'childPrice': 100,
        'currency': 'ZAR',
        'rating': 4.8,
        'reviewCount': 98,
        'duration': 75,
        'description': 'Experience the heart of African philosophy through interactive holographic sessions with traditional knowledge keepers. Learn how Ubuntu principles can transform modern life and business practices.',
        'image': 'assets/images/ubuntu_circle_hologram.png',
        'category': 'Philosophy & Wisdom',
        'difficulty': 'All Ages',
        'groupSize': 'Up to 15 people per circle',
        'accessibility': 'Fully accessible with sign language interpretation',
        'includes': ['Holographic elder interactions', 'Philosophy guide', 'Discussion circles', 'Traditional tea ceremony', 'Personal reflection time'],
        'hologramFeatures': ['Real-time conversation with elders', 'Emotion-responsive technology', 'Cultural protocol training'],
        'availableShows': ['09:00', '11:30', '14:30', '17:00'],
      },
      {
        'id': '3',
        'title': 'Freedom Struggle Journey',
        'subtitle': 'Walk with Mandela Experience',
        'location': 'Heritage Innovation Hub',
        'price': 261,
        'studentPrice': 209,
        'seniorPrice': 222,
        'childPrice': 100,
        'currency': 'ZAR',
        'rating': 4.9,
        'reviewCount': 234,
        'duration': 105,
        'description': 'Experience pivotal moments in South Africa\'s freedom struggle through immersive holographic recreations. Walk alongside Nelson Mandela and other struggle heroes in historically accurate environments.',
        'image': 'assets/images/freedom_struggle_hologram.png',
        'category': 'Historical Journey',
        'difficulty': 'Moderate (emotional content)',
        'groupSize': 'Up to 20 people per show',
        'accessibility': 'Wheelchair accessible with content warnings',
        'includes': ['Historical recreation', 'Expert historian guide', 'Mandela hologram interaction', 'Robben Island virtual tour', 'Democracy celebration'],
        'hologramFeatures': ['Time-period accurate environments', 'Historical figure interactions', 'Emotional impact management'],
        'availableShows': ['10:30', '13:00', '15:30', '18:00'],
      },
      {
        'id': '4',
        'title': 'Traditional Ceremony Experience',
        'subtitle': 'Respectful Cultural Participation',
        'location': 'Heritage Innovation Hub',
        'price': 261,
        'studentPrice': 209,
        'seniorPrice': 222,
        'childPrice': 100,
        'currency': 'ZAR',
        'rating': 4.7,
        'reviewCount': 87,
        'duration': 120,
        'description': 'Participate in traditional ceremonies through respectful holographic experiences approved by community elders. Learn protocols, meanings, and cultural significance.',
        'image': 'assets/images/traditional_ceremony_hologram.png',
        'category': 'Cultural Immersion',
        'difficulty': 'Easy',
        'groupSize': 'Up to 12 people per ceremony',
        'accessibility': 'Adaptive participation options available',
        'includes': ['Traditional dress experience', 'Ceremony participation', 'Elder guidance', 'Cultural protocol training', 'Community blessing'],
        'hologramFeatures': ['Community-approved content', 'Sacred space recreation', 'Respectful engagement protocols'],
        'availableShows': ['11:00', '14:00', '16:30'],
      },
    ];
  }

  Future<void> _loadHologramShows() async {
    _hologramShows = [
      {
        'id': 'show_1',
        'title': 'KZN Heritage Showcase',
        'description': 'Rotating showcase of KwaZulu-Natal\'s rich cultural heritage',
        'nextShowTime': '14:00',
        'duration': 45,
        'capacity': 20,
        'availableSeats': 8,
        'price': 261,
        'features': ['360-degree holography', 'Multi-sensory experience', 'Interactive elements'],
        'accessibility': 'Wheelchair accessible',
        'language': 'English, Zulu, Afrikaans',
      },
      {
        'id': 'show_2',
        'title': 'Ubuntu in Business',
        'description': 'Corporate training through cultural wisdom',
        'nextShowTime': '16:30',
        'duration': 90,
        'capacity': 15,
        'availableSeats': 12,
        'price': 350, // Premium corporate pricing
        'features': ['Leadership insights', 'Team building', 'Cultural intelligence'],
        'accessibility': 'Fully accessible',
        'language': 'English',
      },
      {
        'id': 'show_3',
        'title': 'Family Discovery Adventure',
        'description': 'Specially designed for families with children',
        'nextShowTime': '10:00',
        'duration': 60,
        'capacity': 20,
        'availableSeats': 15,
        'price': 200, // Family-friendly pricing
        'features': ['Child-appropriate content', 'Interactive games', 'Educational fun'],
        'accessibility': 'Child and wheelchair friendly',
        'language': 'English, Zulu',
      },
    ];
  }

  Future<void> _loadKZNArtisans() async {
    _kznArtisans = [
      {
        'id': 'artisan_1',
        'name': 'Nomsa Mthembu',
        'craft': 'Traditional Beadwork',
        'location': 'Rural KZN',
        'story': 'Third-generation beadwork artist preserving Zulu traditions',
        'hologramStory': 'Meet Nomsa through holographic storytelling',
        'featuredProduct': 'Ceremonial Wedding Necklace',
        'price': 450,
        'image': 'assets/images/nomsa_beadwork.png',
        'sustainabilityScore': 95,
        'communityImpact': 'Supports 8 local families',
      },
      {
        'id': 'artisan_2',
        'name': 'Sipho Ndlovu',
        'craft': 'Wood Carving & Sculptures',
        'location': 'Hluhluwe Township',
        'story': 'Self-taught artist creating contemporary African art',
        'hologramStory': 'Watch Sipho demonstrate carving techniques',
        'featuredProduct': 'Ubuntu Philosophy Sculpture',
        'price': 1200,
        'image': 'assets/images/sipho_carving.png',
        'sustainabilityScore': 88,
        'communityImpact': 'Mentors 15 young artists',
      },
      {
        'id': 'artisan_3',
        'name': 'Thandiwe Zulu',
        'craft': 'Traditional Pottery',
        'location': 'Bergville',
        'story': 'Keeping ancient pottery techniques alive',
        'hologramStory': 'Learn traditional pottery methods',
        'featuredProduct': 'Ceremonial Beer Pot',
        'price': 680,
        'image': 'assets/images/thandiwe_pottery.png',
        'sustainabilityScore': 92,
        'communityImpact': 'Employs 6 women artisans',
      },
    ];
  }

  Future<void> _loadUserStats() async {
    _userStats = {
      'hologramExperiencesBooked': 3,
      'culturalLearningPoints': 450,
      'familyFriendlyVisits': 2,
      'accessibilityFeaturesUsed': 1,
      'totalSpent': 783,
      'currency': 'ZAR',
      'favoriteCategory': 'Cultural Heritage',
      'memberSince': DateTime.now().subtract(const Duration(days: 45)),
      'achievements': [
        'First Hologram Experience',
        'Ubuntu Philosophy Explorer',
        'Heritage Advocate',
        'Community Supporter',
      ],
      'upcomingBookings': 1,
      'wishlistItems': 5,
      'accessibilityPreferences': ['Audio descriptions', 'Wheelchair access'],
      'languagePreference': 'English',
      'familyGroupSize': 3,
      'culturalInterests': ['Zulu Heritage', 'Ubuntu Philosophy', 'Traditional Arts'],
    };
  }

  // Search functionality
  Future<List<Map<String, dynamic>>> searchExperiences(String query) async {
    if (query.isEmpty) return [];

    try {
      _setLoading(true);

      // Simulate search delay
      await Future.delayed(const Duration(milliseconds: 500));

      final allExperiences = [..._featuredExperiences, ..._hologramShows];
      final results = allExperiences.where((experience) {
        final title = experience['title']?.toString().toLowerCase() ?? '';
        final location = experience['location']?.toString().toLowerCase() ?? '';
        final description = experience['description']?.toString().toLowerCase() ?? '';
        final category = experience['category']?.toString().toLowerCase() ?? '';
        final searchTerm = query.toLowerCase();

        return title.contains(searchTerm) ||
               location.contains(searchTerm) ||
               description.contains(searchTerm) ||
               category.contains(searchTerm);
      }).toList();

      return results;
    } catch (e) {
      _setError('Search failed: ${e.toString()}');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Get personalized recommendations based on user personas
  List<Map<String, dynamic>> getPersonalizedRecommendations() {
    final recommendations = <Map<String, dynamic>>[];

    // For Nomvula (Family-focused recommendations)
    recommendations.add({
      'id': 'rec_family',
      'type': 'family_experience',
      'title': 'Perfect for Families',
      'subtitle': 'Ubuntu Philosophy Circle - Child Friendly',
      'icon': 'family_restroom',
      'color': 'green',
      'data': _featuredExperiences.firstWhere(
        (exp) => exp['id'] == '2',
        orElse: () => {},
      ),
      'personalizedReason': 'Great for introducing children to African wisdom',
    });

    // For Luyanda (Tech-focused recommendations)
    recommendations.add({
      'id': 'rec_tech',
      'type': 'hologram_experience',
      'title': 'Cutting-Edge Technology',
      'subtitle': 'Freedom Struggle Journey - Interactive Holograms',
      'icon': 'view_in_ar',
      'color': 'purple',
      'data': _featuredExperiences.firstWhere(
        (exp) => exp['id'] == '3',
        orElse: () => {},
      ),
      'personalizedReason': 'Advanced holographic technology meets history',
    });

    // For Sihle (Accessibility-focused recommendations)
    recommendations.add({
      'id': 'rec_accessible',
      'type': 'accessible_experience',
      'title': 'Accessibility Excellence',
      'subtitle': 'eMakhosini Heritage - Fully Accessible',
      'icon': 'accessible',
      'color': 'blue',
      'data': _featuredExperiences.firstWhere(
        (exp) => exp['id'] == '1',
        orElse: () => {},
      ),
      'personalizedReason': 'Universal design with audio descriptions and wheelchair access',
    });

    return recommendations;
  }

  // Get available show times for booking
  List<Map<String, dynamic>> getAvailableShowTimes(String experienceId) {
    final experience = _featuredExperiences.firstWhere(
      (exp) => exp['id'] == experienceId,
      orElse: () => {},
    );

    if (experience.isEmpty || experience['availableShows'] == null) {
      return [];
    }

    return (experience['availableShows'] as List<String>).map((time) => {
      'time': time,
      'availableSeats': 20, // Mock availability
      'price': experience['price'],
      'studentPrice': experience['studentPrice'],
      'seniorPrice': experience['seniorPrice'],
      'childPrice': experience['childPrice'],
    }).toList();
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

  // Get KZN artisan stories for marketplace
  List<Map<String, dynamic>> getFeaturedArtisans() {
    return _kznArtisans.take(3).toList();
  }

  // Calculate pricing for different user types
  Map<String, int> getPricingForExperience(String experienceId, {
    int adults = 1,
    int students = 0,
    int seniors = 0,
    int children = 0,
  }) {
    final experience = _featuredExperiences.firstWhere(
      (exp) => exp['id'] == experienceId,
      orElse: () => {},
    );

    if (experience.isEmpty) return {'total': 0};

    final adultPrice = experience['price'] as int? ?? 261;
    final studentPrice = experience['studentPrice'] as int? ?? 209;
    final seniorPrice = experience['seniorPrice'] as int? ?? 222;
    final childPrice = experience['childPrice'] as int? ?? 100;

    final total = (adults * adultPrice) +
                  (students * studentPrice) +
                  (seniors * seniorPrice) +
                  (children * childPrice);

    return {
      'total': total,
      'adultPrice': adultPrice,
      'studentPrice': studentPrice,
      'seniorPrice': seniorPrice,
      'childPrice': childPrice,
    };
  }
}
