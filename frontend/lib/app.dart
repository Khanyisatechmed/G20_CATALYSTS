import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'shared/themes/app_theme.dart';
import 'routes/app_router.dart';
import 'core/constants/app_strings.dart';

class UbuntuDestinationsApp extends StatelessWidget {
  const UbuntuDestinationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0, // Prevent text scaling issues
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
