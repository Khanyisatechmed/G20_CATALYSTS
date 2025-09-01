// core/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1200;

  // Screen size detection methods
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  // Get responsive values based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop(context)) {
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    } else if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  // Get responsive padding as EdgeInsetsGeometry
  static EdgeInsetsGeometry getResponsivePaddingGeometry(
    BuildContext context, {
    required EdgeInsetsGeometry mobile,
    EdgeInsetsGeometry? tablet,
    EdgeInsetsGeometry? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  // Get screen dimensions
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // Get responsive padding
  static EdgeInsetsGeometry getResponsivePadding(
    BuildContext context, {
    EdgeInsetsGeometry? mobile,
    EdgeInsetsGeometry? tablet,
    EdgeInsetsGeometry? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile ?? const EdgeInsets.all(16),
      tablet: tablet ?? const EdgeInsets.all(24),
      desktop: desktop ?? const EdgeInsets.all(32),
    );
  }

  // Get responsive margin
  static EdgeInsetsGeometry getResponsiveMargin(
    BuildContext context, {
    EdgeInsetsGeometry? mobile,
    EdgeInsetsGeometry? tablet,
    EdgeInsetsGeometry? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile ?? const EdgeInsets.all(8),
      tablet: tablet ?? const EdgeInsets.all(12),
      desktop: desktop ?? const EdgeInsets.all(16),
    );
  }

  // Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile ?? 14,
      tablet: tablet ?? 16,
      desktop: desktop ?? 18,
    );
  }

  // Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile ?? 20,
      tablet: tablet ?? 24,
      desktop: desktop ?? 28,
    );
  }

  // Get responsive border radius
  static BorderRadius getResponsiveBorderRadius(
    BuildContext context, {
    BorderRadius? mobile,
    BorderRadius? tablet,
    BorderRadius? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile ?? BorderRadius.circular(8),
      tablet: tablet ?? BorderRadius.circular(12),
      desktop: desktop ?? BorderRadius.circular(16),
    );
  }

  // Get number of columns for grid layouts
  static int getResponsiveGridColumns(
    BuildContext context, {
    int? mobile,
    int? tablet,
    int? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile ?? 1,
      tablet: tablet ?? 2,
      desktop: desktop ?? 3,
    );
  }

  // Get responsive cross axis count for grid
  static int getResponsiveCrossAxisCount(
    BuildContext context, {
    int? mobile,
    int? tablet,
    int? desktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile ?? 2,
      tablet: tablet ?? 3,
      desktop: desktop ?? 4,
    );
  }

  // Check if device has small screen (mobile)
  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < mobileBreakpoint;
  }

  // Check if device has medium screen (tablet)
  static bool isMediumScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  // Check if device has large screen (desktop)
  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) >= tabletBreakpoint;
  }

  // Get device orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  // Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }

  // Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == Orientation.portrait;
  }

  // Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Get device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    // ignore: deprecated_member_use
    return MediaQuery.of(context).textScaleFactor;
  }

  // Check if device has accessibility features enabled
  static bool isAccessibilityEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  // Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
    );
  }

  // Get responsive bottom navigation bar height
  static double getBottomNavBarHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 60.0,
      tablet: 70.0,
      desktop: 80.0,
    );
  }
}
