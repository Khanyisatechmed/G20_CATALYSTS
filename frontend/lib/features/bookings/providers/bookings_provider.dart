// features/bookings/providers/booking_provider.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import '../../../core/services/api_service.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _accommodationBookings = [];
  List<Map<String, dynamic>> _experienceBookings = [];
  bool _isLoading = false;
  String? _error;

  BookingProvider(ApiService read, AuthProvider read2);

  // Getters
  List<Map<String, dynamic>> get bookings => _bookings;
  List<Map<String, dynamic>> get accommodationBookings => _accommodationBookings;
  List<Map<String, dynamic>> get experienceBookings => _experienceBookings;
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

  // Fetch all bookings
  Future<void> fetchBookings() async {
    try {
      _setLoading(true);
      _setError(null);

      // In a real app, you would make API calls here:
      // final response = await _apiService.get('/bookings');

      // For now, simulate with mock data
      await Future.delayed(const Duration(seconds: 1));

      _bookings = [
        {
          'id': '1',
          'type': 'accommodation',
          'status': 'confirmed',
          'accommodation_name': 'WandersVillage Homestay',
          'check_in_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
          'check_out_date': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
          'total_amount': 1200.0,
          'booking_reference': 'UB123456',
          'location': 'Eastern Cape, South Africa',
        },
        {
          'id': '2',
          'type': 'experience',
          'status': 'pending',
          'experience_name': 'Traditional Cooking Class',
          'date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
          'total_amount': 350.0,
          'booking_reference': 'UE789012',
          'location': 'KwaZulu-Natal, South Africa',
        },
      ];

      _accommodationBookings = _bookings.where((b) => b['type'] == 'accommodation').toList();
      _experienceBookings = _bookings.where((b) => b['type'] == 'experience').toList();

      _setLoading(false);

    } catch (e) {
      _setError('Failed to fetch bookings: $e');
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

        // Update specific booking lists
        if (_bookings[bookingIndex]['type'] == 'accommodation') {
          final accIndex = _accommodationBookings.indexWhere((b) => b['id'] == bookingId);
          if (accIndex != -1) {
            _accommodationBookings[accIndex]['status'] = 'cancelled';
          }
        } else if (_bookings[bookingIndex]['type'] == 'experience') {
          final expIndex = _experienceBookings.indexWhere((b) => b['id'] == bookingId);
          if (expIndex != -1) {
            _experienceBookings[expIndex]['status'] = 'cancelled';
          }
        }
      }

      _setLoading(false);
      notifyListeners();

    } catch (e) {
      _setError('Failed to cancel booking: $e');
      _setLoading(false);
    }
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

  // Get upcoming bookings
  List<Map<String, dynamic>> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      if (booking['type'] == 'accommodation') {
        final checkInDate = DateTime.parse(booking['check_in_date']);
        return checkInDate.isAfter(now) && booking['status'] != 'cancelled';
      } else if (booking['type'] == 'experience') {
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
      } else if (booking['type'] == 'experience') {
        final experienceDate = DateTime.parse(booking['date']);
        return experienceDate.isBefore(now);
      }
      return false;
    }).toList();
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
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
