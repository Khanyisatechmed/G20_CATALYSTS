// core/models/experience_model.dart
class ExperienceModel {
  final int id;
  final String title;
  final String description;
  final String shortDescription;
  final String category;
  final String location;
  final String province;
  final double pricePerPerson;
  final String currency;
  final int durationHours;
  final int maxParticipants;
  final int minParticipants;
  final String difficultyLevel;
  final List<String> images;
  final List<String> includedItems;
  final List<String> requirements;
  final bool isActive;
  final bool hasAR;
  final String? arContentUrl;
  final double? latitude;
  final double? longitude;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  ExperienceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.shortDescription,
    required this.category,
    required this.location,
    required this.province,
    required this.pricePerPerson,
    this.currency = 'ZAR',
    required this.durationHours,
    required this.maxParticipants,
    this.minParticipants = 1,
    this.difficultyLevel = 'Easy',
    this.images = const [],
    this.includedItems = const [],
    this.requirements = const [],
    this.isActive = true,
    this.hasAR = false,
    this.arContentUrl,
    this.latitude,
    this.longitude,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
  });

  String get formattedPrice => '$currency${pricePerPerson.toInt()}';
  String get formattedDuration => '${durationHours}h';
  String get participantRange => minParticipants == maxParticipants
      ? '$maxParticipants participants'
      : '$minParticipants-$maxParticipants participants';

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      shortDescription: json['short_description'],
      category: json['category'],
      location: json['location'],
      province: json['province'],
      pricePerPerson: json['price_per_person'].toDouble(),
      currency: json['currency'] ?? 'ZAR',
      durationHours: json['duration_hours'],
      maxParticipants: json['max_participants'],
      minParticipants: json['min_participants'] ?? 1,
      difficultyLevel: json['difficulty_level'] ?? 'Easy',
      images: List<String>.from(json['images'] ?? []),
      includedItems: List<String>.from(json['included_items'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      isActive: json['is_active'] ?? true,
      hasAR: json['has_ar'] ?? false,
      arContentUrl: json['ar_content_url'],
      latitude: json['coordinates']?['lat']?.toDouble(),
      longitude: json['coordinates']?['lng']?.toDouble(),
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'short_description': shortDescription,
      'category': category,
      'location': location,
      'province': province,
      'price_per_person': pricePerPerson,
      'currency': currency,
      'duration_hours': durationHours,
      'max_participants': maxParticipants,
      'min_participants': minParticipants,
      'difficulty_level': difficultyLevel,
      'images': images,
      'included_items': includedItems,
      'requirements': requirements,
      'is_active': isActive,
      'has_ar': hasAR,
      'ar_content_url': arContentUrl,
      'coordinates': latitude != null && longitude != null
          ? {'lat': latitude, 'lng': longitude}
          : null,
      'rating': rating,
      'review_count': reviewCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
