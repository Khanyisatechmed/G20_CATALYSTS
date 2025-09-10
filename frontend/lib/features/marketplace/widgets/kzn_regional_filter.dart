// features/marketplace/widgets/kzn_regional_filter.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/marketplace_provider.dart';
import '../../../core/utils/responsive_helper.dart';

class KznRegionalFilter extends StatelessWidget {
  const KznRegionalFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildRegionChips(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        const Text(
          'KwaZulu-Natal Regions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRegionChips(BuildContext context, MarketplaceProvider provider) {
    final regions = _getRegionsWithInfo();
    final selectedRegion = provider.selectedRegion;

    if (ResponsiveHelper.isMobile(context)) {
      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: regions.length,
          itemBuilder: (context, index) {
            final region = regions[index];
            final isSelected = selectedRegion == region['id'];

            return Container(
              margin: EdgeInsets.only(right: index < regions.length - 1 ? 8 : 0),
              child: _buildRegionChip(context, region, isSelected, provider),
            );
          },
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: regions.map((region) {
        final isSelected = selectedRegion == region['id'];
        return _buildRegionChip(context, region, isSelected, provider);
      }).toList(),
    );
  }

  Widget _buildRegionChip(
    BuildContext context,
    Map<String, dynamic> region,
    bool isSelected,
    MarketplaceProvider provider
  ) {
    final productCount = provider.getRegionStats()[region['id']] ?? 0;

    return GestureDetector(
      onTap: () => provider.selectRegion(region['id'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              region['icon'] as IconData,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              region['name'] as String,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (productCount > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$productCount',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getRegionsWithInfo() {
    return [
      {
        'id': 'all',
        'name': 'All KZN',
        'icon': Icons.map,
        'description': 'All regions in KwaZulu-Natal',
      },
      {
        'id': 'durban',
        'name': 'eThekwini',
        'icon': Icons.location_city,
        'description': 'Durban metropolitan area',
      },
      {
        'id': 'zululand',
        'name': 'Zululand',
        'icon': Icons.account_balance,
        'description': 'Traditional Zulu heartland',
      },
      {
        'id': 'drakensberg',
        'name': 'Drakensberg',
        'icon': Icons.terrain,
        'description': 'Mountain region',
      },
      {
        'id': 'south_coast',
        'name': 'South Coast',
        'icon': Icons.waves,
        'description': 'Coastal region south of Durban',
      },
      {
        'id': 'midlands',
        'name': 'Midlands',
        'icon': Icons.grass,
        'description': 'Central KZN region',
      },
      {
        'id': 'north_coast',
        'name': 'North Coast',
        'icon': Icons.beach_access,
        'description': 'Coastal region north of Durban',
      },
      {
        'id': 'pietermaritzburg',
        'name': 'PMB',
        'icon': Icons.business,
        'description': 'Provincial capital',
      },
      {
        'id': 'ukhahlamba',
        'name': 'uKhahlamba',
        'icon': Icons.landscape,
        'description': 'World Heritage mountain region',
      },
    ];
  }
}
