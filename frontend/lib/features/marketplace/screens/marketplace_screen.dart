// features/marketplace/screens/enhanced_marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/ar_viewer.dart';
import '../widgets/cultural_collections.dart';
import '../widgets/kzn_regional_filter.dart';
import '../widgets/vendor_profile_card.dart';

class EnhancedMarketplaceScreen extends StatefulWidget {
  const EnhancedMarketplaceScreen({super.key});

  @override
  State<EnhancedMarketplaceScreen> createState() => _EnhancedMarketplaceScreenState();
}

class _EnhancedMarketplaceScreenState extends State<EnhancedMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  int _selectedView = 0; // 0: Products, 1: Vendors, 2: Experiences

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this); // Updated for more categories
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
              preferredSize: const Size.fromHeight(160),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildViewSelector(),
                  const SizedBox(height: 8),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search handcrafted products, vendors, experiences...',
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

  Widget _buildViewSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildViewTab('Products', Icons.inventory_2, 0),
          ),
          Expanded(
            child: _buildViewTab('Vendors', Icons.store, 1),
          ),
          Expanded(
            child: _buildViewTab('Experiences', Icons.tour, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildViewTab(String title, IconData icon, int index) {
    final isSelected = _selectedView == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedView = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
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
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(25),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }

  Widget _buildMobileLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // KZN Regional Filter
            KZNRegionalFilter(
              selectedRegion: provider.selectedRegion,
              onRegionSelected: provider.selectRegion,
              regionCounts: provider.getRegionStats(),
            ),

            // Cultural Collections (only for products view)
            if (_selectedView == 0)
              CulturalCollections(
                collections: CulturalCollectionsData.getCollections(),
                onCollectionTap: (collectionId) {
                  // Navigate to collection view
                  Navigator.pushNamed(context, '/collection', arguments: collectionId);
                },
              ),

            // Main content
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildViewSelector(),
                  const SizedBox(height: 16),
                  if (_selectedView == 0) _buildCategoryTabs(),
                ],
              ),
            ),

            // KZN Regional Filter
            KZNRegionalFilter(
              selectedRegion: provider.selectedRegion,
              onRegionSelected: provider.selectRegion,
              regionCounts: provider.getRegionStats(),
            ),

            // Cultural Collections
            if (_selectedView == 0)
              CulturalCollections(
                collections: CulturalCollectionsData.getCollections(),
                onCollectionTap: (collectionId) {
                  Navigator.pushNamed(context, '/collection', arguments: collectionId);
                },
              ),

            Expanded(
              child: _buildMainContent(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            // Left sidebar with enhanced filters
            Container(
              width: 360,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  right: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: _buildEnhancedSidebar(provider),
            ),
            // Main content area
            Expanded(
              child: Column(
                children: [
                  // Search and header
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    ),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 16),
                        _buildViewSelector(),
                        const SizedBox(height: 24),
                        _buildFeaturedSection(),
                      ],
                    ),
                  ),

                  // KZN Regional Filter
                  KZNRegionalFilter(
                    selectedRegion: provider.selectedRegion,
                    onRegionSelected: provider.selectRegion,
                    regionCounts: provider.getRegionStats(),
                  ),

                  // Cultural Collections
                  if (_selectedView == 0)
                    CulturalCollections(
                      collections: CulturalCollectionsData.getCollections(),
                      onCollectionTap: (collectionId) {
                        Navigator.pushNamed(context, '/collection', arguments: collectionId);
                      },
                    ),

                  // Main content
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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

  Widget _buildVendorsGrid() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final vendors = provider.vendors;
        if (vendors.isEmpty) {
          return _buildEmptyState('vendors');
        }

        return GridView.builder(
          padding: ResponsiveHelper.getResponsivePadding(context),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.5 : 1.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return VendorProfileCard(
              vendor: vendor,
              onTap: () => _navigateToVendorProfile(vendor),
              onContact: () => _contactVendor(vendor),
              onViewProducts: () => _viewVendorProducts(vendor),
            );
          },
        );
      },
    );
  }

  Widget _buildExperiencesGrid() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final experiences = provider.culturalExperiences;
        if (experiences.isEmpty) {
          return _buildEmptyState('experiences');
        }

        return GridView.builder(
          padding: ResponsiveHelper.getResponsivePadding(context),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: experiences.length,
          itemBuilder: (context, index) {
            final experience = experiences[index];
            return ProductCard(
              product: experience,
              onTap: () => _navigateToExperienceDetail(experience),
              onARTap: experience['hasAR'] == true
                  ? () => _showARViewer(experience)
                  : null,
              onAddToCart: () => _bookExperience(experience),
            );
          },
        );
      },
    );
  }

  Widget _buildProductsGrid(String category) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingGrid();
        }

        if (provider.error != null) {
          return _buildErrorState(provider);
        }

        final products = provider.getProductsByCategory(category);

        if (products.isEmpty) {
          return _buildEmptyState('products');
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
      padding: const EdgeInsets.all(24),
      children: [
        // Categories section
        _buildSidebarSection(
          'Categories',
          Icons.local_mall,
          _buildCategoriesList(provider),
        ),
        const SizedBox(height: 32),

        // KZN Regions section
        _buildSidebarSection(
          'KZN Regions',
          Icons.location_on,
          _buildRegionsList(provider),
        ),
        const SizedBox(height: 32),

        // Price Range section
        _buildSidebarSection(
          'Price Range',
          Icons.attach_money,
          _buildPriceRangeSection(provider),
        ),
        const SizedBox(height: 32),

        // Ubuntu Features section
        _buildSidebarSection(
          'Ubuntu Features',
          Icons.handshake,
          _buildUbuntuFeaturesSection(provider),
        ),
        const SizedBox(height: 32),

        // Sort Options
        _buildSidebarSection(
          'Sort By',
          Icons.sort,
          _buildSortSection(provider),
        ),
        const SizedBox(height: 32),

        // Clear filters button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: provider.clearFilters,
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear All Filters'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(category['icon'] as IconData),
            title: Text(category['name'] as String),
            selected: isSelected,
            selectedTileColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            selectedColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () => provider.selectCategory(category['id'] as String),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRegionsList(MarketplaceProvider provider) {
    return Column(
      children: provider.kznRegions.map((regionId) {
        final regionInfo = _getRegionDisplayInfo(regionId);
        final isSelected = provider.selectedRegion == regionId;
        final count = provider.getRegionStats()[regionId] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(regionInfo['icon']),
            title: Text(regionInfo['name']),
            trailing: count > 0 ? Text('$count') : null,
            selected: isSelected,
            selectedTileColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            selectedColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () => provider.selectRegion(regionId),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSection(MarketplaceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
    );
  }

  Widget _buildUbuntuFeaturesSection(MarketplaceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
            value: provider.showAROnly ?? false,
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
            value: provider.showInStockOnly ?? false,
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
            value: provider.showFairTradeOnly ?? false,
            onChanged: (value) => provider.toggleFairTradeFilter(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
          ),
          CheckboxListTile(
            title: Row(
              children: [
                Icon(Icons.favorite, size: 20, color: Colors.red),
                const SizedBox(width: 8),
                const Text('Ubuntu Certified'),
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

  Widget _buildSortSection(MarketplaceProvider provider) {
    final sortOptions = [
      {'id': 'relevance', 'name': 'Relevance'},
      {'id': 'price_low', 'name': 'Price: Low to High'},
      {'id': 'price_high', 'name': 'Price: High to Low'},
      {'id': 'rating', 'name': 'Highest Rated'},
      {'id': 'newest', 'name': 'Newest First'},
    ];

    return Column(
      children: sortOptions.map((option) {
        final isSelected = provider.sortBy == option['id'];
        return RadioListTile<String>(
          title: Text(option['name'] as String),
          value: option['id'] as String,
          groupValue: provider.sortBy,
          onChanged: (value) => provider.updateSortBy(value!),
          activeColor: Theme.of(context).primaryColor,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildFeaturedSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
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
                'Discover KZN\'s Ubuntu Heritage',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Authentic handcrafted items from local Ubuntu artisans celebrating South African heritage and culture',
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

  Widget _buildErrorState(MarketplaceProvider provider) {
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
            'Error loading content',
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

  Widget _buildEmptyState(String type) {
    String title, subtitle;
    IconData icon;

    switch (type) {
      case 'vendors':
        icon = Icons.store;
        title = 'No vendors found';
        subtitle = 'Try adjusting your search or filters';
        break;
      case 'experiences':
        icon = Icons.tour;
        title = 'No experiences available';
        subtitle = 'Check back later for new cultural experiences';
        break;
      default:
        icon = Icons.shopping_bag_outlined;
        title = 'No products found';
        subtitle = 'Try adjusting your search or filters';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(
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

  // Navigation methods
  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-detail',
      arguments: product,
    );
  }

  void _navigateToVendorProfile(Map<String, dynamic> vendor) {
    Navigator.pushNamed(
      context,
      '/vendor-profile',
      arguments: vendor,
    );
  }

  void _navigateToExperienceDetail(Map<String, dynamic> experience) {
    Navigator.pushNamed(
      context,
      '/experience-detail',
      arguments: experience,
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

  void _toggleWishlist(Map<String, dynamic> product) {
    final provider = context.read<MarketplaceProvider>();
    if (provider.isInWishlist(product['id'])) {
      provider.removeFromWishlist(product['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from wishlist')),
      );
    } else {
      provider.addToWishlist(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to wishlist')),
      );
    }
  }

  void _contactVendor(Map<String, dynamic> vendor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${vendor['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (vendor['contactInfo']?['phone'] != null)
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call'),
                subtitle: Text(vendor['contactInfo']['phone']),
                onTap: () {
                  Navigator.pop(context);
                  // Implement phone call
                },
              ),
            if (vendor['contactInfo']?['whatsapp'] != null)
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('WhatsApp'),
                subtitle: Text(vendor['contactInfo']['whatsapp']),
                onTap: () {
                  Navigator.pop(context);
                  // Implement WhatsApp
                },
              ),
            if (vendor['contactInfo']?['email'] != null)
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(vendor['contactInfo']['email']),
                onTap: () {
                  Navigator.pop(context);
                  // Implement email
                },
              ),
          ],
        ),
      ),
    );
  }

  void _viewVendorProducts(Map<String, dynamic> vendor) {
    Navigator.pushNamed(
      context,
      '/vendor-products',
      arguments: vendor['id'],
    );
  }

  void _bookExperience(Map<String, dynamic> experience) {
    Navigator.pushNamed(
      context,
      '/book-experience',
      arguments: experience,
    );
  }
}
