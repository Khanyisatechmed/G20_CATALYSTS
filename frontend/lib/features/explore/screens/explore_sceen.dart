// features/explore/screens/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/explore_provider.dart';
import '../widgets/destination_card.dart';
import '../widgets/filter_chip.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreProvider>().loadDestinations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Explore Ubuntu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(context, provider),
              ),
              if (ResponsiveHelper.isMobile(context))
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.filter_list),
                      if (_hasActiveFilters(provider))
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () => _showFilterBottomSheet(context, provider),
                ),
            ],
          ),
          body: ResponsiveLayout(
            mobile: _buildMobileLayout(),
            tablet: _buildTabletLayout(),
            desktop: _buildDesktopLayout(),
          ),
          bottomNavigationBar: const CustomBottomNav(currentRoute: '/explore'),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _buildFilterChips(provider),
            Expanded(
              child: _buildDestinationGrid(context, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            // Sidebar with filters
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  right: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: _buildFilterSidebar(provider),
            ),
            // Main content
            Expanded(
              child: _buildDestinationGrid(context, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            // Sidebar with filters
            Container(
              width: 350,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  right: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: _buildFilterSidebar(provider),
            ),
            // Main content
            Expanded(
              child: Column(
                children: [
                  // Header with results count and sort options
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${provider.filteredDestinations.length} destinations found',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        _buildSortDropdown(provider),
                      ],
                    ),
                  ),
                  // Destinations grid
                  Expanded(
                    child: _buildDestinationGrid(context, provider),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChips(ExploreProvider provider) {
    final categories = provider.categories;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" chip
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChipWidget(
                label: 'All',
                isSelected: provider.selectedCategories.isEmpty,
                onTap: () => provider.clearCategorySelection(),
              ),
            );
          }

          final category = categories[index - 1];
          final isSelected = provider.selectedCategories.contains(category);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChipWidget(
              label: category,
              isSelected: isSelected,
              onTap: () => provider.selectCategory(category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSidebar(ExploreProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_hasActiveFilters(provider))
                TextButton(
                  onPressed: () => provider.clearFilters(),
                  child: const Text('Clear All'),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Search
          TextField(
            onChanged: (value) => provider.updateSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Search destinations...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Categories
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.categories.map((category) {
              final isSelected = provider.selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (bool selected) => provider.selectCategory(category),
                selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).primaryColor,
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Price Range
          const Text(
            'Price Range (per person)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
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
                  max: 2000,
                  divisions: 20,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (RangeValues values) => provider.updatePriceRange(values),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Rating Filter
          const Text(
            'Minimum Rating',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${provider.minimumRating.toStringAsFixed(1)} stars and above',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Slider(
                  value: provider.minimumRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  activeColor: Colors.amber,
                  onChanged: (double value) => provider.updateMinimumRating(value),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // WandersFeatures
          const Text(
            'Wanders Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ..._getUbuntuFeatures().map((feature) => CheckboxListTile(
            title: Text(feature['title']!),
            subtitle: Text(feature['description']!),
            value: provider.selectedFeatures.contains(feature['id']),
            onChanged: (bool? value) => provider.toggleFeature(feature['id']!),
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
          )),
        ],
      ),
    );
  }

  Widget _buildSortDropdown(ExploreProvider provider) {
    return DropdownButton<String>(
      value: provider.sortBy,
      onChanged: (String? value) {
        if (value != null) {
          provider.updateSortBy(value);
        }
      },
      items: const [
        DropdownMenuItem(value: 'name', child: Text('Name')),
        DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
        DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
        DropdownMenuItem(value: 'rating', child: Text('Highest Rated')),
        DropdownMenuItem(value: 'popular', child: Text('Most Popular')),
      ],
    );
  }

  Widget _buildDestinationGrid(BuildContext context, ExploreProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Catalystic Wanders...'),
          ],
        ),
      );
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
              'Error loading destinations',
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
              onPressed: () => provider.loadDestinations(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredDestinations = provider.filteredDestinations;

    if (filteredDestinations.isEmpty) {
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
            const Text(
              'No destinations found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => provider.clearFilters(),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: ResponsiveHelper.getResponsivePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridColumns(context),
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.8 : 0.9,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredDestinations.length,
      itemBuilder: (context, index) {
        final destination = filteredDestinations[index];
        return DestinationCard(
          destination: destination,
          onTap: () => _navigateToDestinationDetail(destination),
        );
      },
    );
  }

  void _navigateToDestinationDetail(Map<String, dynamic> destination) {
    Navigator.pushNamed(
      context,
      '/destination-detail',
      arguments: destination,
    );
  }

  void _showSearchDialog(BuildContext context, ExploreProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Search Catalystic Wanders'),
        content: TextField(
          onChanged: (value) => provider.updateSearchQuery(value),
          decoration: const InputDecoration(
            hintText: 'Enter destination or cultural experience...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, ExploreProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            // Filter content
            Expanded(
              child: _buildFilterSidebar(provider),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters(ExploreProvider provider) {
    return provider.selectedCategories.isNotEmpty ||
           provider.priceRange.start > 0 ||
           provider.priceRange.end < 2000 ||
           provider.minimumRating > 0 ||
           provider.searchQuery.isNotEmpty ||
           provider.selectedFeatures.isNotEmpty;
  }

  List<Map<String, String>> _getUbuntuFeatures() {
    return [
      {
        'id': 'cultural_tours',
        'title': 'Cultural Tours',
        'description': 'Traditional cultural experiences',
      },
      {
        'id': 'ubuntu_philosophy',
        'title': 'Wanders Philosophy',
        'description': 'Learn about "I am because we are"',
      },
      {
        'id': 'local_community',
        'title': 'Community Interaction',
        'description': 'Meet and interact with locals',
      },
      {
        'id': 'traditional_food',
        'title': 'Traditional Food',
        'description': 'Authentic South African cuisine',
      },
      {
        'id': 'ar_experience',
        'title': 'AR Experience',
        'description': 'Augmented reality cultural tours',
      },
    ];
  }
}
