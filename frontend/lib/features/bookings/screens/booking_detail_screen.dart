// features/bookings/screens/booking_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../core/utils/date_formatter.dart';
import '../widgets/status_badge.dart';

class BookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingDetailScreen({
    super.key,
    required this.booking,
    String? bookingId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayoutBuilder(
        mobile: (context, constraints) => _buildMobileLayout(context),
        tablet: (context, constraints) => _buildTabletLayout(context),
        desktop: (context, constraints) => _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookingHeader(context),
                const SizedBox(height: 24),
                _buildBookingInfo(context),
                const SizedBox(height: 24),
                if (_isHologramHubBooking()) _buildHologramHubDetails(context),
                if (_isHologramHubBooking()) const SizedBox(height: 24),
                _buildAccessibilityInfo(context),
                const SizedBox(height: 24),
                _buildPricingBreakdown(context),
                const SizedBox(height: 24),
                _buildActionButtons(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context),
        SliverToBoxAdapter(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildBookingHeader(context),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildBookingInfo(context),
                          const SizedBox(height: 24),
                          if (_isHologramHubBooking()) _buildHologramHubDetails(context),
                          if (_isHologramHubBooking()) const SizedBox(height: 24),
                          _buildAccessibilityInfo(context),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        children: [
                          _buildPricingBreakdown(context),
                          const SizedBox(height: 24),
                          _buildActionButtons(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left side - Image and basic info
        Expanded(
          flex: 2,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _getBookingImage(),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 32,
                  right: 32,
                  child: _buildBookingHeader(context, isDarkMode: true),
                ),
              ],
            ),
          ),
        ),
        // Right side - Detailed content
        Expanded(
          flex: 3,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(48),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingInfo(context),
                  const SizedBox(height: 32),
                  if (_isHologramHubBooking()) _buildHologramHubDetails(context),
                  if (_isHologramHubBooking()) const SizedBox(height: 32),
                  _buildAccessibilityInfo(context),
                  const SizedBox(height: 32),
                  _buildPricingBreakdown(context),
                  const SizedBox(height: 40),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _getBookingImage(),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider _getBookingImage() {
    if (_isHologramHubBooking()) {
      return const AssetImage('assets/images/hologram_hub.png');
    }

    if (booking['imageUrl'] != null && booking['imageUrl'].isNotEmpty) {
      return NetworkImage(booking['imageUrl']);
    }

    return const AssetImage('assets/images/default_experience.png');
  }

  Widget _buildBookingHeader(BuildContext context, {bool isDarkMode = false}) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.grey[600];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _getBookingTitle(),
                style: TextStyle(
                  fontSize: ResponsiveHelper.isMobile(context) ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            StatusBadge(status: booking['status'] ?? 'confirmed'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 20,
              color: subtitleColor,
            ),
            const SizedBox(width: 4),
            Text(
              booking['location'] ?? 'Cape Town, South Africa',
              style: TextStyle(
                fontSize: 16,
                color: subtitleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.2)
                : Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Booking Reference: ${booking['booking_reference'] ?? _generateBookingRef()}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Date',
                  _formatBookingDate(),
                  Icons.calendar_today,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Time',
                  booking['time'] ?? '10:00 AM',
                  Icons.schedule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Duration',
                  _getBookingDuration(),
                  Icons.timelapse,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Participants',
                  '${_getParticipantCount()}',
                  Icons.group,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHologramHubDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.view_in_ar,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hologram Hub Experience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Immerse yourself in cutting-edge holographic technology showcasing South African cultural heritage. Experience traditional stories, dances, and ceremonies through stunning 3D holograms.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureChip('3D Holograms', Icons.view_in_ar),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFeatureChip('Interactive Displays', Icons.touch_app),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFeatureChip('Cultural Stories', Icons.auto_stories),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFeatureChip('Multi-Language', Icons.language),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityInfo(BuildContext context) {
    final hasAccessibilityNeeds = booking['wheelchair_access'] == true ||
        booking['accessibility_requirements'] != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasAccessibilityNeeds
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.accessible,
                color: hasAccessibilityNeeds ? Colors.blue : Colors.grey[600],
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Accessibility Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (hasAccessibilityNeeds) ...[
            if (booking['wheelchair_access'] == true)
              _buildAccessibilityFeature(
                'Wheelchair Access Required',
                'Accessible entrance, pathways, and viewing areas provided',
                Icons.wheelchair_pickup,
                Colors.blue,
              ),
            if (booking['wheelchair_rental'] == true)
              _buildAccessibilityFeature(
                'Wheelchair Rental',
                'On-site wheelchair rental included in booking',
                Icons.event_seat,
                Colors.green,
              ),
            if (booking['accessible_parking'] == true)
              _buildAccessibilityFeature(
                'Accessible Parking',
                'Reserved accessible parking space',
                Icons.local_parking,
                Colors.orange,
              ),
            if (booking['accessibility_requirements'] != null)
              _buildAccessibilityFeature(
                'Special Requirements',
                booking['accessibility_requirements'],
                Icons.support,
                Colors.purple,
              ),
          ] else ...[
            Text(
              'This venue is fully accessible for differently-abled visitors:',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            _buildAccessibilityFeature(
              'Wheelchair Accessible',
              'Ramps, wide doorways, and accessible restrooms',
              Icons.accessible_forward,
              Colors.green,
            ),
            _buildAccessibilityFeature(
              'Audio Descriptions',
              'Available for visually impaired visitors',
              Icons.hearing,
              Colors.blue,
            ),
            _buildAccessibilityFeature(
              'Sign Language Support',
              'Upon request with advance notice',
              Icons.sign_language,
              Colors.orange,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccessibilityFeature(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingBreakdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildPricingItems(),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${booking['currency'] ?? 'ZAR'} ${_getTotalAmount()}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPricingItems() {
    List<Widget> items = [];
    final participants = _getParticipantCount();
    final basePrice = _getBasePrice();

    // Base ticket price
    items.add(_buildPricingItem(
      'Hologram Hub Tickets ($participants x ZAR $basePrice)',
      basePrice * participants,
    ));

    // Wheelchair rental if applicable
    if (booking['wheelchair_rental'] == true) {
      items.add(_buildPricingItem('Wheelchair Rental', 50.0));
    }

    // Accessibility support if applicable
    if (booking['accessibility_requirements'] != null) {
      items.add(_buildPricingItem('Accessibility Support', 100.0));
    }

    // Group discount if applicable
    if (participants >= 5) {
      final discount = (basePrice * participants * 0.1);
      items.add(_buildPricingItem('Group Discount (10%)', -discount, isDiscount: true));
    }

    return items;
  }

  Widget _buildPricingItem(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDiscount ? Colors.green : Colors.grey[700],
              ),
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}ZAR ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = booking['status'] ?? 'confirmed';

    return Column(
      children: [
        if (status == 'confirmed' || status == 'pending') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _modifyBooking(context),
              icon: const Icon(Icons.edit),
              label: const Text('Modify Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareBooking(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _cancelBooking(context),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _shareBooking(context),
              icon: const Icon(Icons.share),
              label: const Text('Share Booking'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
        if (status == 'completed') ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _rateExperience(context),
              icon: const Icon(Icons.star_rate),
              label: const Text('Rate Experience'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
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
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).primaryColor),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper methods
  bool _isHologramHubBooking() {
    return booking['type'] == 'hologram_hub' ||
           booking['experience_name']?.toLowerCase().contains('hologram') == true ||
           booking['title']?.toLowerCase().contains('hologram') == true;
  }

  String _getBookingTitle() {
    if (_isHologramHubBooking()) {
      return booking['title'] ?? 'Hologram Hub Cultural Experience';
    }
    return booking['accommodation_name'] ??
           booking['experience_name'] ??
           booking['title'] ??
           'Cultural Experience';
  }

  String _formatBookingDate() {
    final dateStr = booking['check_in_date'] ?? booking['date'];
    if (dateStr != null) {
      final date = DateTime.parse(dateStr);
      return DateFormatter.dayMonth(date);
    }
    return 'TBA';
  }

  String _getBookingDuration() {
    if (_isHologramHubBooking()) {
      return booking['duration'] ?? '90 minutes';
    }
    return booking['duration'] ?? '2 hours';
  }

  int _getParticipantCount() {
    return booking['participants'] ??
           booking['adults'] ??
           booking['guests'] ?? 1;
  }

  double _getBasePrice() {
    // Base price for Hologram Hub - update these values as needed
    return _isHologramHubBooking() ? 250.0 : 150.0;
  }

  double _getTotalAmount() {
    if (booking['total_amount'] != null) {
      return (booking['total_amount'] as num).toDouble();
    }

    // Calculate total if not provided
    final participants = _getParticipantCount();
    final basePrice = _getBasePrice();
    double total = basePrice * participants;

    // Add wheelchair rental
    if (booking['wheelchair_rental'] == true) {
      total += 50.0;
    }

    // Add accessibility support
    if (booking['accessibility_requirements'] != null) {
      total += 100.0;
    }

    // Apply group discount
    if (participants >= 5) {
      total *= 0.9; // 10% discount
    }

    return total;
  }

  String _generateBookingRef() {
    final id = booking['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    return 'HH${id.substring(id.length - 6)}';
  }

  // Action methods
  void _modifyBooking(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/modify-booking',
      arguments: booking,
    );
  }

  void _shareBooking(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing booking ${booking['booking_reference'] ?? 'details'}...'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _cancelBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel your ${_getBookingTitle()} booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle cancellation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _rateExperience(BuildContext context) {
    // Navigate to rating screen or show rating dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
