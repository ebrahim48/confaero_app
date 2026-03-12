import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../domain/services/agenda_service.dart';
import '../../data/models/session_model.dart';

class AgendaController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();

  // Loading states
  final RxBool isLoading = false.obs;

  // Current Event ID — reads from global session state
  String get currentEventId => SessionController.to.eventId;

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
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    isLoading.value = true;
    try {
      final all = await _agendaService.getEventAgenda(currentEventId);
      allSessions.assignAll(all);

      final bookmarked = await _agendaService.getMyAgenda(currentEventId);
      myAgendaSessions.assignAll(bookmarked);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load agenda');
    } finally {
      isLoading.value = false;
    }
  }

  // All sessions (Image 1 - All Sessions Tab)
  final RxList<SessionModel> allSessions = <SessionModel>[].obs;

  // My Agenda sessions (Image 2 - My Agenda Tab)
  final RxList<SessionModel> myAgendaSessions = <SessionModel>[].obs;

  // Get current sessions based on selected tab
  RxList<SessionModel> get currentSessions {
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
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // Toggle favorite (Like)
  Future<void> toggleFavorite(int index) async {
    final session = currentSessions[index];
    try {
      await _agendaService.toggleSessionLike(currentEventId, session.id);
      await _fetchSessions(); // Refresh data to get updated likes count
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to toggle like');
    }
  }

  // Add session to my agenda (Bookmark)
  Future<void> addToMyAgenda(SessionModel session) async {
    try {
      await _agendaService.bookmarkSession(currentEventId, session.id);
      SnackbarHelper.showSuccess('Success', 'Added to your agenda');
      await _fetchSessions();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to add to agenda');
    }
  }

  // Remove session from my agenda
  Future<void> removeFromMyAgenda(SessionModel session) async {
    try {
      await _agendaService.removeBookmarkSession(currentEventId, session.id);
      SnackbarHelper.showSuccess('Success', 'Removed from your agenda');
      await _fetchSessions();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to remove from agenda');
    }
  }
}
