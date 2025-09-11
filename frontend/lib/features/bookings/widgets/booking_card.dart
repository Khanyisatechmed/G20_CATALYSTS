// widgets/booking_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/date_formatter.dart';
import 'status_badge.dart';

class BookingCard extends StatelessWidget {
  final String title;
  final String location;
  final DateTime date;
  final String time;
  final int participants;
  final double price;
  final String currency;
  final String status;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onModify;
  final bool isPast;
  final Map<String, dynamic>? bookingData;

  const BookingCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.participants,
    required this.price,
    required this.currency,
    required this.status,
    required this.imageUrl,
    required this.onTap,
    this.onCancel,
    this.onModify,
    required this.isPast,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final isHologramHub = _isHologramHubBooking();
    final hasAccessibilityFeatures = _hasAccessibilityFeatures();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image header with overlay
            if (imageUrl.isNotEmpty) _buildImageHeader(context, isHologramHub),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and status row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (isHologramHub) ...[
                                  Icon(
                                    Icons.view_in_ar,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: status),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Accessibility indicators
                  if (hasAccessibilityFeatures) ...[
                    _buildAccessibilityIndicators(context),
                    const SizedBox(height: 16),
                  ],

                  // Booking information
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Date',
                          DateFormatter.dayMonth(date),
                          Icons.calendar_today,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'Time',
                          time,
                          Icons.schedule,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          isHologramHub ? 'Duration' : 'Participants',
                          isHologramHub ? _getDuration() : participants.toString(),
                          isHologramHub ? Icons.timelapse : Icons.group,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'Price',
                          '$currency ${price.toInt()}',
                          Icons.monetization_on,
                        ),
                      ),
                    ],
                  ),

                  // Special features for Hologram Hub
                  if (isHologramHub) ...[
                    const SizedBox(height: 16),
                    _buildHologramHubFeatures(context),
                  ],

                  // Action buttons
                  if (onCancel != null || onModify != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (onModify != null) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onModify,
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Modify'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (onCancel != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onCancel,
                              icon: const Icon(Icons.cancel, size: 16),
                              label: const Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, bool isHologramHub) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        image: imageUrl.isNotEmpty
            ? DecorationImage(
                image: imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl) as ImageProvider
                    : AssetImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
        gradient: imageUrl.isEmpty
            ? LinearGradient(
                colors: isHologramHub
                    ? [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withValues(alpha: 0.7)]
                    : [Colors.grey[400]!, Colors.grey[600]!],
              )
            : null,
      ),
      child: Stack(
        children: [
          if (imageUrl.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),

          // Type indicator
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isHologramHub
                    ? Theme.of(context).primaryColor
                    : Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isHologramHub ? Icons.view_in_ar : Icons.explore,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isHologramHub ? 'AR Experience' : 'Cultural Tour',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Participants indicator for Hologram Hub
          if (isHologramHub)
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.group,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$participants',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityIndicators(BuildContext context) {
    List<Widget> indicators = [];

    if (bookingData?['wheelchair_access'] == true) {
      indicators.add(_buildAccessibilityChip(
        'Wheelchair Access',
        Icons.accessible,
        Colors.blue,
      ));
    }

    if (bookingData?['wheelchair_rental'] == true) {
      indicators.add(_buildAccessibilityChip(
        'Wheelchair Rental',
        Icons.wheelchair_pickup,
        Colors.green,
      ));
    }

    if (bookingData?['sign_language_interpreter'] == true) {
      indicators.add(_buildAccessibilityChip(
        'Sign Language',
        Icons.sign_language,
        Colors.purple,
      ));
    }

    if (bookingData?['audio_description'] == true) {
      indicators.add(_buildAccessibilityChip(
        'Audio Description',
        Icons.hearing,
        Colors.orange,
      ));
    }

    if (indicators.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.accessible_forward,
                size: 16,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 6),
              Text(
                'Accessibility Features',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: indicators,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHologramHubFeatures(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.view_in_ar,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Immersive Holographic Experience',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '3D Cultural Artifacts • Interactive Displays',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getDuration(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper methods
  bool _isHologramHubBooking() {
    return bookingData?['type'] == 'hologram_hub' ||
           title.toLowerCase().contains('hologram') ||
           bookingData?['experience_name']?.toLowerCase().contains('hologram') == true;
  }

  bool _hasAccessibilityFeatures() {
    return bookingData?['wheelchair_access'] == true ||
           bookingData?['wheelchair_rental'] == true ||
           bookingData?['sign_language_interpreter'] == true ||
           bookingData?['audio_description'] == true ||
           bookingData?['accessibility_requirements'] != null;
  }

  String _getDuration() {
    return bookingData?['duration'] ?? '90 min';
  }
}
