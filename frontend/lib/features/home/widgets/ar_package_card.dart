// features/home/widgets/ar_package_card.dart - FIXED VERSION
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';

class ARPackageCard extends StatelessWidget {
  final Map<String, dynamic> package;
  final VoidCallback? onTap;

  const ARPackageCard({
    super.key,
    required this.package,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: isMobile ? 220 : 270, // Fixed height to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with fixed height
              Container(
                height: isMobile ? 120 : 150,
                width: double.infinity,
                child: _buildImageSection(context),
              ),
              // Content section with flexible height
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and description with constrained height
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package['title'] ?? 'Product',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              child: Text(
                                package['description'] ?? 'Description',
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom section with price and rating
                      Container(
                        height: isMobile ? 44 : 50, // Fixed height for bottom section
                        child: Column(
                          children: [
                            // Artisan info
                            if (package['artisan'] != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: isMobile ? 12 : 14,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      package['artisan'],
                                      style: TextStyle(
                                        fontSize: isMobile ? 10 : 11,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                            ],
                            // Price and rating row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Price
                                Flexible(
                                  child: Text(
                                    package['price'] ?? 'R 0',
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ),
                                // Rating
                                if (package['rating'] != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: isMobile ? 14 : 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${package['rating']}',
                                        style: TextStyle(
                                          fontSize: isMobile ? 11 : 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Stack(
      children: [
        // Background image or placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          child: package['image'] != null
              ? CachedNetworkImage(
                  imageUrl: package['image'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
        // Type badge
        if (package['type'] != null)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 6 : 8,
                vertical: isMobile ? 2 : 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                package['type'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 9 : 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5CF6),
            Color(0xFF3B82F6),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}
