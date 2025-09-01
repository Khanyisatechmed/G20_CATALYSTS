// core/models/booking_model.dart
enum BookingStatus { pending, confirmed, cancelled, completed }

class BookingModel {
  final int id;
  final int userId;
  final int experienceId;
  final DateTime bookingDate;
  final int participants;
  final double totalPrice;
  final String currency;
  final BookingStatus status;
  final String? specialRequirements;
  final Map<String, dynamic>? contactDetails;
  final String? paymentReference;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related data
  final String? experienceTitle;
  final String? experienceLocation;
  final String? experienceImage;

  BookingModel({
    required this.id,
    required this.userId,
    required this.experienceId,
    required this.bookingDate,
    required this.participants,
    required this.totalPrice,
    this.currency = 'ZAR',
    required this.status,
    this.specialRequirements,
    this.contactDetails,
    this.paymentReference,
    required this.createdAt,
    required this.updatedAt,
    this.experienceTitle,
    this.experienceLocation,
    this.experienceImage,
  });

  String get formattedPrice => '$currency${totalPrice.toInt()}';
  String get statusText => status.name.toUpperCase();
  bool get canCancel => status == BookingStatus.confirmed || status == BookingStatus.pending;
  bool get canModify => status == BookingStatus.confirmed;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['user_id'],
      experienceId: json['experience_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      participants: json['participants'],
      totalPrice: json['total_price'].toDouble(),
      currency: json['currency'] ?? 'ZAR',
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      specialRequirements: json['special_requirements'],
      contactDetails: json['contact_details'],
      paymentReference: json['payment_reference'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      experienceTitle: json['experience']?['title'],
      experienceLocation: json['experience']?['location'],
      experienceImage: json['experience']?['images']?.isNotEmpty == true
          ? json['experience']['images'][0]
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'experience_id': experienceId,
      'booking_date': bookingDate.toIso8601String(),
      'participants': participants,
      'total_price': totalPrice,
      'currency': currency,
      'status': status.name,
      'special_requirements': specialRequirements,
      'contact_details': contactDetails,
      'payment_reference': paymentReference,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
