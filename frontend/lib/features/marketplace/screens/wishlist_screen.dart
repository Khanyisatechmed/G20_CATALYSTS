// features/marketplace/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ResponsiveLayoutBuilder(
        mobile: (context, constraints) => _buildMobileLayout(),
        tablet: (context, constraints) => _buildTabletLayout(),
        desktop: (context, constraints) => _buildDesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveHelper.isMobile(context)
          ? const CustomBottomNav(currentRoute: '/wishlist')
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('My Wishlist'),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      actions: [
        Consumer<MarketplaceProvider>(
          builder: (context, provider, child) {
            if (provider.wishlist.isEmpty) return const SizedBox.shrink();

            return TextButton(
              onPressed: () => _showClearWishlistDialog(context),
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.wishlist.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: provider.wishlist.length,
          itemBuilder: (context, index) {
            final product = provider.wishlist[index];
            return ProductCard(
              product: product,
              onTap: () => _navigateToProductDetail(context, product),
              onAddToCart: () => _addToCart(context, product, provider),
              onFavorite: () => _toggleWishlist(context, product, provider),
              isWishlisted: true,
              showFullDetails: true,
            );
          },
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.wishlist.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: provider.wishlist.length,
          itemBuilder: (context, index) {
            final product = provider.wishlist[index];
            return ProductCard(
              product: product,
              onTap: () => _navigateToProductDetail(context, product),
              onAddToCart: () => _addToCart(context, product, provider),
              onFavorite: () => _toggleWishlist(context, product, provider),
              isWishlisted: true,
              showFullDetails: true,
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.wishlist.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              // Wishlist header with stats
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Text(
                      '${provider.wishlist.length} Items in Your Wishlist',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () => _moveAllToCart(context, provider),
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Add All to Cart'),
                    ),
                  ],
                ),
              ),
              // Products grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: provider.wishlist.length,
                  itemBuilder: (context, index) {
                    final product = provider.wishlist[index];
                    return ProductCard(
                      product: product,
                      onTap: () => _navigateToProductDetail(context, product),
                      onAddToCart: () => _addToCart(context, product, provider),
                      onFavorite: () => _toggleWishlist(context, product, provider),
                      isWishlisted: true,
                      showFullDetails: true,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save items you love for later',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/marketplace'),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Browse Products'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _addToCart(BuildContext context, Map<String, dynamic> product, MarketplaceProvider provider) {
    if (product['isInStock'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This item is currently out of stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    provider.addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['title']} added to cart'),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  void _toggleWishlist(BuildContext context, Map<String, dynamic> product, MarketplaceProvider provider) {
    provider.removeFromWishlist(product['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from wishlist')),
    );
  }

  void _moveAllToCart(BuildContext context, MarketplaceProvider provider) {
    final availableItems = provider.wishlist.where((item) => item['isInStock'] == true).toList();

    if (availableItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items are currently available in stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (final item in availableItems) {
      provider.addToCart(item);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${availableItems.length} items added to cart'),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  void _showClearWishlistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text('Are you sure you want to remove all items from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MarketplaceProvider>().clearWishlist();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wishlist cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
