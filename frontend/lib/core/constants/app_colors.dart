// core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryDark = Color(0xFF357ABD);
  static const Color primaryLight = Color(0xFF6BA3E8);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF8A65);
  static const Color secondaryDark = Color(0xFFFF6F44);
  static const Color secondaryLight = Color(0xFFFFAB7A);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF8E8E93);

  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // Booking Status Colors
  static const Color confirmed = Color(0xFF28A745);
  static const Color pending = Color(0xFFFFC107);
  static const Color cancelled = Color(0xFFDC3545);
  static const Color completed = Color(0xFF6F42C1);

  // Special Colors
  static const Color orange = Color(0xFFFF8A65);
  static const Color arBlue = Color(0xFF007AFF);
  static const Color culturalGold = Color(0xFFFFD700);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF4A90E2),
    Color(0xFF357ABD),
  ];

  static const List<Color> warmGradient = [
    Color(0xFFFF8A65),
    Color(0xFFFFAB7A),
  ];

  static MaterialColor? get primarySwatch => null;
}

// core/constants/app_strings.dart
class AppStrings {
  // App Info
  static const String appName = 'Catalystic Wanders';
  static const String appTagline = 'Discover Authentic South African Culture';
  static const String version = '1.0.0';

  // Welcome Screen
  static const String welcomeTitle = 'Welcome to Catalystic Wanders';
  static const String welcomeSubtitle = 'Discover authentic South African cultural experiences';
  static const String continueWithEmail = 'Continue with email';
  static const String continueWithGoogle = 'Continue with Google';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUp = 'Sign up';
  static const String language = 'Language';

  // Auth Strings
  static const String login = 'Log in';
  static const String loginToContinue = 'Log in to continue';
  static const String createAccount = 'Create your account';
  static const String emailAddress = 'Email Address';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm password';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String forgotPassword = 'I forgot my password';
  static const String passwordMinLength = 'Password length must be at least 8 characters';
  static const String nameInstruction = 'Please add your full name as it appears in your id';
  static const String yourInterests = 'Your Interests';
  static const String continueButton = 'Continue';

  // Navigation
  static const String home = 'Home';
  static const String explore = 'Explore';
  static const String bookings = 'Bookings';
  static const String marketplace = 'Market';
  static const String profile = 'Profile';

  // Home Screen
  static const String popularExperiences = 'Popular Experiences';
  static const String trendingARPackages = 'Trending AR Packages';
  static const String seeAll = 'See all';
  static const String search = 'Search...';

  // Explore Screen
  static const String searchDestinations = 'Search destinations...';
  static const String filter = 'Filter';
  static const String listView = 'List View';
  static const String mapView = 'Map View';
  static const String categories = 'Categories';
  static const String priceRange = 'Price Range';
  static const String location = 'Location';
  static const String clearAllFilters = 'Clear All Filters';

  // Bookings Screen
  static const String myBookings = 'My Bookings';
  static const String allBookings = 'All';
  static const String upcomingBookings = 'Upcoming';
  static const String completedBookings = 'Completed';
  static const String cancelledBookings = 'Cancelled';
  static const String bookNewExperience = 'Book New Experience';
  static const String exportHistory = 'Export History';
  static const String cancelBooking = 'Cancel Booking';
  static const String modifyBooking = 'Modify';

  // Marketplace Screen
  static const String localMarketplace = 'Local Market place';
  static const String searchProducts = 'Search local products...';
  static const String featuredProducts = 'Featured Products';
  static const String viewDetails = 'View Details';
  static const String viewInAR = 'View in AR';
  static const String addToCart = 'Add to Cart';

  // Profile Screen
  static const String memberSince = 'Member since';
  static const String experiences = 'Experiences';
  static const String reviews = 'Reviews';
  static const String points = 'Points';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy';
  static const String payments = 'Payments';
  static const String helpSupport = 'Help & Support';
  static const String signOut = 'Sign Out';
  static const String editProfile = 'Edit Profile';
  static const String shareProfile = 'Share Profile';

  // Accommodation Screen
  static const String homeAwayFromHome = 'Home away from home';
  static const String accommodationDescription = 'Find the perfect place to stay for your rural getaway. Our curated selection of lodges, guesthouses, homestays, and eco-friendly retreats offers comfort, authenticity, and a true taste of local culture.';
  static const String propertyType = 'Property Type';
  static const String pricePerNight = 'Price per Night';
  static const String amenities = 'Amenities';
  static const String numberOfGuests = 'Number of Guests';
  static const String book = 'Book';

  // Cultural Context
  static const String culturalSignificance = 'Cultural Significance';
  static const String aboutExperience = 'About This Experience';
  static const String bookExperience = 'Book Experience';
  static const String share = 'Share';
  static const String arExperience = 'AR Experience';

  // Error Messages
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String selectInterests = 'Please select at least one interest';

  // Success Messages
  static const String loginSuccess = 'Welcome back!';
  static const String signUpSuccess = 'Account created successfully!';
  static const String bookingConfirmed = 'Booking confirmed!';
  static const String addedToCart = 'Added to cart';
  static const String profileUpdated = 'Profile updated successfully';

  // Common Actions
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String retry = 'Retry';
  static const String close = 'Close';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String done = 'Done';

  // Loading States
  static const String loading = 'Loading...';
  static const String loadingExperiences = 'Loading experiences...';
  static const String loadingDestinations = 'Loading destinations...';
  static const String loadingBookings = 'Loading bookings...';
  static const String loadingProducts = 'Loading products...';

  // Empty States
  static const String noExperiences = 'No experiences found';
  static const String noDestinations = 'No destinations found';
  static const String noBookings = 'No bookings yet';
  static const String noProducts = 'No products available';
  static const String noResults = 'No results found';

