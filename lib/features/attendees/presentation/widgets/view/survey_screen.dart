import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/resources_controller.dart';
import '../custom_app_bar_widget.dart';
import '../multiline_text_field_widget.dart';
import '../survey_radio_option.dart';
import '../survey_star_rating_widgets.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResourcesController controller = Get.find<ResourcesController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(
            title: 'Resources',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomText(
                    text: 'Event Feedback Survey',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 4.h),

                  // Subtitle
                  CustomText(
                    text: 'Please share your experience.',
                    fontsize: 14.sp,
                    color: const Color(0xff757575),
                  ),
                  SizedBox(height: 24.h),

                  // Question 1: Rating
                  CustomText(
                    text: '1. How would you rate this event?',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 12.h),

                  Obx(() {
                    return StarRating(
                      rating: controller.selectedRating.value,
                      onRatingChanged: (rating) {
                        controller.setRating(rating);
                      },
                    );
                  }),
                  SizedBox(height: 24.h),

                  // Question 2: Yes/No
                  CustomText(
                    text: '2. Was the sessions content helpful?',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 12.h),

                  Obx(() {
                    return Column(
                      children: [
                        RadioOption(
                          text: 'Yes',
                          isSelected: controller.selectedOption.value == 'Yes',
                          onTap: () => controller.setOption('Yes'),
                        ),
                        RadioOption(
                          text: 'No',
                          isSelected: controller.selectedOption.value == 'No',
                          onTap: () => controller.setOption('No'),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 24.h),

                  // Question 3: Suggestions
                  CustomText(
                    text: '3. Any suggestions? (optional)',
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff252525),
                  ),
                  SizedBox(height: 12.h),

                  // Text Area
                  MultiLineTextField(
                    controller: controller.suggestionController,
                    hintText: 'Write your message',
                    height: 120.h,
                    maxLines: 5,
                    maxLength: 200,
                  ),

                  Obx(() {
                    final error = controller.suggestionError.value;
                    if (error.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: CustomText(
                        text: error,
                        fontsize: 12.sp,
                        color: const Color(0xffE53935),
                        textAlign: TextAlign.start,
                      ),
                    );
                  }),
                  SizedBox(height: 32.h),


                  Obx(() => controller.isSurveyLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          title: 'Submit Survey',
                          onpress: () => controller.submitSurvey(),
                        ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}