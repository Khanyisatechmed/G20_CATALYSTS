// features/marketplace/providers/marketplace_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_endpoints.dart' as api_endpoints;

class MarketplaceProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _cart = [];
  bool _isLoading = false;
  String _selectedCategory = 'all';
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _showAROnly = false;
  bool _showInStockOnly = false;
  String _searchQuery = '';

  MarketplaceProvider(this._apiService);

  // Getters
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get cart => _cart;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  RangeValues get priceRange => _priceRange;
  bool get showAROnly => _showAROnly;
  bool get showInStockOnly => _showInStockOnly;
  int get cartItemCount => _cart.length;

  get error => null;

  get toggleFairTradeFilter => null;

  get showFairTradeOnly => null;

  Future<void> loadProducts() async {
    _setLoading(true);

    try {
      final response = await _apiService.get(api_endpoints.ApiEndpoints.products);
      _products = List<Map<String, dynamic>>.from(response.data['products']);
    } catch (e) {
      // Mock data for development
      _products = [
        {
          'id': 1,
          'title': 'Rustic Terracotta Vase',
          'artisan': 'Local Artisan',
          'price': 200.0,
          'currency': 'ZAR',
          'imageUrl': '',
          'hasAR': true,
          'rating': 4.5,
          'isInStock': true,
          'category': 'pottery',
        },
        {
          'id': 2,
          'title': 'Mokorotlo',
          'artisan': 'Traditional Weaver',
          'price': 300.0,
          'currency': 'ZAR',
          'imageUrl': '',
          'hasAR': true,
          'rating': 4.8,
          'isInStock': true,
          'category': 'textile',
        },
      ];
      if (kDebugMode) print('Error loading products: $e');
    }

    _setLoading(false);
  }

  List<Map<String, dynamic>> getProductsByCategory(String category) {
    return _products.where((product) {
      // Category filter
      if (category != 'all' && product['category'] != category) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final title = product['title']?.toLowerCase() ?? '';
        if (!title.contains(_searchQuery.toLowerCase())) {
          return false;
        }
      }

      // Price filter
      final price = product['price']?.toDouble() ?? 0.0;
      if (price < _priceRange.start || price > _priceRange.end) {
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

      return true;
    }).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updatePriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void toggleARFilter(bool? value) {
    _showAROnly = value ?? false;
    notifyListeners();
  }

  void toggleStockFilter(bool? value) {
    _showInStockOnly = value ?? false;
    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = 'all';
    _priceRange = const RangeValues(0, 1000);
    _showAROnly = false;
    _showInStockOnly = false;
    _searchQuery = '';
    notifyListeners();
  }

  void addToCart(Map<String, dynamic> product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cart.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
