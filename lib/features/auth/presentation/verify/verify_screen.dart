import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../widgets/custom_pin_code.dart';
import 'controllers/verify_controller.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late final VerifyController controller;
  String? _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get email from GoRouter query parameters
    if (_email == null) {
      _email = GoRouterState.of(context).uri.queryParameters['email'] ?? '';
      controller = Get.put(VerifyController());
      controller.setEmail(_email!);
    }
  }

  @override
  void dispose() {
    Get.delete<VerifyController>();
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
              SizedBox(height: 56.h),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.textColor424242),
                  onPressed: () => Get.back(),
                ),
              ),
              SizedBox(height: 40.h),
              Image.asset('assets/images/logo.png', width: 169.w, height: 84.h),
              SizedBox(height: 32.h),

              CustomText(
                text: 'Enter verification code',
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),
              SizedBox(height: 12.h),

              Obx(() => CustomText(
                text: 'We\'ve sent a verification code to ${controller.email.value} that will expire in 10 minutes. Please enter the code to continue',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor424242.withValues(alpha: 0.7),
                textAlign: TextAlign.center,
                maxline: 3,
              )),
              SizedBox(height: 32.h),

              CustomPinCodeTextField(
                textEditingController: controller.pinController,
                onChanged: (value) {},
                onCompleted: (value) {},
              ),
              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Didnt receive the code? ',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor424242.withValues(alpha: 0.7),
                  ),
                  Spacer(),
                  Obx(() => GestureDetector(
                    onTap: controller.canResend.value ? () => controller.resendCode(context) : null,
                    child: CustomText(
                      text: controller.canResend.value 
                          ? 'Resend Code' 
                          : 'Resend in ${controller.resendTimer.value}s',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: controller.canResend.value 
                          ? const Color(0xffFF1D1D) 
                          : AppColors.textColor707070,
                    ),
                  )),
                ],
              ),
              SizedBox(height: 200.h),

              Obx(() => CustomButton(
                title: 'Verify',
                onpress: () => controller.verifyCode(context),
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
