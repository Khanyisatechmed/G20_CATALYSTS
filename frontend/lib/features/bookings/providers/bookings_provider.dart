// features/bookings/providers/booking_provider.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import '../../../core/services/api_service.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _accommodationBookings = [];
  List<Map<String, dynamic>> _experienceBookings = [];
  List<Map<String, dynamic>> _hologramHubBookings = [];
  bool _isLoading = false;
  String? _error;

  BookingProvider(ApiService read, AuthProvider read2);

  // Getters
  List<Map<String, dynamic>> get bookings => _bookings;
  List<Map<String, dynamic>> get accommodationBookings => _accommodationBookings;
  List<Map<String, dynamic>> get experienceBookings => _experienceBookings;
  List<Map<String, dynamic>> get hologramHubBookings => _hologramHubBookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Create Hologram Hub booking with accessibility options
  Future<void> createHologramHubBooking(Map<String, dynamic> bookingData) async {
    try {
      _setLoading(true);
      _setError(null);

      // Generate a temporary booking ID for demonstration
      final bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      // Calculate pricing based on accessibility needs
      final pricingInfo = _calculateHologramHubPricing(bookingData);

      // Create booking object with accessibility features
      final booking = {
        'id': bookingId,
        'type': 'hologram_hub',
        'status': 'confirmed',
        'created_at': DateTime.now().toIso8601String(),
        'booking_reference': 'HH${bookingId.substring(bookingId.length - 6)}',
        'title': 'Hologram Hub Cultural Experience',
        'experience_name': 'Hologram Hub Cultural Experience',
        'location': 'Durban, KwaZulu-Natal',
        'duration': '90 minutes',
        'currency': 'ZAR',
        'base_price': pricingInfo['basePrice'],
        'total_amount': pricingInfo['total'],
        'pricing_breakdown': pricingInfo['breakdown'],
        // Enhanced accessibility features
        'wheelchair_access': bookingData['wheelchairAccess'] ?? false,
        'wheelchair_rental': bookingData['wheelchairRental'] ?? false,
        'wheelchair_assistance': bookingData['wheelchairAssistance'] ?? false,
        'accessible_parking': bookingData['accessibleParking'] ?? false,
        'sign_language_interpreter': bookingData['signLanguageInterpreter'] ?? false,
        'audio_description': bookingData['audioDescription'] ?? false,
        'large_text_display': bookingData['largeTextDisplay'] ?? false,
        'braille_support': bookingData['brailleSupport'] ?? false,
        'personal_care_assistant': bookingData['personalCareAssistant'] ?? false,
        'quiet_space': bookingData['quietSpace'] ?? false,
        'accessibility_requirements': bookingData['accessibilityRequirements'],
        // Standard booking data
        ...bookingData,
      };

      // In a real app, you would make an API call here:
      // final response = await _apiService.post('/bookings/hologram-hub', bookingData);

      // For now, we'll simulate the API call
      await Future.delayed(const Duration(seconds: 2));

      // Add to local bookings list
      _hologramHubBookings.add(booking);
      _bookings.add(booking);

      _setLoading(false);
      notifyListeners();

    } catch (e) {
      _setError('Failed to create Hologram Hub booking: $e');
      _setLoading(false);
    }
  }

  // Calculate Hologram Hub pricing with accessibility considerations
  Map<String, dynamic> _calculateHologramHubPricing(Map<String, dynamic> bookingData) {
    const double baseTicketPrice = 250.0; // Base price per person
    const double wheelchairRentalFee = 50.0;
    const double accessibilitySupport = 100.0;
    const double signLanguageFee = 200.0;
    const double audioDescriptionFee = 75.0;

    final int participants = bookingData['participants'] ?? 1;
    double subtotal = baseTicketPrice * participants;

    List<Map<String, dynamic>> breakdown = [
      {
        'item': 'Hologram Hub Tickets ($participants x ZAR ${baseTicketPrice.toInt()})',
        'amount': subtotal,
        'type': 'base'
      }
    ];

    // Add accessibility fees
    if (bookingData['wheelchairRental'] == true) {
      breakdown.add({
        'item': 'Wheelchair Rental',
        'amount': wheelchairRentalFee,
        'type': 'accessibility'
      });
      subtotal += wheelchairRentalFee;
    }

    if (bookingData['accessibilityRequirements'] != null &&
        bookingData['accessibilityRequirements'].isNotEmpty) {
      breakdown.add({
        'item': 'Accessibility Support',
        'amount': accessibilitySupport,
        'type': 'accessibility'
      });
      subtotal += accessibilitySupport;
    }

    if (bookingData['signLanguageInterpreter'] == true) {
      breakdown.add({
        'item': 'Sign Language Interpreter',
        'amount': signLanguageFee,
        'type': 'accessibility'
      });
      subtotal += signLanguageFee;
    }

    if (bookingData['audioDescription'] == true) {
      breakdown.add({
        'item': 'Audio Description Service',
        'amount': audioDescriptionFee,
        'type': 'accessibility'
      });
      subtotal += audioDescriptionFee;
    }

    // Group discount for 5+ people
    if (participants >= 5) {
      final discount = subtotal * 0.1;
      breakdown.add({
        'item': 'Group Discount (10%)',
        'amount': -discount,
        'type': 'discount'
      });
      subtotal -= discount;
    }

    // Student/Senior discounts
    if (bookingData['studentDiscount'] == true) {
      final discount = baseTicketPrice * participants * 0.15;
      breakdown.add({
        'item': 'Student Discount (15%)',
        'amount': -discount,
        'type': 'discount'
      });
      subtotal -= discount;
    }

    if (bookingData['seniorDiscount'] == true) {
      final discount = baseTicketPrice * participants * 0.2;
      breakdown.add({
        'item': 'Senior Discount (20%)',
        'amount': -discount,
        'type': 'discount'
      });
      subtotal -= discount;
    }

    return {
      'basePrice': baseTicketPrice,
      'total': subtotal,
      'breakdown': breakdown,
    };
  }

  // Create accommodation booking
  Future<void> createAccommodationBooking(Map<String, dynamic> bookingData) async {
    try {
      _setLoading(true);
      _setError(null);

      // Generate a temporary booking ID for demonstration
      final bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create booking object
      final booking = {
        'id': bookingId,
        'type': 'accommodation',
        'status': 'confirmed',
        'created_at': DateTime.now().toIso8601String(),
        'booking_reference': 'UB${bookingId.substring(bookingId.length - 6)}',
        ...bookingData,
      };

      // In a real app, you would make an API call here:
      // final response = await _apiService.post('/bookings/accommodation', bookingData);

      // For now, we'll simulate the API call
      await Future.delayed(const Duration(seconds: 2));

      // Add to local bookings list
      _accommodationBookings.add(booking);
      _bookings.add(booking);

      _setLoading(false);
      notifyListeners();

    } catch (e) {
      _setError('Failed to create booking: $e');
      _setLoading(false);
    }
  }

  // Create experience booking
  Future<void> createExperienceBooking(Map<String, dynamic> bookingData) async {
    try {
      _setLoading(true);
      _setError(null);

      // Generate a temporary booking ID
      final bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      final booking = {
        'id': bookingId,
        'type': 'experience',
        'status': 'confirmed',
        'created_at': DateTime.now().toIso8601String(),
        'booking_reference': 'UE${bookingId.substring(bookingId.length - 6)}',
        ...bookingData,
      };

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _experienceBookings.add(booking);
      _bookings.add(booking);

      _setLoading(false);
      notifyListeners();

    } catch (e) {
      _setError('Failed to create experience booking: $e');
      _setLoading(false);
    }
  }

  // Load a specific booking by ID
  Future<void> loadBooking(String bookingId) async {
    try {
      _setLoading(true);
      _setError(null);

      // In a real app, you would make an API call here:
      // final response = await _apiService.get('/bookings/$bookingId');

      // For now, simulate with a delay
      await Future.delayed(const Duration(seconds: 1));

      // This would typically update a selectedBooking property
      // For now, we'll just ensure the booking exists in our list
      final booking = getBookingById(bookingId);
      if (booking == null) {
        throw Exception('Booking not found');
      }

      _setLoading(false);

    } catch (e) {
      _setError('Failed to load booking: $e');
      _setLoading(false);
    }
  }

  // Fetch all bookings with enhanced mock data
  Future<void> fetchBookings() async {
    try {
      _setLoading(true);
      _setError(null);

      // In a real app, you would make API calls here:
      // final response = await _apiService.get('/bookings');

      // For now, simulate with enhanced mock data including Hologram Hub
      await Future.delayed(const Duration(seconds: 1));

      _bookings = [
        // Hologram Hub booking with wheelchair access
        {
          'id': '1',
          'type': 'hologram_hub',
          'status': 'confirmed',
          'title': 'Hologram Hub Cultural Experience',
          'experience_name': 'Hologram Hub Cultural Experience',
          'date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          'time': '14:00',
          'duration': '90 minutes',
          'participants': 2,
          'total_amount': 580.0,
          'currency': 'ZAR',
          'base_price': 250.0,
          'booking_reference': 'HH123456',
          'location': 'Durban, KwaZulu-Natal',
          'wheelchair_access': true,
          'wheelchair_rental': true,
          'accessible_parking': true,
          'accessibility_requirements': 'Visual impairment support needed',
          'audio_description': true,
          'imageUrl': 'assets/images/hologram_hub.png',
        },
        // Regular Hologram Hub booking
        {
          'id': '2',
          'type': 'hologram_hub',
          'status': 'pending',
          'title': 'Hologram Hub Cultural Experience',
          'experience_name': 'Hologram Hub Cultural Experience',
          'date': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
          'time': '10:00',
          'duration': '90 minutes',
          'participants': 4,
          'total_amount': 1000.0,
          'currency': 'ZAR',
          'base_price': 250.0,
          'booking_reference': 'HH789012',
          'location': 'V&A Waterfront, Cape Town',
          'wheelchair_access': false,
          'imageUrl': 'assets/images/hologram_hub.png',
        },
        // Traditional accommodation booking
        {
          'id': '3',
          'type': 'accommodation',
          'status': 'confirmed',
          'accommodation_name': 'Ubuntu Village Homestay',
          'check_in_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
          'check_out_date': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
          'total_amount': 1200.0,
          'currency': 'ZAR',
          'booking_reference': 'UB123456',
          'location': 'Eastern Cape, South Africa',
          'guests': 2,
        },
        // Traditional experience booking
        {
          'id': '4',
          'type': 'experience',
          'status': 'completed',
          'experience_name': 'Traditional Cooking Class',
          'date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
          'time': '16:00',
          'duration': '3 hours',
          'participants': 3,
          'total_amount': 525.0,
          'currency': 'ZAR',
          'booking_reference': 'UE789012',
          'location': 'KwaZulu-Natal, South Africa',
        },
      ];

      // Separate bookings by type
      _accommodationBookings = _bookings.where((b) => b['type'] == 'accommodation').toList();
      _experienceBookings = _bookings.where((b) => b['type'] == 'experience').toList();
      _hologramHubBookings = _bookings.where((b) => b['type'] == 'hologram_hub').toList();

      _setLoading(false);

    } catch (e) {
      _setError('Failed to fetch bookings: $e');
      _setLoading(false);
    }
  }

  // Update booking accessibility requirements
  Future<void> updateAccessibilityRequirements(String bookingId, Map<String, dynamic> accessibilityData) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Find and update the booking
      final bookingIndex = _bookings.indexWhere((b) => b['id'] == bookingId);
      if (bookingIndex != -1) {
        _bookings[bookingIndex] = {
          ..._bookings[bookingIndex],
          ...accessibilityData,
        };

        // Recalculate pricing if needed
        if (_bookings[bookingIndex]['type'] == 'hologram_hub') {
          final updatedPricing = _calculateHologramHubPricing(_bookings[bookingIndex]);
          _bookings[bookingIndex]['total_amount'] = updatedPricing['total'];
          _bookings[bookingIndex]['pricing_breakdown'] = updatedPricing['breakdown'];
        }

        // Update specific booking lists
        _updateSpecificBookingLists();
      }

      _setLoading(false);
      notifyListeners();

    } catch (e) {
      _setError('Failed to update accessibility requirements: $e');
      _setLoading(false);
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update booking status
      final bookingIndex = _bookings.indexWhere((b) => b['id'] == bookingId);
      if (bookingIndex != -1) {
        _bookings[bookingIndex]['status'] = 'cancelled';
        _updateSpecificBookingLists();
      }

      _setLoading(false);
      notifyListeners();

    } catch (e) {
      _setError('Failed to cancel booking: $e');
      _setLoading(false);
    }
  }

  // Update specific booking lists when main list changes
  void _updateSpecificBookingLists() {
    _accommodationBookings = _bookings.where((b) => b['type'] == 'accommodation').toList();
    _experienceBookings = _bookings.where((b) => b['type'] == 'experience').toList();
    _hologramHubBookings = _bookings.where((b) => b['type'] == 'hologram_hub').toList();
  }

  // Get booking by ID
  Map<String, dynamic>? getBookingById(String bookingId) {
    try {
      return _bookings.firstWhere((booking) => booking['id'] == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Filter bookings by status
  List<Map<String, dynamic>> getBookingsByStatus(String status) {
    return _bookings.where((booking) => booking['status'] == status).toList();
  }

  // Get bookings by type
  List<Map<String, dynamic>> getBookingsByType(String type) {
    return _bookings.where((booking) => booking['type'] == type).toList();
  }

  // Get bookings with accessibility requirements
  List<Map<String, dynamic>> getAccessibleBookings() {
    return _bookings.where((booking) =>
      booking['wheelchair_access'] == true ||
      booking['accessibility_requirements'] != null ||
      booking['sign_language_interpreter'] == true ||
      booking['audio_description'] == true
    ).toList();
  }

  // Get upcoming bookings
  List<Map<String, dynamic>> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      if (booking['type'] == 'accommodation') {
        final checkInDate = DateTime.parse(booking['check_in_date']);
        return checkInDate.isAfter(now) && booking['status'] != 'cancelled';
      } else if (booking['type'] == 'experience' || booking['type'] == 'hologram_hub') {
        final experienceDate = DateTime.parse(booking['date']);
        return experienceDate.isAfter(now) && booking['status'] != 'cancelled';
      }
      return false;
    }).toList();
  }

  // Get past bookings
  List<Map<String, dynamic>> getPastBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      if (booking['type'] == 'accommodation') {
        final checkOutDate = DateTime.parse(booking['check_out_date']);
        return checkOutDate.isBefore(now);
      } else if (booking['type'] == 'experience' || booking['type'] == 'hologram_hub') {
        final experienceDate = DateTime.parse(booking['date']);
        return experienceDate.isBefore(now);
      }
      return false;
    }).toList();
  }

  // Get pricing estimates for different accessibility options
  Map<String, double> getAccessibilityPricingOptions() {
    return {
      'wheelchair_rental': 50.0,
      'accessibility_support': 100.0,
      'sign_language_interpreter': 200.0,
      'audio_description': 75.0,
      'accessible_parking': 0.0, // Free service
    };
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Clear all bookings (for logout, etc.)
  void clearBookings() {
    _bookings.clear();
    _accommodationBookings.clear();
    _experienceBookings.clear();
    _hologramHubBookings.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
