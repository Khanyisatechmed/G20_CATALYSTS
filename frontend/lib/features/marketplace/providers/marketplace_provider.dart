// features/marketplace/providers/marketplace_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_endpoints.dart' as api_endpoints;

class MarketplaceProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _vendors = [];
  List<Map<String, dynamic>> _cart = [];
  List<Map<String, dynamic>> _wishlist = [];
  List<Map<String, dynamic>> _culturalExperiences = [];

  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'all';
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _showAROnly = false;
  bool _showInStockOnly = false;
  bool _showFairTradeOnly = false;
  bool _showUbuntuOnly = false;
  String _searchQuery = '';
  String _selectedRegion = 'all';
  String _sortBy = 'relevance';

  MarketplaceProvider(this._apiService) {
    // Auto-load data on initialization
    _initializeData();
  }

  // Getters
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get vendors => _vendors;
  List<Map<String, dynamic>> get cart => _cart;
  List<Map<String, dynamic>> get wishlist => _wishlist;
  List<Map<String, dynamic>> get culturalExperiences => _culturalExperiences;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  RangeValues get priceRange => _priceRange;
  bool get showAROnly => _showAROnly;
  bool get showInStockOnly => _showInStockOnly;
  bool get showFairTradeOnly => _showFairTradeOnly;
  bool get showUbuntuOnly => _showUbuntuOnly;
  String get searchQuery => _searchQuery;
  String get selectedRegion => _selectedRegion;
  String get sortBy => _sortBy;
  int get cartItemCount => _cart.fold(0, (sum, item) => sum + (item['quantity'] as int? ?? 1));
  double get cartTotal => _cart.fold(0.0, (sum, item) =>
    sum + ((item['price'] as num? ?? 0) * (item['quantity'] as int? ?? 1)));

  // Enhanced getters with better data
  List<String> get kznRegions => [
    'all',
    'durban',
    'pietermaritzburg',
    'drakensberg',
    'zululand',
    'south_coast',
    'north_coast',
    'midlands',
    'ukhahlamba'
  ];

  List<String> get culturalCategories => [
    'all',
    'zulu_heritage',
    'beadwork',
    'pottery',
    'traditional_food',
    'storytelling',
    'dance_music',
    'crafts',
    'experiences'
  ];

  List<String> get productCategories => [
    'all',
    'crafts',
    'textile',
    'pottery',
    'food',
    'jewelry'
  ];

  // Filtered products getter
  List<Map<String, dynamic>> get filteredProducts => getProductsByCategory(_selectedCategory);

  Future<void> _initializeData() async {
    await loadProducts();
    await loadVendors();
    await loadCulturalExperiences();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.get(api_endpoints.ApiEndpoints.products);
      _products = List<Map<String, dynamic>>.from(response.data['products']);
    } catch (e) {
      // Enhanced mock data with better variety
      _products = [
        {
          'id': 1,
          'title': 'Handwoven Zulu Basket (u-bha-ske-di)',
          'artisan': 'Nomsa Mthembu',
          'vendor_id': 'vendor_001',
          'price': 350.0,
          'originalPrice': 400.0,
          'currency': 'ZAR',
          'imageUrl': 'assets/images/zulubasket.png',
          'images': ['assets/images/zulubasket.png', 'assets/images/zulubasket.png'],
          'hasAR': true,
          'rating': 4.8,
          'reviewCount': 23,
          'isInStock': true,
          'stockQuantity': 5,
          'category': 'crafts',
          'region': 'zululand',
          'location': 'Nongoma, KZN',
          'isFairTrade': true,
          'isUbuntu': true,
          'isHandmade': true,
          'materials': ['Ilala palm', 'Natural dyes'],
          'culturalSignificance': 'Traditional Zulu baskets carry deep meaning, with patterns telling stories of family heritage and clan identity.',
          'description': 'Beautifully handwoven basket using traditional Zulu techniques passed down through generations. Each pattern tells a unique story of heritage and cultural identity.',
          'dimensions': {'length': 30, 'width': 30, 'height': 25, 'unit': 'cm'},
          'weight': 0.8,
          'discount': 12,
          'tags': ['traditional', 'handmade', 'zulu', 'heritage'],
          'vendor': {
            'name': 'Nomsa Mthembu',
            'bio': 'Master weaver with 25 years of experience, teaching young women traditional basket weaving.',
            'location': 'Nongoma',
            'verified': true,
            'rating': 4.9
          }
        },
        {
          'id': 2,
          'title': 'Traditional Zulu Hat ( I-nke-hle )',
          'artisan': 'Sipho Dlamini',
          'vendor_id': 'vendor_002',
          'price': 280.0,
          'currency': 'ZAR',
          'imageUrl': 'assets/images/zuluhat.png ',
          'images': ['assets/images/zuluhat.png'],
          'hasAR': true,
          'rating': 4.6,
          'reviewCount': 15,
          'isInStock': true,
          'stockQuantity': 3,
          'category': 'textile',
          'region': 'drakensberg',
          'location': 'Bergville, KZN',
          'isFairTrade': true,
          'isUbuntu': true,
          'isHandmade': true,
          'materials': ['Mohair', 'Wool'],
          'culturalSignificance': 'The traditional conical hat represents protection from the elements and connection to mountain heritage.',
          'description': 'Traditional conical hat worn by Basotho people, hand-knitted using authentic patterns and techniques.',
          'dimensions': {'diameter': 35, 'height': 20, 'unit': 'cm'},
          'weight': 0.3,
          'tags': ['traditional', 'basotho', 'headwear', 'mountain'],
          'vendor': {
            'name': 'Sipho Dlamini',
            'bio': 'Traditional textile artist specializing in Basotho cultural garments.',
            'location': 'Bergville',
            'verified': true,
            'rating': 4.7
          }
        },
        {
          'id': 3,
          'title': 'Zulu Beadwork Necklace (u-bu-hla-lu)',
          'artisan': 'Thandi Ngcobo',
          'vendor_id': 'vendor_003',
          'price': 180.0,
          'currency': 'ZAR',
          'imageUrl': 'assets/images/zulunecklace.png ',
          'images': ['assets/images/zulunecklace.png ', 'assets/images/zulunecklace.png '],
          'hasAR': true,
          'rating': 4.9,
          'reviewCount': 31,
          'isInStock': true,
          'stockQuantity': 8,
          'category': 'jewelry',
          'region': 'durban',
          'location': 'Umlazi, Durban',
          'isFairTrade': true,
          'isUbuntu': true,
          'isHandmade': true,
          'materials': ['Glass beads', 'Cotton thread'],
          'culturalSignificance': 'Each color and pattern tells a story - age, marital status, clan affiliation, and personal achievements.',
          'description': 'Intricate beadwork necklace with traditional Zulu color patterns and deep cultural symbolism.',
          'dimensions': {'length': 45, 'width': 3, 'unit': 'cm'},
          'weight': 0.15,
          'tags': ['jewelry', 'beadwork', 'zulu', 'ceremonial'],
          'vendor': {
            'name': 'Thandi Ngcobo',
            'bio': 'Fourth-generation beadwork artist from Umlazi, preserving traditional Zulu jewelry techniques.',
            'location': 'Umlazi',
            'verified': true,
            'rating': 4.8
          }
        },
        {
          'id': 4,
          'title': 'Traditional Pot Bread Workshop (u-je-qe)',
          'artisan': 'Gogo Mkhize',
          'vendor_id': 'vendor_004',
          'price': 80.0,
          'currency': 'ZAR',
          'imageUrl': 'assets/images/potbread.png',
          'images': ['assets/images/potbread.png'],
          'hasAR': false,
          'rating': 4.7,
          'reviewCount': 18,
          'isInStock': true,
          'stockQuantity': 10,
          'category': 'food',
          'subcategory': 'experience',
          'region': 'midlands',
          'location': 'Howick, KZN',
          'isFairTrade': true,
          'isUbuntu': true,
          'isHandmade': true,
          'culturalSignificance': 'Pot bread baking is a communal activity that brings families together and preserves traditional cooking methods.',
          'description': 'Learn to bake traditional South African pot bread over an open fire with Gogo Mkhize. A hands-on cultural experience.',
          'duration': '3 hours',
          'includes': ['Ingredients', 'Recipe card', 'Bread to take home'],
          'maxParticipants': 8,
          'tags': ['cooking', 'experience', 'traditional', 'bread'],
          'vendor': {
            'name': 'Gogo Mkhize',
            'bio': 'Traditional cook and grandmother sharing 40 years of indigenous cooking knowledge.',
            'location': 'Howick',
            'verified': true,
            'rating': 4.9
          }
        },
        {
          'id': 5,
          'title': 'Drakensberg Clay Pottery Set (u-kha-mba)',
          'artisan': 'Mandla Mthembu',
          'vendor_id': 'vendor_005',
          'price': 250.0,
          'currency': 'ZAR',
          'imageUrl': 'assets/images/claypot.png',
          'images': ['assets/images/claypot.png', 'assets/images/claypot.png'],
          'hasAR': true,
          'rating': 4.5,
          'reviewCount': 12,
          'isInStock': true,
          'stockQuantity': 4,
          'category': 'pottery',
          'region': 'drakensberg',
          'location': 'Underberg, KZN',
          'isFairTrade': true,
          'isUbuntu': true,
          'isHandmade': true,
          'materials': ['Local clay', 'Natural glazes'],
          'culturalSignificance': 'Pottery making connects us to the earth and represents the nurturing spirit of Ubuntu.',
          'description': 'Set of 4 hand-thrown pottery pieces using clay from the Drakensberg foothills. Perfect for traditional and modern homes.',
          'dimensions': {'various': 'Bowl: 15cm, Cups: 8cm each'},
          'weight': 1.2,
          'tags': ['pottery', 'set', 'drakensberg', 'clay'],
          'vendor': {
            'name': 'Mandla Mthembu',
            'bio': 'Potter and ceramicist using traditional firing techniques with modern design sensibilities.',
            'location': 'Underberg',
            'verified': true,
            'rating': 4.6
          }
        },
        // Add more varied products
        {
          'id': 6,
          'title': 'The King Shaka Portriat',
          'artisan': 'Sibongile Radebe',
          'vendor_id': 'vendor_006',
          'price': 950.0,
          'currency': 'ZAR',
          'imageUrl': 'assets/images/shakaimage.png',
          'images': ['assets/images/shakaimage.png'],
          'hasAR': true,
          'rating': 4.9,
          'reviewCount': 8,
          'isInStock': false,
          'stockQuantity': 0,
          'category': 'crafts',
          'region': 'south_coast',
          'location': 'Port Shepstone, KZN',
          'isFairTrade': true,
          'isUbuntu': false,
          'isHandmade': true,
          'materials': ['Canvas', 'Acrylic paint', 'Natural pigments'],
          'culturalSignificance': 'Ndebele geometric patterns represent the mathematical precision and artistic heritage of South African culture.',
          'description': 'Vibrant geometric wall art inspired by traditional Ndebele house paintings.',
          'dimensions': {'length': 60, 'width': 40, 'unit': 'cm'},
          'weight': 1.5,
          'tags': ['art', 'geometric', 'ndebele', 'wall'],
          'vendor': {
            'name': 'Sibongile Radebe',
            'bio': 'Contemporary artist blending traditional Ndebele patterns with modern techniques.',
            'location': 'Port Shepstone',
            'verified': true,
            'rating': 4.8
          }
        }
      ];
      _error = null;
      if (kDebugMode) print('Loaded ${_products.length} products');
    }

    _setLoading(false);
  }

  Future<void> loadVendors() async {
    try {
      _vendors = [
        {
          'id': 'vendor_001',
          'name': 'Nomsa Mthembu',
          'bio': 'Master weaver with 25 years of experience, teaching young women traditional basket weaving.',
          'location': 'Nongoma, KZN',
          'region': 'zululand',
          'specialty': 'Traditional Zulu baskets and weaving',
          'verified': true,
          'rating': 4.9,
          'totalSales': 156,
          'yearsActive': 25,
          'profileImage': 'https://picsum.photos/100/100?random=101',
          'coverImage': 'https://picsum.photos/400/200?random=201',
          'products': [1],
          'contactInfo': {
            'phone': '+27 58 713 0126',
            'whatsapp': '+27 58 713 0126',
            'email': 'nomsa.mthembu@email.com'
          },
          'socialMedia': {
            'facebook': 'nomsa.baskets',
            'instagram': '@nomsa_traditional_baskets'
          },
          'languages': ['isiZulu', 'English'],
          'paymentMethods': ['cash', 'snapscan', 'zapper'],
          'deliveryOptions': ['collection', 'local_delivery', 'courier']
        },
        // Add more vendors...
      ];
    } catch (e) {
      if (kDebugMode) print('Error loading vendors: $e');
    }
  }

  Future<void> loadCulturalExperiences() async {
    try {
      _culturalExperiences = [
        {
          'id': 'exp_001',
          'title': 'Zulu Cultural Village Experience',
          'description': 'Immersive half-day experience in traditional Zulu culture',
          'location': 'Shakaland, KZN',
          'region': 'zululand',
          'duration': '4 hours',
          'price': 380.0,
          'currency': 'ZAR',
          'rating': 4.7,
          'reviewCount': 89,
          'maxParticipants': 20,
          'includes': ['Traditional meal', 'Dance performance', 'Village tour', 'Craft demonstration'],
          'languages': ['English', 'isiZulu'],
          'category': 'cultural_experience',
          'hasAR': true,
          'vendor_id': 'exp_vendor_001',
          'imageUrl': 'https://picsum.photos/400/400?random=301'
        }
      ];
    } catch (e) {
      if (kDebugMode) print('Error loading cultural experiences: $e');
    }
  }

  List<Map<String, dynamic>> getProductsByCategory(String category) {
    var filteredProducts = _products.where((product) {
      // Category filter
      if (category != 'all' && product['category'] != category) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final title = product['title']?.toLowerCase() ?? '';
        final artisan = product['artisan']?.toLowerCase() ?? '';
        final description = product['description']?.toLowerCase() ?? '';
        final tags = (product['tags'] as List<dynamic>?)?.join(' ').toLowerCase() ?? '';

        if (!title.contains(searchLower) &&
            !artisan.contains(searchLower) &&
            !description.contains(searchLower) &&
            !tags.contains(searchLower)) {
          return false;
        }
      }

      // Price filter
      final price = product['price']?.toDouble() ?? 0.0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Region filter
      if (_selectedRegion != 'all' && product['region'] != _selectedRegion) {
        return false;
      }

      // AR filter
      if (_showAROnly && product['hasAR'] != true) {
        return false;
      }

      // Stock filter
      if (_showInStockOnly && product['isInStock'] != true) {
        return false;
      }

      // Fair Trade filter
      if (_showFairTradeOnly && product['isFairTrade'] != true) {
        return false;
      }

      // Ubuntu filter
      if (_showUbuntuOnly && product['isUbuntu'] != true) {
        return false;
      }

      return true;
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'price_low':
        filteredProducts.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
        break;
      case 'price_high':
        filteredProducts.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
        break;
      case 'rating':
        filteredProducts.sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
        break;
      case 'newest':
        filteredProducts.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
        break;
      default: // relevance
        // Keep original order for relevance
        break;
    }

    return filteredProducts;
  }

  // Filter and search methods
  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void selectRegion(String region) {
    if (_selectedRegion != region) {
      _selectedRegion = region;
      notifyListeners();
    }
  }

  void updateSortBy(String sortBy) {
    if (_sortBy != sortBy) {
      _sortBy = sortBy;
      notifyListeners();
    }
  }

  void updatePriceRange(RangeValues range) {
    if (_priceRange != range) {
      _priceRange = range;
      notifyListeners();
    }
  }

  void toggleARFilter(bool value) {
    if (_showAROnly != value) {
      _showAROnly = value;
      notifyListeners();
    }
  }

  void toggleStockFilter(bool value) {
    if (_showInStockOnly != value) {
      _showInStockOnly = value;
      notifyListeners();
    }
  }

  void toggleFairTradeFilter(bool value) {
    if (_showFairTradeOnly != value) {
      _showFairTradeOnly = value;
      notifyListeners();
    }
  }

  void toggleUbuntuFilter(bool value) {
    if (_showUbuntuOnly != value) {
      _showUbuntuOnly = value;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void clearFilters() {
    _selectedCategory = 'all';
    _selectedRegion = 'all';
    _priceRange = const RangeValues(0, 1000);
    _showAROnly = false;
    _showInStockOnly = false;
    _showFairTradeOnly = false;
    _showUbuntuOnly = false;
    _searchQuery = '';
    _sortBy = 'relevance';
    notifyListeners();
  }

  // Cart methods with improved functionality
  void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
    final existingIndex = _cart.indexWhere((item) => item['id'] == product['id']);

    if (existingIndex >= 0) {
      // Update quantity if product already in cart
      _cart[existingIndex]['quantity'] = (_cart[existingIndex]['quantity'] ?? 1) + quantity;
    } else {
      // Add new product to cart
      final cartItem = Map<String, dynamic>.from(product);
      cartItem['quantity'] = quantity;
      cartItem['addedAt'] = DateTime.now().toIso8601String();
      _cart.add(cartItem);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    final initialLength = _cart.length;
    _cart.removeWhere((item) => item['id'] == productId);
    if (_cart.length != initialLength) {
      notifyListeners();
    }
  }

  void updateCartQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _cart.indexWhere((item) => item['id'] == productId);
    if (index >= 0) {
      _cart[index]['quantity'] = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    if (_cart.isNotEmpty) {
      _cart.clear();
      notifyListeners();
    }
  }

  // Enhanced wishlist methods
  void addToWishlist(Map<String, dynamic> product) {
    if (!isInWishlist(product['id'])) {
      final wishlistItem = Map<String, dynamic>.from(product);
      wishlistItem['addedAt'] = DateTime.now().toIso8601String();
      _wishlist.add(wishlistItem);
      notifyListeners();
    }
  }

  void removeFromWishlist(int productId) {
    final initialLength = _wishlist.length;
    _wishlist.removeWhere((item) => item['id'] == productId);
    if (_wishlist.length != initialLength) {
      notifyListeners();
    }
  }

  bool isInWishlist(int productId) {
    return _wishlist.any((item) => item['id'] == productId);
  }

  void toggleWishlist(Map<String, dynamic> product) {
    if (isInWishlist(product['id'])) {
      removeFromWishlist(product['id']);
    } else {
      addToWishlist(product);
    }
  }

  void clearWishlist() {
    if (_wishlist.isNotEmpty) {
      _wishlist.clear();
      notifyListeners();
    }
  }

  // Utility methods
  Map<String, dynamic>? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? getVendorById(String vendorId) {
    try {
      return _vendors.firstWhere((vendor) => vendor['id'] == vendorId);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> getProductsByVendor(String vendorId) {
    return _products.where((product) => product['vendor_id'] == vendorId).toList();
  }

  // Statistics with better calculations
  Map<String, int> getCategoryStats() {
    final stats = <String, int>{};
    for (final product in _products) {
      final category = product['category'] as String? ?? 'other';
      stats[category] = (stats[category] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> getRegionStats() {
    final stats = <String, int>{};
    for (final product in _products) {
      final region = product['region'] as String? ?? 'other';
      stats[region] = (stats[region] ?? 0) + 1;
    }
    return stats;
  }

  // Helper method to refresh all data
  Future<void> refreshData() async {
    await _initializeData();
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }
}
