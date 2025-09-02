// routes/app_router.dart
import 'package:frontend/features/bookings/screens/booking_detail_screen.dart';
import 'package:frontend/features/explore/screens/explore_sceen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/auth/welcome_screen.dart';
import 'package:frontend/features/auth/login_screen.dart';
import 'package:frontend/features/auth/signup_screen.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/features/bookings/screens/bookings_screen.dart';
import 'package:frontend/features/bookings/screens/destination_detail_screen.dart';
import 'package:frontend/features/marketplace/screens/marketplace_screen.dart';
import 'package:frontend/features/marketplace/screens/product_detail_screen.dart';
import 'package:frontend/features/accommodation/screens/accommodation_screen.dart';
import 'package:frontend/features/accommodation/screens/accommodation_booking_screen.dart';
import 'package:frontend/features/profile/screens/profile_screen.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome',
    debugLogDiagnostics: true,

    // Authentication redirect logic
    redirect: (BuildContext context, GoRouterState state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isAuthRoute = ['/welcome', '/login', '/signup'].contains(state.uri.toString());

      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && !isAuthRoute) {
        return '/welcome';
      }

      // If authenticated and on auth routes, redirect to home
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      // No redirect needed
      return null;
    },

    routes: [
      // Auth Routes
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // Main App Routes (Protected)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (context, state) => const ExploreScreen(),
      ),

      // Destination detail route (under bookings since that's where you have it)
      GoRoute(
        path: '/destination/:id',
        name: 'destination-detail',
        builder: (context, state) {
          final destinationData = state.extra as Map<String, dynamic>?;
          final destinationId = state.pathParameters['id'] ?? '';
          return DestinationDetailScreen(
            destination: destinationData ?? {
              'id': destinationId,
              'name': 'Ubuntu Destination',
              'location': 'South Africa',
              'description': 'Experience authentic Ubuntu culture',
              'images': [],
              'rating': 4.5,
              'price': 150,
              'currency': 'ZAR',
            }, destinationId: '',
          );
        },
      ),

      GoRoute(
        path: '/bookings',
        name: 'bookings',
        builder: (context, state) => const BookingsScreen(),
      ),

      // Booking detail route (under bookings as per your structure)
      GoRoute(
        path: '/booking/:id',
        name: 'booking-detail',
        builder: (context, state) {
          final bookingData = state.extra as Map<String, dynamic>?;
          final bookingId = state.pathParameters['id'] ?? '';
          return BookingDetailScreen(
            booking: bookingData ?? {
              'id': bookingId,
              'type': 'accommodation',
              'title': 'Ubuntu Experience',
              'date': DateTime.now().toIso8601String(),
              'status': 'confirmed',
              'total_amount': 150,
              'currency': 'ZAR',
            },
            bookingId: bookingId,
          );
        },
      ),

      GoRoute(
        path: '/marketplace',
        name: 'marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productData = state.extra as Map<String, dynamic>?;
          final productId = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(
            product: productData ?? {
              'id': productId,
              'title': 'Ubuntu Craft Item',
              'price': 200,
              'currency': 'ZAR',
              'isInStock': true,
              'artisan': 'Local Artisan',
              'category': 'Crafts',
              'description': 'Beautiful handcrafted item representing Ubuntu culture',
              'images': [],
              'rating': 4.5,
              'reviewCount': 10,
            },
            productId: productId,
          );
        },
      ),
      GoRoute(
        path: '/accommodation',
        name: 'accommodation',
        builder: (context, state) => const AccommodationScreen(),
      ),
      GoRoute(
        path: '/accommodation-booking/:id',
        name: 'accommodation-booking',
        builder: (context, state) {
          final accommodationData = state.extra as Map<String, dynamic>?;
          final accommodationId = state.pathParameters['id'] ?? '';
          return AccommodationBookingScreen(
            accommodation: accommodationData ?? {
              'id': accommodationId,
              'name': 'Ubuntu Village Homestay',
              'location': 'Eastern Cape, South Africa',
              'price': 120,
              'currency': 'ZAR',
              'maxGuests': 4,
              'bedrooms': 2,
              'bathrooms': 1,
              'features': ['Traditional meals', 'Cultural activities', 'WiFi'],
              'images': [],
              'rating': 4.8,
              'host': 'Mama Nomsa',
            }, accommodationId: '',
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Additional utility routes
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => _buildPlaceholderScreen(
          'Settings',
          'Manage your account settings and preferences',
          Icons.settings,
        ),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => _buildPlaceholderScreen(
          'Notifications',
          'View your latest notifications and updates',
          Icons.notifications,
        ),
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => _buildPlaceholderScreen(
          'Support',
          'Get help and contact customer support',
          Icons.help_outline,
        ),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => _buildPlaceholderScreen(
          'Privacy Policy',
          'Read our privacy policy and terms of service',
          Icons.privacy_tip,
        ),
      ),
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => _buildPlaceholderScreen(
          'Payment Methods',
          'Manage your payment methods and billing',
          Icons.payment,
        ),
      ),
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) => _buildPlaceholderScreen(
          'My Wishlist',
          'Your saved accommodations and experiences',
          Icons.favorite,
        ),
      ),
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        builder: (context, state) => _buildPlaceholderScreen(
          'My Reviews',
          'Reviews you have written',
          Icons.star,
        ),
      ),
    ],

    errorBuilder: (context, state) => _buildErrorScreen(context, state),
  );

  static BuildContext? get context => null;

  // Helper method to build placeholder screens
  static Widget _buildPlaceholderScreen(String title, String description, IconData icon) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => GoRouter.of(context!).go('/home'),
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced error screen
  static Widget _buildErrorScreen(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Oops! Page Not Found',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The page "${state.uri.toString()}" doesn\'t exist.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Let\'s get you back on track with your Ubuntu journey.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home),
                  label: const Text('Go Home'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
