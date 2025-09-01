// core/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../constants/api_endpoints.dart';
import 'storage_service.dart';

class ApiService {
  late Dio _dio;
  final StorageService _storage = StorageService();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseApiUrl,
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
        handler.next(options);
      },

      onResponse: (response, handler) {
        if (kDebugMode) {
          print('Response: ${response.statusCode} ${response.requestOptions.path}');
        }
        handler.next(response);
      },

      onError: (error, handler) async {
        if (kDebugMode) {
          print('API Error: ${error.response?.statusCode} ${error.message}');
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
      ));
    }
  }

  Future<void> _handleTokenExpiration() async {
    await _storage.clearToken();
    // Navigate to login screen would be handled by auth provider
  }

  // Generic GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // File upload
  Future<Response> uploadFile(String endpoint, File file, {String fieldName = 'file'}) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path),
      });
      return await _dio.post(endpoint, data: formData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException('Connection timeout. Please check your internet connection.');
        case DioExceptionType.badResponse:
          return _handleHttpError(error.response!);
        case DioExceptionType.cancel:
          return ApiException('Request cancelled.');
        case DioExceptionType.unknown:
          return ApiException('Network error. Please check your internet connection.');
        default:
          return ApiException('An unexpected error occurred.');
      }
    }
    return ApiException('An unexpected error occurred.');
  }

  ApiException _handleHttpError(Response response) {
    switch (response.statusCode) {
      case 400:
        return ApiException('Bad request. Please check your input.');
      case 401:
        return ApiException('Unauthorized. Please log in again.');
      case 403:
        return ApiException('Access forbidden.');
      case 404:
        return ApiException('Resource not found.');
      case 422:
        final errors = response.data['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final firstError = errors.values.first;
          return ApiException(firstError is List ? firstError.first : firstError);
        }
        return ApiException('Validation error.');
      case 500:
        return ApiException('Server error. Please try again later.');
      default:
        return ApiException('An error occurred (${response.statusCode}).');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
