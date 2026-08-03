import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../../core/controllers/role_controller.dart';
import '../../../../../core/controllers/session_controller.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../domain/services/agenda_service.dart';
import '../../controllers/spekar_profile_controller.dart';
import '../speaker_action_button_widget.dart';
import '../speaker_bio_widget.dart';
import '../speaker_profile_header.dart';
import '../speaker_session_section.dart';

class SpeakerProfileScreen extends StatefulWidget {
  final String speakerId;
  final String? sessionIdx; // optional — only passed from AgendaDetailsScreen

  const SpeakerProfileScreen({super.key, required this.speakerId, this.sessionIdx});

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
                              controller.goToSessionDetails(context, session);
                            },
                            onFavoriteTap: controller.toggleSessionFavorite,
                            isSessionFavorited: controller.isSessionFavorited,
                          );
                        }),
                      ),
                      // Remove Speaker button (TRACK_CHAIR only, when sessionIdx provided)
                      Obx(() {
                        final isTrackChair = RoleController.to.activeRole.value.toUpperCase() == 'TRACK_CHAIR';
                        if (!isTrackChair || widget.sessionIdx == null) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: _RemoveSpeakerButton(
                            speakerId: widget.speakerId,
                            sessionIdx: widget.sessionIdx!,
                          ),
                        );
                      }),
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

class _RemoveSpeakerButton extends StatefulWidget {
  final String speakerId;
  final String sessionIdx;

  const _RemoveSpeakerButton({
    required this.speakerId,
    required this.sessionIdx,
  });

  @override
  State<_RemoveSpeakerButton> createState() => _RemoveSpeakerButtonState();
}

class _RemoveSpeakerButtonState extends State<_RemoveSpeakerButton> {
  bool _isRemoving = false;

  Future<void> _confirmAndRemove(BuildContext context) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48.sp),
            SizedBox(height: 12.h),
            Text(
              'Remove Speaker',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff252525),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'This will remove user from this event as a Speaker, this action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xff757575),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Remove Speaker',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    setState(() => _isRemoving = true);
    try {
      final agendaService = Get.find<AgendaService>();
      final eventId = SessionController.to.eventId;
      await agendaService.removeSpeaker(eventId, widget.sessionIdx, widget.speakerId);
      if (context.mounted) Navigator.of(context).pop(); // go back to session details
    } catch (e) {
    } finally {
      if (mounted) setState(() => _isRemoving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isRemoving ? null : () => _confirmAndRemove(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: _isRemoving
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_remove_outlined,
                      color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Remove Speaker',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
