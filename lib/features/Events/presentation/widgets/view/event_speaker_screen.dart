import 'package:confaero_app/features/Events/presentation/controllers/events_controller.dart';
import 'package:confaero_app/features/Events/presentation/widgets/view/event_spaker_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../attendees/presentation/widgets/document_search_field_widget.dart';
import '../../controllers/events_spekar_controller.dart';
import '../event_spekar_card.dart';
import '../state_events_spekar_card.dart';


class EventSpekarScreen extends StatelessWidget {
  const EventSpekarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventSpekarController controller = Get.put(EventSpekarController());

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
                          text: 'Event Speaker',
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
                    EventSpekarStatsCard(
                      count: controller.totalAttendees.value.toString(),
                      label: 'Total Attendees',
                    ),
                    EventSpekarStatsCard(
                      count: controller.bookmarked.value.toString(),
                      label: 'Bookmarked',
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 20.h),

            // Attendees List
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: controller.attendees.length,
                  itemBuilder: (context, index) {
                    final attendee = controller.attendees[index];
                    return EventSpekarCard(
                      name: attendee['name'],
                      company: attendee['company'],
                      role: attendee['role'],
                      sessions: attendee['sessions'],
                      imagePath: attendee['image'],
                      isBookmarked: attendee['isBookmarked'],
                      onBookmarkTap: () => controller.toggleBookmark(attendee['id']),
                      onSayHi: () => controller.sayHi(attendee['name']),
                      onSendMail: () => controller.sendMail(attendee['name']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventSpekarDetailsScreen(),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}