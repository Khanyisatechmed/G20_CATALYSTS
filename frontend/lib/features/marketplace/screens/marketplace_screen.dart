// features/marketplace/screens/optimized_marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../../../core/theme/marketplace_theme.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/ar_viewer.dart';
import '../widgets/product_detail_modal.dart';
import '../widgets/cultural_collections.dart';
import '../widgets/kzn_regional_filter.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  int _selectedView = 0; // 0: Products, 1: Vendors, 2: Experiences

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Initialize data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MarketplaceProvider>();
      provider.loadProducts();
      provider.loadVendors();
      provider.loadCulturalExperiences();
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
    return Theme(
      data: MarketplaceTheme.lightTheme,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: ResponsiveLayoutBuilder(
          mobile: (context, constraints) => _buildMobileLayout(),
          tablet: (context, constraints) => _buildTabletLayout(),
          desktop: (context, constraints) => _buildDesktopLayout(),
        ),
        bottomNavigationBar: ResponsiveHelper.isMobile(context)
            ? const CustomBottomNav(currentRoute: '/marketplace')
            : null,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1565C0),
      foregroundColor: Colors.white,
      title: Text(
        'Wanders Marketplace',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.isMobile(context) ? 20 : 24,
          color: Colors.white,
        ),
      ),
      actions: [
        if (ResponsiveHelper.isDesktop(context)) ...[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/wishlist'),
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            tooltip: 'Wishlist',
          ),
          Consumer<MarketplaceProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/marketplace/cart'),
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    tooltip: 'Shopping Cart',
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
            icon: const Icon(Icons.person_outline, color: Colors.white),
            tooltip: 'Profile',
          ),
          const SizedBox(width: 16),
        ] else ...[
          Consumer<MarketplaceProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    tooltip: 'Shopping Cart',
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
                  const SizedBox(height: 8),
                  _buildViewSelector(),
                  const SizedBox(height: 4),
                  if (_selectedView == 0) _buildCategoryTabs(),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search handcrafted products...',
          hintStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onChanged: (value) {
          context.read<MarketplaceProvider>().searchProducts(value);
        },
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 32,
      child: Row(
        children: [
          Expanded(child: _buildViewTab('Products', Icons.inventory_2, 0)),
          Expanded(child: _buildViewTab('Vendors', Icons.store, 1)),
          Expanded(child: _buildViewTab('Experiences', Icons.tour, 2)),
        ],
      ),
    );
  }

  Widget _buildViewTab(String title, IconData icon, int index) {
    final isSelected = _selectedView == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedView = index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: Consumer<MarketplaceProvider>(
        builder: (context, provider, child) {
          return TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            indicator: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: (index) {
              final categories = ['all', 'crafts', 'textile', 'pottery', 'food', 'jewelry'];
              provider.selectCategory(categories[index]);
            },
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Crafts'),
              Tab(text: 'Textile'),
              Tab(text: 'Pottery'),
              Tab(text: 'Food'),
              Tab(text: 'Jewelry'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () => provider.refreshData(),
          child: Column(
            children: [
              // Featured banner for mobile
              if (_selectedView == 0) _buildFeaturedBanner(),

              // Quick filters for mobile
              if (_selectedView == 0) _buildMobileQuickFilters(),

              // Main content
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () => provider.refreshData(),
          child: Column(
            children: [
              // Compact header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF1565C0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildViewSelector(),
                    const SizedBox(height: 12),
                    if (_selectedView == 0) _buildImprovedCategorySection(),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () => provider.refreshData(),
          child: Row(
            children: [
              // Left sidebar with enhanced filters
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    right: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                ),
                child: _buildEnhancedSidebar(provider),
              ),

              // Main content area
              Expanded(
                child: Column(
                  children: [
                    // Compact search header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                      ),
                      child: Column(
                        children: [
                          _buildSearchBar(),
                          const SizedBox(height: 12),
                          _buildViewSelector(),
                          const SizedBox(height: 16),
                          _buildCompactFeaturedSection(),
                        ],
                      ),
                    ),

                    // Products grid - maximum space
                    Expanded(
                      child: _buildMainContent(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImprovedCategorySection() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        final categories = [
          {'id': 'all', 'name': 'All', 'icon': Icons.apps, 'color': const Color(0xFF546E7A)},
          {'id': 'crafts', 'name': 'Crafts', 'icon': Icons.handyman, 'color': const Color(0xFF8D6E63)},
          {'id': 'textile', 'name': 'Textile', 'icon': Icons.checkroom, 'color': const Color(0xFF7986CB)},
          {'id': 'pottery', 'name': 'Pottery', 'icon': Icons.emoji_objects, 'color': const Color(0xFFAED581)},
          {'id': 'food', 'name': 'Food', 'icon': Icons.restaurant, 'color': const Color(0xFFFFB74D)},
          {'id': 'jewelry', 'name': 'Jewelry', 'icon': Icons.diamond, 'color': const Color(0xFFBA68C8)},
        ];

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = provider.selectedCategory == category['id'];
              final categoryColor = category['color'] as Color;

              return Container(
                width: 70,
                margin: EdgeInsets.only(right: index < categories.length - 1 ? 12 : 0),
                child: GestureDetector(
                  onTap: () => provider.selectCategory(category['id'] as String),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? categoryColor : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          size: 24,
                          color: categoryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.deepOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: Colors.orange[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover KZN\'s Authentic Heritage',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Handcrafted with Ubuntu spirit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileQuickFilters() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildQuickFilterChip('In Stock', Icons.inventory,
                provider.showInStockOnly, () => provider.toggleStockFilter(!provider.showInStockOnly),
                const Color(0xFF388E3C)),
              const SizedBox(width: 8),
              _buildQuickFilterChip('Fair Trade', Icons.handshake,
                provider.showFairTradeOnly, () => provider.toggleFairTradeFilter(!provider.showFairTradeOnly),
                const Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              _buildQuickFilterChip('Ubuntu', Icons.favorite,
                provider.showUbuntuOnly, () => provider.toggleUbuntuFilter(!provider.showUbuntuOnly),
                const Color(0xFFFF6D00)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickFilterChip(String label, IconData icon, bool isSelected, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(isSelected ? 1.0 : 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactFeaturedSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Discover KZN\'s Wanders Heritage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedView) {
      case 1:
        return _buildVendorsGrid();
      case 2:
        return _buildExperiencesGrid();
      default:
        return _buildProductsContent();
    }
  }

  Widget _buildProductsContent() {
    if (_selectedView == 0 && ResponsiveHelper.isMobile(context)) {
      return TabBarView(
        controller: _tabController,
        children: [
          _buildProductsGrid('all'),
          _buildProductsGrid('crafts'),
          _buildProductsGrid('textile'),
          _buildProductsGrid('pottery'),
          _buildProductsGrid('food'),
          _buildProductsGrid('jewelry'),
        ],
      );
    }
    return _buildProductsGrid('all');
  }

  Widget _buildProductsGrid(String category) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingGrid();
        }

        final products = provider.getProductsByCategory(category);
        if (products.isEmpty) {
          return _buildEmptyState('products');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.8 : 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => _showProductDetail(product),
              onARTap: product['hasAR'] == true
                  ? () => _showARViewer(product)
                  : null,
              onAddToCart: () => _addToCart(product),
              onFavorite: () => _toggleWishlist(product),
              isWishlisted: provider.isInWishlist(product['id']),
            );
          },
        );
      },
    );
  }

  Widget _buildEnhancedSidebar(MarketplaceProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Categories section
        _buildSidebarSection(
          'Categories',
          Icons.category,
          _buildCategoriesList(provider),
        ),
        const SizedBox(height: 24),

        // KZN Regions section
        _buildSidebarSection(
          'KZN Regions',
          Icons.location_on,
          _buildCompactRegionsList(provider),
        ),
        const SizedBox(height: 24),

        // Price Range section
        _buildSidebarSection(
          'Price Range',
          Icons.monetization_on,
          _buildPriceRangeSection(provider),
        ),
        const SizedBox(height: 24),

        // Wanders Features section
        _buildSidebarSection(
          'Wanders Features',
          Icons.handshake,
          _buildUbuntuFeaturesSection(provider),
        ),
        const SizedBox(height: 24),

        // Clear filters button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: provider.clearFilters,
            icon: const Icon(Icons.clear_all, size: 18),
            label: const Text('Clear All Filters'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods for sidebar sections
  Widget _buildSidebarSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildCategoriesList(MarketplaceProvider provider) {
    final categories = [
      {'id': 'all', 'name': 'All', 'icon': Icons.apps},
      {'id': 'crafts', 'name': 'Crafts', 'icon': Icons.handyman},
      {'id': 'textile', 'name': 'Textile', 'icon': Icons.checkroom},
      {'id': 'pottery', 'name': 'Pottery', 'icon': Icons.emoji_objects},
      {'id': 'food', 'name': 'Food', 'icon': Icons.restaurant},
      {'id': 'jewelry', 'name': 'Jewelry', 'icon': Icons.diamond},
    ];

    return Column(
      children: categories.map((category) {
        final isSelected = provider.selectedCategory == category['id'];
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            leading: Icon(category['icon'] as IconData, size: 18),
            title: Text(
              category['name'] as String,
              style: const TextStyle(fontSize: 14),
            ),
            selected: isSelected,
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            selectedColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onTap: () => provider.selectCategory(category['id'] as String),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompactRegionsList(MarketplaceProvider provider) {
    return Column(
      children: provider.kznRegions.take(6).map((regionId) {
        final regionInfo = _getRegionDisplayInfo(regionId);
        final isSelected = provider.selectedRegion == regionId;
        final count = provider.getRegionStats()[regionId] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            leading: Icon(regionInfo['icon'], size: 18),
            title: Text(
              regionInfo['name'],
              style: const TextStyle(fontSize: 14),
            ),
            trailing: count > 0 ? Text('$count', style: const TextStyle(fontSize: 12)) : null,
            selected: isSelected,
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            selectedColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onTap: () => provider.selectRegion(regionId),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSection(MarketplaceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
                  fontSize: 12,
                ),
              ),
              Text(
                'ZAR ${provider.priceRange.end.round()}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 20,
            child: RangeSlider(
              values: provider.priceRange,
              min: 0,
              max: 1000,
              divisions: 20,
              activeColor: Theme.of(context).primaryColor,
              onChanged: provider.updatePriceRange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUbuntuFeaturesSection(MarketplaceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          CheckboxListTile(
            dense: true,
            title: const Row(
              children: [
                Icon(Icons.inventory, size: 16, color: Colors.green),
                SizedBox(width: 6),
                Text('In Stock', style: TextStyle(fontSize: 12)),
              ],
            ),
            value: provider.showInStockOnly ?? false,
            onChanged: (value) => provider.toggleStockFilter(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
          ),
          CheckboxListTile(
            dense: true,
            title: const Row(
              children: [
                Icon(Icons.handshake, size: 16, color: Colors.orange),
                SizedBox(width: 6),
                Text('Fair Trade', style: TextStyle(fontSize: 12)),
              ],
            ),
            value: provider.showFairTradeOnly ?? false,
            onChanged: (value) => provider.toggleFairTradeFilter(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
          ),
          CheckboxListTile(
            dense: true,
            title: const Row(
              children: [
                Icon(Icons.favorite, size: 16, color: Colors.red),
                SizedBox(width: 6),
                Text('Ubuntu', style: TextStyle(fontSize: 12)),
              ],
            ),
            value: provider.showUbuntuOnly ?? false,
            onChanged: (value) => provider.toggleUbuntuFilter(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No $type found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<MarketplaceProvider>().clearFilters(),
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  // Placeholder methods for other grids
  Widget _buildVendorsGrid() {
    return _buildEmptyState('vendors');
  }

  Widget _buildExperiencesGrid() {
    return _buildEmptyState('experiences');
  }

  Map<String, dynamic> _getRegionDisplayInfo(String regionId) {
    final regionMap = {
      'all': {'name': 'All KZN', 'icon': Icons.map},
      'durban': {'name': 'eThekwini', 'icon': Icons.location_city},
      'zululand': {'name': 'Zululand', 'icon': Icons.account_balance},
      'drakensberg': {'name': 'Drakensberg', 'icon': Icons.terrain},
      'south_coast': {'name': 'South Coast', 'icon': Icons.waves},
      'midlands': {'name': 'Midlands', 'icon': Icons.grass},
      'north_coast': {'name': 'North Coast', 'icon': Icons.beach_access},
      'pietermaritzburg': {'name': 'PMB', 'icon': Icons.business},
      'ukhahlamba': {'name': 'uKhahlamba', 'icon': Icons.landscape},
    };
    return regionMap[regionId] ?? {'name': regionId, 'icon': Icons.location_on};
  }

  // Enhanced navigation and action methods
  void _showProductDetail(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailModal(
        product: product,
        onAddToCart: () => _addToCart(product),
        onToggleWishlist: () => _toggleWishlist(product),
        onViewAR: product['hasAR'] == true
          ? () {
              Navigator.pop(context);
              _showARViewer(product);
            }
          : null,
        isWishlisted: context.read<MarketplaceProvider>().isInWishlist(product['id']),
      ),
    );
  }

  void _showARViewer(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
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
    final provider = context.read<MarketplaceProvider>();

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
        content: Text('${product['title'] ?? 'Product'} added to cart'),
        backgroundColor: Theme.of(context).primaryColor,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  void _toggleWishlist(Map<String, dynamic> product) {
    final provider = context.read<MarketplaceProvider>();
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
