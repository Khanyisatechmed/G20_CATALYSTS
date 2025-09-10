// features/marketplace/widgets/cultural_collections.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import '../../../core/utils/responsive_helper.dart';

class CulturalCollections extends StatelessWidget {
  const CulturalCollections({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildCollectionsList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.auto_stories,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        const Text(
          'Cultural Collections',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            // Navigate to full collections view
          },
          child: const Text('View All'),
        ),
      ],
    );
  }

  Widget _buildCollectionsList(BuildContext context) {
    final collections = [
      {
        'id': 'zulu_heritage',
        'name': 'Zulu Heritage',
        'description': 'Traditional Zulu crafts and cultural items',
        'icon': Icons.account_balance,
        'color': Colors.orange,
        'itemCount': 12,
      },
      {
        'id': 'beadwork',
        'name': 'Beadwork',
        'description': 'Intricate beadwork jewelry and accessories',
        'icon': Icons.diamond,
        'color': Colors.purple,
        'itemCount': 8,
      },
      {
        'id': 'pottery',
        'name': 'Traditional Pottery',
        'description': 'Handcrafted pottery from local artisans',
        'icon': Icons.emoji_objects,
        'color': Colors.brown,
        'itemCount': 6,
      },
    ];

    if (ResponsiveHelper.isMobile(context)) {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: collections.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              margin: EdgeInsets.only(right: index < collections.length - 1 ? 16 : 0),
              child: _buildCollectionCard(context, collections[index]),
            );
          },
        ),
      );
    }

    return Row(
      children: collections.map((collection) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildCollectionCard(context, collection),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCollectionCard(BuildContext context, Map<String, dynamic> collection) {
    return GestureDetector(
      onTap: () => _onCollectionTap(context, collection),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (collection['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (collection['color'] as Color).withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  collection['icon'] as IconData,
                  color: collection['color'] as Color,
                  size: 24,
                ),
                const Spacer(),
                Text(
                  '${collection['itemCount']} items',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              collection['name'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              collection['description'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _onCollectionTap(BuildContext context, Map<String, dynamic> collection) {
    final provider = context.read<MarketplaceProvider>();
    // Filter by collection category
    provider.selectCategory(collection['id'] as String);

    // Navigate to marketplace with filter applied
    Navigator.pushNamed(context, '/marketplace');
  }
}
