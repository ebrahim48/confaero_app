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

class SpeakerProfileScreen extends StatefulWidget {
  final String speakerId;

  const SpeakerProfileScreen({super.key, required this.speakerId});

  @override
  State<SpeakerProfileScreen> createState() => _SpeakerProfileScreenState();
}

class _SpeakerProfileScreenState extends State<SpeakerProfileScreen> {
  late final SpeakerProfileController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SpeakerProfileController>()) {
      Get.delete<SpeakerProfileController>(force: true);
    }
    controller = Get.put(SpeakerProfileController(widget.speakerId));
  }

  @override
  void dispose() {
    Get.delete<SpeakerProfileController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff5BB8AE)),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),

                      // Profile Header
                      Obx(() => SpeakerProfileHeader(
                            name: controller.speakerName,
                            role: controller.speakerRole,
                            location: controller.speakerLocation,
                            imagePath: controller.speakerAvatar,
                          )),
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

                      // Speaking At Sessions
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Obx(() {
                          final sessions = controller.speakingAtSessions;
                          return SpeakerSessionsSection(
                            sessions: sessions,
                            onSessionTap: (sessionId) {
                              final session = sessions.firstWhere(
                                (s) => s['_id'] == sessionId,
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
          Obx(() => CustomText(
                text: controller.speakerName.isNotEmpty
                    ? controller.speakerName
                    : 'Speaker',
                fontsize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff252525),
              )),
        ],
      ),
    );
  }
}
