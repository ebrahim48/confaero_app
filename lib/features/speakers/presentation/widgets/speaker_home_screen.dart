import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../controllers/speaker_home_controller.dart';

/// Speaker Home Screen
///
/// Shows:
/// - Welcome message with speaker stats
/// - Pending session invitations (Accept/Reject)
/// - Accepted sessions
/// - Live session controls (Go Live, Stop Live, Camera)
class SpeakerHomeScreen extends StatelessWidget {
  const SpeakerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpeakerHomeController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value && controller.invitations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: _buildHeader(controller),
            ),

            // Live Session Controls (if active or has sessions)
            if (controller.acceptedSessions.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildLiveControls(controller),
              ),

            // Pending Invitations
            if (controller.invitations.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildInvitationsSection(controller),
              ),

            // Accepted Sessions
            if (controller.acceptedSessions.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildAcceptedSessions(controller),
              ),

            // Empty state
            if (controller.invitations.isEmpty &&
                controller.acceptedSessions.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(),
              ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        );
      }),
    );
  }

  /// Header with welcome message and stats
  Widget _buildHeader(SpeakerHomeController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor32A69A,
            AppColors.primaryColor32A69A.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: 'Hello Speaker!',
                  fontsize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 28.w,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Manage your sessions and invitations',
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
          SizedBox(height: 24.h),
          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.event_note,
                  value: '${controller.acceptedSessions.length}',
                  label: 'Accepted Sessions',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.mail_outline,
                  value: '${controller.invitations.length}',
                  label: 'Pending Invites',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Stat card widget
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28.w),
          SizedBox(height: 8.h),
          CustomText(
            text: value,
            fontsize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: label,
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Live session controls
  Widget _buildLiveControls(SpeakerHomeController controller) {
    return Container(
      margin: EdgeInsets.all(24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Live Session Controls',
            fontsize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
          SizedBox(height: 16.h),
          Obx(() => controller.isLive.value
              ? _buildLiveActiveControls(controller)
              : _buildGoLiveButton(controller)),
        ],
      ),
    );
  }

  /// Go Live button
  Widget _buildGoLiveButton(SpeakerHomeController controller) {
    return GestureDetector(
      onTap: controller.isProcessing.value
          ? null
          : () => controller.startLiveSession(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor32A69A,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isProcessing.value)
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else ...[
              Icon(Icons.videocam, color: Colors.white, size: 24.w),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Go Live',
                fontsize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Live active controls (Stop Live, Camera toggle)
  Widget _buildLiveActiveControls(SpeakerHomeController controller) {
    return Column(
      children: [
        // Status indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: 'LIVE',
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Control buttons
        Row(
          children: [
            Expanded(
              child: Obx(() => GestureDetector(
                    onTap: controller.toggleCamera,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: controller.isCameraOn.value
                            ? AppColors.primaryColor32A69A
                            : AppColors.textColorF6F6F6,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.isCameraOn.value
                                ? Icons.videocam
                                : Icons.videocam_off,
                            color: controller.isCameraOn.value
                                ? Colors.white
                                : AppColors.textColor707070,
                            size: 20.w,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: controller.isCameraOn.value
                                ? 'Camera On'
                                : 'Camera Off',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: controller.isCameraOn.value
                                ? Colors.white
                                : AppColors.textColor707070,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: controller.isProcessing.value
                    ? null
                    : () => controller.stopLiveSession(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.isProcessing.value)
                        SizedBox(
                          width: 18.w,
                          height: 18.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else ...[
                        Icon(Icons.stop, color: Colors.white, size: 20.w),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: 'Stop',
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Invitations section
  Widget _buildInvitationsSection(SpeakerHomeController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Pending Invitations',
            fontsize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.invitations.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final invitation = controller.invitations[index];
              return _buildInvitationCard(controller, invitation);
            },
          ),
        ],
      ),
    );
  }

  /// Individual invitation card
  Widget _buildInvitationCard(
    SpeakerHomeController controller,
    Map<String, dynamic> invitation,
  ) {
    final sessionName =
        invitation['sessionName'] as String? ?? 'Speaker Session';
    final eventDate = invitation['date'] != null
        ? DateTime.tryParse(invitation['date'])
        : null;
    final formattedDate = eventDate != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(eventDate)
        : 'Date TBD';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor32A69A.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor32A69A.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.mic_outlined,
                  color: AppColors.primaryColor32A69A,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: sessionName,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor252525,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: formattedDate,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor7E7F7E,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: controller.isProcessing.value
                      ? null
                      : () => controller.rejectInvitation(
                            invitation['_id'] as String? ?? '',
                          ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.isProcessing.value)
                          SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        else ...[
                          Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 18.w,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: 'Reject',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: controller.isProcessing.value
                      ? null
                      : () => controller.acceptInvitation(
                            invitation['_id'] as String? ?? '',
                          ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor32A69A,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.isProcessing.value)
                          SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18.w,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: 'Accept',
                            fontsize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Accepted sessions section
  Widget _buildAcceptedSessions(SpeakerHomeController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Your Sessions',
            fontsize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.acceptedSessions.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final session = controller.acceptedSessions[index];
              return _buildSessionCard(controller, session);
            },
          ),
        ],
      ),
    );
  }

  /// Session card
  Widget _buildSessionCard(
    SpeakerHomeController controller,
    Map<String, dynamic> session,
  ) {
    final sessionName = session['sessionName'] as String? ?? 'Session';
    final eventDate = session['date'] != null
        ? DateTime.tryParse(session['date'])
        : null;
    final formattedDate = eventDate != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(eventDate)
        : 'Date TBD';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 20.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: sessionName,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor252525,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: formattedDate,
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor7E7F7E,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.iconColorAEAEAE,
            size: 24.w,
          ),
        ],
      ),
    );
  }

  /// Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic_none_outlined,
              size: 80.w,
              color: AppColors.iconColorAEAEAE,
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: 'No Sessions Yet',
              fontsize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor252525,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'You haven\'t been invited to any sessions yet. Check back later!',
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor7E7F7E,
              textAlign: TextAlign.center,
              maxline: 3,
            ),
          ],
        ),
      ),
    );
  }
}
