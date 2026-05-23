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
  }) : _connectivityService = connectivityService,
       _apiService = apiService;

  //*-------------- Google Sign In ----------------//
  Future<Map<String, dynamic>> googleSignIn({required String idToken}) async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        _logger.w('Google sign-in failed: No internet connection');
        throw Exception('No internet connection');
      }

      _logger.i('Sending Google sign-in request to backend');

      final response = await _apiService.post(
        ApiConstants.googleSignIn,
        data: {'idToken': idToken},
      );

      _logger.d('Google Sign-In Response Status: ${response.statusCode}');
      _logger.d('Google Sign-In Response Data: ${response.data}');

      if (response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'success': false,
          'message': response.statusCode == 200 ? 'Success' : 'Request failed',
        };
      }
    } catch (e) {
      _logger.e('Google Sign-In Error: $e');
      rethrow;
    }
  }

  //*-------------- Register----------------//
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
          'message':
              response.statusCode == 200 || response.statusCode == 201
                  ? 'Registration successful'
                  : 'Request failed',
        };
      }
    } catch (e) {
      _logger.e('Registration Error: $e');
      rethrow;
    }
  }

  //*---------------Login-----------------//
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
        data: {'email': email, 'password': password},
      );

      _logger.d('Login Response Status: ${response.statusCode}');
      _logger.d('Login Response Data: ${response.data}');

      if (response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        _logger.e('Login response data is null');
        return {
          'success': false,
          'message':
              response.statusCode == 200
                  ? 'Login successful'
                  : 'Request failed',
        };
      }
    } catch (e) {
      _logger.e('Login Error: $e');
      rethrow;
    }
  }

  //*------------Change Password----------------//
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final response = await _apiService.post(
        ApiConstants.changePassword,
        data: {
          'oldPassword': currentPassword,  // Backend expects 'oldPassword'
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.e('Change Password Error: $e');
      rethrow;
    }
  }

  //*------------Get Current User Details----------------//
  Future<Map<String, dynamic>> getMe() async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final response = await _apiService.get(ApiConstants.getMe);
      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.e('Get Me Error: $e');
      rethrow;
    }
  }

  //*------------Delete Account----------------//
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final response = await _apiService.delete(ApiConstants.deleteAccount);
      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.e('Delete Account Error: $e');
      rethrow;
    }
  }

  //*------------Toggle Email Notification----------------//
  Future<Map<String, dynamic>> toggleNotification(bool enable) async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final response = await _apiService.patch(
        ApiConstants.toggleNotification,
        data: {'emailNotification': enable},
      );

      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.e('Toggle Notification Error: $e');
      rethrow;
    }
  }

  //*------------Change Role----------------//
  Future<Map<String, dynamic>> changeRole(String role) async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) throw Exception('No internet connection');

      final response = await _apiService.post(
        ApiConstants.changeRole,
        data: {'role': role},
      );
      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.e('Change Role Error: $e');
      rethrow;
    }
  }

  //*------------Get My Roles----------------//
  Future<Map<String, dynamic>> getMyRoles() async {
    try {
      final isConnected = await _connectivityService.checkConnectivity();
      if (!isConnected) throw Exception('No internet connection');

      final response = await _apiService.get(ApiConstants.getMyRoles);
      return response.data as Map<String, dynamic>? ?? {};
    } catch (e) {
      _logger.e('Get My Roles Error: $e');
      rethrow;
    }
  }
}
