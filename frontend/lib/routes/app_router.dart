// routes/app_router.dart - FINAL FIXED VERSION
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

      // Destination detail route
      GoRoute(
        path: '/destination/:id',
        name: 'destination-detail',
        builder: (context, state) {
          final destinationData = state.extra as Map<String, dynamic>?;
          final destinationId = state.pathParameters['id'] ?? '';
          return DestinationDetailScreen(
            destination: destinationData ?? {
              'id': destinationId,
              'name': 'Wanders Destination',
              'location': 'KwaZulu-Natal, South Africa',
              'description': 'Experience authentic Wanders culture and heritage',
              'images': [],
              'rating': 4.5,
              'price': 150,
              'currency': 'ZAR',
            },
            destinationId: destinationId,
          );
        },
      ),

      GoRoute(
        path: '/bookings',
        name: 'bookings',
        builder: (context, state) => const BookingsScreen(),
      ),

      // Booking detail route
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
              'title': 'Wanders Experience',
              'date': DateTime.now().toIso8601String(),
              'status': 'confirmed',
              'total_amount': 150,
              'currency': 'ZAR',
            },
            bookingId: bookingId,
          );
        },
      ),

      // Marketplace Routes
      GoRoute(
        path: '/marketplace',
        name: 'marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),

      // Product detail route
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productData = state.extra as Map<String, dynamic>?;
          final productId = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(
            product: productData ?? {
              'id': productId,
              'title': 'Wanders Craft Item',
              'price': 200,
              'currency': 'ZAR',
              'isInStock': true,
              'artisan': 'Local Artisan',
              'category': 'crafts',
              'description': 'Beautiful handcrafted item representing Wanders culture',
              'images': [],
              'rating': 4.5,
              'reviewCount': 10,
              'location': 'KZN, South Africa',
              'hasAR': true,
              'isFairTrade': true,
              'isUbuntu': true,
            },
            productId: productId,
          );
        },
      ),

      // Collection route
      GoRoute(
        path: '/collection/:id',
        name: 'collection',
        builder: (context, state) {
          final collectionId = state.pathParameters['id'] ?? '';
          return CollectionScreen(collectionId: collectionId);
        },
      ),

      // Vendor profile route
      GoRoute(
        path: '/vendor/:id',
        name: 'vendor-profile',
        builder: (context, state) {
          final vendorData = state.extra as Map<String, dynamic>?;
          final vendorId = state.pathParameters['id'] ?? '';
          return VendorProfileScreen(
            vendor: vendorData ?? {
              'id': vendorId,
              'name': 'Wanders Artisan',
              'bio': 'Traditional craftsperson preserving Wanders heritage',
              'location': 'KZN, South Africa',
              'verified': true,
              'rating': 4.8,
              'totalSales': 150,
              'yearsActive': 10,
              'specialty': 'Traditional crafts',
              'contactInfo': {
                'phone': '+27 58 713 0126',
                'email': 'artisan@ubuntu.co.za'
              },
              'paymentMethods': ['cash', 'snapscan', 'zapper'],
            },
          );
        },
      ),

      // Vendor products route
      GoRoute(
        path: '/vendor/:vendorId/products',
        name: 'vendor-products',
        builder: (context, state) {
          final vendorId = state.pathParameters['vendorId'] ?? '';
          return VendorProductsScreen(vendorId: vendorId);
        },
      ),

      // Cart route
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),

      // Wishlist route
      GoRoute(
        path: '/wishlist',
        name: 'wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),

      // Experience routes - FIXED: Using single consistent route
      GoRoute(
        path: '/experience/:id',
        name: 'experience-detail',
        builder: (context, state) {
          final experienceData = state.extra as Map<String, dynamic>?;
          final experienceId = state.pathParameters['id'] ?? '';
          return ExperienceDetailScreen(
            experience: experienceData ?? {
              'id': experienceId,
              'title': 'Wanders Cultural Experience',
              'description': 'Immersive cultural experience',
              'price': 380,
              'currency': 'ZAR',
              'duration': '4 hours',
              'maxParticipants': 20,
              'location': 'KZN, South Africa',
              'rating': 4.7,
              'reviewCount': 89,
            },
          );
        },
      ),

      // Experience booking route
      GoRoute(
        path: '/book-experience/:id',
        name: 'book-experience',
        builder: (context, state) {
          final experienceData = state.extra as Map<String, dynamic>?;
          final experienceId = state.pathParameters['id'] ?? '';
          return BookExperienceScreen(
            experience: experienceData ?? {
              'id': experienceId,
              'title': 'Wanders Cultural Experience',
              'price': 380,
              'currency': 'ZAR',
              'duration': '4 hours',
              'maxParticipants': 20,
              'location': 'KZN, South Africa',
            },
          );
        },
      ),

      // Accommodation Routes
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
              'name': 'Wanders Village Homestay',
              'location': 'KwaZulu-Natal, South Africa',
              'price': 120,
              'currency': 'ZAR',
              'maxGuests': 4,
              'bedrooms': 2,
              'bathrooms': 1,
              'features': ['Traditional meals', 'Cultural activities', 'WiFi'],
              'images': [],
              'rating': 4.8,
              'host': 'Mama Nomsa',
            },
            accommodationId: accommodationId,
          );
        },
      ),

      // Profile route
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
          context,
          'Settings',
          'Manage your account settings and preferences',
          Icons.settings,
        ),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => _buildPlaceholderScreen(
          context,
          'Notifications',
          'View your latest notifications and updates',
          Icons.notifications,
        ),
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => _buildPlaceholderScreen(
          context,
          'Support',
          'Get help and contact customer support',
          Icons.help_outline,
        ),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => _buildPlaceholderScreen(
          context,
          'Privacy Policy',
          'Read our privacy policy and terms of service',
          Icons.privacy_tip,
        ),
      ),
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => _buildPlaceholderScreen(
          context,
          'Payment Methods',
          'Manage your payment methods and billing',
          Icons.payment,
        ),
      ),
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        builder: (context, state) => _buildPlaceholderScreen(
          context,
          'My Reviews',
          'Reviews you have written',
          Icons.star,
        ),
      ),
    ],

    errorBuilder: (context, state) => _buildErrorScreen(context, state),
  );

  // Helper method to build placeholder screens
  static Widget _buildPlaceholderScreen(BuildContext context, String title, String description, IconData icon) {
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
              onPressed: () => context.go('/home'),
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
              'Let\'s get you back on track with your Wanders journey.',
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

// Placeholder screen classes - keeping the same as before
class CollectionScreen extends StatelessWidget {
  final String collectionId;
  const CollectionScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCollectionName(collectionId)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.collections, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              _getCollectionName(collectionId),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Collection screen coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              child: const Text('Back to Marketplace'),
            ),
          ],
        ),
      ),
    );
  }

  String _getCollectionName(String collectionId) {
    switch (collectionId) {
      case 'zulu_heritage': return 'Zulu Heritage Collection';
      case 'beadwork_masters': return 'Beadwork Masters';
      case 'drakensberg_crafts': return 'Drakensberg Mountain Crafts';
      case 'coastal_creations': return 'Coastal Creations';
      default: return 'Cultural Collection';
    }
  }
}

class VendorProfileScreen extends StatelessWidget {
  final Map<String, dynamic> vendor;
  const VendorProfileScreen({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vendor['name'] ?? 'Vendor Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              vendor['name'] ?? 'Wanders Vendor',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Vendor profile screen coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              child: const Text('Back to Marketplace'),
            ),
          ],
        ),
      ),
    );
  }
}

class VendorProductsScreen extends StatelessWidget {
  final String vendorId;
  const VendorProductsScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Products'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              'Vendor Products',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Vendor products screen coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              child: const Text('Back to Marketplace'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              'Shopping Cart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Cart screen coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              'My Wishlist',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Wishlist screen coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookExperienceScreen extends StatelessWidget {
  final Map<String, dynamic> experience;
  const BookExperienceScreen({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Experience'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tour, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              experience['title'] ?? 'Wanders Experience',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Experience booking coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              child: const Text('Back to Marketplace'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> experience;
  const ExperienceDetailScreen({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(experience['title'] ?? 'Experience'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              experience['title'] ?? 'Wanders Experience',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Experience details coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/marketplace'),
              child: const Text('Back to Marketplace'),
            ),
          ],
        ),
      ),
    );
  }
}
