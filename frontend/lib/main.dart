import 'package:flutter/material.dart';
import 'package:frontend/features/bookings/providers/bookings_provider.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app.dart';
import 'core/services/api_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/explore/providers/explore_provider.dart'; // Fixed: was bookings_provider
import 'features/marketplace/providers/marketplace_provider.dart';
import 'features/accommodation/providers/accommodation_provider.dart';
import 'features/profile/providers/profile_provider.dart';

void main() {
  usePathUrlStrategy(); // Use path-based URLs for web
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core services
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),

        // Auth provider - foundation for other providers
        ChangeNotifierProxyProvider<ApiService, AuthProvider>(
          create: (context) => AuthProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? AuthProvider(apiService),
        ),

        // Home provider
        ChangeNotifierProxyProvider<ApiService, HomeProvider>(
          create: (context) => HomeProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? HomeProvider(apiService),
        ),

        // Explore provider
        ChangeNotifierProvider<ExploreProvider>(
          create: (context) => ExploreProvider(),
        ),

        // Booking provider - Fixed: BookingProvider instead of BookingsProvider
        ChangeNotifierProvider<BookingProvider>(
          create: (context) => BookingProvider(
            context.read<ApiService>(),
            context.read<AuthProvider>(),
          ),
        ),

        // Marketplace provider
        ChangeNotifierProvider<MarketplaceProvider>(
          create: (context) => MarketplaceProvider(
            context.read<ApiService>(),
          ),
        ),

        // Accommodation provider
        ChangeNotifierProvider<AccommodationProvider>(
          create: (context) => AccommodationProvider(
            context.read<ApiService>(),
          ),
        ),

        // Profile provider
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(
            context.read<ApiService>(),
          ),
        ),
      ],
      child: const UbuntuDestinationsApp(),
    );
  }
}
