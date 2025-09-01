// features/accommodation/screens/accommodation_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/bookings/providers/bookings_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/widgets/responsive_layout.dart';



class AccommodationBookingScreen extends StatefulWidget {
  final Map<String, dynamic> accommodation;

  const AccommodationBookingScreen({
    super.key,
    required this.accommodation, required String accommodationId,
  });

  @override
  State<AccommodationBookingScreen> createState() => _AccommodationBookingScreenState();
}

class _AccommodationBookingScreenState extends State<AccommodationBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _adults = 1;
  int _children = 0;
  int _currentImageIndex = 0;

  final TextEditingController _specialRequestsController = TextEditingController();
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestEmailController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _specialRequestsController.dispose();
    _guestNameController.dispose();
    _guestEmailController.dispose();
    _guestPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildAccommodationSummary(),
                const SizedBox(height: 24),
                _buildBookingForm(),
                const SizedBox(height: 24),
                _buildPricingSummary(),
                const SizedBox(height: 24),
                _buildBookingButton(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildAccommodationSummary(),
                      const SizedBox(height: 32),
                      _buildBookingForm(),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildPricingSummary(),
                      const SizedBox(height: 24),
                      _buildBookingButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildImageGallery(),
        ),
        Expanded(
          flex: 3,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  widget.accommodation['name'] ?? 'Book Accommodation',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                floating: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildAccommodationSummary(),
                            const SizedBox(height: 32),
                            _buildBookingForm(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildPricingSummary(),
                            const SizedBox(height: 24),
                            _buildBookingButton(),
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
      ],
    );
  }

  Widget _buildSliverAppBar() {
    final images = widget.accommodation['images'] as List<String>? ?? [];

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: images.isEmpty
            ? Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 64, color: Colors.grey),
              )
            : Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  if (images.length > 1) ...[
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = widget.accommodation['images'] as List<String>? ?? [];

    if (images.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, size: 64, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error, color: Colors.grey),
              ),
            );
          },
        ),
        if (images.length > 1) ...[
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == entry.key
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAccommodationSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.accommodation['name'] ?? 'Accommodation',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.accommodation['location'] ?? 'Location not specified',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildFeatureBadge(Icons.people, '${widget.accommodation['maxGuests'] ?? 2} guests'),
                const SizedBox(width: 12),
                _buildFeatureBadge(Icons.bed, '${widget.accommodation['bedrooms'] ?? 1} bedroom'),
                const SizedBox(width: 12),
                _buildFeatureBadge(Icons.bathroom, '${widget.accommodation['bathrooms'] ?? 1} bathroom'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.accommodation['description'] ?? 'Experience authentic Ubuntu hospitality in this beautiful accommodation.',
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Check-in and Check-out Dates
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Check-in',
                      selectedDate: _checkInDate,
                      onTap: () => _selectCheckInDate(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      label: 'Check-out',
                      selectedDate: _checkOutDate,
                      onTap: () => _selectCheckOutDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Guests
              Row(
                children: [
                  Expanded(
                    child: _buildGuestCounter('Adults', _adults, (value) {
                      setState(() => _adults = value);
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGuestCounter('Children', _children, (value) {
                      setState(() => _children = value);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Guest Information
              const Text(
                'Guest Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _guestNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _guestEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _guestPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _specialRequestsController,
                decoration: const InputDecoration(
                  labelText: 'Special Requests (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                  hintText: 'Any special dietary requirements, cultural experiences, etc.',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : 'Select date',
          style: TextStyle(
            color: selectedDate != null ? null : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestCounter(String label, int count, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: count > (label == 'Adults' ? 1 : 0)
                    ? () => onChanged(count - 1)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: count < 10 ? () => onChanged(count + 1) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSummary() {
    final basePrice = (widget.accommodation['price'] as num?)?.toDouble() ?? 100.0;
    final nights = _checkInDate != null && _checkOutDate != null
        ? _checkOutDate!.difference(_checkInDate!).inDays
        : 1;
    final subtotal = basePrice * nights;
    final cleaningFee = 25.0;
    final serviceFee = subtotal * 0.1;
    final total = subtotal + cleaningFee + serviceFee;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildPriceRow(
              'R${basePrice.toStringAsFixed(0)} × $nights nights',
              'R${subtotal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _buildPriceRow('Cleaning fee', 'R${cleaningFee.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildPriceRow('Service fee', 'R${serviceFee.toStringAsFixed(2)}'),
            const Divider(height: 24),
            _buildPriceRow(
              'Total',
              'R${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                // ignore: deprecated_member_use
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Experience authentic Ubuntu hospitality with local cultural activities included',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingButton() {
    final isFormValid = _checkInDate != null &&
        _checkOutDate != null &&
        _guestNameController.text.isNotEmpty &&
        _guestEmailController.text.isNotEmpty &&
        _guestPhoneController.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isFormValid ? _handleBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Confirm Booking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
          _checkOutDate = null;
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (_checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select check-in date first')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? _checkInDate!.add(const Duration(days: 1)),
      firstDate: _checkInDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  Future<void> _handleBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

      final bookingData = {
        'accommodation_id': widget.accommodation['id'],
        'accommodation_name': widget.accommodation['name'],
        'check_in_date': _checkInDate!.toIso8601String(),
        'check_out_date': _checkOutDate!.toIso8601String(),
        'adults': _adults,
        'children': _children,
        'guest_name': _guestNameController.text,
        'guest_email': _guestEmailController.text,
        'guest_phone': _guestPhoneController.text,
        'special_requests': _specialRequestsController.text,
        'total_amount': _calculateTotal(),
      };

      await bookingProvider.createAccommodationBooking(bookingData);

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Booking Confirmed!'),
            content: const Text(
              'Your accommodation booking has been confirmed. You will receive a confirmation email shortly.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pushReplacementNamed('/bookings'); // Navigate to bookings
                },
                child: const Text('View Bookings'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  double _calculateTotal() {
    final basePrice = (widget.accommodation['price'] as num?)?.toDouble() ?? 100.0;
    final nights = _checkInDate != null && _checkOutDate != null
        ? _checkOutDate!.difference(_checkInDate!).inDays
        : 1;
    final subtotal = basePrice * nights;
    final cleaningFee = 25.0;
    final serviceFee = subtotal * 0.1;
    return subtotal + cleaningFee + serviceFee;
  }
}
