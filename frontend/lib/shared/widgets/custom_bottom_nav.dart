// shared/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/responsive_helper.dart';

class CustomBottomNav extends StatelessWidget {
  final String currentRoute;

  const CustomBottomNav({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show bottom nav on desktop
    if (ResponsiveHelper.isDesktop(context)) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
               Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 16.0,
              tablet: 24.0,
            ),
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                route: '/home',
                isActive: currentRoute == '/home',
              ),
              _buildNavItem(
                context,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explore',
                route: '/explore',
                isActive: currentRoute == '/explore',
              ),
              _buildNavItem(
                context,
                icon: Icons.bookmark_outline,
                activeIcon: Icons.bookmark,
                label: 'Bookings',
                route: '/bookings',
                isActive: currentRoute == '/bookings',
              ),
              _buildNavItem(
                context,
                icon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag,
                label: 'Market',
                route: '/marketplace',
                isActive: currentRoute == '/marketplace',
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                route: '/profile',
                isActive: currentRoute == '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final inactiveColor = theme.unselectedWidgetColor;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          context.go(route);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? primaryColor : inactiveColor,
                size: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 24.0,
                  tablet: 26.0,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 12.0,
                  tablet: 13.0,
                ),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? primaryColor : inactiveColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative floating bottom navigation
class FloatingBottomNav extends StatelessWidget {
  final String currentRoute;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const FloatingBottomNav({
    super.key,
    required this.currentRoute,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show on desktop
    if (ResponsiveHelper.isDesktop(context)) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.cardColor;
    final selectedClr = selectedColor ?? theme.primaryColor;
    final unselectedClr = unselectedColor ?? theme.unselectedWidgetColor;

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFloatingNavItem(
              context,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              route: '/home',
              isActive: currentRoute == '/home',
              selectedColor: selectedClr,
              unselectedColor: unselectedClr,
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore,
              route: '/explore',
              isActive: currentRoute == '/explore',
              selectedColor: selectedClr,
              unselectedColor: unselectedClr,
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.bookmark_outline,
              activeIcon: Icons.bookmark,
              route: '/bookings',
              isActive: currentRoute == '/bookings',
              selectedColor: selectedClr,
              unselectedColor: unselectedClr,
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.shopping_bag_outlined,
              activeIcon: Icons.shopping_bag,
              route: '/marketplace',
              isActive: currentRoute == '/marketplace',
              selectedColor: selectedClr,
              unselectedColor: unselectedClr,
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              route: '/profile',
              isActive: currentRoute == '/profile',
              selectedColor: selectedClr,
              unselectedColor: unselectedClr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String route,
    required bool isActive,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          context.go(route);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isActive ? 50 : 40,
        height: isActive ? 50 : 40,
        decoration: BoxDecoration(
          color: isActive ? selectedColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isActive ? activeIcon : icon,
              key: ValueKey(isActive),
              color: isActive ? selectedColor : unselectedColor,
              size: isActive ? 28 : 24,
            ),
          ),
        ),
      ),
    );
  }
}

// Bottom navigation with badges
class BadgedBottomNav extends StatelessWidget {
  final String currentRoute;
  final Map<String, int> badges;

  const BadgedBottomNav({
    super.key,
    required this.currentRoute,
    this.badges = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return const SizedBox.shrink();
    }

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(),
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      items: [
        BottomNavigationBarItem(
          icon: _buildBadgedIcon(Icons.home_outlined, '/home'),
          activeIcon: _buildBadgedIcon(Icons.home, '/home'),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgedIcon(Icons.explore_outlined, '/explore'),
          activeIcon: _buildBadgedIcon(Icons.explore, '/explore'),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgedIcon(Icons.bookmark_outline, '/bookings'),
          activeIcon: _buildBadgedIcon(Icons.bookmark, '/bookings'),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgedIcon(Icons.shopping_bag_outlined, '/marketplace'),
          activeIcon: _buildBadgedIcon(Icons.shopping_bag, '/marketplace'),
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgedIcon(Icons.person_outline, '/profile'),
          activeIcon: _buildBadgedIcon(Icons.person, '/profile'),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildBadgedIcon(IconData icon, String route) {
    final badgeCount = badges[route] ?? 0;

    if (badgeCount == 0) {
      return Icon(icon);
    }

    return Stack(
      children: [
        Icon(icon),
        Positioned(
          right: 0,
          top: 0,
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
              badgeCount > 99 ? '99+' : badgeCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  int _getCurrentIndex() {
    switch (currentRoute) {
      case '/home':
        return 0;
      case '/explore':
        return 1;
      case '/bookings':
        return 2;
      case '/marketplace':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index) {
    // This would need to be implemented with context.go() in the parent widget
    // The parent widget should handle the navigation logic
  }
}
