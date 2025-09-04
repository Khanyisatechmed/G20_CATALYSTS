// features/marketplace/screens/marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/ar_viewer.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ResponsiveLayoutBuilder(
        mobile: (context, constraints) => _buildMobileLayout(),
        tablet: (context, constraints) => _buildTabletLayout(),
        desktop: (context, constraints) => _buildDesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveHelper.isMobile(context)
          ? const CustomBottomNav(currentRoute: '/marketplace')
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      title: Text(
        'Ubuntu Marketplace',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.isMobile(context) ? 20 : 24,
        ),
      ),
      actions: [
        if (ResponsiveHelper.isDesktop(context)) ...[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/wishlist'),
            icon: const Icon(Icons.favorite_border),
          ),
          Consumer<MarketplaceProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                  if (provider.cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${provider.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 16),
        ] else ...[
          Consumer<MarketplaceProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                  if (provider.cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${provider.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ],
      bottom: ResponsiveHelper.isMobile(context)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildCategoryTabs(),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search handcrafted products...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          context.read<MarketplaceProvider>().searchProducts(value);
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          onTap: (index) {
            final categories = ['all', 'artwork', 'textile', 'pottery', 'food'];
            provider.selectCategory(categories[index]);
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Artwork'),
            Tab(text: 'Textile'),
            Tab(text: 'Pottery'),
            Tab(text: 'Food'),
          ],
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildProductsGrid('all'),
              _buildProductsGrid('artwork'),
              _buildProductsGrid('textile'),
              _buildProductsGrid('pottery'),
              _buildProductsGrid('food'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCategoryTabs(),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildProductsGrid('all'),
              _buildProductsGrid('artwork'),
              _buildProductsGrid('textile'),
              _buildProductsGrid('pottery'),
              _buildProductsGrid('food'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar with categories and filters
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              right: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: _buildSidebar(),
        ),
        // Main content area
        Expanded(
          child: Column(
            children: [
              // Search and header
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildFeaturedSection(),
                  ],
                ),
              ),
              // Products grid
              Expanded(
                child: _buildProductsGrid('all'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_mall,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...['All', 'Artwork', 'Textile', 'Pottery', 'Food'].map((category) {
              final categoryId = category.toLowerCase();
              final isSelected = provider.selectedCategory == categoryId;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(_getCategoryIcon(categoryId)),
                  title: Text(category),
                  selected: isSelected,
                  selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  selectedColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () => provider.selectCategory(categoryId),
                ),
              );
            }),

            const SizedBox(height: 32),

            const Text(
              'Price Range',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ZAR ${provider.priceRange.start.round()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'ZAR ${provider.priceRange.end.round()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: provider.priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: provider.updatePriceRange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Ubuntu Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Icon(Icons.view_in_ar, size: 20, color: Colors.purple),
                        const SizedBox(width: 8),
                        const Text('AR Preview'),
                      ],
                    ),
                    value: provider.showAROnly ?? false, // Fixed: Added null safety
                    onChanged: (value) => provider.toggleARFilter(value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Icon(Icons.inventory, size: 20, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text('In Stock'),
                      ],
                    ),
                    value: provider.showInStockOnly ?? false, // Fixed: Added null safety
                    onChanged: (value) => provider.toggleStockFilter(value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Icon(Icons.handshake, size: 20, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text('Fair Trade'),
                      ],
                    ),
                    value: provider.showFairTradeOnly ?? false, // Fixed: Added null safety
                    onChanged: (value) => provider.toggleFairTradeFilter(value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: provider.clearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear Filters'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                'Featured Ubuntu Crafts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Discover authentic handcrafted items from local Ubuntu artisans celebrating South African heritage',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(String category) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingGrid();
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading products',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.error!,
                  style: TextStyle(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final products = provider.getProductsByCategory(category);

        if (products.isEmpty) {
          return _buildEmptyState(category);
        }

        return GridView.builder(
          padding: ResponsiveHelper.getResponsivePadding(context),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.75 : 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => _navigateToProductDetail(product),
              onARTap: product['hasAR'] == true
                  ? () => _showARViewer(product)
                  : null,
              onAddToCart: () => _addToCart(product),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: ResponsiveHelper.getResponsivePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            category == 'all'
                ? 'No products available'
                : 'No ${category} products found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Check back later for new Ubuntu crafts from local artisans',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<MarketplaceProvider>().clearFilters(),
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'all':
        return Icons.apps;
      case 'artwork':
        return Icons.palette;
      case 'textile':
        return Icons.checkroom;
      case 'pottery':
        return Icons.emoji_objects;
      case 'food':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }

  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _showARViewer(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: ResponsiveHelper.isMobile(context) ?
              MediaQuery.of(context).size.width * 0.9 : 600,
          height: ResponsiveHelper.isMobile(context) ?
              MediaQuery.of(context).size.height * 0.7 : 500,
          child: ARViewer(
            product: product,
            onClose: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    context.read<MarketplaceProvider>().addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['title'] ?? 'Product'} added to cart'),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }
}
