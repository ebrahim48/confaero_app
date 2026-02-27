import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final forgetPasswordFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  ForgetPasswordController({String? email}) {
    // Get email from constructor parameter
    print('ForgetPassword - Received email from constructor: $email');
    if (email != null && email.isNotEmpty) {
      emailController.text = email;
      print('Email set in controller: ${emailController.text}');
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
      ToastMessageHelper.showToastMessage(
        "No internet connection. Please check your network and try again.",
        title: 'Error',
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiService.post(
        '/auth/forgot-password',
        data: {'email': emailController.text.trim()},
      );

      isLoading.value = false;

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Verification code sent to your email';

        if (success) {
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          // Navigate to verify screen with email using GoRouter
          context.push('${AppRoutes.verifyScreen}?email=${Uri.encodeComponent(emailController.text.trim())}');
        } else {
          ToastMessageHelper.showToastMessage(message, title: 'Error');
        }
      }
    } catch (e) {
      isLoading.value = false;
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
    
    ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
  }
}
