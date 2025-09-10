// core/theme/marketplace_theme.dart
import 'package:flutter/material.dart';

class MarketplaceTheme {
  static const Color primaryBlue = Color(0xFF2E7CE4);
  static const Color primaryOrange = Color(0xFFFF8A65);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentGreen = Color(0xFF4CAF50);

  // Feature colors with better contrast
  static const Color arColor = Color(0xFF6A1B9A); // Deep purple for AR
  static const Color ubuntuColor = Color(0xFFFF6D00); // Deep orange for Ubuntu
  static const Color fairTradeColor = Color(0xFF2E7D32); // Deep green for Fair Trade
  static const Color handmadeColor = Color(0xFF1565C0); // Deep blue for Handmade
  static const Color inStockColor = Color(0xFF388E3C); // Deep green for In Stock
  static const Color outOfStockColor = Color(0xFFD32F2F); // Deep red for Out of Stock

  // Background colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color surfaceColor = Color(0xFFF5F5F5);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
      ),
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: lightBackground,

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // // Card theme - Fixed the parameter type issue
      // cardTheme: CardTheme(
      //   color: cardBackground,
      //   elevation: 2,
      //   shadowColor: Colors.black.withOpacity(0.1),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      // ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textLight,
          fontSize: 12,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryBlue.withOpacity(0.2),
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Badge colors with high contrast
  static Map<String, Color> get badgeColors => {
    'ar': arColor,
    'ubuntu': ubuntuColor,
    'fair_trade': fairTradeColor,
    'handmade': handmadeColor,
    'in_stock': inStockColor,
    'out_of_stock': outOfStockColor,
    'discount': const Color(0xFFE53935), // Bright red for discounts
    'new': const Color(0xFF43A047), // Green for new items
    'featured': const Color(0xFFFFB300), // Amber for featured items
  };

  // Category colors
  static Map<String, Color> get categoryColors => {
    'all': const Color(0xFF546E7A),
    'crafts': const Color(0xFF8D6E63),
    'textile': const Color(0xFF7986CB),
    'pottery': const Color(0xFFAED581),
    'food': const Color(0xFFFFB74D),
    'jewelry': const Color(0xFFBA68C8),
  };

  // Region colors
  static Map<String, Color> get regionColors => {
    'all': const Color(0xFF78909C),
    'durban': const Color(0xFF42A5F5),
    'zululand': const Color(0xFFFFCA28),
    'drakensberg': const Color(0xFF66BB6A),
    'south_coast': const Color(0xFF26C6DA),
    'north_coast': const Color(0xFF29B6F6),
    'midlands': const Color(0xFF9CCC65),
    'pietermaritzburg': const Color(0xFFEF5350),
    'ukhahlamba': const Color(0xFFAB47BC),
  };

  // Utility methods for better color contrast
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  static Color getBadgeColor(String badgeType) {
    return badgeColors[badgeType] ?? Colors.grey[600]!;
  }

  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? Colors.grey[600]!;
  }

  static Color getRegionColor(String region) {
    return regionColors[region] ?? Colors.grey[600]!;
  }

  // Helper for creating gradient backgrounds
  static BoxDecoration getFeatureGradient(String featureType) {
    Color primaryColor;
    Color secondaryColor;

    switch (featureType.toLowerCase()) {
      case 'ar':
        primaryColor = arColor;
        secondaryColor = arColor.withOpacity(0.7);
        break;
      case 'ubuntu':
        primaryColor = ubuntuColor;
        secondaryColor = ubuntuColor.withOpacity(0.7);
        break;
      case 'fair_trade':
        primaryColor = fairTradeColor;
        secondaryColor = fairTradeColor.withOpacity(0.7);
        break;
      default:
        primaryColor = Colors.grey[600]!;
        secondaryColor = Colors.grey[400]!;
    }

    return BoxDecoration(
      gradient: LinearGradient(
        colors: [primaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // Status indicator colors with high contrast
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_stock':
        return inStockColor;
      case 'out_of_stock':
        return outOfStockColor;
      case 'low_stock':
        return const Color(0xFFFF9800);
      case 'featured':
        return const Color(0xFFFFB300);
      case 'new':
        return const Color(0xFF43A047);
      default:
        return Colors.grey[600]!;
    }
  }

  // Enhanced badge styling
  static Container createBadge({
    required String text,
    required String type,
    double fontSize = 10,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
  }) {
    final backgroundColor = getBadgeColor(type);
    final textColor = getContrastingTextColor(backgroundColor);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Create themed icon with background
  static Widget createThemedIcon({
    required IconData icon,
    required String type,
    double size = 16,
  }) {
    final backgroundColor = getBadgeColor(type);
    final iconColor = getContrastingTextColor(backgroundColor);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }

  // Get themed colors for different states
  static Color getThemedColor({
    required String type,
    double opacity = 1.0,
    bool isSelected = false,
  }) {
    Color baseColor;

    switch (type.toLowerCase()) {
      case 'primary':
        baseColor = primaryBlue;
        break;
      case 'success':
        baseColor = inStockColor;
        break;
      case 'error':
        baseColor = outOfStockColor;
        break;
      case 'warning':
        baseColor = const Color(0xFFFF9800);
        break;
      case 'ar':
        baseColor = arColor;
        break;
      case 'ubuntu':
        baseColor = ubuntuColor;
        break;
      default:
        baseColor = Colors.grey[600]!;
    }

    if (isSelected) {
      baseColor = baseColor.lighten(0.1);
    }

    return baseColor.withOpacity(opacity);
  }
}

// Extension for additional color utilities
extension ColorExtensions on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color withAlpha(int alpha) {
    return Color.fromARGB(alpha, red, green, blue);
  }
}
