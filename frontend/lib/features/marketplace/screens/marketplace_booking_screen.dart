// features/marketplace/screens/marketplace_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../../../core/theme/marketplace_theme.dart';

class MarketplaceBookingScreen extends StatefulWidget {
  final Map<String, dynamic> experience;

  const MarketplaceBookingScreen({
    super.key,
    required this.experience,
  });

  @override
  State<MarketplaceBookingScreen> createState() => _MarketplaceBookingScreenState();
}

class _MarketplaceBookingScreenState extends State<MarketplaceBookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _numberOfParticipants = 1;
  String _selectedTimeSlot = '';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  bool _acceptsTerms = false;
  bool _wantsNewsletter = false;

  // Available time slots for experiences
  final List<String> _timeSlots = [
    '09:00 AM',
    '11:00 AM',
    '02:00 PM',
    '04:00 PM',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MarketplaceTheme.lightTheme,
      child: Scaffold(
        backgroundColor: MarketplaceTheme.lightBackground,
        appBar: _buildAppBar(),
        body: ResponsiveLayoutBuilder(
          mobile: (context, constraints) => _buildMobileLayout(),
          tablet: (context, constraints) => _buildTabletLayout(),
          desktop: (context, constraints) => _buildDesktopLayout(),
        ),
        bottomNavigationBar: _buildBottomBookingBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Book Experience'),
      backgroundColor: MarketplaceTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        IconButton(
          onPressed: () => _showHelpDialog(),
          icon: const Icon(Icons.help_outline),
          tooltip: 'Help',
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExperienceHeader(),
            const SizedBox(height: 24),
            _buildDateTimeSelection(),
            const SizedBox(height: 24),
            _buildParticipantSelection(),
            const SizedBox(height: 24),
            _buildContactForm(),
            const SizedBox(height: 24),
            _buildAdditionalOptions(),
            const SizedBox(height: 24),
            _buildPricingSummary(),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExperienceHeader(),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildDateTimeSelection(),
                        const SizedBox(height: 24),
                        _buildParticipantSelection(),
                        const SizedBox(height: 24),
                        _buildContactForm(),
                        const SizedBox(height: 24),
                        _buildAdditionalOptions(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _buildPricingSummary(),
                        const SizedBox(height: 24),
                        _buildExperienceIncludes(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExperienceHeader(),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildDateTimeSelection()),
                              const SizedBox(width: 24),
                              Expanded(child: _buildParticipantSelection()),
                            ],
                          ),
                          const SizedBox(height: 32),
                          _buildContactForm(),
                          const SizedBox(height: 32),
                          _buildAdditionalOptions(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildPricingSummary(),
                          const SizedBox(height: 24),
                          _buildExperienceIncludes(),
                          const SizedBox(height: 24),
                          _buildCancellationPolicy(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceHeader() {
    final imageUrl = widget.experience['imageUrl'] as String?;
    final title = widget.experience['title'] as String? ?? 'Cultural Experience';
    final description = widget.experience['description'] as String? ?? '';
    final location = widget.experience['location'] as String? ?? 'KZN';
    final duration = widget.experience['duration'] as String? ?? '2 hours';
    final rating = widget.experience['rating'] as double?;
    final reviewCount = widget.experience['reviewCount'] as int? ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 48),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MarketplaceTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: MarketplaceTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(Icons.schedule, 'Duration: $duration'),
                    _buildInfoChip(Icons.location_on, location),
                    if (rating != null)
                      _buildInfoChip(Icons.star, '$rating ($reviewCount reviews)'),
                    _buildInfoChip(Icons.group, 'Max ${widget.experience['maxParticipants'] ?? 10} participants'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MarketplaceTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: MarketplaceTheme.primaryBlue),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: MarketplaceTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Date & Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Date selection
          OutlinedButton.icon(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'Select Date',
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: _selectedDate != null
                  ? MarketplaceTheme.primaryBlue
                  : MarketplaceTheme.textSecondary,
              side: BorderSide(
                color: _selectedDate != null
                    ? MarketplaceTheme.primaryBlue
                    : Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Time slot selection
          const Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MarketplaceTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeSlots.map((timeSlot) {
              final isSelected = _selectedTimeSlot == timeSlot;
              return GestureDetector(
                onTap: () => setState(() => _selectedTimeSlot = timeSlot),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MarketplaceTheme.primaryBlue
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? MarketplaceTheme.primaryBlue
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      color: isSelected ? Colors.white : MarketplaceTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantSelection() {
    final maxParticipants = widget.experience['maxParticipants'] as int? ?? 10;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number of Participants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MarketplaceTheme.lightBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _numberOfParticipants > 1
                      ? () => setState(() => _numberOfParticipants--)
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: _numberOfParticipants > 1
                        ? MarketplaceTheme.primaryBlue
                        : Colors.grey[300],
                    foregroundColor: _numberOfParticipants > 1
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),

                Column(
                  children: [
                    Text(
                      '$_numberOfParticipants',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: MarketplaceTheme.textPrimary,
                      ),
                    ),
                    Text(
                      _numberOfParticipants == 1 ? 'Participant' : 'Participants',
                      style: const TextStyle(
                        fontSize: 12,
                        color: MarketplaceTheme.textSecondary,
                      ),
                    ),
                  ],
                ),

                IconButton(
                  onPressed: _numberOfParticipants < maxParticipants
                      ? () => setState(() => _numberOfParticipants++)
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: _numberOfParticipants < maxParticipants
                        ? MarketplaceTheme.primaryBlue
                        : Colors.grey[300],
                    foregroundColor: _numberOfParticipants < maxParticipants
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Maximum $maxParticipants participants allowed',
            style: const TextStyle(
              fontSize: 12,
              color: MarketplaceTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email address';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+27 12 345 6789',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.trim().length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Special Requirements (Optional)',
              hintText: 'Any dietary restrictions, accessibility needs, etc.',
              prefixIcon: Icon(Icons.note_outlined),
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            maxLength: 500,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          CheckboxListTile(
            title: const Text('I agree to the Terms and Conditions'),
            subtitle: const Text('Required to complete booking'),
            value: _acceptsTerms,
            onChanged: (value) => setState(() => _acceptsTerms = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: MarketplaceTheme.primaryBlue,
          ),

          CheckboxListTile(
            title: const Text('Subscribe to newsletter'),
            subtitle: const Text('Get updates on new experiences and offers'),
            value: _wantsNewsletter,
            onChanged: (value) => setState(() => _wantsNewsletter = value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: MarketplaceTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSummary() {
    final pricePerPerson = widget.experience['price'] as num? ?? 100;
    final subtotal = pricePerPerson * _numberOfParticipants;
    final serviceFee = subtotal * 0.05; // 5% service fee
    final total = subtotal + serviceFee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MarketplaceTheme.primaryBlue.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: MarketplaceTheme.primaryBlue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          _buildPriceRow('Price per person', 'ZAR ${pricePerPerson.toInt()}'),
          _buildPriceRow('Participants', 'x $_numberOfParticipants'),
          _buildPriceRow('Subtotal', 'ZAR ${subtotal.toInt()}'),
          _buildPriceRow('Service fee', 'ZAR ${serviceFee.toInt()}'),

          const Divider(height: 24),

          _buildPriceRow('Total', 'ZAR ${total.toInt()}', isTotal: true),

          if (_selectedDate != null && _selectedTimeSlot.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MarketplaceTheme.lightBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Booking:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MarketplaceTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at $_selectedTimeSlot',
                    style: const TextStyle(
                      color: MarketplaceTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal
                  ? MarketplaceTheme.primaryBlue
                  : MarketplaceTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceIncludes() {
    final includes = widget.experience['includes'] as List<dynamic>? ?? [];

    if (includes.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s Included',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...includes.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: MarketplaceTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCancellationPolicy() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cancellation Policy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MarketplaceTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '• Free cancellation up to 24 hours before the experience\n'
            '• 50% refund if cancelled within 24 hours\n'
            '• No refund for no-shows\n'
            '• Weather-related cancellations are fully refundable',
            style: TextStyle(
              fontSize: 14,
              color: MarketplaceTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomBookingBar() {
    if (!ResponsiveHelper.isMobile(context)) return null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _canProceedWithBooking() ? _processBooking : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: MarketplaceTheme.primaryBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  bool _canProceedWithBooking() {
    return _selectedDate != null &&
           _selectedTimeSlot.isNotEmpty &&
           _nameController.text.isNotEmpty &&
           _emailController.text.isNotEmpty &&
           _phoneController.text.isNotEmpty &&
           _acceptsTerms;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _processBooking() async {
    if (_formKey.currentState!.validate() && _canProceedWithBooking()) {
      setState(() => _isLoading = true);

      // Simulate processing time
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text('Booking Confirmed!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your booking has been confirmed successfully.'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Details:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Experience: ${widget.experience['title']}'),
                      Text('Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                      Text('Time: $_selectedTimeSlot'),
                      Text('Participants: $_numberOfParticipants'),
                      Text('Total: ZAR ${((widget.experience['price'] as num? ?? 100) * _numberOfParticipants * 1.05).toInt()}'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'A confirmation email has been sent to your email address.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: const Text('Continue Shopping'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamed(context, '/bookings'); // Go to bookings screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarketplaceTheme.primaryBlue,
                ),
                child: const Text('View Bookings'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Booking Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need assistance with your booking?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('• Select your preferred date and time'),
            Text('• Choose number of participants'),
            Text('• Fill in contact information'),
            Text('• Review and confirm booking'),
            SizedBox(height: 16),
            Text(
              'For support, contact us:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('📧 support@wandersmarketplace.co.za'),
            Text('📞 +27 11 123 4567'),
            Text('💬 Live chat available 9AM-5PM'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
