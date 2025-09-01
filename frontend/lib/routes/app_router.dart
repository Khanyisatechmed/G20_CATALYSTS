// routes/app_router.dart
import 'package:frontend/features/bookings/screens/booking_detail_screen.dart';
import 'package:frontend/features/explore/screens/explore_sceen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/welcome_screen.dart';
import 'package:frontend/features/auth/login_screen.dart';
import 'package:frontend/features/auth/signup_screen.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/features/bookings/screens/bookings_screen.dart';
import 'package:frontend/features/bookings/screens/destination_detail_screen.dart';
import 'package:frontend/features/marketplace/screens/marketplace_screen.dart';
import 'package:frontend/features/marketplace/screens/product_detail_screen.dart' hide SizedBox;
import 'package:frontend/features/accommodation/screens/accommodation_screen.dart';
import 'package:frontend/features/accommodation/screens/accommodation_booking_screen.dart';
import 'package:frontend/features/profile/screens/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
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

      // Main App Routes
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
          final destinationData = state.extra as Map<String, dynamic>? ?? {};
          final destinationId = state.pathParameters['id'] ?? '';
          return DestinationDetailScreen(
            destination: destinationData,
            destinationId: destinationId,
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
          final bookingData = state.extra as Map<String, dynamic>? ?? {};
          final bookingId = state.pathParameters['id'] ?? '';
          return BookingDetailScreen(
            booking: bookingData,
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
          final productData = state.extra as Map<String, dynamic>? ?? {};
          final productId = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(
            product: productData,
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
          final accommodationData = state.extra as Map<String, dynamic>? ?? {};
          final accommodationId = state.pathParameters['id'] ?? '';
          return AccommodationBookingScreen(
            accommodation: accommodationData,
            accommodationId: accommodationId,
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
        builder: (context, state) => const Scaffold(
          appBar: null,
          body: Center(child: Text('Settings Screen - To be implemented')),
        ),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const Scaffold(
          appBar: null,
          body: Center(child: Text('Notifications Screen - To be implemented')),
        ),
      ),
      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => const Scaffold(
          appBar: null,
          body: Center(child: Text('Support Screen - To be implemented')),
        ),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const Scaffold(
          appBar: null,
          body: Center(child: Text('Privacy Screen - To be implemented')),
        ),
      ),
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => const Scaffold(
          appBar: null,
          body: Center(child: Text('Payments Screen - To be implemented')),
        ),
      ),
    ],
    redirect: (context, state) {
      // Add authentication logic here if needed
      // For now, allow all routes
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The page you\'re looking for doesn\'t exist.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
