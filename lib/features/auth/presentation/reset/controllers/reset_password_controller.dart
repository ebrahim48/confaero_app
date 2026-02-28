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

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final LoggerHelper _logger = LoggerHelper('ResetPasswordController');

  final email = ''.obs;
  final resetToken = ''.obs;

  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void onInit() {
    super.onInit();
    // Email and token are set via setEmailAndToken from GoRouter
  }

  void setEmailAndToken(String emailValue, String tokenValue) {
    email.value = emailValue;
    resetToken.value = tokenValue;
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm password";
    }
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> resetPassword(BuildContext context) async {
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }

    if (!await _connectivityService.checkConnectivity()) {
      ToastMessageHelper.showToastMessage(
        "No internet connection. Please check your network and try again.",
        title: 'Error',
      );
      return;
    }

    isLoading.value = true;

    _logger.i('Password reset request for: ${email.value}');

    try {
      final response = await _apiService.post(
        ApiConstants.resetPassword,
        data: {
          'token': resetToken.value,
          'email': email.value,
          'newPassword': passwordController.text,
          'confirmPassword': confirmPasswordController.text,
        },
        validateStatus: false,
      );

      isLoading.value = false;

      _logger.d('Reset password response - Status: ${response.statusCode}, Data: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Password reset successfully!';

        if (success) {
          _logger.i('Password reset successful, navigating to sign in');
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          context.go(AppRoutes.signInScreen);
        } else {
          _logger.w('Password reset failed: $message');
          String errorMessage = data['message'] as String? ?? 'Password reset failed';

          // Handle expired token
          if (errorMessage.toLowerCase().contains('expire')) {
            errorMessage = "Your reset link has expired. Please request a new one.";
            _logger.w('Token expired, redirecting to forget password');
            ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
            Future.delayed(const Duration(seconds: 2), () {
              context.go(AppRoutes.forgetPasswordScreen);
            });
          } else {
            ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
          }
        }
      }
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e('ServerException during password reset', error: e, stackTrace: e.stackTrace);
      
      // Check if response has success data despite error status
      if (e.responseData is Map<String, dynamic>) {
        final data = e.responseData as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Password reset failed';

        if (success) {
          _logger.i('Password reset successful (despite error status)');
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          context.go(AppRoutes.signInScreen);
          return;
        }
      }

      _handleError(context, e.toString());
    } on TimeoutException catch (_) {
      isLoading.value = false;
      _logger.w('Password reset timeout');
      ToastMessageHelper.showToastMessage(
        'Request timed out. Please try again.',
        title: 'Error',
      );
    } on NoInternetException catch (_) {
      isLoading.value = false;
      _logger.w('Password reset failed: No internet connection');
      ToastMessageHelper.showToastMessage(
        'No internet connection. Please check your network and try again.',
        title: 'Error',
      );
    } catch (e, stackTrace) {
      isLoading.value = false;
      _logger.e('Exception during password reset', error: e, stackTrace: stackTrace);
      _handleError(context, e.toString());
    }
  }

  void _handleError(BuildContext context, String error) {
    String errorMessage;
    
    if (error.contains('expire') || error.contains('expired') || error.contains('invalid token')) {
      errorMessage = "Your reset link has expired. Please request a new one.";
      ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
      Future.delayed(const Duration(seconds: 2), () {
        context.go(AppRoutes.forgetPasswordScreen);
      });
    } else if (error.contains('no internet')) {
      errorMessage = "No internet connection. Please check your network and try again.";
      ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
    } else if (error.contains('timeout')) {
      errorMessage = "Request timed out. Please try again.";
      ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
    } else {
      errorMessage = "Password reset failed. Please try again.";
      ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
    }
  }
}
