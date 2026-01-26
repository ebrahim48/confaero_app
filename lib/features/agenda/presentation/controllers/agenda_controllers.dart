import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AgendaController extends GetxController {
  // Selected tab (0 = All Sessions, 1 = My Agenda)
  final RxInt selectedTab = 0.obs;

  // Selected month/year
  final RxString selectedMonth = 'JUL 2026'.obs;

  // Selected day
  final RxInt selectedDay = 3.obs;

  // Selected full date
  final Rx<DateTime> selectedDate = DateTime(2026, 7, 3).obs;

  // Week days - dynamically generated based on selected date
  final RxList<Map<String, dynamic>> weekDays = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateWeekDays(selectedDate.value);
  }

  // All sessions (Image 1 - All Sessions Tab)
  final RxList<Map<String, dynamic>> allSessions = <Map<String, dynamic>>[
    {
      'time': '08:30 AM',
      'type': 'KEYNOTE',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '08:30 - 09:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
    {
      'time': '09:00 AM',
      'type': 'WORKSHOP',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '9:00 - 11:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
    {
      'time': '11:00 AM',
      'type': 'BREAK',
      'title': 'Coffee Break / Posters & Exhibit',
      'duration': '11:00 AM - 11:30 AM',
      'location': 'Exhibit Area',
      'isBreak': true,
    },
  ].obs;

  // My Agenda sessions (Image 2 - My Agenda Tab)
  final RxList<Map<String, dynamic>> myAgendaSessions = <Map<String, dynamic>>[
    {
      'time': '08:30 AM',
      'type': 'KEYNOTE',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '08:30 - 09:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
    {
      'time': '09:00 AM',
      'type': 'KEYNOTE',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '08:30 - 09:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
  ].obs;

  // Get current sessions based on selected tab
  RxList<Map<String, dynamic>> get currentSessions {
    return selectedTab.value == 0 ? allSessions : myAgendaSessions;
  }

  // Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Change day
  void changeDay(int day) {
    selectedDay.value = day;

    // Update the full selected date
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      day,
    );
  }

  // Handle calendar date selection
  void onCalendarDateSelected(DateTime date) {
    selectedDate.value = date;
    selectedDay.value = date.day;

    // Update month string
    selectedMonth.value = _formatMonthYear(date);

    // Generate new week days based on selected date
    _generateWeekDays(date);
  }

  // Generate week days around selected date
  void _generateWeekDays(DateTime date) {
    weekDays.clear();

    // Find Monday of the week containing the selected date
    final dayOfWeek = date.weekday; // Monday = 1, Sunday = 7
    final monday = date.subtract(Duration(days: dayOfWeek - 1));

    // Generate 6 days starting from Monday
    for (int i = 0; i < 6; i++) {
      final currentDay = monday.add(Duration(days: i));
      weekDays.add({
        'day': _getDayName(currentDay.weekday),
        'date': currentDay.day,
        'fullDate': currentDay,
      });
    }
  }

  // Get day name from weekday number
  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  // Format DateTime to "MMM YYYY" format
  String _formatMonthYear(DateTime date) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // Toggle favorite
  void toggleFavorite(int index) {
    final sessions = currentSessions;
    if (sessions[index]['isBreak'] != true) {
      sessions[index]['favorites'] = sessions[index]['favorites'] == 0 ? 1 : 0;
      sessions.refresh();
    }
  }

  // Add session to my agenda
  void addToMyAgenda(Map<String, dynamic> session) {
    if (!myAgendaSessions.contains(session)) {
      myAgendaSessions.add(session);
    }
  }

  // Remove session from my agenda
  void removeFromMyAgenda(Map<String, dynamic> session) {
    myAgendaSessions.remove(session);
  }
}