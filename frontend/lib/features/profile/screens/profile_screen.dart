import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../shared/widgets/custom_bottom_nav.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/profile_stats.dart';
import '../widgets/settings_tile.dart';
import '../widgets/interest_chip.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadUserProfile();
    });
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
          ? const CustomBottomNavigation(currentIndex: 4)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Profile',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.isMobile(context) ? 24 : 28,
        ),
      ),
      actions: ResponsiveHelper.isDesktop(context) ? [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit, color: Colors.black87),
        ),
        IconButton(
          onPressed: () => _showLogoutDialog(),
          icon: const Icon(Icons.logout, color: Colors.black87),
        ),
        const SizedBox(width: 16),
      ] : [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileStats(),
          const SizedBox(height: 24),
          _buildInterestsSection(),
          const SizedBox(height: 24),
          _buildSettingsSection(),
          const SizedBox(height: 100), // Bottom navigation space
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: _buildProfileStats()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildInterestsSection()),
                ],
              ),
              const SizedBox(height: 32),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar
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
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildProfileStats(),
              const Spacer(),
              _buildQuickActions(),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: SingleChildScrollView(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    _buildInterestsSection(),
                    const SizedBox(height: 32),
                    _buildSettingsSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
