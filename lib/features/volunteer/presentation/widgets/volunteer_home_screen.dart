import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/volunteer_home_controller.dart';

/// Volunteer Home Screen - Shows Events with My Events / Invited Event tabs
class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VolunteerHomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              color: AppColors.backgroundColor,
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.person, size: 20.sp, color: Colors.grey),
                  ),
                  SizedBox(width: 12.w),
                  // Title
                  Expanded(
                    child: CustomText(
                      text: 'Events',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  // Notification
                  GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.notificationsScreen),
                    child: SvgPicture.asset(
                      'assets/icons/notification.svg',
                      width: 22.w,
                      height: 22.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.textColor424242,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Menu
                  GestureDetector(
                    onTap: () {
                      try {
                        final scaffoldKey = Get.find<GlobalKey<ScaffoldState>>();
                        scaffoldKey.currentState?.openDrawer();
                      } catch (_) {}
                    },
                    child: Icon(
                      Icons.menu,
                      size: 22.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search event name, Location, etc',
                  hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
          ),

          // Tab Switcher
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.tabIndex.value = 0,
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          color: controller.tabIndex.value == 0
                              ? const Color(0xFF32A69A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'My Events',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: controller.tabIndex.value == 0
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                      )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.tabIndex.value = 1,
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          color: controller.tabIndex.value == 1
                              ? const Color(0xFF32A69A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Invited Event',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: controller.tabIndex.value == 1
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Event List
          Expanded(
            child: Obx(() {
              final events = controller.tabIndex.value == 0
                  ? controller.myEvents
                  : controller.invitedEvents;

              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (events.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64.r,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        controller.tabIndex.value == 0
                            ? 'No events yet'
                            : 'No invitations yet',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _EventCard(
                    event: event,
                    isInvitedTab: controller.tabIndex.value == 1,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final bool isInvitedTab;

  const _EventCard({required this.event, required this.isInvitedTab});

  @override
  Widget build(BuildContext context) {
    final status = event['status']?.toString().toLowerCase() ?? '';
    final isAccepted = status == 'accepted';
    final isRejected = status == 'rejected';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          // Event thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: event['banner'] != null && event['banner'].toString().isNotEmpty
                ? Image.network(
                    event['banner'],
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          SizedBox(width: 12.w),
          // Event details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'] ?? 'Event',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor424242,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      event['date'] ?? '',
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      event['location'] ?? '',
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'You are invited as a volunteer',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          // Action button
          if (isInvitedTab) ...[
            SizedBox(width: 8.w),
            _buildActionButton(isAccepted, isRejected),
          ],
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(Icons.event, size: 32.sp, color: Colors.grey.shade400),
    );
  }

  Widget _buildActionButton(bool isAccepted, bool isRejected) {
    if (isAccepted) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF32A69A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Accepted',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF32A69A),
          ),
        ),
      );
    }

    if (isRejected) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Rejected',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF32A69A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'Accept Now',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
