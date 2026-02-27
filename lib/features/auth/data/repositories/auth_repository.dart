import 'package:logger/logger.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';

class AuthRepository {
  final ConnectivityService _connectivityService;
  final ApiService _apiService;
  final Logger _logger = Logger();

  AuthRepository({
    required ConnectivityService connectivityService,
    required ApiService apiService,
  })  : _connectivityService = connectivityService,
        _apiService = apiService;

  /// Registers a new user with email, password and confirmPassword
  ///
  /// Request Body:
  /// {
  ///   "name": "test user1",
  ///   "email": "user1@gmail.com",
  ///   "password": "123456",
  ///   "confirmPassword": "123456"
  /// }
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Check connectivity
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        _logger.w('Registration failed: No internet connection');
        throw Exception('No internet connection');
      }

      _logger.i('Sending registration request for: $email');

      final response = await _apiService.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      _logger.d('Registration Response Status: ${response.statusCode}');
      _logger.d('Registration Response Data: ${response.data}');

      if (response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        _logger.e('Registration response data is null');
        return {
          'success': false,
          'message': response.statusCode == 200 || response.statusCode == 201
              ? 'Registration successful'
              : 'Request failed',
        };
      }
    } catch (e) {
      _logger.e('Registration Error: $e');
      rethrow;
    }
  }

  /// Login user with email and password
  ///
  /// Request Body:
  /// {
  ///   "email": "attendee@gmail.com",
  ///   "password": "123456"
  /// }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check connectivity
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        _logger.w('Login failed: No internet connection');
        throw Exception('No internet connection');
      }

      _logger.i('Sending login request for: $email');

      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      _logger.d('Login Response Status: ${response.statusCode}');
      _logger.d('Login Response Data: ${response.data}');

      if (response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        _logger.e('Login response data is null');
        return {
          'success': false,
          'message': response.statusCode == 200
              ? 'Login successful'
              : 'Request failed',
        };
      }
    } catch (e) {
      _logger.e('Login Error: $e');
      rethrow;
    }
  }
}
