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
import '../verify_screen.dart';

class VerifyController extends GetxController {
  final pinController = TextEditingController();
  final isLoading = false.obs;
  final email = ''.obs;
  final resendTimer = 60.obs;
  final canResend = false.obs;

  VerifyMode _mode = VerifyMode.passwordReset;

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

  void setMode(VerifyMode mode) {
    _mode = mode;
  }

  bool get isAccountActivation => _mode == VerifyMode.accountActivation;

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
      return;
    }

    if (!await _connectivityService.checkConnectivity()) {
      return;
    }

    isLoading.value = true;

    _logger.i('Verifying code for: ${email.value} (mode: $_mode)');

    if (isAccountActivation) {
      await _verifyAccountActivation(context);
    } else {
      await _verifyPasswordReset(context);
    }
  }

  /// Account activation: POST /auth/verified-account
  Future<void> _verifyAccountActivation(BuildContext context) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifiedAccount,
        data: {'email': email.value, 'code': pinController.text},
        validateStatus: false,
      );

      isLoading.value = false;

      _logger.d(
        'Account verify response - Status: ${response.statusCode}, Data: ${response.data}',
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Account verified successfully';

        if (success) {
          _logger.i('Account verified, navigating to sign in');
          if (!context.mounted) return;
          context.go(AppRoutes.signInScreen);
        } else {
          _logger.w('Account verification failed: $message');
        }
      }
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e('ServerException during account verification', error: e, stackTrace: e.stackTrace);
    } on TimeoutException catch (_) {
      isLoading.value = false;
    } on NoInternetException catch (_) {
      isLoading.value = false;
    } catch (e, stackTrace) {
      isLoading.value = false;
      _logger.e('Exception during account verification', error: e, stackTrace: stackTrace);
    }
  }

  /// Password reset: POST /auth/verify-reset-code
  Future<void> _verifyPasswordReset(BuildContext context) async {
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
          context.pushNamed(
            AppRoutes.resetPasswordScreen,
            queryParameters: {'email': email.value, 'token': resetToken},
          );
        } else {
          _logger.w('Code verification failed: $message');
        }
      }
    } on ServerException catch (e) {
      isLoading.value = false;
      _logger.e(
        'ServerException during code verification',
        error: e,
        stackTrace: e.stackTrace,
      );

      if (e.responseData is Map<String, dynamic>) {
        final data = e.responseData as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message =
            data['message'] as String? ?? 'Code verified successfully';
        final resetData = data['data'] as Map<String, dynamic>?;

        if (success && resetData != null) {
          final resetToken = resetData['resetToken'] as String? ?? '';
          _logger.i('Code verified successfully (despite error status)');
          context.pushNamed(
            AppRoutes.resetPasswordScreen,
            queryParameters: {'email': email.value, 'token': resetToken},
          );
          return;
        }
      }

    } on TimeoutException catch (_) {
      isLoading.value = false;
      _logger.w('Code verification timeout');
    } on NoInternetException catch (_) {
      isLoading.value = false;
      _logger.w('Code verification failed: No internet connection');
    } catch (e, stackTrace) {
      isLoading.value = false;
      _logger.e(
        'Exception during code verification',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> resendCode(BuildContext context) async {
    if (!canResend.value) return;

    if (!await _connectivityService.checkConnectivity()) {
      _logger.w('Resend code failed: No internet connection');
      return;
    }

    _logger.i('Resending verification code to: ${email.value} (mode: $_mode)');

    if (isAccountActivation) {
      await _resendAccountActivationCode();
    } else {
      await _resendPasswordResetCode();
    }
  }

  /// Resend for account activation: POST /auth/new-verification-link
  Future<void> _resendAccountActivationCode() async {
    try {
      final response = await _apiService.post(
        ApiConstants.newVerificationLink,
        data: {'email': email.value},
        validateStatus: false,
      );

      _logger.d(
        'Resend activation code response - Status: ${response.statusCode}, Data: ${response.data}',
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Verification code sent';

        if (success) {
          _logger.i('Activation code resent successfully');
          startResendTimer();
        } else {
          _logger.w('Resend activation code failed: $message');
        }
      }
    } on ServerException catch (e) {
      _logger.e('ServerException during resend activation code', error: e, stackTrace: e.stackTrace);
    } on TimeoutException catch (_) {
    } on NoInternetException catch (_) {
    } catch (e, stackTrace) {
      _logger.e('Exception during resend activation code', error: e, stackTrace: stackTrace);
    }
  }

  /// Resend for password reset: POST /auth/forgot-password
  Future<void> _resendPasswordResetCode() async {
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
          startResendTimer();
        } else {
          _logger.w('Resend code failed: $message');
        }
      }
    } on ServerException catch (e) {
      _logger.e(
        'ServerException during resend code',
        error: e,
        stackTrace: e.stackTrace,
      );

      if (e.responseData is Map<String, dynamic>) {
        final data = e.responseData as Map<String, dynamic>;
        final success = data['success'] as bool? ?? false;
        final message = data['message'] as String? ?? 'Verification code sent';

        if (success) {
          _logger.i('Verification code resent successfully (despite error status)');
          startResendTimer();
          return;
        }
      }

    } on TimeoutException catch (_) {
      _logger.w('Resend code timeout');
    } on NoInternetException catch (_) {
      _logger.w('Resend code failed: No internet connection');
    } catch (e, stackTrace) {
      _logger.e(
        'Exception during resend code',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
