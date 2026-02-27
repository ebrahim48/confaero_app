import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../presentations/widgets/custom_text_field.dart';
import 'controllers/forget_password_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final String? email;

  const ForgetPasswordScreen({super.key, this.email});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final ForgetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ForgetPasswordController(email: widget.email));
  }

  @override
  void dispose() {
    Get.delete<ForgetPasswordController>();
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
                text: 'Forgot Password',
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),
              SizedBox(height: 12.h),

              CustomText(
                text: 'Enter email address to reset your password.',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor424242.withValues(alpha: 0.7),
                textAlign: TextAlign.center,
                maxline: 2,
              ),
              SizedBox(height: 24.h),

              Form(
                key: controller.forgetPasswordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Email',
                      fontsize: 12.sp,
                      color: AppColors.textColor252525,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      isEmail: true,
                      contentPaddingHorizontal: 16.w,
                      contentPaddingVertical: 14.h,
                      validator: (value) => controller.validateEmail(value),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 280.h),

              Obx(() => CustomButton(
                title: 'Send Code',
                onpress: () => controller.sendResetCode(context),
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
