// core/constants/api_endpoints.dart

/// API endpoints for Catalystic Wandersapp
class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String prodBaseUrl = 'https://api.ubuntu-destinations.com/v1';

  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';

  // User/Profile endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadAvatar = '/user/avatar';
  static const String userBookings = '/user/bookings';
  static const String userWishlist = '/user/wishlist';
  static const String userReviews = '/user/reviews';
  static const String deleteAccount = '/user/delete';

  // Accommodation endpoints
  static const String accommodations = '/accommodations';
  static const String accommodationDetail = '/accommodations/{id}';
  static const String accommodationSearch = '/accommodations/search';
  static const String accommodationFilter = '/accommodations/filter';
  static const String accommodationAvailability = '/accommodations/{id}/availability';
  static const String accommodationReviews = '/accommodations/{id}/reviews';

  // Experience endpoints
  static const String experiences = '/experiences';
  static const String experienceDetail = '/experiences/{id}';
  static const String experienceSearch = '/experiences/search';
  static const String experienceFilter = '/experiences/filter';
  static const String experienceAvailability = '/experiences/{id}/availability';
  static const String experienceReviews = '/experiences/{id}/reviews';

  // Booking endpoints
  static const String bookings = '/bookings';
  static const String createBooking = '/bookings';
  static const String bookingDetail = '/bookings/{id}';
  static const String cancelBooking = '/bookings/{id}/cancel';
  static const String modifyBooking = '/bookings/{id}';
  static const String bookingPayment = '/bookings/{id}/payment';
  static const String bookingConfirmation = '/bookings/{id}/confirmation';

  // Marketplace endpoints
  static const String products = '/marketplace/products';
  static const String productDetail = '/marketplace/products/{id}';
  static const String productSearch = '/marketplace/products/search';
  static const String productFilter = '/marketplace/products/filter';
  static const String productReviews = '/marketplace/products/{id}/reviews';
  static const String cart = '/marketplace/cart';
  static const String addToCart = '/marketplace/cart/add';
  static const String updateCart = '/marketplace/cart/update';
  static const String removeFromCart = '/marketplace/cart/remove';
  static const String checkout = '/marketplace/checkout';
  static const String orders = '/marketplace/orders';
  static const String orderDetail = '/marketplace/orders/{id}';

  // Wishlist endpoints
  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist/add';
  static const String removeFromWishlist = '/wishlist/remove';

  // Review endpoints
  static const String reviews = '/reviews';
  static const String createReview = '/reviews';
  static const String updateReview = '/reviews/{id}';
  static const String deleteReview = '/reviews/{id}';

  // Search endpoints
  static const String search = '/search';
  static const String searchSuggestions = '/search/suggestions';
  static const String searchHistory = '/search/history';

  // Location endpoints
  static const String locations = '/locations';
  static const String locationDetail = '/locations/{id}';
  static const String nearbyLocations = '/locations/nearby';
  static const String popularDestinations = '/destinations/popular';

  // Cultural content endpoints
  static const String culturalExperiences = '/cultural/experiences';
  static const String culturalStories = '/cultural/stories';
  static const String culturalTraditions = '/cultural/traditions';
  static const String culturalEvents = '/cultural/events';

  // AR/VR endpoints
  static const String arContent = '/ar/content';
  static const String arModels = '/ar/models/{id}';
  static const String arExperiences = '/ar/experiences';

  // Payment endpoints
  static const String paymentMethods = '/payments/methods';
  static const String createPayment = '/payments/create';
  static const String processPayment = '/payments/process';
  static const String paymentStatus = '/payments/{id}/status';
  static const String refunds = '/payments/refunds';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String notificationSettings = '/notifications/settings';

  // Analytics endpoints
  static const String analytics = '/analytics';
  static const String userAnalytics = '/analytics/user';
  static const String contentAnalytics = '/analytics/content';

  // Admin endpoints (if needed)
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminBookings = '/admin/bookings';
  static const String adminReports = '/admin/reports';

  // File upload endpoints
  static const String uploadImage = '/uploads/images';
  static const String uploadDocument = '/uploads/documents';
  static const String uploadVideo = '/uploads/videos';

  // Social features endpoints
  static const String socialFeed = '/social/feed';
  static const String socialPost = '/social/posts';
  static const String socialLike = '/social/like';
  static const String socialComment = '/social/comment';
  static const String socialFollow = '/social/follow';

  // Chat/Support endpoints
  static const String supportTickets = '/support/tickets';
  static const String createSupportTicket = '/support/tickets';
  static const String chatMessages = '/chat/messages';
  static const String chatSessions = '/chat/sessions';

  static String? popularExperiences;

  // Utility methods
  static String getFullUrl(String endpoint) {
    return baseUrl + endpoint;
  }

  static String getProdUrl(String endpoint) {
    return prodBaseUrl + endpoint;
  }

  static String replacePathParam(String endpoint, String param, String value) {
    return endpoint.replaceAll('{$param}', value);
  }

  static String accommodationById(String id) {
    return replacePathParam(accommodationDetail, 'id', id);
  }

  static String experienceById(String id) {
    return replacePathParam(experienceDetail, 'id', id);
  }

  static String bookingById(String id) {
    return replacePathParam(bookingDetail, 'id', id);
  }

  static String productById(String id) {
    return replacePathParam(productDetail, 'id', id);
  }

  static String orderById(String id) {
    return replacePathParam(orderDetail, 'id', id);
  }
}
