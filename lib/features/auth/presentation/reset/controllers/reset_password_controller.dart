import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  
  final email = ''.obs;
  final resetToken = ''.obs;

  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void onInit() {
    super.onInit();
    // Get email and token from query parameters
    email.value = Get.parameters['email'] ?? '';
    resetToken.value = Get.parameters['token'] ?? '';
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

    try {
      final response = await _apiService.post(
        '/auth/reset-password',
        data: {
          'token': resetToken.value,
          'email': email.value,
          'newPassword': passwordController.text,
          'confirmPassword': confirmPasswordController.text,
        },
      );

      isLoading.value = false;

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Password reset successfully!';

        if (success) {
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          // Navigate to sign in screen using GoRouter
          context.go(AppRoutes.signInScreen);
        } else {
          String errorMessage = data['message'] as String? ?? 'Password reset failed';
          
          // Handle expired token
          if (errorMessage.toLowerCase().contains('expire')) {
            errorMessage = "Your reset link has expired. Please request a new one.";
            ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
            Future.delayed(const Duration(seconds: 2), () {
              context.go(AppRoutes.forgetPasswordScreen);
            });
          } else {
            ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
          }
        }
      }
    } catch (e) {
      isLoading.value = false;
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
