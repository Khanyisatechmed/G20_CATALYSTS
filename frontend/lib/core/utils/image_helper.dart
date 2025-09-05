// core/utils/image_helper.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageHelper {
  // Asset image paths
  static const String africaMapBackground = 'assets/images/africa_map_background.jpg';
  static const String ubuntuLogo = 'assets/images/ubuntu_logo.png';
  static const String defaultAvatar = 'assets/images/default_avatar.png';

  // Network image placeholder colors
  static const List<Color> gradientColors = [
    Color(0xFFE67E22), // Wandersorange
    Color(0xFFD68910), // Golden orange
    Color(0xFFE74C3C), // Red
    Color(0xFF8E44AD), // Purple
  ];

  // Safe asset image widget with fallback
  static Widget safeAssetImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? fallback,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? _buildFallbackContainer(width, height);
      },
    );
  }

  // Safe network image widget with cached loading
  static Widget safeNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? fallback,
  }) {
    if (imageUrl.isEmpty) {
      return fallback ?? _buildFallbackContainer(width, height);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ?? _buildLoadingPlaceholder(width, height),
      errorWidget: (context, url, error) =>
          fallback ?? _buildFallbackContainer(width, height),
    );
  }

  // Africa map background widget with gradient fallback
  static Widget africaMapBackgroundWidget({
    double? width,
    double? height,
    Widget? child,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColors[0].withOpacity(0.8),
            gradientColors[1].withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Try to load the actual image
          Positioned.fill(
            child: safeAssetImage(
              assetPath: africaMapBackground,
              width: width,
              height: height,
              fit: BoxFit.cover,
              fallback: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gradientColors[0].withOpacity(0.3),
                      gradientColors[1].withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.map,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          // Overlay content
          if (child != null) child,
        ],
      ),
    );
  }

  // Wanderslogo widget with text fallback
  static Widget ubuntuLogoWidget({
    double? width,
    double? height,
  }) {
    return safeAssetImage(
      assetPath: ubuntuLogo,
      width: width,
      height: height,
      fallback: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: gradientColors[0],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'U',
            style: TextStyle(
              fontSize: (height ?? 40) * 0.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Product image widget with category-specific fallbacks
  static Widget productImageWidget({
    required String imageUrl,
    required String category,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final categoryIcons = {
      'pottery': Icons.local_florist,
      'textiles': Icons.checkroom,
      'jewelry': Icons.diamond,
      'art': Icons.palette,
      'crafts': Icons.handyman,
    };

    final categoryColors = {
      'pottery': Colors.brown,
      'textiles': Colors.purple,
      'jewelry': Colors.amber,
      'art': Colors.blue,
      'crafts': Colors.green,
    };

    return safeNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fallback: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: categoryColors[category.toLowerCase()] ?? gradientColors[0],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          categoryIcons[category.toLowerCase()] ?? Icons.shopping_bag,
          size: (width ?? 100) * 0.4,
          color: Colors.white,
        ),
      ),
    );
  }

  // Destination image widget with location-specific fallbacks
  static Widget destinationImageWidget({
    required String imageUrl,
    required String location,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return safeNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fallback: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientColors[0], gradientColors[1]],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.place,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              location,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Private helper methods
  static Widget _buildFallbackContainer(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image,
        size: (width != null && height != null) ?
            (width < height ? width : height) * 0.3 : 40,
        color: Colors.grey[400],
      ),
    );
  }

  static Widget _buildLoadingPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
