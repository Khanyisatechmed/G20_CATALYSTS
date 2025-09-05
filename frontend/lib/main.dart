// main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/bookings/providers/bookings_provider.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'routes/app_router.dart';
import 'core/services/api_service.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/explore/providers/explore_provider.dart';
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
          dispose: (_, service) => service.dispose(),
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
        ChangeNotifierProxyProvider2<ApiService, AuthProvider, BookingProvider>(
          create: (context) => BookingProvider(
            context.read<ApiService>(),
            context.read<AuthProvider>(),
          ),
          update: (context, apiService, authProvider, previous) =>
              previous ?? BookingProvider(apiService, authProvider),
        ),

        // Marketplace provider
        ChangeNotifierProxyProvider<ApiService, MarketplaceProvider>(
          create: (context) => MarketplaceProvider(
            context.read<ApiService>(),
          ),
          update: (context, apiService, previous) =>
              previous ?? MarketplaceProvider(apiService),
        ),

        // Accommodation provider
        ChangeNotifierProxyProvider<ApiService, AccommodationProvider>(
          create: (context) => AccommodationProvider(
            context.read<ApiService>(),
          ),
          update: (context, apiService, previous) =>
              previous ?? AccommodationProvider(apiService),
        ),

        // Profile provider
        ChangeNotifierProxyProvider<ApiService, ProfileProvider>(
          create: (context) => ProfileProvider(
            context.read<ApiService>(),
          ),
          update: (context, apiService, previous) =>
              previous ?? ProfileProvider(apiService),
        ),
      ],
      child: const UbuntuDestinationsApp(),
    );
  }
}

class UbuntuDestinationsApp extends StatelessWidget {
  const UbuntuDestinationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ubuntu Destinations',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',

        // App Bar Theme
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),

        // Button Themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Snack Bar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.primary,
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          actionTextColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // Progress Indicator Theme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade100,
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // List Tile Theme
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          dense: false,
        ),

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade300,
          thickness: 1,
          space: 1,
        ),

        // Icon Theme
        iconTheme: IconThemeData(
          color: Colors.grey.shade700,
          size: 24,
        ),

        // Primary Icon Theme
        primaryIconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),

        // Text Theme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),

        // Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.surface,
          error: AppColors.error,
        ),

        // Use Material 3
        useMaterial3: true,
      ),

      // Global error handling
      builder: (context, child) {
        // Global error widget
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return ErrorScreen(error: errorDetails.exception.toString());
        };

        // Return the child widget (router)
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

// Global error screen for critical errors
class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),

                // Error title
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Error message
                Text(
                  'We encountered an unexpected error. Please try restarting the app.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Technical details (only in debug mode)
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      error,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Colors.black54,
                      ),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Action button
                ElevatedButton.icon(
                  onPressed: () {
                    // In a real app, you might want to restart the app
                    // For now, we'll try to navigate to home
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart App'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
