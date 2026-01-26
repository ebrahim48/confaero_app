import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/spekar_profile_controller.dart';
import '../speaker_action_button_widget.dart';
import '../speaker_bio_widget.dart';
import '../speaker_profile_header.dart';
import '../speaker_session_section.dart';


class SpeakerProfileScreen extends StatelessWidget {
  const SpeakerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeakerProfileController controller = Get.put(SpeakerProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // // Loading State
        // if (controller.isLoading.value) {
        //   return const Center(
        //     child: CircularProgressIndicator(
        //       color: Color(0xff5BB8AE),
        //     ),
        //   );
        // }

        final speaker = controller.speaker;

        return SafeArea(
          child: Column(
            children: [
              // Header with Back Button
              _buildAppBar(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),

                      // Profile Header
                      SpeakerProfileHeader(
                        name: speaker['name']?.toString() ?? 'Speaker',
                        role: speaker['role']?.toString() ?? '',
                        location: speaker['location']?.toString() ?? '',
                        imagePath: speaker['image']?.toString() ?? '',
                      ),
                      SizedBox(height: 24.h),

                      // Action Buttons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: SpeakerActionButtons(
                          onLinkedInTap: controller.openLinkedIn,
                          onWebsiteTap: controller.openWebsite,
                          onContractTap: controller.contractSpeaker,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Bio Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Obx(() => SpeakerBioWidget(
                          bio: controller.getBioText(),
                          isExpanded: controller.isBioExpanded.value,
                          onToggle: controller.toggleBioExpansion,
                        )),
                      ),
                      SizedBox(height: 32.h),

                      // Sessions Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Obx(() {
                          final sessions = speaker['sessions'] as List? ?? [];
                          return SpeakerSessionsSection(
                            sessions: sessions.cast<Map<String, dynamic>>(),
                            onSessionTap: (sessionId) {
                              final session = sessions.firstWhere(
                                    (s) => s['id'] == sessionId,
                                orElse: () => {},
                              );
                              controller.goToSessionDetails(session);
                            },
                            onFavoriteTap: controller.toggleSessionFavorite,
                            isSessionFavorited: controller.isSessionFavorited,
                          );
                        }),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  size: 20.sp,
                  color: const Color(0xff252525),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          CustomText(
            text: 'Speaker',
            fontsize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff252525),
          ),
        ],
      ),
    );
  }
}