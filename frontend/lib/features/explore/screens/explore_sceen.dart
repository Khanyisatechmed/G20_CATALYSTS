import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/explore_provider.dart';
import '../widgets/destination_card.dart';
import '../widgets/filter_chip.dart';
import '../widgets/map_view.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreProvider>().loadDestinations();
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
          ? const CustomBottomNavigation(currentIndex: 1)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Explore',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.isMobile(context) ? 24 : 28,
        ),
      ),
      actions: ResponsiveHelper.isDesktop(context) ? [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person_outline, color: Colors.black87),
        ),
        const SizedBox(width: 16),
      ] : null,
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildSearchAndFilters(),
        Expanded(
          child: Consumer<ExploreProvider>(
            builder: (context, provider, child) {
              if (provider.showMapView) {
                return _buildMapView();
              }
              return _buildDestinationsList();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        Container(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: _buildSearchAndFilters(),
        ),
        Expanded(
          child: Consumer<ExploreProvider>(
            builder: (context, provider, child) {
              if (provider.showMapView) {
                return _buildMapView();
              }
              return _buildDestinationsList();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left panel - Filters and search
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              right: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: _buildSearchAndFilters(),
              ),
              Expanded(
                child: _buildFiltersList(),
              ),
            ],
          ),
        ),
        // Right panel - Content
        Expanded(
          child: Consumer<ExploreProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  // Destinations list
                  Expanded(
                    flex: provider.showMapView ? 1 : 2,
                    child: _buildDestinationsList(),
                  ),
                  // Map view
                  if (provider.showMapView)
                    Expanded(
                      flex: 1,
                      child: _buildMapView(),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search destinations...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            onChanged: (value) {
              context.read<ExploreProvider>().searchDestinations(value);
            },
          ),
        ),

        const SizedBox(height: 16),

        // Filter tabs
        if (!ResponsiveHelper.isDesktop(context)) ...[
          TabBar(
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
              Tab(text: 'Story telling'),
              Tab(text: 'Arts'),
              Tab(text: 'Guided Tours'),
              Tab(text: 'Accommodation'),
            ],
          ),

          const SizedBox(height: 16),

          // Map toggle
          Row(
            children: [
              Expanded(
                child: Consumer<ExploreProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton.icon(
                      onPressed: () => provider.toggleMapView(),
                      icon: Icon(
                        provider.showMapView ? Icons.list : Icons.map,
                        size: 20,
                      ),
                      label: Text(
                        provider.showMapView ? 'List View' : 'Map View',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.showMapView
                            ? Theme.of(context).primaryColor
                            : Colors.grey[100],
                        foregroundColor: provider.showMapView
                            ? Colors.white
                            : Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Consumer<ExploreProvider>(
                builder: (context, provider, child) {
                  return IconButton(
                    onPressed: () => _showFilterBottomSheet(),
                    icon: Stack(
                      children: [
                        const Icon(Icons.filter_list),
                        if (provider.hasActiveFilters)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFiltersList() {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'All', 'Story telling', 'Arts', 'Guided Tours', 'Accommodation'
              ].map((category) {
                final isSelected = provider.selectedCategory == category;
                return FilterChipWidget(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => provider.selectCategory(category),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Price Range',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
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

            const SizedBox(height: 24),

            const Text(
              'Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...['Mpumalanga', 'KwaZulu-Natal', 'Limpopo', 'Eastern Cape']
                .map((province) {
              final isSelected = provider.selectedProvinces.contains(province);
              return CheckboxListTile(
                title: Text(province),
                value: isSelected,
                onChanged: (value) => provider.toggleProvince(province),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildDestinationsList() {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.filteredDestinations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No destinations found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: ResponsiveHelper.getResponsivePadding(context),
          gridDelegate: ResponsiveHelper.getResponsiveGridDelegate(
            context,
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.8 : 0.9,
          ),
          itemCount: provider.filteredDestinations.length,
          itemBuilder: (context, index) {
            final destination = provider.filteredDestinations[index];
            return DestinationCard(
              title: destination['title'] ?? 'The Bantus',
              location: destination['location'] ?? 'Mpumalanga',
              rating: destination['rating']?.toDouble() ?? 4.5,
              reviewCount: destination['reviewCount'] ?? 120,
              price: destination['price']?.toDouble() ?? 150.0,
              imageUrl: destination['imageUrl'] ?? '',
              onTap: () => _navigateToDestinationDetail(destination),
            );
          },
        );
      },
    );
  }

  Widget _buildMapView() {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return MapView(
          destinations: provider.filteredDestinations,
          onDestinationTap: _navigateToDestinationDetail,
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ExploreProvider>().clearFilters();
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: _buildFiltersList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToDestinationDetail(Map<String, dynamic> destination) {
    Navigator.pushNamed(
      context,
      '/destination-detail',
      arguments: destination,
    );
  }
}
