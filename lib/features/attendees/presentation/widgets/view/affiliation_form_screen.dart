import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../controllers/profile_forms_controller.dart';
import '../form_input_widget.dart';

class AffiliationFormScreen extends StatelessWidget {
  const AffiliationFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileFormsController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomText(
                      text: 'Affiliation',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffE1E1E1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: CustomText(
                      text: 'Affiliation',
                      fontsize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor424242,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Company
                  FormInputWidget(
                    controller: controller.companyController,
                    hintText: 'Company',
                  ),

                  SizedBox(height: 12.h),

                  // Position Title
                  FormInputWidget(
                    controller: controller.positionTitleController,
                    hintText: 'Position Title',
                  ),

                  SizedBox(height: 16.h),

                  // From
                  CustomText(
                    text: 'From',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Expanded(
                        child: FormInputWidget(
                          controller: controller.fromYearController,
                          hintText: 'Year',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FormInputWidget(
                          controller: controller.fromMonthController,
                          hintText: 'Month',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // To
                  CustomText(
                    text: 'To',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor424242,
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Expanded(
                        child: FormInputWidget(
                          controller: controller.toYearController,
                          hintText: 'Year',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FormInputWidget(
                          controller: controller.toMonthController,
                          hintText: 'Month',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // I currently work here
                  Obx(
                        () => Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Checkbox(
                            value: controller.currentlyWorkHere.value,
                            onChanged: (value) {
                              controller.currentlyWorkHere.value = value ?? false;
                            },
                            activeColor: const Color(0xff32A69A),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'I currently work here',
                          fontsize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor424242,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Save Button
                  CustomButton(
                    title: 'Save',
                    onpress: () => controller.saveAffiliation(),
                    color: const Color(0xff32A69A),
                    height: 48.h,
                    borderRadius: 8.r,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}