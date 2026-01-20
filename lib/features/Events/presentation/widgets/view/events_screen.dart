import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/events_controller.dart';
import '../../widgets/event_card_widget.dart';
import '../events_search_widgets.dart';
import '../events_tab_switcher_widget.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  final EventsController controller = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 98.h,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              color: const Color(0xffF5F5F5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Image
                  Container(
                    width: 40.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xff252525),
                        width: 0.7,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Events Title
                  CustomText(
                    text: 'Events',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),

                  // Notification and Menu Icons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.notificationsScreen);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/notification.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.textColor424242,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {

                        },
                        child: SvgPicture.asset(
                          'assets/icons/menusidebar.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                            AppColors.textColor424242,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Search Bar
                    EventSearchBar(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                    ),

                    SizedBox(height: 16.h),

                    // Tab Switcher
                    Obx(() => EventTabSwitcher(
                      selectedTab: controller.selectedTab.value,
                      onTabChanged: controller.switchTab,
                    )),

                    SizedBox(height: 12.h),

                    // Content based on selected tab
                    Obx(() {
                      if (controller.selectedTab.value == 0) {
                        // My Events Tab
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Active Events Section
                            CustomText(
                              text: 'Active events(1)',
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor424242,
                              textAlign: TextAlign.start,
                              bottom: 12.h,
                            ),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: EventCard(
                                    imageUrl: 'assets/images/myevents.png',
                                    title:
                                    '18th Lithium Supply & Battery Raw Materials Conference',
                                    date: 'Jun 22-25, 2026',
                                    location: 'Las Vegas, USA',
                                    isRegistered: true,
                                    onCardTap: controller.openEventDetails,
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 24.h),

                            // Upcoming Events Section
                            CustomText(
                              text: 'Upcoming events(10)',
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor424242,
                              textAlign: TextAlign.start,
                              bottom: 12.h,
                            ),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: EventCard(
                                    imageUrl: 'assets/images/myevents.png',
                                    title:
                                    '18th Lithium Supply & Battery Raw Materials Conference',
                                    date: 'Jun 22-25, 2026',
                                    location: 'Las Vegas, USA',
                                    isRegistered: false,
                                    onRegisterTap: () => controller.registerEvent(context),
                                    onCardTap: controller.openEventDetails,
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 24.h),
                          ],
                        );
                      } else {
                        // Explore Events Tab
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'All events(30)',
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor424242,
                              textAlign: TextAlign.start,
                              bottom: 12.h,
                            ),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 30,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: EventCard(
                                    imageUrl: 'assets/images/myevents.png',
                                    title:
                                    '18th Lithium Supply & Battery Raw Materials Conference',
                                    date: 'Jun 22-25, 2026',
                                    location: 'Las Vegas, USA',
                                    isRegistered: false,
                                    onRegisterTap: () => controller.registerEvent(context),
                                    onCardTap: controller.openEventDetails,
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 24.h),
                          ],
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}