// features/marketplace/screens/collection_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/product_card.dart';

class CollectionScreen extends StatefulWidget {
  final String collectionId;
  final String collectionName;

  const CollectionScreen({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  void initState() {
    super.initState();
    // Filter products by collection on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().selectCategory(widget.collectionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ResponsiveLayoutBuilder(
        mobile: (context, constraints) => _buildMobileLayout(),
        tablet: (context, constraints) => _buildTabletLayout(),
        desktop: (context, constraints) => _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        final products = provider.getProductsByCategory(widget.collectionId);

        return Column(
          children: [
            _buildCollectionHeader(),
            Expanded(
              child: _buildProductsGrid(products, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    return _buildMobileLayout();
  }

  Widget _buildCollectionHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Text(
            widget.collectionName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getCollectionDescription(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<Map<String, dynamic>> products, MarketplaceProvider provider) {
    if (products.isEmpty) {
      return const Center(
        child: Text('No products found in this collection'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => _navigateToProduct(product),
          onAddToCart: () => _addToCart(product, provider),
          onFavorite: () => _toggleWishlist(product, provider),
          isWishlisted: provider.isInWishlist(product['id']),
          showFullDetails: true,
        );
      },
    );
  }

  String _getCollectionDescription() {
    switch (widget.collectionId) {
      case 'zulu_heritage':
        return 'Authentic Zulu cultural artifacts and traditional crafts';
      case 'beadwork':
        return 'Intricate beadwork jewelry and decorative items';
      case 'pottery':
        return 'Handcrafted pottery from local artisans';
      default:
        return 'Curated collection of traditional South African crafts';
    }
  }

  void _navigateToProduct(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _addToCart(Map<String, dynamic> product, MarketplaceProvider provider) {
    provider.addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['title']} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  void _toggleWishlist(Map<String, dynamic> product, MarketplaceProvider provider) {
    provider.toggleWishlist(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.isInWishlist(product['id'])
              ? 'Added to wishlist'
              : 'Removed from wishlist'
        ),
      ),
    );
  }
}
