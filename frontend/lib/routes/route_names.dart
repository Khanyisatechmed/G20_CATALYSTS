// routes/route_names.dart
class RouteNames {
  // Auth Routes
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';

  // Main Routes
  static const String home = '/home';
  static const String explore = '/explore';
  static const String bookings = '/bookings';
  static const String marketplace = '/marketplace';
  static const String profile = '/profile';

  // Detail Routes
  static const String destinationDetail = '/destination';
  static const String bookingDetail = '/booking';
  static const String productDetail = '/product';
  static const String accommodationDetail = '/accommodation';

  // Utility Routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String support = '/support';
  static const String privacy = '/privacy';
  static const String payments = '/payments';
}

// core/models/user_model.dart
class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final List<String> interests;
  final DateTime createdAt;
  final int experiences;
  final int reviews;
  final int points;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    required this.interests,
    required this.createdAt,
    this.experiences = 0,
    this.reviews = 0,
    this.points = 0,
    this.isVerified = false,
  });

  String get fullName => '$firstName $lastName';
  String get memberSince => 'Member since ${_formatMonthYear(createdAt)}';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: json['profile_picture'],
      interests: List<String>.from(json['interests'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      experiences: json['experiences'] ?? 0,
      reviews: json['reviews'] ?? 0,
      points: json['points'] ?? 0,
      isVerified: json['is_verified'] ?? false,
    );
  }

  get avatarUrl => null;

  get displayName => null;

  get location => null;

  get membershipLevel => null;

  get experiencesCount => null;

  get placesVisited => null;

  get culturalPoints => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
      'interests': interests,
      'created_at': createdAt.toIso8601String(),
      'experiences': experiences,
      'reviews': reviews,
      'points': points,
      'is_verified': isVerified,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profilePicture,
    List<String>? interests,
    DateTime? createdAt,
    int? experiences,
    int? reviews,
    int? points,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      experiences: experiences ?? this.experiences,
      reviews: reviews ?? this.reviews,
      points: points ?? this.points,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  static String _formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
