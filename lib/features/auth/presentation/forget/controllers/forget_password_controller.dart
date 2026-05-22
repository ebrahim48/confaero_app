import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final forgetPasswordFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final LoggerHelper _logger = LoggerHelper('ForgetPasswordController');

  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  ForgetPasswordController({String? email}) {
    // Get email from constructor parameter
    if (email != null && email.isNotEmpty) {
      emailController.text = email;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  Future<void> sendResetCode(BuildContext context) async {
    if (!forgetPasswordFormKey.currentState!.validate()) {
      return;
    }

    // Check internet connectivity
    if (!await _connectivityService.checkConnectivity()) {
      return;
    }

    isLoading.value = true;

    final email = emailController.text.trim();
    _logger.i('Sending password reset code to: $email');

    try {
      final response = await _apiService.post(
        ApiConstants.forgetPassword,
        data: {'email': email},
        validateStatus: false,
      );

      isLoading.value = false;

      _logger.d('Reset code response - Status: ${response.statusCode}, Data: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Verification code sent to your email';

        if (success) {
          _logger.i('Password reset code sent successfully to: $email');
          context.pushNamed(
            AppRoutes.verifyScreen,
            queryParameters: {'email': email},
          );
        } else {
          _logger.w('Password reset failed: $message');
        }
      }
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e('ServerException during send reset code', error: e, stackTrace: e.stackTrace);
      
      // Check if response has success data despite error status
      if (e.responseData is Map<String, dynamic>) {
        final data = e.responseData as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Failed to send verification code';

        if (success) {
          _logger.i('Password reset code sent successfully (despite error status)');
          context.pushNamed(
            AppRoutes.verifyScreen,
            queryParameters: {'email': email},
          );
          return;
        }
      }
      
      _handleError(e.toString());
    } on TimeoutException catch (_) {
      isLoading.value = false;
      _logger.w('Send reset code timeout');
    } on NoInternetException catch (_) {
      isLoading.value = false;
      _logger.w('Send reset code failed: No internet connection');
    } catch (e, stackTrace) {
      isLoading.value = false;
      _logger.e('Exception during send reset code', error: e, stackTrace: stackTrace);
      _handleError(e.toString());
    }
  }

  void _handleError(String error) {
    String errorMessage;
    
    if (error.contains('not found') || error.contains('user not found')) {
      errorMessage = "Email address not found. Please check your email or sign up.";
    } else if (error.contains('no internet')) {
      errorMessage = "No internet connection. Please check your network and try again.";
    } else if (error.contains('timeout')) {
      errorMessage = "Request timed out. Please try again.";
    } else {
      errorMessage = "Failed to send verification code. Please try again.";
    }
    
  }
}
