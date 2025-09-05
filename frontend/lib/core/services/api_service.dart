// core/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../constants/api_endpoints.dart' as api_endpoints;
import 'storage_service.dart';

class ApiService {
  late Dio _dio;
  final StorageService _storage = StorageService();

  // Connection status
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: api_endpoints.ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
      receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor - Add auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          print('*** Request ***');
          print('uri: ${options.uri}');
          print('method: ${options.method}');
          print('headers: ${options.headers}');
          if (options.data != null) {
            print('data: ${options.data}');
          }
        }

        handler.next(options);
      },

      onResponse: (response, handler) {
        _isOnline = true;
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.requestOptions.path}');
        }
        handler.next(response);
      },

      onError: (error, handler) async {
        if (kDebugMode) {
          print('*** DioException ***:');
          print('uri: ${error.requestOptions.uri}');
          print('${error.type}: ${error.message}');
          if (error.response != null) {
            print('statusCode: ${error.response?.statusCode}');
            print('data: ${error.response?.data}');
          }
        }

        // Update connection status
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout) {
          _isOnline = false;
        }

        // Handle token expiration
        if (error.response?.statusCode == 401) {
          await _handleTokenExpiration();
        }

        handler.next(error);
      },
    ));

    // Logging interceptor for debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => print(obj),
      ));
    }
  }

  Future<void> _handleTokenExpiration() async {
    await _storage.clearToken();
    // Navigate to login screen would be handled by auth provider
    if (kDebugMode) {
      print('Token expired - user needs to re-authenticate');
    }
  }

  // Generic GET request with enhanced error handling
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e ${_getErrorMessage(e)}');
      }
      throw _handleError(e);
    }
  }

  // Generic POST request with enhanced error handling
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e ${_getErrorMessage(e)}');
      }
      throw _handleError(e);
    }
  }

  // Generic PUT request with enhanced error handling
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e ${_getErrorMessage(e)}');
      }
      throw _handleError(e);
    }
  }

  // Generic DELETE request with enhanced error handling
  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e ${_getErrorMessage(e)}');
      }
      throw _handleError(e);
    }
  }

  // File upload with progress tracking
  Future<Response> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'file',
    ProgressCallback? onSendProgress,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path),
        ...?additionalData,
      });

      return await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      if (kDebugMode) {
        print('File upload error: $e');
      }
      throw _handleError(e);
    }
  }

  // Enhanced error handling with more specific messages
  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          _isOnline = false;
          return ApiException('Connection timeout. Please check your internet connection and try again.');
        case DioExceptionType.sendTimeout:
          return ApiException('Upload timeout. Please check your connection and try again.');
        case DioExceptionType.receiveTimeout:
          return ApiException('Server response timeout. Please try again.');
        case DioExceptionType.badResponse:
          return _handleHttpError(error.response!);
        case DioExceptionType.cancel:
          return ApiException('Request was cancelled.');
        case DioExceptionType.connectionError:
          _isOnline = false;
          return ApiException('No internet connection. Please check your network and try again.');
        case DioExceptionType.badCertificate:
          return ApiException('Security certificate error. Please contact support.');
        case DioExceptionType.unknown:
        default:
          if (error.message?.contains('SocketException') == true) {
            _isOnline = false;
            return ApiException('Network connection failed. Please check your internet connection.');
          }
          return ApiException('An unexpected error occurred. Please try again.');
      }
    }
    return ApiException('An unexpected error occurred: ${error.toString()}');
  }

  // Enhanced HTTP error handling with better user messages
  ApiException _handleHttpError(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 400:
        String message = 'Bad request. Please check your input.';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        return ApiException(message);

      case 401:
        return ApiException('Your session has expired. Please log in again.');

      case 403:
        return ApiException('Access denied. You don\'t have permission to perform this action.');

      case 404:
        return ApiException('The requested resource was not found.');

      case 422:
        // Handle validation errors
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          final errorMessage = firstError is List ? firstError.first : firstError;
          return ApiException(errorMessage.toString());
        }
        if (data is Map && data['message'] != null) {
          return ApiException(data['message'].toString());
        }
        return ApiException('Validation error. Please check your input and try again.');

      case 429:
        return ApiException('Too many requests. Please wait a moment and try again.');

      case 500:
        return ApiException('Internal server error. Please try again later.');

      case 502:
        return ApiException('Server temporarily unavailable. Please try again later.');

      case 503:
        return ApiException('Service temporarily unavailable. Please try again later.');

      case 504:
        return ApiException('Server timeout. Please try again later.');

      default:
        String message = 'Server error (${statusCode}). Please try again later.';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
        return ApiException(message);
    }
  }

  // Helper method to get user-friendly error messages
  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.connectionError:
          return 'The connection errored: ${error.message ?? 'Network connection failed'}. This typically indicates an error on the network layer. This indicates an error which most likely cannot be solved by the library.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout occurred';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout occurred';
        case DioExceptionType.badResponse:
          return 'Server returned an error: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request was cancelled';
        case DioExceptionType.unknown:
        default:
          return error.message ?? 'Unknown error occurred';
      }
    }
    return error.toString();
  }

  // Method to check network connectivity
  Future<bool> checkConnectivity() async {
    try {
      final response = await _dio.get('/health-check');
      _isOnline = response.statusCode == 200;
      return _isOnline;
    } catch (e) {
      _isOnline = false;
      return false;
    }
  }

  // Method to retry failed requests
  Future<Response> retryRequest(
    String method,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
  }) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        switch (method.toUpperCase()) {
          case 'GET':
            return await get(endpoint, queryParameters: queryParameters);
          case 'POST':
            return await post(endpoint, data: data);
          case 'PUT':
            return await put(endpoint, data: data);
          case 'DELETE':
            return await delete(endpoint);
          default:
            throw ApiException('Unsupported HTTP method: $method');
        }
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          rethrow;
        }

        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: retryCount * 2));

        if (kDebugMode) {
          print('Retrying request (attempt $retryCount/$maxRetries)');
        }
      }
    }

    throw ApiException('Max retries exceeded');
  }

  // Clean up resources
  void dispose() {
    _dio.close();
  }
}

// Enhanced API Exception class
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(this.message, [this.statusCode, this.originalError]);

  @override
  String toString() => message;

  // Helper methods for specific error types
  bool get isNetworkError =>
      statusCode == null ||
      message.contains('connection') ||
      message.contains('network');

  bool get isServerError =>
      statusCode != null && statusCode! >= 500;

  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  bool get isAuthError => statusCode == 401 || statusCode == 403;
}

// App constants class
class AppConstants {
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;
  static const String appVersion = '1.0.0';

  // Offline data constants
  static const String offlineDataKey = 'offline_marketplace_data';
  static const Duration offlineDataExpiry = Duration(hours: 24);
}
