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

class VerifyController extends GetxController {
  final pinController = TextEditingController();
  final isLoading = false.obs;
  final email = ''.obs;
  final resendTimer = 60.obs;
  final canResend = false.obs;

  final LoggerHelper _logger = LoggerHelper('VerifyController');

  final ApiService _apiService = ApiService();
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  void setEmail(String emailValue) {
    email.value = emailValue;
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

    _logger.i('Verifying code for: ${email.value}');

    try {
      final response = await _apiService.post(
        ApiConstants.verifyResetCode,
        data: {'email': email.value, 'code': pinController.text},
        validateStatus: false,
      );

      isLoading.value = false;

      _logger.d(
        'Verify response - Status: ${response.statusCode}, Data: ${response.data}',
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message =
            data['message'] as String? ?? 'Code verified successfully';
        final resetData = data['data'] as Map<String, dynamic>?;

        if (success && resetData != null) {
          final resetToken = resetData['resetToken'] as String? ?? '';
          _logger.i('Code verified successfully, navigating to reset password');
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          context.pushNamed(
            AppRoutes.resetPasswordScreen,
            queryParameters: {'email': email.value, 'token': resetToken},
          );
        } else {
          _logger.w('Code verification failed: $message');
          ToastMessageHelper.showToastMessage(message, title: 'Error');
        }
      }
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e(
        'ServerException during code verification',
        error: e,
        stackTrace: e.stackTrace,
      );

      // Check if response has success data despite error status
      if (e.responseData is Map<String, dynamic>) {
        final data = e.responseData as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message =
            data['message'] as String? ?? 'Code verified successfully';
        final resetData = data['data'] as Map<String, dynamic>?;

        if (success && resetData != null) {
          final resetToken = resetData['resetToken'] as String? ?? '';
          _logger.i('Code verified successfully (despite error status)');
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          context.pushNamed(
            AppRoutes.resetPasswordScreen,
            queryParameters: {'email': email.value, 'token': resetToken},
          );
          return;
        }
      }

      ToastMessageHelper.showToastMessage(e.message, title: 'Error');
    } on TimeoutException catch (_) {
      isLoading.value = false;
      _logger.w('Code verification timeout');
      ToastMessageHelper.showToastMessage(
        'Request timed out. Please try again.',
        title: 'Error',
      );
    } on NoInternetException catch (_) {
      isLoading.value = false;
      _logger.w('Code verification failed: No internet connection');
      ToastMessageHelper.showToastMessage(
        'No internet connection. Please check your network and try again.',
        title: 'Error',
      );
    } catch (e, stackTrace) {
      isLoading.value = false;
      _logger.e(
        'Exception during code verification',
        error: e,
        stackTrace: stackTrace,
      );
      ToastMessageHelper.showToastMessage(
        'Verification failed. Please try again.',
        title: 'Error',
      );
    }
  }

  Future<void> resendCode(BuildContext context) async {
    if (!canResend.value) return;

    if (!await _connectivityService.checkConnectivity()) {
      _logger.w('Resend code failed: No internet connection');
      ToastMessageHelper.showToastMessage(
        "No internet connection. Please check your network and try again.",
        title: 'Error',
      );
      return;
    }

    _logger.i('Resending verification code to: ${email.value}');

    try {
      final response = await _apiService.post(
        ApiConstants.forgetPassword,
        data: {'email': email.value},
        validateStatus: false,
      );

      _logger.d(
        'Resend code response - Status: ${response.statusCode}, Data: ${response.data}',
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Verification code sent';

        if (success) {
          _logger.i('Verification code resent successfully');
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          startResendTimer();
        } else {
          _logger.w('Resend code failed: $message');
          ToastMessageHelper.showToastMessage(message, title: 'Error');
        }
      }
    } on ServerException catch (e) {
      _logger.e(
        'ServerException during resend code',
        error: e,
        stackTrace: e.stackTrace,
      );

      // Check if response has success data despite error status
      if (e.responseData is Map<String, dynamic>) {
        final data = e.responseData as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Verification code sent';

        if (success) {
          _logger.i(
            'Verification code resent successfully (despite error status)',
          );
          ToastMessageHelper.showToastMessage(message, title: 'Success');
          startResendTimer();
          return;
        }
      }

      ToastMessageHelper.showToastMessage(
        'Failed to resend code. Please try again.',
        title: 'Error',
      );
    } on TimeoutException catch (_) {
      _logger.w('Resend code timeout');
      ToastMessageHelper.showToastMessage(
        'Request timed out. Please try again.',
        title: 'Error',
      );
    } on NoInternetException catch (_) {
      _logger.w('Resend code failed: No internet connection');
      ToastMessageHelper.showToastMessage(
        'No internet connection. Please check your network and try again.',
        title: 'Error',
      );
    } catch (e, stackTrace) {
      _logger.e(
        'Exception during resend code',
        error: e,
        stackTrace: stackTrace,
      );
      ToastMessageHelper.showToastMessage(
        'Failed to resend code. Please try again.',
        title: 'Error',
      );
    }
  }
}
