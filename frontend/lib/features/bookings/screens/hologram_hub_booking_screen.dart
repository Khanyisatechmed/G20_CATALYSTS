// features/bookings/screens/hologram_hub_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/bookings/providers/bookings_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../shared/widgets/responsive_layout.dart';

class HologramHubBookingScreen extends StatefulWidget {
  final Map<String, dynamic>? experienceData;

  const HologramHubBookingScreen({super.key, this.experienceData});

  @override
  State<HologramHubBookingScreen> createState() => _HologramHubBookingScreenState();
}

class _HologramHubBookingScreenState extends State<HologramHubBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Booking data
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _participants = 1;

  // Contact information
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialRequestsController = TextEditingController();

  // Enhanced accessibility options for differently-abled community
  bool _needsWheelchairAccess = false;
  bool _needsWheelchairRental = false;
  bool _needsWheelchairAssistance = false;
  bool _needsAccessibleParking = false;
  bool _needsSignLanguage = false;
  bool _needsAudioDescription = false;
  bool _needsLargeTextDisplay = false;
  bool _needsBrailleSupport = false;
  bool _needsPersonalCareAssistant = false;
  bool _needsQuietSpace = false;
  bool _hasStudentDiscount = false;
  bool _hasSeniorDiscount = false;

  int _currentStep = 0;
  final int _totalSteps = 4;

  // Available time slots
  final List<String> _timeSlots = [
    '09:00', '10:30', '12:00', '13:30', '15:00', '16:30', '18:00'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Hologram Hub Experience'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ResponsiveLayoutBuilder(
        mobile: (context, constraints) => _buildMobileLayout(),
        tablet: (context, constraints) => _buildTabletLayout(),
        desktop: (context, constraints) => _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildProgressIndicator(),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildDateTimeSelection(),
              _buildParticipantsSection(),
              _buildAccessibilityOptions(),
              _buildContactInformation(),
            ],
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Left sidebar with progress
        Container(
          width: 300,
          color: Colors.grey[50],
          child: Column(
            children: [
              _buildBookingSummary(),
              _buildProgressIndicator(isVertical: true),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildDateTimeSelection(),
                    _buildParticipantsSection(),
                    _buildAccessibilityOptions(),
                    _buildContactInformation(),
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar
        Container(
          width: 350,
          color: Colors.grey[50],
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildBookingSummary(),
              const SizedBox(height: 24),
              _buildProgressIndicator(isVertical: true),
              const Spacer(),
              _buildPricingEstimate(),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildDateTimeSelection(),
                      _buildParticipantsSection(),
                      _buildAccessibilityOptions(),
                      _buildContactInformation(),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator({bool isVertical = false}) {
    const steps = ['Date & Time', 'Participants', 'Accessibility', 'Contact'];

    if (isVertical) {
      return Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted || isActive
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.circle,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              if (index < steps.length - 1) ...[
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  width: 2,
                  height: 24,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        }).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: Colors.grey[300],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hologram Hub Experience',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Durban, KwaZulu-Natal',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              const Text('90 minutes duration'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.language, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              const Text('Available in multiple languages'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingEstimate() {
    final pricing = _calculateCurrentPricing();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing Estimate',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...pricing['breakdown'].map<Widget>((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['item'],
                    style: TextStyle(
                      fontSize: 13,
                      color: item['type'] == 'discount' ? Colors.green : Colors.grey[700],
                    ),
                  ),
                ),
                Text(
                  '${item['amount'] < 0 ? '-' : ''}ZAR ${item['amount'].abs().toInt()}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item['type'] == 'discount' ? Colors.green : Colors.black87,
                  ),
                ),
              ],
            ),
          )).toList(),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ZAR ${pricing['total'].toInt()}',
                style: TextStyle(
                  fontSize: 18,
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

  Widget _buildDateTimeSelection() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Date & Time',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose your preferred date and time for the Hologram Hub experience.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),

          // Date Selection
          const Text(
            'Select Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CalendarDatePicker(
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),

          const SizedBox(height: 32),

          // Time Selection
          const Text(
            'Select Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _timeSlots.map((timeSlot) {
              final isSelected = _selectedTime?.format(context) == timeSlot;
              return InkWell(
                onTap: () {
                  setState(() {
                    final timeParts = timeSlot.split(':');
                    _selectedTime = TimeOfDay(
                      hour: int.parse(timeParts[0]),
                      minute: int.parse(timeParts[1]),
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
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

  Widget _buildParticipantsSection() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Number of Participants',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'How many people will be joining this experience?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Participants',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _participants > 1
                          ? () => setState(() => _participants--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '$_participants',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _participants < 20
                          ? () => setState(() => _participants++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Discount options
          const Text(
            'Available Discounts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          CheckboxListTile(
            title: const Text('Student Discount (15%)'),
            subtitle: const Text('Valid student ID required'),
            value: _hasStudentDiscount,
            onChanged: (value) {
              setState(() {
                _hasStudentDiscount = value ?? false;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),

          CheckboxListTile(
            title: const Text('Senior Discount (20%)'),
            subtitle: const Text('For visitors 65+ years'),
            value: _hasSeniorDiscount,
            onChanged: (value) {
              setState(() {
                _hasSeniorDiscount = value ?? false;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),

          if (_participants >= 5)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.group, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Group Discount Applied! 10% off for groups of 5+',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityOptions() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Accessibility & Inclusion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We are committed to providing an inclusive experience for all visitors. Please let us know how we can best accommodate your needs.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),

          // Mobility and Physical Support section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.accessible, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Mobility & Physical Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CheckboxListTile(
                  title: const Text('I require wheelchair accessible facilities'),
                  subtitle: const Text('Accessible entrance, ramps, wide pathways, and viewing areas'),
                  value: _needsWheelchairAccess,
                  onChanged: (value) {
                    setState(() {
                      _needsWheelchairAccess = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                ),

                CheckboxListTile(
                  title: const Text('I need wheelchair rental'),
                  subtitle: const Text('Standard or electric wheelchair available on-site (+ZAR 50)'),
                  value: _needsWheelchairRental,
                  onChanged: (value) {
                    setState(() {
                      _needsWheelchairRental = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                ),

                CheckboxListTile(
                  title: const Text('I need wheelchair assistance'),
                  subtitle: const Text('Personal assistance with wheelchair navigation (+ZAR 100)'),
                  value: _needsWheelchairAssistance,
                  onChanged: (value) {
                    setState(() {
                      _needsWheelchairAssistance = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                ),

                CheckboxListTile(
                  title: const Text('I need accessible parking'),
                  subtitle: const Text('Reserved parking space close to entrance (Free)'),
                  value: _needsAccessibleParking,
                  onChanged: (value) {
                    setState(() {
                      _needsAccessibleParking = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                ),

                CheckboxListTile(
                  title: const Text('I require personal care assistant access'),
                  subtitle: const Text('Companion/caregiver access at no additional charge'),
                  value: _needsPersonalCareAssistant,
                  onChanged: (value) {
                    setState(() {
                      _needsPersonalCareAssistant = value ?? false;
                    });
                  },
                  activeColor: Colors.blue,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Visual and Hearing Support section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.hearing, color: Colors.purple),
                    const SizedBox(width: 8),
                    const Text(
                      'Visual & Hearing Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CheckboxListTile(
                  title: const Text('South African Sign Language interpreter'),
                  subtitle: const Text('Professional SASL interpreter (+ZAR 200)'),
                  value: _needsSignLanguage,
                  onChanged: (value) {
                    setState(() {
                      _needsSignLanguage = value ?? false;
                    });
                  },
                  activeColor: Colors.purple,
                  contentPadding: EdgeInsets.zero,
                ),

                CheckboxListTile(
                  title: const Text('Audio description service'),
                  subtitle: const Text('Detailed audio descriptions of visual content (+ZAR 75)'),
                  value: _needsAudioDescription,
                  onChanged: (value) {
                    setState(() {
                      _needsAudioDescription = value ?? false;
                    });
                  },
                  activeColor: Colors.purple,
                  contentPadding: EdgeInsets.zero,
                ),

                CheckboxListTile(
                  title: const Text('Large text display'),
                  subtitle: const Text('Enhanced text size for better visibility (Free)'),
                  value: _needsLargeTextDisplay,
                  onChanged: (value) {
                    setState(() {
                      _needsLargeTextDisplay = value ?? false;
                    });
                  },
                  activeColor: Colors.purple,
                  contentPadding: EdgeInsets.zero,
                ),

                CheckboxListTile(
                  title: const Text('Braille information support'),
                  subtitle: const Text('Braille materials and tactile guidance (+ZAR 50)'),
                  value: _needsBrailleSupport,
                  onChanged: (value) {
                    setState(() {
                      _needsBrailleSupport = value ?? false;
                    });
                  },
                  activeColor: Colors.purple,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Sensory and Cognitive Support section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'Sensory & Cognitive Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CheckboxListTile(
                  title: const Text('Quiet space access'),
                  subtitle: const Text('Dedicated quiet area for sensory breaks (Free)'),
                  value: _needsQuietSpace,
                  onChanged: (value) {
                    setState(() {
                      _needsQuietSpace = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Additional Requirements
          const Text(
            'Additional Accessibility Needs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _specialRequestsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Please describe any other accessibility needs, medical requirements, or special accommodations we should be aware of...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(16),
              helperText: 'We are committed to making this experience accessible to everyone. Please share any specific needs.',
              helperMaxLines: 2,
            ),
          ),

          const SizedBox(height: 24),

          // Information about what's included
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Included Accessibility Features',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Step-free access throughout the facility\n'
                  '• Accessible restrooms and facilities\n'
                  '• Adjustable seating arrangements\n'
                  '• Multiple language options for displays\n'
                  '• Trained accessibility support staff\n'
                  '• Emergency evacuation assistance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInformation() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please provide your contact details to complete the booking.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Booking summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Experience', 'Hologram Hub Cultural Experience'),
                  _buildSummaryRow('Location', 'Durban, KwaZulu-Natal'),
                  _buildSummaryRow('Date', _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Not selected'),
                  _buildSummaryRow('Time', _selectedTime?.format(context) ?? 'Not selected'),
                  _buildSummaryRow('Participants', '$_participants'),
                  if (_needsWheelchairAccess || _needsWheelchairRental ||
                      _needsAccessibleParking || _needsSignLanguage ||
                      _needsAudioDescription || _needsWheelchairAssistance ||
                      _needsLargeTextDisplay || _needsBrailleSupport ||
                      _needsPersonalCareAssistant || _needsQuietSpace)
                    _buildSummaryRow('Accessibility', _getAccessibilitySummary()),
                  const Divider(height: 20),
                  _buildSummaryRow('Total Amount', 'ZAR ${_calculateCurrentPricing()['total'].toInt()}', isTotal: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Theme.of(context).primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _currentStep == _totalSteps - 1 ? _completeBooking : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _currentStep == _totalSteps - 1 ? 'Complete Booking' : 'Next',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Map<String, dynamic> _calculateCurrentPricing() {
    const double basePrice = 250.0;
    double total = basePrice * _participants;

    List<Map<String, dynamic>> breakdown = [
      {
        'item': 'Tickets ($_participants × ZAR ${basePrice.toInt()})',
        'amount': total,
        'type': 'base'
      }
    ];

    // Physical support and mobility
    if (_needsWheelchairRental) {
      breakdown.add({'item': 'Wheelchair Rental', 'amount': 50.0, 'type': 'accessibility'});
      total += 50.0;
    }

    if (_needsWheelchairAssistance) {
      breakdown.add({'item': 'Wheelchair Assistance', 'amount': 100.0, 'type': 'accessibility'});
      total += 100.0;
    }

    // Visual and hearing support
    if (_needsSignLanguage) {
      breakdown.add({'item': 'SASL Interpreter', 'amount': 200.0, 'type': 'accessibility'});
      total += 200.0;
    }

    if (_needsAudioDescription) {
      breakdown.add({'item': 'Audio Description', 'amount': 75.0, 'type': 'accessibility'});
      total += 75.0;
    }

    if (_needsBrailleSupport) {
      breakdown.add({'item': 'Braille Support', 'amount': 50.0, 'type': 'accessibility'});
      total += 50.0;
    }

    // Additional accessibility support
    if (_specialRequestsController.text.isNotEmpty ||
        _needsPersonalCareAssistant ||
        _needsQuietSpace ||
        _needsLargeTextDisplay) {
      breakdown.add({'item': 'Additional Accessibility Support', 'amount': 75.0, 'type': 'accessibility'});
      total += 75.0;
    }

    // Free services note
    List<String> freeServices = [];
    if (_needsWheelchairAccess) freeServices.add('Wheelchair Access');
    if (_needsAccessibleParking) freeServices.add('Accessible Parking');
    if (_needsPersonalCareAssistant) freeServices.add('Caregiver Access');
    if (_needsQuietSpace) freeServices.add('Quiet Space');
    if (_needsLargeTextDisplay) freeServices.add('Large Text Display');

    if (freeServices.isNotEmpty) {
      breakdown.add({
        'item': 'Free: ${freeServices.join(', ')}',
        'amount': 0.0,
        'type': 'free'
      });
    }

    // Group discount for 5+ people
    if (_participants >= 5) {
      final discount = total * 0.1;
      breakdown.add({'item': 'Group Discount (10%)', 'amount': -discount, 'type': 'discount'});
      total -= discount;
    }

    // Student/Senior discounts
    if (_hasStudentDiscount) {
      final discount = basePrice * _participants * 0.15;
      breakdown.add({'item': 'Student Discount (15%)', 'amount': -discount, 'type': 'discount'});
      total -= discount;
    }

    if (_hasSeniorDiscount) {
      final discount = basePrice * _participants * 0.2;
      breakdown.add({'item': 'Senior Discount (20%)', 'amount': -discount, 'type': 'discount'});
      total -= discount;
    }

    return {
      'total': total,
      'breakdown': breakdown,
    };
  }

  String _getAccessibilitySummary() {
    List<String> requirements = [];
    if (_needsWheelchairAccess) requirements.add('Wheelchair Access');
    if (_needsWheelchairRental) requirements.add('Wheelchair Rental');
    if (_needsWheelchairAssistance) requirements.add('Wheelchair Assistance');
    if (_needsAccessibleParking) requirements.add('Accessible Parking');
    if (_needsSignLanguage) requirements.add('SASL Interpreter');
    if (_needsAudioDescription) requirements.add('Audio Description');
    if (_needsLargeTextDisplay) requirements.add('Large Text');
    if (_needsBrailleSupport) requirements.add('Braille Support');
    if (_needsPersonalCareAssistant) requirements.add('Caregiver Access');
    if (_needsQuietSpace) requirements.add('Quiet Space');

    if (requirements.isEmpty) {
      return 'Standard access';
    }

    return requirements.join(', ');
  }

  void _nextStep() {
    if (_currentStep == 0 && (_selectedDate == null || _selectedTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeBooking() {
    if (_formKey.currentState?.validate() ?? false) {
      final bookingData = {
        'date': _selectedDate!.toIso8601String(),
        'time': _selectedTime!.format(context),
        'participants': _participants,
        'wheelchairAccess': _needsWheelchairAccess,
        'wheelchairRental': _needsWheelchairRental,
        'wheelchairAssistance': _needsWheelchairAssistance,
        'accessibleParking': _needsAccessibleParking,
        'signLanguageInterpreter': _needsSignLanguage,
        'audioDescription': _needsAudioDescription,
        'largeTextDisplay': _needsLargeTextDisplay,
        'brailleSupport': _needsBrailleSupport,
        'personalCareAssistant': _needsPersonalCareAssistant,
        'quietSpace': _needsQuietSpace,
        'studentDiscount': _hasStudentDiscount,
        'seniorDiscount': _hasSeniorDiscount,
        'accessibilityRequirements': _specialRequestsController.text.isNotEmpty
            ? _specialRequestsController.text : null,
        'contact_name': _nameController.text,
        'contact_email': _emailController.text,
        'contact_phone': _phoneController.text,
      };

      context.read<BookingProvider>().createHologramHubBooking(bookingData).then((_) {
        Navigator.pushReplacementNamed(context, '/bookings');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hologram Hub booking confirmed! Welcome to an inclusive cultural experience.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }
}
