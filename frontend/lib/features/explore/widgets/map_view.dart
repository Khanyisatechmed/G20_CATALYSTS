import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class MapView extends StatefulWidget {
  final List<Map<String, dynamic>> destinations;
  final Function(Map<String, dynamic>) onDestinationTap;
  final double initialZoom;
  final LatLng? initialCenter;

  const MapView({
    super.key,
    required this.destinations,
    required this.onDestinationTap,
    this.initialZoom = 10.0,
    this.initialCenter,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedDestination;
  bool _isLoading = true;

  // Default center (Johannesburg, South Africa)
  static const LatLng _defaultCenter = LatLng(-26.2041, 28.0473);

  // South African provinces approximate centers
  static const Map<String, LatLng> _provinceLocations = {
    'Mpumalanga': LatLng(-25.4753, 30.9688),
    'KwaZulu-Natal': LatLng(-28.5305, 30.8958),
    'Limpopo': LatLng(-23.4013, 29.4179),
    'Eastern Cape': LatLng(-32.2968, 26.4194),
    'Western Cape': LatLng(-33.9249, 18.4241),
    'Gauteng': LatLng(-26.2708, 28.1123),
    'Free State': LatLng(-28.4541, 26.7968),
    'Northern Cape': LatLng(-28.7282, 24.7499),
    'North West': LatLng(-25.8601, 25.6401),
  };

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinations != widget.destinations) {
      _updateMarkers();
    }
  }

  Future<void> _initializeMap() async {
    await _updateMarkers();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateMarkers() async {
    final Set<Marker> markers = {};

    for (int i = 0; i < widget.destinations.length; i++) {
      final destination = widget.destinations[i];
      final LatLng position = _getDestinationPosition(destination);

      final BitmapDescriptor markerIcon = await _createCustomMarker(
        destination['price']?.toString() ?? '150',
        _getMarkerColor(destination['category'] ?? 'All'),
      );

      markers.add(
        Marker(
          markerId: MarkerId('destination_$i'),
          position: position,
          icon: markerIcon,
          onTap: () => _onMarkerTapped(destination),
          infoWindow: InfoWindow(
            title: destination['title'] ?? 'Destination',
            snippet: 'ZAR ${destination['price'] ?? 150} • ${_formatRating(destination['rating'])}',
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  LatLng _getDestinationPosition(Map<String, dynamic> destination) {
    // If destination has coordinates, use them
    if (destination['latitude'] != null && destination['longitude'] != null) {
      return LatLng(
        destination['latitude'].toDouble(),
        destination['longitude'].toDouble(),
      );
    }

    // Otherwise, use province location with some randomization
    final province = destination['location'] ?? 'Gauteng';
    final baseLocation = _provinceLocations[province] ?? _defaultCenter;

    // Add some randomization to avoid overlapping markers
    final random = (destination['title']?.hashCode ?? 0) % 1000;
    final latOffset = (random % 200 - 100) / 10000.0; // ±0.01 degrees
    final lngOffset = ((random * 7) % 200 - 100) / 10000.0; // ±0.01 degrees

    return LatLng(
      baseLocation.latitude + latOffset,
      baseLocation.longitude + lngOffset,
    );
  }

  Color _getMarkerColor(String category) {
    switch (category.toLowerCase()) {
      case 'story telling':
        return Colors.purple;
      case 'arts':
        return Colors.orange;
      case 'guided tours':
        return Colors.green;
      case 'accommodation':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  Future<BitmapDescriptor> _createCustomMarker(String price, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 120;

    // Draw shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(
      const Offset(size / 2 + 2, size / 2 + 2),
      size / 3,
      shadowPaint,
    );

    // Draw main circle
    final Paint circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 3,
      circlePaint,
    );

    // Draw border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 3,
      borderPaint,
    );

    // Draw price text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'R$price',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );

    final ByteData? byteData = await markerAsImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  String _formatRating(dynamic rating) {
    if (rating == null) return '4.5⭐';
    final double ratingValue = rating.toDouble();
    return '${ratingValue.toStringAsFixed(1)}⭐';
  }

  void _onMarkerTapped(Map<String, dynamic> destination) {
    setState(() {
      _selectedDestination = destination;
    });

    // Show bottom sheet with destination details
    _showDestinationBottomSheet(destination);
  }

  void _showDestinationBottomSheet(Map<String, dynamic> destination) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        image: destination['imageUrl']?.isNotEmpty == true
                            ? DecorationImage(
                                image: NetworkImage(destination['imageUrl']),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: destination['imageUrl']?.isEmpty != false
                          ? const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),

                    const SizedBox(height: 12),

                    // Title and location
                    Text(
                      destination['title'] ?? 'Destination',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination['location'] ?? 'Location',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _formatRating(destination['rating']),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${destination['reviewCount'] ?? 0} reviews)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'ZAR ${destination['price'] ?? 150}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onDestinationTap(destination);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Set map style if needed
    _setMapStyle();
  }

  Future<void> _setMapStyle() async {
    try {
      final String style = await rootBundle.loadString('assets/map_style.json');
      _mapController?.setMapStyle(style);
    } catch (e) {
      // Map style file not found, use default style
      debugPrint('Map style not found, using default style');
    }
  }

  LatLng _getMapCenter() {
    if (widget.initialCenter != null) {
      return widget.initialCenter!;
    }

    if (widget.destinations.isEmpty) {
      return _defaultCenter;
    }

    // Calculate center based on destinations
    double totalLat = 0;
    double totalLng = 0;
    int validLocations = 0;

    for (final destination in widget.destinations) {
      final position = _getDestinationPosition(destination);
      totalLat += position.latitude;
      totalLng += position.longitude;
      validLocations++;
    }

    if (validLocations > 0) {
      return LatLng(
        totalLat / validLocations,
        totalLng / validLocations,
      );
    }

    return _defaultCenter;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _getMapCenter(),
            zoom: widget.initialZoom,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
        ),

        // Floating action buttons
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              // Recenter button
              FloatingActionButton.small(
                heroTag: "recenter",
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                onPressed: _recenterMap,
                child: const Icon(Icons.center_focus_strong),
              ),

              const SizedBox(height: 8),

              // Map type toggle
              FloatingActionButton.small(
                heroTag: "maptype",
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                onPressed: _toggleMapType,
                child: const Icon(Icons.layers),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _recenterMap() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _getMapCenter(),
            zoom: widget.initialZoom,
          ),
        ),
      );
    }
  }

  MapType _currentMapType = MapType.normal;

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
