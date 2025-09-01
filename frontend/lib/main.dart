import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app.dart';
import 'core/services/api_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/explore/providers/explore_provider.dart';
import 'features/bookings/providers/bookings_provider.dart';
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
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProxyProvider<ApiService, AuthProvider>(
          create: (context) => AuthProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? AuthProvider(apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, HomeProvider>(
          create: (context) => HomeProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? HomeProvider(apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, ExploreProvider>(
          create: (context) => ExploreProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? ExploreProvider(apiService),
        ),
        ChangeNotifierProxyProvider2<ApiService, AuthProvider, BookingsProvider>(
          create: (context) => BookingsProvider(
            context.read<ApiService>(),
            context.read<AuthProvider>(),
          ),
          update: (context, apiService, authProvider, previous) =>
              previous ?? BookingsProvider(apiService, authProvider),
        ),
        ChangeNotifierProxyProvider<ApiService, MarketplaceProvider>(
          create: (context) => MarketplaceProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? MarketplaceProvider(apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, AccommodationProvider>(
          create: (context) => AccommodationProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? AccommodationProvider(apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, ProfileProvider>(
          create: (context) => ProfileProvider(context.read<ApiService>()),
          update: (context, apiService, previous) =>
              previous ?? ProfileProvider(apiService),
        ),
      ],
      child: const UbuntuDestinationsApp(),
    );
  }
}