  // Currencies
  static const String zarCurrency = 'ZAR';
  static const String usdCurrency = 'USD';

  // Languages
  static const String english = 'English';
  static const String afrikaans = 'Afrikaans';
  static const String zulu = 'isiZulu';
  static const String sesotho = 'Sesotho';
  static const String xhosa = 'isiXhosa';
}

// core/constants/api_endpoints.dart
class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';
  static const String baseApiUrl = '$baseUrl$apiVersion';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User Endpoints
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadAvatar = '/users/avatar';
  static const String getUserStats = '/users/stats';

  // Experience Endpoints
  static const String experiences = '/experiences';
  static const String popularExperiences = '/experiences/popular';
  static const String experiencesByCategory = '/experiences/category';
  static const String searchExperiences = '/experiences/search';
  static const String experienceDetails = '/experiences';

  // Destination Endpoints
  static const String destinations = '/destinations';
  static const String searchDestinations = '/destinations/search';
  static const String destinationDetails = '/destinations';
  static const String destinationsByProvince = '/destinations/province';

  // Booking Endpoints
  static const String bookings = '/bookings';
  static const String createBooking = '/bookings';
  static const String bookingDetails = '/bookings';
  static const String cancelBooking = '/bookings';
  static const String modifyBooking = '/bookings';
  static const String bookingHistory = '/bookings/history';

  // Marketplace Endpoints
  static const String products = '/marketplace/products';
  static const String productDetails = '/marketplace/products';
  static const String searchProducts = '/marketplace/search';
  static const String productsByCategory = '/marketplace/category';
  static const String addToCart = '/marketplace/cart';
  static const String cart = '/marketplace/cart';
  static const String checkout = '/marketplace/checkout';

  // Accommodation Endpoints
  static const String accommodations = '/accommodations';
  static const String searchAccommodations = '/accommodations/search';
  static const String accommodationDetails = '/accommodations';
  static const String bookAccommodation = '/accommodations/book';

  // Review Endpoints
  static const String reviews = '/reviews';
  static const String createReview = '/reviews';
  static const String updateReview = '/reviews';
  static const String deleteReview = '/reviews';

  // Upload Endpoints
  static const String uploadImage = '/uploads/image';
  static const String uploadFile = '/uploads/file';

  // Utility Methods
  static String experienceDetail(int id) => '$experiences/$id';
  static String destinationDetail(int id) => '$destinations/$id';
  static String bookingDetail(int id) => '$bookings/$id';
  static String productDetail(int id) => '$products/$id';
  static String accommodationDetail(int id) => '$accommodations/$id';
  static String userBookings(int userId) => '/users/$userId/bookings';
  static String userReviews(int userId) => '/users/$userId/reviews';
}

// core/constants/app_constants.dart
class AppConstants {
  // App Configuration
  static const String appName = 'Catalystic Wanders';
  static const String packageName = 'com.ubuntu.destinations';
  static const bool isDebugMode = true;

  // API Configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  static const int cacheExpirationHours = 24;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image Configuration
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 85;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Validation Constants
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  static const int maxReviewLength = 1000;

  // Price Configuration
  static const double minPrice = 0.0;
  static const double maxPrice = 10000.0;
  static const String defaultCurrency = 'ZAR';

  // Booking Configuration
  static const int maxParticipants = 50;
  static const int minParticipants = 1;
  static const int maxAdvanceBookingDays = 365;
  static const int minAdvanceBookingHours = 24;

  // AR Configuration
  static const bool arEnabled = true;
  static const List<String> supportedARFormats = ['glb', 'gltf', 'usdz'];
  static const double maxARModelSizeMB = 50.0;

  // Map Configuration
  static const double defaultLatitude = -25.7479;  // South Africa center
  static const double defaultLongitude = 28.2293;
  static const double defaultZoom = 6.0;
  static const double maxZoom = 20.0;
  static const double minZoom = 2.0;

  // Cache Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String languageKey = 'selected_language';
  static const String themeKey = 'selected_theme';

  // Cultural Categories
  static const List<String> cultureCategories = [
    'History',
    'Art',
    'Culture',
    'Adventure',
    'Food',
    'Music',
    'Dance',
    'Crafts',
    'Nature',
    'Wildlife',
    'Photography',
  ];

  // South African Provinces
  static const List<String> provinces = [
    'Eastern Cape',
    'Free State',
    'Gauteng',
    'KwaZulu-Natal',
    'Limpopo',
    'Mpumalanga',
    'Northern Cape',
    'North West',
    'Western Cape',
  ];

  // Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'af': 'Afrikaans',
    'zu': 'isiZulu',
    'st': 'Sesotho',
    'xh': 'isiXhosa',
    'ss': 'siSwati',
    'tn': 'Setswana',
    've': 'Tshivenda',
    'ts': 'Xitsonga',
    'nr': 'isiNdebele',
    'nso': 'Sepedi',
  };

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String namePattern = r"^[a-zA-Z\s\-\';\.]+$";

  // Social Media
  static const String facebookUrl = 'https://facebook.com/ubuntudestinations';
  static const String twitterUrl = 'https://twitter.com/ubuntudest';
  static const String instagramUrl = 'https://instagram.com/ubuntudestinations';
  static const String websiteUrl = 'https://ubuntu-destinations.com';

  // Support
  static const String supportEmail = 'support@ubuntu-destinations.com';
  static const String supportPhone = '+27 11 123 4567';
  static const String privacyPolicyUrl = 'https://ubuntu-destinations.com/privacy';
  static const String termsUrl = 'https://ubuntu-destinations.com/terms';
}
