import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../widgets/custom_pin_code.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isPinComplete = false;

  @override
  void dispose() {
    _pinController.dispose();
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // AppBar with back button
              SizedBox(
                height: 56.h,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textColor424242,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Logo
              Image.asset(
                'assets/images/logo.png',
                width: 169.w,
                height: 84.h,
              ),

              SizedBox(height: 32.h),

              // Enter verification code Title
              CustomText(
                text: 'Enter verification code',
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),

              SizedBox(height: 12.h),

              // Description
              CustomText(
                text:
                'We ve sent a verification code to example@gmail.com that will expire in 10 minutes. Please enter the code to continue',
              fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor424242.withValues(alpha: 0.7),
                textAlign: TextAlign.center,
                maxline: 3,
              ),

              SizedBox(height: 32.h),

              // PIN Code TextField
              CustomPinCodeTextField(
                textEditingController: _pinController,
                onChanged: (value) {
                  setState(() {
                    _isPinComplete = value.length == 6;
                  });
                },
                onCompleted: (value) {
                  setState(() {
                    _isPinComplete = true;
                  });
                },
              ),

              SizedBox(height: 24.h),

              // Resend Code
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
                  GestureDetector(
                    onTap: () {
                      // Resend code logic
                      print('Resending code...');
                    },
                    child: CustomText(
                      text: 'Resend Code',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffFF1D1D),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 200.h),

             CustomButton(title: 'Verify', onpress: () {
               context.pushNamed(AppRoutes.resetPasswordScreen);

             },),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}