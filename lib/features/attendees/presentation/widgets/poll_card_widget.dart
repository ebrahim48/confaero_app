import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../../presentations/widgets/custom_button.dart';
import '../controllers/live_meeting_controller.dart';
import 'poll_option_widget.dart';

class PollCardWidget extends StatelessWidget {
  const PollCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveMeetingController>();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xffD2D2D2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poll Creator Info
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: const Color(0xff999999),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 14.sp, color: Colors.white),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: CustomText(
                  text: 'Poll create by speaker, Anthony Ciobanu',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor7E7F7E,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Poll Question
          CustomText(
            text: 'Rate your overall event experience.',
            fontsize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor424242,
          ),

          SizedBox(height: 16.h),

          // Poll Options - Using Obx for reactive updates
          Obx(
            () => Column(
              children: [
                PollOptionWidget(
                  text: 'Very good',
                  isSelected: controller.pollOptions[0],
                  onTap: () => controller.togglePollOption(0),
                ),
                PollOptionWidget(
                  text: 'Very good',
                  isSelected: controller.pollOptions[1],
                  onTap: () => controller.togglePollOption(1),
                ),
                PollOptionWidget(
                  text: 'Very good',
                  isSelected: controller.pollOptions[2],
                  onTap: () => controller.togglePollOption(2),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Submit Button
          CustomButton(
            title: 'Submit',
            onpress: () => controller.submitPollVote(pollId: 'poll_default'),
            color: const Color(0xff32A69A),
            height: 48.h,
            borderRadius: 8.r,
          ),
        ],
      ),
    );
  }
}
