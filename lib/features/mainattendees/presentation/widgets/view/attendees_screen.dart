import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/attendees_controller.dart';
import '../attendee_card.dart';
import '../stats_card.dart';
import 'attendees_details_screen.dart';

class AttendeesScreen extends StatefulWidget {
  const AttendeesScreen({super.key});

  @override
  State<AttendeesScreen> createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends State<AttendeesScreen>
    with SingleTickerProviderStateMixin {
  late final AttendeesController controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AttendeesController());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      controller.selectRole(_tabController.index == 0 ? '' : 'SPEAKER');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                  // GestureDetector(
                  //   onTap: () => Navigator.of(context).pop(),
                  //   child: Icon(Icons.arrow_back, size: 24.sp, color: AppColors.textColor424242),
                  // ),
                  // SizedBox(width: 16.w),
                  Expanded(
                    child: CustomText(
                      text: 'Event Attendees',
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xffE1E1E1)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(Icons.search, size: 20.sp, color: AppColors.textColor7E7F7E),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search attendees',
                        hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textColor7E7F7E),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textColor424242),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(() => Row(
              children: [
                Expanded(
                  child: StatsCard(
                    count: controller.totalAttendees.value.toString(),
                    label: _tabController.index == 0 ? 'Total Attendees' : 'Total Speakers',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: StatsCard(
                    count: controller.bookmarkedCount.value.toString(),
                    label: 'Bookmarked',
                  ),
                ),
              ],
            )),
          ),

          SizedBox(height: 12.h),

          // Tabs
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xff32A69A),
                borderRadius: BorderRadius.circular(8.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textColor7E7F7E,
              labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Attendees'),
                Tab(text: 'Speakers'),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const _AttendeesShimmer();
              return RefreshIndicator(
                onRefresh: controller.refreshAttendees,
                color: const Color(0xff32A69A),
                child: controller.filteredAttendees.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64.sp, color: const Color(0xffBDBDBD)),
                            SizedBox(height: 16.h),
                            CustomText(
                              text: 'No attendees found',
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor7E7F7E,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        itemCount: controller.filteredAttendees.length,
                        itemBuilder: (context, index) {
                          final attendee = controller.filteredAttendees[index];
                          return AttendeeCard(
                            name: attendee.name,
                            company: attendee.company,
                            role: attendee.role,
                            sessions: '${attendee.sessionsCount} sessions',
                            imagePath: attendee.avatarUrl.isNotEmpty
                                ? attendee.avatarUrl
                                : 'assets/images/sampleprofile.png',
                            isBookmarked: attendee.isBookmarked,
                            isOnline: attendee.isOnline ||
                                controller.isUserOnline(attendee.accountId.isNotEmpty
                                    ? attendee.accountId
                                    : attendee.id),
                            onBookmarkTap: () => controller.toggleBookmark(attendee),
                            onSayHi: () => controller.sayHi(attendee),
                            onSendMail: () => controller.sendMail(attendee.email),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AttendeeDetailsScreen(
                                  attendeeId: attendee.accountId.isNotEmpty
                                      ? attendee.accountId
                                      : attendee.id,
                                ),
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
    );
  }
}

class _AttendeesShimmer extends StatelessWidget {
  const _AttendeesShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
