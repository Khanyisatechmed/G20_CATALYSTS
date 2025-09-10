// features/home/screens/home_screen.dart - COMPLETE VERSION WITH VIDEO PLAYER
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/home_provider.dart';
import '../widgets/ar_package_card.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Video player variables
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _isVideoLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<HomeProvider>().loadData();
      } catch (e) {
        debugPrint('Error loading data: $e');
      }
    });
  }

  void _initializeVideo() async {
    setState(() {
      _isVideoLoading = true;
    });

    try {
      // Initialize video controller with asset video
      _videoController = VideoPlayerController.asset('assets/videos/hologram.mp4');
      await _videoController.initialize();

      // Set video properties
      _videoController.setLooping(true);
      _videoController.setVolume(0.0); // Muted for autoplay

      // Start playing automatically
      await _videoController.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _isVideoPlaying = true;
          _isVideoLoading = false;
        });
      }

      // Listen to video state changes
      _videoController.addListener(_videoListener);
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
          _isVideoLoading = false;
        });
      }
    }
  }

  void _videoListener() {
    if (mounted && _videoController.value.isInitialized) {
      setState(() {
        _isVideoPlaying = _videoController.value.isPlaying;
      });
    }
  }

  void _toggleVideoPlayback() {
    if (_isVideoInitialized) {
      setState(() {
        if (_videoController.value.isPlaying) {
          _videoController.pause();
        } else {
          _videoController.play();
        }
      });
    } else if (!_isVideoLoading) {
      // Retry video initialization if it failed
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    if (_isVideoInitialized) {
      _videoController.removeListener(_videoListener);
      _videoController.dispose();
    }
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
      bottomNavigationBar: const CustomBottomNav(currentRoute: '/home'),
    );
  }

  Widget _buildMobileLayout() {
    return RefreshIndicator(
      onRefresh: () async {
        try {
          await context.read<HomeProvider>().refresh();
        } catch (e) {
          debugPrint('Error refreshing: $e');
        }
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHologramHubWelcomeVideo(),
                    const SizedBox(height: 16),
                    _buildWelcomeHeroSection(),
                    const SizedBox(height: 16),
                    _buildSearchSection(),
                    const SizedBox(height: 24),
                    _buildQuickActionsSection(),
                    const SizedBox(height: 24),
                    _buildFeaturedExperiencesSection(provider),
                    const SizedBox(height: 24),
                    _buildKZNMarketplaceSection(provider),
                    const SizedBox(height: 24),
                    _buildCulturalHighlightsSection(),
                    const SizedBox(height: 24),
                    _buildRecommendationsSection(),
                    const SizedBox(height: 100), // Bottom padding for nav
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return RefreshIndicator(
      onRefresh: () async {
        try {
          await context.read<HomeProvider>().refresh();
        } catch (e) {
          debugPrint('Error refreshing: $e');
        }
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHologramHubWelcomeVideo(),
                      const SizedBox(height: 32),
                      _buildWelcomeHeroSection(),
                      const SizedBox(height: 32),
                      _buildSearchSection(),
                      const SizedBox(height: 40),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildFeaturedExperiencesSection(provider),
                                const SizedBox(height: 40),
                                _buildKZNMarketplaceSection(provider),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                _buildQuickActionsSection(),
                                const SizedBox(height: 40),
                                _buildCulturalHighlightsSection(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildRecommendationsSection(),
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(right: BorderSide(color: Colors.grey[200]!)),
          ),
          child: _buildDesktopSidebar(),
        ),
        // Main content
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              try {
                await context.read<HomeProvider>().refresh();
              } catch (e) {
                debugPrint('Error refreshing: $e');
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildDesktopHeader(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHologramHubWelcomeVideo(),
                            const SizedBox(height: 40),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      _buildFeaturedExperiencesSection(provider),
                                      const SizedBox(height: 40),
                                      _buildCulturalHighlightsSection(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildKZNMarketplaceSection(provider),
                                      const SizedBox(height: 40),
                                      _buildRecommendationsSection(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: ResponsiveHelper.isMobile(context) ? 100 : 120,
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF1E3A8A),
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Catalystic',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Wanders',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Hologram Hub',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E3A8A),
                Color(0xFF3B82F6),
              ],
            ),
          ),
          child: Stack(
            children: [
              if (!ResponsiveHelper.isMobile(context))
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preserving the Past',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Empowering the Future',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Catalystic Wanders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Heritage Innovation Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _showNotifications,
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
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
    return SingleChildScrollView(
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

  Widget _buildHologramHubWelcomeVideo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: ResponsiveHelper.isMobile(context) ? 160 : 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Video background
            Positioned.fill(
              child: _buildVideoBackground(),
            ),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
            // Content overlay
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isVideoLoading
                          ? Icons.hourglass_empty
                          : _isVideoPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                      color: Colors.white,
                      size: ResponsiveHelper.isMobile(context) ? 32 : 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome to the Hologram Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.isMobile(context) ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Experience the future of cultural heritage',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: ResponsiveHelper.isMobile(context) ? 12 : 14,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Live indicator
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: _isVideoPlaying && !_isVideoLoading ? Colors.red : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (_isVideoPlaying && !_isVideoLoading ? Colors.red : Colors.grey).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      _isVideoLoading
                          ? 'LOADING'
                          : _isVideoPlaying
                              ? 'LIVE'
                              : 'PAUSED',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tap to play/pause
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleVideoPlayback,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoBackground() {
    if (_isVideoLoading) {
      // Loading state with animated gradient
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8B5CF6),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                'Loading hologram experience...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.isMobile(context) ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isVideoInitialized) {
      // Error state or fallback
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8B5CF6),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: ResponsiveHelper.isMobile(context) ? 36 : 48,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 12),
              Text(
                'Hologram Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to retry loading',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Video player
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _videoController.value.size.width,
        height: _videoController.value.size.height,
        child: VideoPlayer(_videoController),
      ),
    );
  }

  Widget _buildWelcomeHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sawubona! Welcome to the Hologram Hub',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Discover Heritage through Holograms',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                  const Color(0xFF3B82F6).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF8B5CF6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ubuntu Philosophy in 3D',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.isMobile(context) ? 13 : 14,
                        ),
                      ),
                      Text(
                        '"I am because we are" - Experience through holographic immersion',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.isMobile(context) ? 11 : 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 60),
        child: CustomSearchBar(
          controller: _searchController,
          onSubmitted: _performSearch,
          hintText: 'Search hologram experiences, heritage tours...',
          suggestions: const [
            'Hologram Shows',
            'Ubuntu Philosophy Experience',
            'KZN Heritage Tours',
            'Cultural Immersion',
            'Traditional Ceremonies',
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final actions = [
      {
        'title': 'Book Hub Visit',
        'subtitle': 'Hologram Experience',
        'icon': Icons.theater_comedy_outlined,
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFFA855F7)],
        'route': '/bookings',
      },
      {
        'title': 'Heritage Tours',
        'subtitle': 'Cultural Immersion',
        'icon': Icons.account_balance_outlined,
        'gradient': [const Color(0xFF059669), const Color(0xFF10B981)],
        'route': '/explore',
      },
      {
        'title': 'Marketplace',
        'subtitle': 'KZN Artisans',
        'icon': Icons.shopping_bag_outlined,
        'gradient': [const Color(0xFFDC2626), const Color(0xFFF87171)],
        'route': '/marketplace',
      },

    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          if (ResponsiveHelper.isDesktop(context))
            _buildDesktopQuickActions(actions)
          else
            _buildMobileQuickActions(actions),
        ],
      ),
    );
  }

  Widget _buildDesktopQuickActions(List<Map<String, dynamic>> actions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => context.push(action['route']),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: action['gradient'] as List<Color>,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (action['gradient'] as List<Color>).first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      action['icon'],
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          action['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          action['subtitle'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.8),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildMobileQuickActions(List<Map<String, dynamic>> actions) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.isMobile(context) ? 2 : 4;
        final childAspectRatio = ResponsiveHelper.isMobile(context) ? 1.0 : 1.2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: actions.map((action) => _buildQuickActionCard(action)).toList(),
        );
      },
    );
  }

  Widget _buildQuickActionCard(Map<String, dynamic> action) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (action['gradient'] as List<Color>).first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push(action['route']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: action['gradient'] as List<Color>,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action['icon'],
                      color: Colors.white,
                      size: ResponsiveHelper.isMobile(context) ? 20 : 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      action['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.isMobile(context) ? 13 : 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      action['subtitle'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedExperiencesSection(HomeProvider provider) {
    final experiences = _getFallbackExperiences();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Featured Hologram Experiences',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.isMobile(context) ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.push('/explore'),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 180 : 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              final experience = experiences[index];
              return Container(
                width: ResponsiveHelper.isMobile(context) ? 240 : 280,
                margin: const EdgeInsets.only(right: 12),
                child: _buildFeaturedExperienceCard(experience),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKZNMarketplaceSection(HomeProvider provider) {
    final packages = _getFallbackMarketplaceItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag, color: Colors.purple),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'KZN Marketplace',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.isMobile(context) ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push('/marketplace'),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Supporting 19.3% informal sector with authentic cultural products',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 11 : 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 220 : 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return Container(
                width: ResponsiveHelper.isMobile(context) ? 200 : 240,
                margin: const EdgeInsets.only(right: 12),
                child: ARPackageCard(
                  package: package,
                  onTap: () => context.push('/marketplace'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCulturalHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Cultural Highlights',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 160 : 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: ResponsiveHelper.isMobile(context) ? 160 : 200,
                margin: const EdgeInsets.only(right: 12),
                child: _buildCulturalHighlightCard(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recommended for You',
            style: TextStyle(
              fontSize: ResponsiveHelper.isMobile(context) ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: ResponsiveHelper.isMobile(context) ? 150 : 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: ResponsiveHelper.isMobile(context) ? 220 : 250,
                margin: const EdgeInsets.only(right: 12),
                child: _buildRecommendationCard(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCulturalHighlightCard(int index) {
    final highlights = [
      {
        'title': 'Ubuntu Philosophy',
        'subtitle': 'Community Connection',
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFFA855F7)],
        'icon': Icons.diversity_3,
      },
      {
        'title': 'Zulu Traditions',
        'subtitle': 'Ancient Wisdom',
        'gradient': [const Color(0xFF059669), const Color(0xFF10B981)],
        'icon': Icons.account_balance,
      },
      {
        'title': 'Music & Dance',
        'subtitle': 'Cultural Expression',
        'gradient': [const Color(0xFFDC2626), const Color(0xFFF87171)],
        'icon': Icons.music_note,
      },
      {
        'title': 'Oral History',
        'subtitle': 'Stories of Generations',
        'gradient': [const Color(0xFFFF6B35), const Color(0xFFFF8C69)],
        'icon': Icons.record_voice_over,
      },
    ];

    final highlight = highlights[index];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/explore'),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: highlight['gradient'] as List<Color>,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 12 : 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    highlight['icon'] as IconData,
                    color: Colors.white,
                    size: ResponsiveHelper.isMobile(context) ? 24 : 32,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.isMobile(context) ? 8 : 16),
                Text(
                  highlight['title'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ResponsiveHelper.isMobile(context) ? 4 : 8),
                Text(
                  highlight['subtitle'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(int index) {
    final recommendations = [
      {
        'title': 'Ubuntu Experience Package',
        'subtitle': 'Complete cultural immersion with hologram guides',
        'price': 'R 450',
        'rating': 4.8,
        'type': 'Premium Experience',
      },
      {
        'title': 'Family Heritage Tour',
        'subtitle': 'Kid-friendly holographic storytelling',
        'price': 'R 320',
        'rating': 4.9,
        'type': 'Family Package',
      },
      {
        'title': 'Student Discovery Pass',
        'subtitle': 'Educational hologram experiences',
        'price': 'R 180',
        'rating': 4.7,
        'type': 'Student Discount',
      },
    ];

    final recommendation = recommendations[index];

    return Card(
      child: InkWell(
        onTap: () => context.push('/explore'),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  recommendation['type'] as String,
                  style: TextStyle(
                    color: const Color(0xFF8B5CF6),
                    fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.isMobile(context) ? 6 : 8),
              Text(
                recommendation['title'] as String,
                style: TextStyle(
                  fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: ResponsiveHelper.isMobile(context) ? 3 : 4),
              Flexible(
                child: Text(
                  recommendation['subtitle'] as String,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    recommendation['price'] as String,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.isMobile(context) ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: ResponsiveHelper.isMobile(context) ? 14 : 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${recommendation['rating']}',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedExperienceCard(Map<String, dynamic> experience) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/experience/${experience['id']}', extra: experience),
        child: Stack(
          children: [
            Container(
              height: ResponsiveHelper.isMobile(context) ? 180 : 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF3B82F6),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: ResponsiveHelper.isMobile(context) ? 36 : 48,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: ResponsiveHelper.isMobile(context) ? 180 : 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    experience['title'] ?? 'Hologram Experience',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.isMobile(context) ? 14 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveHelper.isMobile(context) ? 2 : 4),
                  Text(
                    experience['location'] ?? 'KZN Heritage Hub',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: ResponsiveHelper.isMobile(context) ? 11 : 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveHelper.isMobile(context) ? 6 : 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isMobile(context) ? 6 : 8,
                          vertical: ResponsiveHelper.isMobile(context) ? 3 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'R ${experience['price'] ?? '261'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: ResponsiveHelper.isMobile(context) ? 12 : 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${experience['rating'] ?? 4.8}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActivityItem(
          'Booked Ubuntu Experience',
          '2 hours ago',
          Icons.check_circle,
          Colors.green,
        ),
        _buildActivityItem(
          'Viewed Heritage Tours',
          '1 day ago',
          Icons.visibility,
          Colors.blue,
        ),
        _buildActivityItem(
          'Marketplace Purchase',
          '3 days ago',
          Icons.shopping_bag,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<Map<String, dynamic>> _getFallbackExperiences() {
    return [
      {
        'id': '1',
        'title': 'Ubuntu Philosophy Experience',
        'location': 'Main Hologram Theater',
        'price': '261',
        'rating': 4.8,
        'type': 'Cultural',
        'duration': '45 mins',
      },
      {
        'id': '2',
        'title': 'Zulu Heritage Journey',
        'location': 'Heritage Hall',
        'price': '209',
        'rating': 4.9,
        'type': 'Historical',
        'duration': '60 mins',
      },
      {
        'id': '3',
        'title': 'Traditional Ceremonies',
        'location': 'Ceremony Space',
        'price': '222',
        'rating': 4.7,
        'type': 'Cultural',
        'duration': '50 mins',
      },
      {
        'id': '4',
        'title': 'Children\'s Story Circle',
        'location': 'Kids Zone',
        'price': '100',
        'rating': 4.9,
        'type': 'Family',
        'duration': '30 mins',
      },
    ];
  }

  List<Map<String, dynamic>> _getFallbackMarketplaceItems() {
    return [
      {
        'id': '1',
        'title': 'Traditional Beadwork',
        'description': 'Handcrafted Zulu beadwork by local artisans',
        'price': 'R 125',
        'artisan': 'Nomsa Mbeki',
        'type': 'Cultural',
        'rating': 4.8,
        'image': 'assets/images/beadwork.jpg',
      },
      {
        'id': '2',
        'title': 'Clay Pottery Set',
        'description': 'Traditional pottery with modern touches',
        'price': 'R 180',
        'artisan': 'Sipho Dlamini',
        'type': 'Pottery',
        'rating': 4.7,
        'image': 'assets/images/pottery.jpg',
      },
      {
        'id': '3',
        'title': 'Woven Baskets',
        'description': 'Beautifully woven grass baskets',
        'price': 'R 95',
        'artisan': 'Thandi Nkomo',
        'type': 'Textiles',
        'rating': 4.9,
        'image': 'assets/images/baskets.jpg',
      },
      {
        'id': '4',
        'title': 'Wooden Sculptures',
        'description': 'Hand-carved traditional figures',
        'price': 'R 220',
        'artisan': 'Mandla Zulu',
        'type': 'Sculpture',
        'rating': 4.8,
        'image': 'assets/images/sculptures.jpg',
      },
    ];
  }

  void _performSearch(String query) {
    // Implement search functionality
    context.push('/explore', extra: {'query': query});
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

  void _playWelcomeVideo() {
    // Navigate to full-screen video player or show video dialog
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              if (_isVideoInitialized)
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              if (_isVideoInitialized)
                Center(
                  child: IconButton(
                    onPressed: _toggleVideoPlayback,
                    icon: Icon(
                      _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
