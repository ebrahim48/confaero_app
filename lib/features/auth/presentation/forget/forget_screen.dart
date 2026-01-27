import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../presentations/widgets/custom_text_field.dart';
import '../../../attendees/presentation/widgets/custom_app_bar_widget.dart';




class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
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
                text: 'Forgot Password',
                fontsize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor424242,
              ),

              SizedBox(height: 12.h),

              // Description
              CustomText(
                text: 'Enter email address to reset your password.',
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
                  CustomText(
                    textAlign: TextAlign.start,
                    text: 'Email',
                    fontsize: 12.sp,
                    color: AppColors.textColor252525,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    isEmail: true,
                    contentPaddingHorizontal: 16.w,
                    contentPaddingVertical: 14.h,
                  ),
                ],
              ),

             SizedBox(height: 280.h,),
              CustomButton(
                  title: 'Send Code',
                  onpress: () {

                    context.pushNamed(AppRoutes.verifyScreen);

                  },),






              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  final  emailController = TextEditingController();
}