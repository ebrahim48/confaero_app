import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../global/custom_assets/assets.gen.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/agenda_controllers.dart';
import '../calendar_dropwon_widget.dart';
import '../dashed_line_painter.dart';
import '../day_selecter.dart';
import '../session_card.dart';
import '../tab_toggle_button_widget.dart';
import '../timeline_widget.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late final AgendaController controller;

  @override
  void initState() {
    super.initState();
    // Always create a fresh controller so onInit fires with the current eventId
    if (Get.isRegistered<AgendaController>()) {
      Get.delete<AgendaController>(force: true);
    }
    controller = Get.put(AgendaController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'ConfAero - Agenda',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff252525),
                  ),
                  Icon(Icons.search, size: 24.sp, color: const Color(0xff252525)),
                ],
              ),
            ),

            // Tab Toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() => TabToggleButton(
                    selectedIndex: controller.selectedTab.value,
                    onChanged: controller.changeTab,
                  )),
            ),
            SizedBox(height: 16.h),

            // Month Selector & Filters
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => CalendarDropdown(
                        selectedMonth: controller.selectedMonth.value,
                        onDateSelected: controller.onCalendarDateSelected,
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffD2D2D2), width: 1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Day Selector
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.weekDays.map((day) {
                      return DaySelector(
                        day: day['day'],
                        date: day['date'],
                        isSelected: controller.selectedDay.value == day['date'],
                        onTap: () => controller.changeDay(day['date']),
                      );
                    }).toList(),
                  )),
            ),
            SizedBox(height: 24.h),

            // Sessions List / Shimmer / Empty
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const _AgendaShimmer();
                }

                final sessions = controller.currentSessions;

                if (sessions.isEmpty) {
                  return _buildEmptyState(controller.selectedTab.value);
                }

                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  color: const Color(0xff5BB8AE),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < sessions.length - 1 ? 18.h : 0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline dot + dashed line
                            Column(
                              children: [
                                Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xff5BB8AE), width: 2),
                                    color: Colors.white,
                                  ),
                                ),
                                if (index < sessions.length - 1)
                                  CustomPaint(
                                    size: Size(1, 155.h),
                                    painter: DashedLinePainter(),
                                  ),
                              ],
                            ),
                            SizedBox(width: 10.w),
                            TimelineWidget(time: session.startTime),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: SessionCard(
                                type: 'SESSION',
                                title: session.title,
                                duration: '${session.startTime} - ${session.endTime}',
                                attendees: 0,
                                favorites: session.likesCount,
                                isBreak: false,
                                location: session.location,
                                onFavorite: () => controller.toggleFavorite(index),
                                onBookmark: () => controller.toggleBookmark(session),
                                isBookmarked: session.isBookmarked,
                                onTap: () => context.pushNamed(
                                  AppRoutes.agendaDetailsScreen,
                                  extra: session.sessionIndex.toString(),
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildEmptyState(int selectedTab) {
    final isMyAgenda = selectedTab == 1;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMyAgenda ? Icons.bookmark_border : Icons.event_note_outlined,
              size: 80.sp,
              color: const Color(0xFFAD9D8D),
            ),
            SizedBox(height: 16.h),
            Text(
              isMyAgenda ? 'My Agenda is Empty' : 'No Sessions Scheduled',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF252525),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isMyAgenda
                  ? 'Sessions you bookmark will appear here.'
                  : 'Sessions for this event will be published soon.',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF757575)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer ───────────────────────────────────────────────────────────────

class _AgendaShimmer extends StatelessWidget {
  const _AgendaShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemCount: 5,
        itemBuilder: (_, index) => Padding(
          padding: EdgeInsets.only(bottom: 18.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot
              Column(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  if (index < 4)
                    Container(
                      width: 2.w,
                      height: 155.h,
                      color: Colors.white,
                    ),
                ],
              ),
              SizedBox(width: 10.w),

              // Time placeholder
              Container(
                width: 36.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 10.w),

              // Session card placeholder
              Expanded(
                child: Container(
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Left accent bar
                      Container(
                        width: 5.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            bottomLeft: Radius.circular(20.r),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Type badge
                              Container(
                                width: 60.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              // Title line 1
                              Container(
                                width: double.infinity,
                                height: 14.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // Title line 2
                              Container(
                                width: 160.w,
                                height: 14.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Duration line
                              Container(
                                width: 120.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
