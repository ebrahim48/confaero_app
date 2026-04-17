import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AgendaController controller = Get.put(AgendaController());

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
                  Icon(
                    Icons.search,
                    size: 24.sp,
                    color: const Color(0xff252525),
                  ),
                ],
              ),
            ),

            // Tab Toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() {
                return TabToggleButton(
                  selectedIndex: controller.selectedTab.value,
                  onChanged: (index) => controller.changeTab(index),
                );
              }),
            ),
            SizedBox(height: 16.h),

            // Month Selector and Filters
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Calendar Dropdown (Updated)
                  Obx(() {
                    return CalendarDropdown(
                      selectedMonth: controller.selectedMonth.value,
                      onDateSelected: (date) {
                        controller.onCalendarDateSelected(date);
                      },
                    );
                  }),

                  // Filters Button
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffD2D2D2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      children: [
                        Assets.icons.filter.svg(),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: 'Filters',
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff252525),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Day Selector (Updated to use dynamic weekDays)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      controller.weekDays.map((day) {
                        return DaySelector(
                          day: day['day'],
                          date: day['date'],
                          isSelected:
                              controller.selectedDay.value == day['date'],
                          onTap: () => controller.changeDay(day['date']),
                        );
                      }).toList(),
                );
              }),
            ),
            SizedBox(height: 24.h),

            // Sessions List with Timeline
            Expanded(
              child: Obx(() {
                final sessions = controller.currentSessions;

                if (sessions.isEmpty) {
                  return _buildEmptyState(controller.selectedTab.value);
                }

                return ListView.builder(
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
                          // Timeline column (dot + dashed line)
                          Column(
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xff5BB8AE),
                                    width: 2,
                                  ),
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

                          // Time widget
                          TimelineWidget(time: session.startTime),
                          SizedBox(width: 10.w),

                          // Session Card — takes all remaining width
                          Expanded(
                            child: SessionCard(
                              type: 'SESSION',
                              title: session.title,
                              duration:
                                  '${session.startTime} - ${session.endTime}',
                              attendees: 0,
                              favorites: session.likesCount,
                              isBreak: false,
                              location: session.location,
                              onFavorite: () =>
                                  controller.toggleFavorite(index),
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.agendaDetailsScreen,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildEmptyState(int selectedTab) {
    final isMyAgenda = selectedTab == 1;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMyAgenda ? Icons.calendar_today_outlined : Icons.event_note_outlined,
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
                  ? 'Sessions you bookmark will appear here. Browse the agenda and add sessions to your personal schedule.'
                  : 'Sessions for this event will be published soon. Check back later or contact the event organizer.',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF757575),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
