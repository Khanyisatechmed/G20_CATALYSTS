// features/accommodation/widgets/accommodation_filter_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accommodation_provider.dart';

class AccommodationFilterSheet extends StatefulWidget {
  const AccommodationFilterSheet({super.key});

  @override
  State<AccommodationFilterSheet> createState() => _AccommodationFilterSheetState();
}

class _AccommodationFilterSheetState extends State<AccommodationFilterSheet> {
  late AccommodationProvider _provider;

  // Temporary filter values
  String _tempLocation = '';
  double _tempMinPrice = 0;
  double _tempMaxPrice = 5000;
  int _tempGuests = 1;
  List<String> _tempAmenities = [];
  String _tempPropertyType = '';

  @override
  void initState() {
    super.initState();
    _provider = context.read<AccommodationProvider>();
    _initializeTempValues();
  }

  void _initializeTempValues() {
    _tempLocation = _provider.selectedLocation;
    _tempMinPrice = _provider.minPrice;
    _tempMaxPrice = _provider.maxPrice;
    _tempGuests = _provider.guests;
    _tempAmenities = List.from(_provider.amenities);
    _tempPropertyType = _provider.propertyType;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildLocationSection(),
                      _buildDivider(),
                      _buildPriceSection(),
                      _buildDivider(),
                      _buildGuestsSection(),
                      _buildDivider(),
                      _buildPropertyTypeSection(),
                      _buildDivider(),
                      _buildAmenitiesSection(),
                      const SizedBox(height: 100), // Space for bottom buttons
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Filter Accommodations',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _resetFilters,
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: const Text(
              'Reset',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      height: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Location', subtitle: 'Choose your preferred province'),
        Consumer<AccommodationProvider>(
          builder: (context, provider, child) {
            final locations = provider.getUniqueLocations();
            return Column(
              children: [
                _buildLocationOption('All Locations', '', Icons.public),
                const SizedBox(height: 12),
                ...locations.map((location) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildLocationOption(location, location, Icons.location_on),
                )),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLocationOption(String label, String value, IconData icon) {
    final isSelected = _tempLocation == value;
    return InkWell(
      onTap: () {
        setState(() {
          _tempLocation = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.orange.withValues(alpha: 0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.orange : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.orange[800] : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.orange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Price Range', subtitle: 'Per night in South African Rand'),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriceDisplay('Min', _tempMinPrice),
                  Container(
                    width: 40,
                    height: 2,
                    color: Colors.orange,
                  ),
                  _buildPriceDisplay('Max', _tempMaxPrice),
                ],
              ),
              const SizedBox(height: 20),
              RangeSlider(
                values: RangeValues(_tempMinPrice, _tempMaxPrice),
                min: 0,
                max: 5000,
                divisions: 50,
                activeColor: Colors.orange,
                inactiveColor: Colors.grey[300],
                onChanged: (values) {
                  setState(() {
                    _tempMinPrice = values.start;
                    _tempMaxPrice = values.end;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'R5,000+',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceDisplay(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'R${value.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Guests', subtitle: 'How many people will be staying?'),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Number of guests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Maximum occupancy will be filtered',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _tempGuests > 1
                          ? () {
                              setState(() {
                                _tempGuests--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        '$_tempGuests',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _tempGuests < 12
                          ? () {
                              setState(() {
                                _tempGuests++;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.add),
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Property Type', subtitle: 'Choose your preferred accommodation style'),
        Consumer<AccommodationProvider>(
          builder: (context, provider, child) {
            final propertyTypes = provider.getUniquePropertyTypes();
            final typeIcons = {
              'Homestay': Icons.home,
              'Lodge': Icons.cabin,
              'Farm Stay': Icons.agriculture,
              'Guesthouse': Icons.house,
              'B&B': Icons.bed,
            };

            return Column(
              children: [
                _buildPropertyTypeOption('All Types', '', Icons.apps),
                const SizedBox(height: 12),
                ...propertyTypes.map((type) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPropertyTypeOption(
                    type,
                    type,
                    typeIcons[type] ?? Icons.location_city,
                  ),
                )),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPropertyTypeOption(String label, String value, IconData icon) {
    final isSelected = _tempPropertyType == value;
    return InkWell(
      onTap: () {
        setState(() {
          _tempPropertyType = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.orange.withValues(alpha: 0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.orange : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.orange[800] : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.orange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Amenities', subtitle: 'Select the facilities you need'),
        Consumer<AccommodationProvider>(
          builder: (context, provider, child) {
            final allAmenities = provider.getAllAmenities();
            final amenityIcons = {
              'WiFi': Icons.wifi,
              'Kitchen': Icons.kitchen,
              'Cultural Tours': Icons.tour,
              'Traditional Meals': Icons.restaurant,
              'Pool': Icons.pool,
              'Restaurant': Icons.local_dining,
              'Cultural Shows': Icons.theater_comedy,
              'Nature Walks': Icons.hiking,
              'Game Drives': Icons.directions_car,
              'Star Gazing': Icons.nights_stay,
              'Farm Tours': Icons.agriculture,
            };

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: allAmenities.map((amenity) => _buildAmenityChip(
                amenity,
                amenityIcons[amenity] ?? Icons.star,
              )).toList(),
            );
          },
        ),
        const SizedBox(height: 32),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildAmenityChip(String amenity, IconData icon) {
    final isSelected = _tempAmenities.contains(amenity);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _tempAmenities.remove(amenity);
          } else {
            _tempAmenities.add(amenity);
          }
        });
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              amenity,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _resetFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reset All',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Show Results',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _tempLocation = '';
      _tempMinPrice = 0;
      _tempMaxPrice = 5000;
      _tempGuests = 1;
      _tempAmenities.clear();
      _tempPropertyType = '';
    });
  }

  void _applyFilters() {
    _provider.setLocationFilter(_tempLocation);
    _provider.setPriceRange(_tempMinPrice, _tempMaxPrice);
    _provider.setGuestsFilter(_tempGuests);
    _provider.setPropertyTypeFilter(_tempPropertyType);
    _provider.setAmenitiesFilter(_tempAmenities);

    Navigator.of(context).pop();
  }
}
