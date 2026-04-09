import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../../presentations/widgets/custom_text.dart';


import '../../../../attendees/presentation/widgets/document_search_field_widget.dart';
import '../../controllers/attendees_controller.dart';
import '../attendee_card.dart';
import '../stats_card.dart';
import 'attendees_details_screen.dart';


class AttendeesScreen extends StatelessWidget {
  const AttendeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendeesController controller = Get.put(AttendeesController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffD7EAE8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/profile.svg',
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Event Attendees',
                          fontsize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff252525),
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: 'Connect with participants',
                          fontsize: 12.sp,
                          color: const Color(0xff757575),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search and Filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Expanded(
                    child: SearchField(
                      controller: controller.searchController,
                      hintText: 'Search event name, Location, etc',
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Filter Button
                  Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD2D2D2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Assets.icons
                          .filter.svg()
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Stats Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatsCard(
                      count: controller.totalAttendees.value.toString(),
                      label: 'Total Attendees',
                    ),
                    StatsCard(
                      count: controller.bookmarkedCount.value.toString(),
                      label: 'Bookmarked',
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 20.h),

            // Attendees List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshAttendees(),
                color: const Color(0xff32A69A),
                child: Obx(() {
                  if (controller.filteredAttendees.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64.sp,
                            color: const Color(0xffBDBDBD),
                          ),
                          SizedBox(height: 16.h),
                          CustomText(
                            text: 'No attendees yet',
                            fontsize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff757575),
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text: 'Attendees will appear here',
                            fontsize: 14.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: controller.filteredAttendees.length,
                    itemBuilder: (context, index) {
                      final attendee = controller.filteredAttendees[index];
                      return AttendeeCard(
                        name: attendee.name,
                        company: attendee.company,
                        role: attendee.role,
                        sessions: '${attendee.sessionsCount} sessions',
                        imagePath: attendee.avatarUrl,
                        isBookmarked: attendee.isBookmarked,
                        isOnline: attendee.isOnline || controller.isUserOnline(attendee.id),
                        onBookmarkTap: () => controller.toggleBookmark(attendee.id),
                        onSayHi: () => controller.sayHi(attendee.name, attendee.id),
                        onSendMail: () => controller.sendMail(attendee.email ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendeeDetailsScreen(attendeeId: attendee.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}