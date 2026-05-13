import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/live_meeting_controller.dart';
import '../poll_card_widget.dart';

class LiveMeetingScreen extends StatelessWidget {
  final int sessionIndex;
  final String sessionTitle;

  const LiveMeetingScreen({
    super.key,
    this.sessionIndex = 0,
    this.sessionTitle = 'Sample session live discussion',
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveMeetingController());

    return Scaffold(

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
                      text: sessionTitle,
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conference Banner Image
          Container(
            width: double.infinity,
            height: 190.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/livesession.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Live Badge
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: 'Live',
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                // Join Video Conference Button
                Positioned(
                  bottom: 16.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Obx(() => GestureDetector(
                          onTap: controller.isJoining.value
                              ? null
                              : () => controller.joinSession(
                                  sessionIndex: sessionIndex),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff32A69A),
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: controller.isJoining.value
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.videocam,
                                          color: Colors.white, size: 18.sp),
                                      SizedBox(width: 8.w),
                                      CustomText(
                                        text: 'Join Video Conference',
                                        fontsize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),

          // Tabs (Polls & Chat) - Using Obx for reactive UI
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
            height: 42.h,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffD2D2D2)),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Obx(
                  () => Row(
                children: [
                  // Polls Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.switchTab(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.currentTab.value == 0
                              ? const Color(0xffE1E1E1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            bottomLeft: Radius.circular(4.r),
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Polls',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: controller.currentTab.value == 0
                                ? AppColors.textColor424242
                                : AppColors.textColor7E7F7E,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Chat Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.switchTab(1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.currentTab.value == 1
                              ? const Color(0xffE1E1E1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.r),
                            bottomRight: Radius.circular(4.r),
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Chat',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: controller.currentTab.value == 1
                                ? AppColors.textColor424242
                                : AppColors.textColor7E7F7E,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Area - Using Obx to switch between tabs
          Expanded(
            child: Obx(
                  () => controller.currentTab.value == 0
                  ? _buildPollsTab()
                  : _buildChatTab(),
            ),
          ),
        ],
      ),
    );
  }

  // Polls Tab
  Widget _buildPollsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: const PollCardWidget(),
    );
  }

  // Chat Tab
  Widget _buildChatTab() {
    return Container(
      color: AppColors.backgroundColor,
      child: Center(
        child: CustomText(
          text: 'Chat will be available soon',
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
        ),
      ),
    );
  }
}