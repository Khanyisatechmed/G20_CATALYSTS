// features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/home_provider.dart';
import '../widgets/ar_package_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      bottomNavigationBar: CustomBottomNav(currentRoute: '/home'),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              _buildSearchSection(),
              const SizedBox(height: 32),
              _buildQuickActionsSection(),
              const SizedBox(height: 32),
              _buildFeaturedExperiencesSection(),
              const SizedBox(height: 32),
              _buildARPackagesSection(),
              const SizedBox(height: 32),
              _buildCulturalHighlightsSection(),
              const SizedBox(height: 32),
              _buildRecommendationsSection(),
              const SizedBox(height: 100), // Bottom padding for nav
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 32),
                _buildSearchSection(),
                const SizedBox(height: 40),
                _buildQuickActionsSection(),
                const SizedBox(height: 40),
                _buildFeaturedExperiencesSection(),
                const SizedBox(height: 40),
                _buildARPackagesSection(),
                const SizedBox(height: 40),
                _buildCulturalHighlightsSection(),
                const SizedBox(height: 40),
                _buildRecommendationsSection(),
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
        // Sidebar
        Container(
          width: 280,
          color: Colors.grey[50],
          child: _buildDesktopSidebar(),
        ),
        // Main content
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildDesktopHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildFeaturedExperiencesSection(),
                                const SizedBox(height: 40),
                                _buildCulturalHighlightsSection(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: Column(
                              children: [
                                _buildARPackagesSection(),
                                const SizedBox(height: 40),
                                _buildRecommendationsSection(),
                              ],
                            ),
                          ),
                        ],
                      ),
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
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          children: [
            const Text(
              'Ubuntu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Destinations',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showNotifications,
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(
          onPressed: () => context.push('/profile'),
          icon: const Icon(Icons.person_outline),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDesktopHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Ubuntu Destinations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showNotifications,
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSearchSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActionsSection(),
          const SizedBox(height: 32),
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivityList(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sawubona! Welcome back',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Discover Ubuntu experiences',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ubuntu Philosophy',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '"I am because we are" - Experience authentic South African culture',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search experiences, places, culture...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () => _searchController.clear(),
            icon: const Icon(Icons.clear),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final actions = [
      {
        'title': 'Book Stay',
        'icon': Icons.hotel,
        'color': Colors.blue,
        'route': '/accommodation',
      },
      {
        'title': 'Experiences',
        'icon': Icons.local_activity,
        'color': Colors.green,
        'route': '/explore',
      },
      {
        'title': 'Marketplace',
        'icon': Icons.shopping_bag,
        'color': Colors.purple,
        'route': '/marketplace',
      },
      {
        'title': 'AR Tours',
        'icon': Icons.view_in_ar,
        'color': Colors.orange,
        'route': '/ar-experiences',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: actions.map((action) => _buildQuickActionCard(action)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(Map<String, dynamic> action) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.push(action['route']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  action['icon'],
                  color: action['color'],
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedExperiencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Experiences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/explore'),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _getFeaturedExperiences().length,
            itemBuilder: (context, index) {
              final experience = _getFeaturedExperiences()[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: _buildFeaturedExperienceCard(experience),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedExperienceCard(Map<String, dynamic> experience) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/destination/${experience['id']}', extra: experience),
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: experience['image'] != null
                    ? DecorationImage(
                        image: NetworkImage(experience['image']),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: experience['image'] == null ? Colors.grey[300] : null,
              ),
              child: experience['image'] == null
                  ? Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: Colors.grey[500],
                      ),
                    )
                  : null,
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience['title'] ?? 'Ubuntu Experience',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        experience['location'] ?? 'South Africa',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ZAR ${experience['price'] ?? 150}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildARPackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.view_in_ar, color: Colors.purple),
                  const SizedBox(width: 8),
                  const Text(
                    'AR Experiences',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('/ar-experiences'),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _getARPackages().length,
            itemBuilder: (context, index) {
              final package = _getARPackages()[index];
              return Container(
                width: 240,
                margin: const EdgeInsets.only(right: 16),
                child: ARPackageCard(
                  package: package,
                  onTap: () => context.push('/ar-experience/${package['id']}', extra: package),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCulturalHighlightsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cultural Highlights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Ubuntu Stories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Discover the philosophy of Ubuntu - "I am because we are" - through authentic South African cultural experiences that celebrate our shared humanity and interconnectedness.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.push('/cultural-stories'),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Explore Stories'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended for You',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._getRecommendations().map((recommendation) =>
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildRecommendationCard(recommendation),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: (recommendation['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            recommendation['icon'],
            color: recommendation['color'],
          ),
        ),
        title: Text(
          recommendation['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(recommendation['description']),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push(recommendation['route']),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    final activities = [
      'Booked Ubuntu Village Stay',
      'Explored AR Museum Tour',
      'Purchased Ndebele Artwork',
      'Joined Traditional Dance Class',
    ];

    return Column(
      children: activities.map((activity) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  activity,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }

  // Data methods
  List<Map<String, dynamic>> _getFeaturedExperiences() {
    return [
      {
        'id': '1',
        'title': 'Ubuntu Village Experience',
        'location': 'Eastern Cape',
        'price': 450,
        'image': null,
      },
      {
        'id': '2',
        'title': 'Traditional Zulu Dancing',
        'location': 'KwaZulu-Natal',
        'price': 280,
        'image': null,
      },
      {
        'id': '3',
        'title': 'Ndebele Art Workshop',
        'location': 'Mpumalanga',
        'price': 320,
        'image': null,
      },
    ];
  }

  List<Map<String, dynamic>> _getARPackages() {
    return [
      {
        'id': '1',
        'title': 'Museum AR Tour',
        'location': 'Johannesburg',
        'description': 'Explore ancient artifacts through AR',
        'price': 150,
        'rating': 4.8,
        'duration': 45,
        'type': 'museum',
      },
      {
        'id': '2',
        'title': 'Cultural Heritage AR',
        'location': 'Cape Town',
        'description': 'Experience traditional culture in AR',
        'price': 200,
        'rating': 4.6,
        'duration': 60,
        'type': 'cultural',
      },
      {
        'id': '3',
        'title': 'Historical Sites AR',
        'location': 'Pretoria',
        'description': 'Walk through history with AR',
        'price': 0,
        'rating': 4.5,
        'duration': 30,
        'type': 'historical',
      },
    ];
  }

  List<Map<String, dynamic>> _getRecommendations() {
    return [
      {
        'title': 'Complete Your Profile',
        'description': 'Get personalized recommendations',
        'icon': Icons.person,
        'color': Colors.blue,
        'route': '/profile',
      },
      {
        'title': 'Book Your First Stay',
        'description': 'Experience authentic Ubuntu hospitality',
        'icon': Icons.hotel,
        'color': Colors.green,
        'route': '/accommodation',
      },
      {
        'title': 'Try AR Experience',
        'description': 'Explore culture through technology',
        'icon': Icons.view_in_ar,
        'color': Colors.purple,
        'route': '/ar-experiences',
      },
    ];
  }

  // Event handlers
  void _performSearch(String query) {
    if (query.isNotEmpty) {
      context.push('/search?q=$query');
    }
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('No new notifications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
