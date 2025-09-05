// features/marketplace/widgets/kzn_regional_filter.dart
import 'package:flutter/material.dart';
import '../../../core/utils/responsive_helper.dart';

class KZNRegionalFilter extends StatelessWidget {
  final String selectedRegion;
  final Function(String) onRegionSelected;
  final bool showCounts;
  final Map<String, int>? regionCounts;

  const KZNRegionalFilter({
    super.key,
    required this.selectedRegion,
    required this.onRegionSelected,
    this.showCounts = true,
    this.regionCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Explore KZN Regions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 160 : 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: ResponsiveHelper.getResponsivePadding(context),
              itemCount: _getRegions().length,
              itemBuilder: (context, index) {
                final region = _getRegions()[index];
                return _buildRegionCard(context, region);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionCard(BuildContext context, Map<String, dynamic> region) {
    final isSelected = selectedRegion == region['id'];
    final count = regionCounts?[region['id']] ?? 0;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: isSelected ? 6 : 2,
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: () => onRegionSelected(region['id']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Region icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : region['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    region['icon'],
                    size: 32,
                    color: isSelected ? Colors.white : region['color'],
                  ),
                ),
                const SizedBox(height: 12),
                // Region name
                Text(
                  region['name'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (showCounts && count > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count items',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getRegions() {
    return [
      {
        'id': 'all',
        'name': 'All KZN',
        'icon': Icons.map,
        'color': Colors.blue,
        'description': 'Explore all regions',
      },
      {
        'id': 'durban',
        'name': 'eThekwini Durban',
        'icon': Icons.location_city,
        'color': Colors.orange,
        'description': 'Urban coastal hub',
      },
      {
        'id': 'zululand',
        'name': 'Zululand',
        'icon': Icons.account_balance,
        'color': Colors.purple,
        'description': 'Rich Zulu heritage',
      },
      {
        'id': 'drakensberg',
        'name': 'Drakensberg',
        'icon': Icons.terrain,
        'color': Colors.green,
        'description': 'Mountain communities',
      },
      {
        'id': 'south_coast',
        'name': 'South Coast',
        'icon': Icons.waves,
        'color': Colors.cyan,
        'description': 'Coastal villages',
      },
      {
        'id': 'midlands',
        'name': 'Midlands',
        'icon': Icons.grass,
        'color': Colors.lightGreen,
        'description': 'Rolling hills',
      },
      {
        'id': 'north_coast',
        'name': 'North Coast',
        'icon': Icons.beach_access,
        'color': Colors.teal,
        'description': 'Coastal towns',
      },
      {
        'id': 'pietermaritzburg',
        'name': 'Pietermaritzburg',
        'icon': Icons.business,
        'color': Colors.indigo,
        'description': 'Capital city',
      },
      {
        'id': 'ukhahlamba',
        'name': 'uKhahlamba',
        'icon': Icons.landscape,
        'color': Colors.brown,
        'description': 'World heritage site',
      },
    ];
  }
}

// Expanded KZN Regional Information Widget
class KZNRegionInfoCard extends StatelessWidget {
  final String regionId;
  final VoidCallback? onExplore;

  const KZNRegionInfoCard({
    super.key,
    required this.regionId,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    final regionInfo = _getRegionInfo(regionId);

    if (regionInfo == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              regionInfo['color'].withValues(alpha: 0.1),
              regionInfo['color'].withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: regionInfo['color'].withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    regionInfo['icon'],
                    size: 32,
                    color: regionInfo['color'],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        regionInfo['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        regionInfo['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              regionInfo['fullDescription'],
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (regionInfo['highlights'] as List<String>).map((highlight) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: regionInfo['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: regionInfo['color'].withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    highlight,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: regionInfo['color'],
                    ),
                  ),
                );
              }).toList(),
            ),
            if (onExplore != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onExplore,
                  icon: const Icon(Icons.explore),
                  label: Text('Explore ${regionInfo['name']}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: regionInfo['color'],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, dynamic>? _getRegionInfo(String regionId) {
    final regions = {
      'durban': {
        'name': 'eThekwini Durban',
        'icon': Icons.location_city,
        'color': Colors.orange,
        'description': 'Urban coastal hub with vibrant markets',
        'fullDescription': 'Durban is KZN\'s largest city, home to vibrant markets like Warwick Triangle and Victoria Street Market. Experience Indian spice markets, Zulu street food, and urban township culture.',
        'highlights': ['Warwick Market', 'Indian Quarter', 'Beachfront', 'Township Tours'],
      },
      'zululand': {
        'name': 'Zululand',
        'icon': Icons.account_balance,
        'color': Colors.purple,
        'description': 'Heartland of Zulu culture and heritage',
        'fullDescription': 'The traditional homeland of the Zulu people, featuring cultural villages, battlefields, and authentic craft communities. Home to Shakaland and traditional beadwork artisans.',
        'highlights': ['Shakaland', 'Zulu Beadwork', 'Traditional Villages', 'Cultural Tours'],
      },
      'drakensberg': {
        'name': 'Drakensberg',
        'icon': Icons.terrain,
        'color': Colors.green,
        'description': 'Mountain communities and scenic crafts',
        'fullDescription': 'UNESCO World Heritage mountain range with San rock art and traditional mountain communities. Known for pottery, weaving, and mountain-inspired crafts.',
        'highlights': ['Rock Art', 'Mountain Pottery', 'Hiking Trails', 'Craft Villages'],
      },
      'south_coast': {
        'name': 'South Coast',
        'icon': Icons.waves,
        'color': Colors.cyan,
        'description': 'Coastal villages and ocean crafts',
        'fullDescription': 'Stretching from Durban to Port Edward, featuring coastal communities, fishing villages, and ocean-inspired crafts. Home to shell art and maritime traditions.',
        'highlights': ['Shell Crafts', 'Fishing Villages', 'Coastal Art', 'Maritime Heritage'],
      },
    };

    return regions[regionId];
  }
}
