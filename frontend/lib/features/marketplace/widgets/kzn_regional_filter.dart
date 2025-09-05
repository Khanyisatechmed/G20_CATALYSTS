// features/marketplace/widgets/kzn_regional_filter.dart - FINAL FIXED VERSION
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
      margin: const EdgeInsets.symmetric(vertical: 8), // Reduced margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // FIXED: Use min size
        children: [
          Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 20, // Smaller icon
                ),
                const SizedBox(width: 8),
                const Text(
                  'Explore KZN Regions',
                  style: TextStyle(
                    fontSize: 16, // Smaller font
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Reduced spacing
          SizedBox(
            height: 100, // Much smaller fixed height
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
      width: 85, // Smaller width
      margin: const EdgeInsets.only(right: 8), // Reduced margin
      child: InkWell(
        onTap: () => onRegionSelected(region['id']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          padding: const EdgeInsets.all(6), // Minimal padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // FIXED: Use min size
            children: [
              // Region icon - Very compact
              Container(
                width: 28, // Smaller icon container
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : region['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  region['icon'],
                  size: 16, // Much smaller icon
                  color: isSelected ? Colors.white : region['color'],
                ),
              ),
              const SizedBox(height: 4), // Minimal spacing

              // Region name - Very compact
              SizedBox(
                height: 24, // Fixed small height
                child: Center(
                  child: Text(
                    region['name'],
                    style: TextStyle(
                      fontSize: 9, // Very small font
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black87,
                      height: 1.0, // Tight line height
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Count badge - Very compact
              if (showCounts && count > 0)
                Container(
                  height: 16, // Fixed small height
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 8, // Very small font
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
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
      },
      {
        'id': 'durban',
        'name': 'eThekwini',
        'icon': Icons.location_city,
        'color': Colors.orange,
      },
      {
        'id': 'zululand',
        'name': 'Zululand',
        'icon': Icons.account_balance,
        'color': Colors.purple,
      },
      {
        'id': 'drakensberg',
        'name': 'Drakensberg',
        'icon': Icons.terrain,
        'color': Colors.green,
      },
      {
        'id': 'south_coast',
        'name': 'South Coast',
        'icon': Icons.waves,
        'color': Colors.cyan,
      },
      {
        'id': 'midlands',
        'name': 'Midlands',
        'icon': Icons.grass,
        'color': Colors.lightGreen,
      },
      {
        'id': 'north_coast',
        'name': 'North Coast',
        'icon': Icons.beach_access,
        'color': Colors.teal,
      },
      {
        'id': 'pietermaritzburg',
        'name': 'PMB',
        'icon': Icons.business,
        'color': Colors.indigo,
      },
      {
        'id': 'ukhahlamba',
        'name': 'uKhahlamba',
        'icon': Icons.landscape,
        'color': Colors.brown,
      },
    ];
  }
}
