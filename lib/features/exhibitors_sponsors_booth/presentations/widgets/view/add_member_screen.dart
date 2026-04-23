import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../controllers/booth_staff_controller.dart';


class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoothStaffController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text(
          'Add Member',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the email address to invite as staff.',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textColor7E7F7E,
              ),
            ),
            SizedBox(height: 20.h),

            // Email Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderColorD2D2D2),
              ),
              child: TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textColor424242),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 14.h),
                  hintText: 'Current Email',
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(Icons.email_outlined,
                        size: 20.sp, color: AppColors.textColor7E7F7E),
                  ),
                  prefixIconConstraints:
                  BoxConstraints(minWidth: 20.w, minHeight: 20.h),
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(Icons.visibility_off_outlined,
                        size: 20.sp, color: AppColors.textColor7E7F7E),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Info text
            Center(
              child: Text(
                'This will create family account in the system.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textColor7E7F7E,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 16.h),

            // Add Member Button
            Obx(() => CustomButton(
              title: 'Add Member',
              loading: controller.isLoading.value,
              onpress: controller.addMember,
            )),
          ],
        ),
      ),
    );
  }
}