import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../presentations/widgets/custom_text_field.dart';
import 'controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final ResetPasswordController controller;
  String? _email;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_email == null) {
      // Get email and token from GoRouter query parameters
      final state = GoRouterState.of(context);
      _email = state.uri.queryParameters['email'] ?? '';
      _token = state.uri.queryParameters['token'] ?? '';
      
      controller = Get.put(ResetPasswordController());
      controller.setEmailAndToken(_email!, _token!);
    }
  }

  @override
  void dispose() {
    Get.delete<ResetPasswordController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Image.asset('assets/images/logo.png', width: 169.w, height: 84.h),
              SizedBox(height: 32.h),

              CustomText(
                text: 'Reset Password',
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),
              SizedBox(height: 12.h),

              CustomText(
                text: 'Enter and confirm your new password below to reset your account access. Your new password must be at least 6 characters long',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor424242.withValues(alpha: 0.7),
                textAlign: TextAlign.center,
                maxline: 2,
              ),
              SizedBox(height: 24.h),

              Form(
                key: controller.resetPasswordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'New Password *',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242,
                      left: 2.w,
                      bottom: 8.h,
                    ),
                    CustomTextField(
                      controller: controller.passwordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      contentPaddingHorizontal: 16.w,
                      contentPaddingVertical: 14.h,
                      validator: (value) => controller.validatePassword(value),
                    ),
                    SizedBox(height: 16.h),

                    CustomText(
                      text: 'Confirm Password *',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor424242,
                      left: 2.w,
                      bottom: 8.h,
                    ),
                    CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: 'Confirm your password',
                      isPassword: true,
                      validator: (value) => controller.validateConfirmPassword(value),
                      contentPaddingHorizontal: 16.w,
                      contentPaddingVertical: 14.h,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100.h),

              Obx(() => CustomButton(
                title: 'Reset Password',
                onpress: () => controller.resetPassword(context),
                loading: controller.isLoading.value,
              )),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
