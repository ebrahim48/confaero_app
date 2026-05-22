import 'package:confaero_app/features/Events/presentation/widgets/view/event_spaker_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../../attendees/presentation/widgets/document_search_field_widget.dart';
import '../../controllers/events_spekar_controller.dart';
import '../event_spekar_card.dart';
import '../state_events_spekar_card.dart';

class EventSpekarScreen extends StatefulWidget {
  const EventSpekarScreen({super.key});

  @override
  State<EventSpekarScreen> createState() => _EventSpekarScreenState();
}

class _EventSpekarScreenState extends State<EventSpekarScreen> {
  late final EventSpekarController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<EventSpekarController>()) {
      Get.delete<EventSpekarController>(force: true);
    }
    controller = Get.put(EventSpekarController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back, size: 24.sp, color: const Color(0xff252525)),
                  ),
                  SizedBox(width: 12.w),
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
                      hintText: 'Search speaker name, company, etc',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffD2D2D2), width: 1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(child: Assets.icons.filter.svg()),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Stats Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EventSpekarStatsCard(
                        count: controller.totalAttendees.value.toString(),
                        label: 'Total Speakers',
                      ),
                      EventSpekarStatsCard(
                        count: controller.bookmarked.value.toString(),
                        label: 'Bookmarked',
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 20.h),

            // List / Shimmer / Empty
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const _SpeakerShimmer();
                }

                if (controller.attendees.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 64.sp, color: const Color(0xffBDBDBD)),
                        SizedBox(height: 16.h),
                        CustomText(
                          text: 'No speakers found',
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff757575),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadSpeakers,
                  color: const Color(0xff32A69A),
                  child: ListView.builder(
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
                        onSayHi: () => controller.sayHi(context, attendee),
                        onSendMail: () => controller.sendMail(attendee['email']),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EventSpekarDetailsScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeakerShimmer extends StatelessWidget {
  const _SpeakerShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 6,
        itemBuilder: (_, __) => _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          // Top row: avatar + name/company + bookmark
          Row(
            children: [
              // Avatar
              Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              // Name + company
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 10.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
              // Bookmark icon placeholder
              Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Role badge + sessions
          Row(
            children: [
              Container(
                width: 64.w,
                height: 22.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 14.w,
                height: 14.h,
                color: Colors.white,
              ),
              SizedBox(width: 4.w),
              Container(
                width: 70.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Divider
          Container(height: 0.5.h, color: Colors.white),
          SizedBox(height: 12.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
