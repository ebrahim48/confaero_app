import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../presentations/widgets/custom_text_field.dart';




class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {




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
              AppBar(
              ),
              SizedBox(height: 40.h),

              // Logo
              Image.asset(
                'assets/images/logo.png',
                width: 169.w,
                height: 84.h,
              ),

              SizedBox(height: 32.h),

              // Sign In Now Title
              CustomText(
                text: 'Reset Password',
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),

              SizedBox(height: 12.h),

              // Description
              CustomText(
                text: 'Enter and confirm your new password below to reset your account access. Your new password must be at least 8 characters long',
                fontsize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor424242.withValues(alpha: 0.7),
                textAlign: TextAlign.center,
                maxline: 2,
              ),
              SizedBox(height: 24.h),

             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // Password Field
                 CustomText(
                   text: 'New Password *',
                   fontsize: 14.sp,
                   fontWeight: FontWeight.w500,
                   color: AppColors.textColor424242,
                   left: 2.w,
                   bottom: 8.h,
                 ),
                 CustomTextField(
                   controller: passwordController,
                   hintText: 'Enter your password',
                   isPassword: true,
                   contentPaddingHorizontal: 16.w,
                   contentPaddingVertical: 14.h,
                 ),

                 SizedBox(height: 16.h),

                 // Confirm Password Field
                 CustomText(
                   text: 'Confirm Password *',
                   fontsize: 14.sp,
                   fontWeight: FontWeight.w500,
                   color: AppColors.textColor424242,
                   left: 2.w,
                   bottom: 8.h,
                 ),
                 CustomTextField(
                   controller: confirmPasswordController,
                   hintText: 'Confirm your password',
                   isPassword: true,
                   // validator: (value) => validateConfirmPassword(value),
                   contentPaddingHorizontal: 16.w,
                   contentPaddingVertical: 14.h,
                 ),
               ],
             ),
              SizedBox(height: 100.h,),
              CustomButton(
                title: 'Reset Password',
                onpress: () {

                  context.pushNamed(AppRoutes.signInScreen);

                },),






              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
}