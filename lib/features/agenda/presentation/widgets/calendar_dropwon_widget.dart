import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDropdown extends StatelessWidget {
  final String selectedMonth;
  final Function(DateTime) onDateSelected;

  const CalendarDropdown({
    super.key,
    required this.selectedMonth,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCalendarBottomSheet(context),
      child: Row(
        children: [
          Text(
            selectedMonth,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff252525),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.keyboard_arrow_down,
            size: 20.sp,
            color: const Color(0xff252525),
          ),
        ],
      ),
    );
  }

  void _showCalendarBottomSheet(BuildContext context) {
    final DateTime initialDate = _parseMonthString(selectedMonth);
    final Rx<DateTime> selectedDate = initialDate.obs;
    final Rx<DateTime> focusedDay = initialDate.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 500.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              // Handle Bar
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff252525),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Calendar
              Expanded(
                child: Obx(() {
                  return TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    focusedDay: focusedDay.value,
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDate.value, day);
                    },
                    onDaySelected: (selected, focused) {
                      selectedDate.value = selected;
                      focusedDay.value = focused;
                    },
                    onPageChanged: (focused) {
                      focusedDay.value = focused;
                    },
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff252525),
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: const Color(0xff5BB8AE),
                        size: 24.sp,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: const Color(0xff5BB8AE),
                        size: 24.sp,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: const Color(0xff5BB8AE).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xff0FC3C2), Color(0xff06B6B4)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      todayTextStyle: TextStyle(
                        color: const Color(0xff252525),
                        fontWeight: FontWeight.w600,
                      ),
                      defaultTextStyle: TextStyle(
                        color: const Color(0xff252525),
                        fontSize: 14.sp,
                      ),
                      weekendTextStyle: TextStyle(
                        color: const Color(0xff252525),
                        fontSize: 14.sp,
                      ),
                      outsideTextStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.sp,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff757575),
                      ),
                      weekendStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff757575),
                      ),
                    ),
                  );
                }),
              ),

              // Confirm Button
              Padding(
                padding: EdgeInsets.all(24.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      onDateSelected(selectedDate.value);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5BB8AE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.sp,)
            ],
          ),
        );
      },
    );
  }

  DateTime _parseMonthString(String monthStr) {
    // Parse "JUL 2026" to DateTime
    final parts = monthStr.split(' ');
    final monthNames = {
      'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
      'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12,
    };

    final month = monthNames[parts[0]] ?? 1;
    final year = int.parse(parts[1]);

    return DateTime(year, month, 1);
  }
}