// core/utils/validators.dart
import 'package:frontend/core/constants/app_colors.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length > AppConstants.maxNameLength) {
      return '$fieldName must be less than ${AppConstants.maxNameLength} characters';
    }

    final nameRegex = RegExp(AppConstants.namePattern);
    if (!nameRegex.hasMatch(value)) {
      return 'Please enter a valid $fieldName';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, {String fieldName = 'Field'}) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price < AppConstants.minPrice) {
      return 'Price must be greater than ${AppConstants.minPrice}';
    }

    if (price > AppConstants.maxPrice) {
      return 'Price must be less than ${AppConstants.maxPrice}';
    }

    return null;
  }

  static String? validateParticipants(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of participants is required';
    }

    final participants = int.tryParse(value);
    if (participants == null) {
      return 'Please enter a valid number';
    }

    if (participants < AppConstants.minParticipants) {
      return 'Must have at least ${AppConstants.minParticipants} participant';
    }

    if (participants > AppConstants.maxParticipants) {
      return 'Maximum ${AppConstants.maxParticipants} participants allowed';
    }

    return null;
  }
}
