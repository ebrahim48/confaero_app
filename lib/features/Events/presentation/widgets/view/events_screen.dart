import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/my_event_model.dart';
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
  late final EventsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EventsController());
  }

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
                  Container(
                    width: 40.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xff252525), width: 0.7),
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/profile.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                  CustomText(
                    text: 'Events',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.pushNamed(AppRoutes.notificationsScreen),
                        child: SvgPicture.asset(
                          'assets/icons/notification.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                              AppColors.textColor424242, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: controller.openDrawer,
                        child: SvgPicture.asset(
                          'assets/icons/menusidebar.svg',
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                              AppColors.textColor424242, BlendMode.srcIn),
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
                    EventSearchBar(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                    ),
                    SizedBox(height: 16.h),
                    Obx(() => EventTabSwitcher(
                      selectedTab: controller.selectedTab.value,
                      onTabChanged: controller.switchTab,
                    )),
                    SizedBox(height: 12.h),
                    Obx(() {
                      if (controller.selectedTab.value == 0) {
                        return _buildMyEventsTab();
                      } else {
                        return _buildExploreEventsTab();
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

  // ── My Events Tab ─────────────────────────────────────────────────────────

  Widget _buildMyEventsTab() {
    if (controller.isMyEventsLoading.value) return _loadingWidget();
    if (controller.myEventsError.isNotEmpty) {
      return _errorWidget(controller.myEventsError.value, controller.loadMyEvents);
    }

    final active = controller.filteredActiveEvents;     // List<MyEventModel> — registered
    final upcoming = controller.filteredUpcomingEvents; // List<EventModel>   — not registered

    if (active.isEmpty && upcoming.isEmpty) {
      return _emptyWidget('No events found');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Active (registered) events ──────────────────────────────────
        if (active.isNotEmpty) ...[
          CustomText(
            text: 'Active events(${active.length})',
            fontsize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor424242,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          ...active.map((m) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildRegisteredCard(m),
          )),
          SizedBox(height: 24.h),
        ],

        // ── Upcoming (not yet registered) events ────────────────────────
        if (upcoming.isNotEmpty) ...[
          CustomText(
            text: 'Upcoming events(${upcoming.length})',
            fontsize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor424242,
            textAlign: TextAlign.start,
            bottom: 12.h,
          ),
          ...upcoming.map((e) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildUpcomingCard(e),
          )),
          SizedBox(height: 24.h),
        ],
      ],
    );
  }

  /// Registered event card (teal border + "Registered" badge)
  Widget _buildRegisteredCard(MyEventModel m) {
    final e = m.event;
    return EventCard(
      imageUrl: (e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty)
          ? e.bannerImageUrl!
          : 'assets/images/myevents.png',
      isNetworkImage: e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
      title: e.title,
      date: e.formattedDateRange,
      location: e.location,
      isRegistered: true,
      registrationStatus: m.status,
      onCardTap: () => controller.openEventDetails(context, e.id),
    );
  }

  /// Upcoming event card (grey border + "Join Now" button)
  Widget _buildUpcomingCard(EventModel e) {
    return EventCard(
      imageUrl: (e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty)
          ? e.bannerImageUrl!
          : 'assets/images/myevents.png',
      isNetworkImage: e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
      title: e.title,
      date: e.formattedDateRange,
      location: e.location,
      isRegistered: false,
      onRegisterTap: () => controller.registerEvent(context, e.id),
      onCardTap: () => controller.openEventDetails(context, e.id),
    );
  }

  // ── Explore Events Tab ────────────────────────────────────────────────────

  Widget _buildExploreEventsTab() {
    if (controller.isExploreLoading.value) return _loadingWidget();
    if (controller.exploreError.isNotEmpty) {
      return _errorWidget(controller.exploreError.value, controller.loadExploreEvents);
    }

    final events = controller.filteredExploreEvents;
    if (events.isEmpty) return _emptyWidget('No events available');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'All events(${events.length})',
          fontsize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor424242,
          textAlign: TextAlign.start,
          bottom: 12.h,
        ),
        ...events.map((e) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: EventCard(
            imageUrl: (e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty)
                ? e.bannerImageUrl!
                : 'assets/images/myevents.png',
            isNetworkImage:
            e.bannerImageUrl != null && e.bannerImageUrl!.isNotEmpty,
            title: e.title,
            date: e.formattedDateRange,
            location: e.location,
            isRegistered: false,
            onRegisterTap: () => controller.registerEvent(context, e.id),
            onCardTap: () => controller.openEventDetails(context, e.id),
          ),
        )),
        SizedBox(height: 24.h),
      ],
    );
  }

  // ── Shared UI helpers ─────────────────────────────────────────────────────

  Widget _loadingWidget() => SizedBox(
    height: 300.h,
    child: const Center(
      child: CircularProgressIndicator(color: Color(0xff5BB8AE)),
    ),
  );

  Widget _errorWidget(String message, VoidCallback onRetry) => SizedBox(
    height: 300.h,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 12.h),
          CustomText(
            text: message,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor7E7F7E,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xff5BB8AE),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CustomText(
                text: 'Retry',
                fontsize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _emptyWidget(String message) => SizedBox(
    height: 300.h,
    child: Center(
      child: CustomText(
        text: message,
        fontsize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textColor7E7F7E,
        textAlign: TextAlign.center,
      ),
    ),
  );
}