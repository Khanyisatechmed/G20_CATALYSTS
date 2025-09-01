import 'package:flutter/material.dart';
import 'package:frontend/core/utils/responsive_helper.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/home_provider.dart';
import '../widgets/experience_card.dart';
import '../widgets/ar_package_card.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isMobile(context) ? null : _buildDesktopAppBar(),
      body: ResponsiveLayoutBuilder(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveHelper.isMobile(context)
          ? const CustomBottomNavigation(currentIndex: 0)
          : null,
    );
  }

  PreferredSizeWidget _buildDesktopAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Text(
            'Ubuntu Destinations',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person_outline, color: Colors.black87),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              children: [
                const CustomSearchBar(),
                const SizedBox(height: 24),
                _buildPopularExperiences(),
                const SizedBox(height: 32),
                _buildTrendingARPackages(),
                const SizedBox(height: 100), // Bottom navigation space
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: const CustomSearchBar(),
                ),
                const SizedBox(height: 32),
                _buildPopularExperiences(),
                const SizedBox(height: 40),
                _buildTrendingARPackages(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar navigation
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              right: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: _buildSidebar(),
        ),
        // Main content
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: const CustomSearchBar(),
                      ),
                      const SizedBox(height: 40),
                      _buildPopularExperiences(),
                      const SizedBox(height: 48),
                      _buildTrendingARPackages(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        const SizedBox(height: 32),
        _buildSidebarItem(Icons.home, 'Home', true),
        _buildSidebarItem(Icons.explore, 'Explore', false),
        _buildSidebarItem(Icons.calendar_today, 'Bookings', false),
        _buildSidebarItem(Icons.shopping_cart, 'Market', false),
        _buildSidebarItem(Icons.person, 'Profile', false),
        const Spacer(),
        _buildSidebarItem(Icons.settings, 'Settings', false),
        _buildSidebarItem(Icons.help_outline, 'Help', false),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Theme.of(context).primaryColor : Colors.grey[800],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: isActive
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        onTap: () {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildPopularExperiences() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingGrid();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Experiences',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to explore screen
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildExperiencesGrid(provider.popularExperiences),
          ],
        );
      },
    );
  }

  Widget _buildTrendingARPackages() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingGrid();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trending AR Packages',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildARPackagesGrid(provider.arPackages),
          ],
        );
      },
    );
  }

  Widget _buildExperiencesGrid(List<dynamic> experiences) {
    final crossAxisCount = ResponsiveHelper.getCrossAxisCount(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 2,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.3 : 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final experience = experiences[index];
        return ExperienceCard(
          title: experience['title'] ?? 'Pottery Workshop',
          price: experience['price'] ?? 150.0,
          currency: experience['currency'] ?? 'ZAR',
          imageUrl: experience['imageUrl'] ?? '',
          onTap: () {
            // Navigate to experience detail
          },
        );
      },
    );
  }

  Widget _buildARPackagesGrid(List<dynamic> packages) {
    final crossAxisCount = ResponsiveHelper.getCrossAxisCount(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 2,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 1.3 : 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        return ARPackageCard(
          title: package['title'] ?? 'Museum AR Tour',
          description: package['description'] ?? 'Interactive cultural experience',
          imageUrl: package['imageUrl'] ?? '',
          onTap: () {
            // Navigate to AR experience
          },
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
        childAspectRatio: 1.3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4,
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
}
