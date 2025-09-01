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
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveHelper.isMobile(context)
          ? const CustomBottomNavigation(currentIndex: 3)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Local Market place',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.isMobile(context) ? 20 : 24,
        ),
      ),
      actions: [
        if (ResponsiveHelper.isDesktop(context)) ...[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline, color: Colors.black87),
          ),
          const SizedBox(width: 16),
        ] else ...[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
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
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search local products...',
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
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey[600],
      indicator: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
      tabs: const [
        Tab(text: 'All'),
        Tab(text: 'Artwork'),
        Tab(text: 'Textile'),
        Tab(text: 'Pottery'),
        Tab(text: 'Food'),
      ],
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
          width: 300,
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
                padding: const EdgeInsets.all(24),
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
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...['All', 'Artwork', 'Textile', 'Pottery', 'Food'].map((category) {
              final isSelected = provider.selectedCategory == category.toLowerCase();
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(category),
                  selected: isSelected,
                  selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () => provider.selectCategory(category.toLowerCase()),
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
            RangeSlider(
              values: provider.priceRange,
              min: 0,
              max: 1000,
              divisions: 20,
              labels: RangeLabels(
                'ZAR${provider.priceRange.start.round()}',
                'ZAR${provider.priceRange.end.round()}',
              ),
              onChanged: provider.updatePriceRange,
            ),

            const SizedBox(height: 32),

            const Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('AR Preview'),
              value: provider.showAROnly,
              onChanged: provider.toggleARFilter,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('In Stock'),
              value: provider.showInStockOnly,
              onChanged: provider.toggleStockFilter,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: provider.clearFilters,
                child: const Text('Clear Filters'),
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
      child: const Column(
        children: [
          Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Discover authentic handcrafted items from local artisans',
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

        final products = provider.getProductsByCategory(category);

        if (products.isEmpty) {
          return _buildEmptyState(category);
        }

        return GridView.builder(
          padding: ResponsiveHelper.getResponsivePadding(context),
          gridDelegate: ResponsiveHelper.getResponsiveGridDelegate(
            context,
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.75 : 0.8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              title: product['title'] ?? 'Rustic Terracotta Vase',
              artisan: product['artisan'] ?? 'Local Artisan',
              price: product['price']?.toDouble() ?? 200.0,
              currency: product['currency'] ?? 'ZAR',
              imageUrl: product['imageUrl'] ?? '',
              hasAR: product['hasAR'] ?? false,
              rating: product['rating']?.toDouble() ?? 4.5,
              isInStock: product['isInStock'] ?? true,
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
      gridDelegate: ResponsiveHelper.getResponsiveGridDelegate(context),
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
          Text(
            'Check back later for new arrivals',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
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
        content: Text('${product['title']} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }
}
