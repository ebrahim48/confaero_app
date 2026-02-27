import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class VerifyController extends GetxController {
  final pinController = TextEditingController();
  final isLoading = false.obs;
  final email = ''.obs;
  final resendTimer = 60.obs;
  final canResend = false.obs;

  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void onInit() {
    super.onInit();
    // Get email from query parameters
    email.value = Get.parameters['email'] ?? '';
    startResendTimer();
  }

  @override
  void onClose() {
    pinController.dispose();
    super.onClose();
  }

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;
    
    Future.delayed(const Duration(seconds: 1), () async {
      while (resendTimer.value > 0) {
        await Future.delayed(const Duration(seconds: 1));
        resendTimer.value--;
      }
      canResend.value = true;
    });
  }

  Future<void> verifyCode(BuildContext context) async {
    if (pinController.text.length != 6) {
      ToastMessageHelper.showToastMessage(
        "Please enter a 6-digit verification code",
        title: 'Error',
      );
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
        '/auth/verify-reset-code',
        data: {'email': email.value, 'code': pinController.text},
      );

      isLoading.value = false;

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Code verified successfully';
        final resetData = data['data'] as Map<String, dynamic>?;

        if (success && resetData != null) {
          final resetToken = resetData['resetToken'] as String? ?? '';
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          // Navigate to reset password with email and token using GoRouter
          context.push('${AppRoutes.resetPasswordScreen}?email=${Uri.encodeComponent(email.value)}&token=${Uri.encodeComponent(resetToken)}');
        } else {
          ToastMessageHelper.showToastMessage(
            data['message'] as String? ?? 'Invalid or expired code',
            title: 'Error',
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      _handleError(e.toString());
    }
  }

  Future<void> resendCode(BuildContext context) async {
    if (!canResend.value) return;

    if (!await _connectivityService.checkConnectivity()) {
      ToastMessageHelper.showToastMessage(
        "No internet connection. Please check your network and try again.",
        title: 'Error',
      );
      return;
    }

    try {
      final response = await _apiService.post(
        '/auth/forgot-password',
        data: {'email': email.value},
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Verification code sent';

        if (success) {
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          startResendTimer();
        } else {
          ToastMessageHelper.showToastMessage(message, title: 'Error');
        }
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage(
        "Failed to resend code. Please try again.",
        title: 'Error',
      );
    }
  }

  void _handleError(String error) {
    String errorMessage;
    
    if (error.contains('invalid') || error.contains('expired')) {
      errorMessage = "Invalid or expired code. Please try again.";
    } else if (error.contains('no internet')) {
      errorMessage = "No internet connection. Please check your network and try again.";
    } else if (error.contains('timeout')) {
      errorMessage = "Request timed out. Please try again.";
    } else {
      errorMessage = "Verification failed. Please try again.";
    }
    
    ToastMessageHelper.showToastMessage(errorMessage, title: 'Error');
  }
}
