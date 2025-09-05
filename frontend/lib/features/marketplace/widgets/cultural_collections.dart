// features/marketplace/widgets/cultural_collections.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';

class CulturalCollections extends StatelessWidget {
  final List<Map<String, dynamic>> collections;
  final Function(String) onCollectionTap;

  const CulturalCollections({
    super.key,
    required this.collections,
    required this.onCollectionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Row(
              children: [
                Icon(
                  Icons.auto_stories,
                  color: Colors.orange[700],
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cultural Collections',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Discover authentic KZN heritage through curated collections',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => onCollectionTap('all'),
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 200 : 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: ResponsiveHelper.getResponsivePadding(context),
              itemCount: collections.length,
              itemBuilder: (context, index) {
                final collection = collections[index];
                return _buildCollectionCard(context, collection);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, Map<String, dynamic> collection) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final cardWidth = isMobile ? 280.0 : 320.0;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => onCollectionTap(collection['id']),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: _buildCollectionImage(collection['imageUrl']),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection['title'] ?? 'Collection',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      collection['description'] ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${collection['itemCount'] ?? 0} items',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Heritage badge
              if (collection['isHeritage'] == true)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'HERITAGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: Colors.orange.withValues(alpha: 0.2),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.collections,
              size: 64,
              color: Colors.orange,
            ),
            SizedBox(height: 8),
            Text(
              'CULTURAL COLLECTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.orange.withValues(alpha: 0.2),
        child: const Icon(Icons.collections, size: 64, color: Colors.orange),
      ),
    );
  }
}

// Mock data for cultural collections
class CulturalCollectionsData {
  static List<Map<String, dynamic>> getCollections() {
    return [
      {
        'id': 'zulu_heritage',
        'title': 'Zulu Heritage Collection',
        'description': 'Traditional artifacts celebrating Zulu culture and history',
        'imageUrl': '',
        'itemCount': 23,
        'isHeritage': true,
        'region': 'zululand',
        'tags': ['zulu', 'traditional', 'heritage'],
      },
      {
        'id': 'beadwork_masters',
        'title': 'Beadwork Masters',
        'description': 'Intricate beadwork from renowned KZN artisans',
        'imageUrl': '',
        'itemCount': 18,
        'isHeritage': true,
        'region': 'all',
        'tags': ['beadwork', 'jewelry', 'traditional'],
      },
      {
        'id': 'drakensberg_crafts',
        'title': 'Drakensberg Mountain Crafts',
        'description': 'Handmade treasures from the mountain communities',
        'imageUrl': '',
        'itemCount': 15,
        'isHeritage': false,
        'region': 'drakensberg',
        'tags': ['mountain', 'pottery', 'textiles'],
      },
      {
        'id': 'coastal_creations',
        'title': 'Coastal Creations',
        'description': 'Ocean-inspired crafts from KZN coastal communities',
        'imageUrl': '',
        'itemCount': 12,
        'isHeritage': false,
        'region': 'south_coast',
        'tags': ['coastal', 'ocean', 'crafts'],
      },
    ];
  }
}
