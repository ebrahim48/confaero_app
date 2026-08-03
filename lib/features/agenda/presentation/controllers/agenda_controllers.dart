import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../domain/services/agenda_service.dart';
import '../../data/models/session_model.dart';

class AgendaController extends GetxController {
  final AgendaService _agendaService = Get.find<AgendaService>();

  final RxBool isLoading = false.obs;

  String get currentEventId => SessionController.to.eventId;

  final RxInt selectedTab = 0.obs;
  final RxString selectedMonth = 'JUL 2026'.obs;
  final RxInt selectedDay = 3.obs;
  final Rx<DateTime> selectedDate = DateTime(2026, 7, 3).obs;
  final RxList<Map<String, dynamic>> weekDays = <Map<String, dynamic>>[].obs;

  final RxList<SessionModel> allSessions = <SessionModel>[].obs;
  final RxList<SessionModel> myAgendaSessions = <SessionModel>[].obs;

  RxList<SessionModel> get currentSessions =>
      selectedTab.value == 0 ? allSessions : myAgendaSessions;

  @override
  void onInit() {
    super.onInit();
    _generateWeekDays(selectedDate.value);

    // Fetch immediately if eventId is already available, otherwise wait for it
    if (currentEventId.isNotEmpty) {
      _fetchSessions();
    } else {
      ever(SessionController.to.eventIdRx, (String id) {
        if (id.isNotEmpty && allSessions.isEmpty) {
          _fetchSessions();
        }
      });
    }
  }

  Future<void> _fetchSessions() async {
    final eventId = currentEventId;
    if (eventId.isEmpty) return;
    isLoading.value = true;
    try {
      final all = await _agendaService.getEventAgenda(eventId);
      allSessions.assignAll(all);

      final bookmarked = await _agendaService.getMyAgenda(eventId);
      myAgendaSessions.assignAll(bookmarked);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => _fetchSessions();

  void changeTab(int index) => selectedTab.value = index;

  void changeDay(int day) {
    selectedDay.value = day;
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      day,
    );
  }

  void onCalendarDateSelected(DateTime date) {
    selectedDate.value = date;
    selectedDay.value = date.day;
    selectedMonth.value = _formatMonthYear(date);
    _generateWeekDays(date);
  }

  void _generateWeekDays(DateTime date) {
    weekDays.clear();
    final monday = date.subtract(Duration(days: date.weekday - 1));
    for (int i = 0; i < 6; i++) {
      final d = monday.add(Duration(days: i));
      weekDays.add({
        'day': _getDayName(d.weekday),
        'date': d.day,
        'fullDate': d,
      });
    }
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _formatMonthYear(DateTime date) {
    const months = ['JAN','FEB','MAR','APR','MAY','JUN',
                    'JUL','AUG','SEP','OCT','NOV','DEC'];
    return '${months[date.month - 1]} ${date.year}';
  }

  Future<void> toggleFavorite(int index) async {
    final session = currentSessions[index];
    try {
      await _agendaService.toggleSessionLike(currentEventId, session.idx.toString());
      await _fetchSessions();
    } catch (e) {
      _showError(e, 'Could not update this session.');
    }
  }

  Future<void> toggleBookmark(SessionModel session) {
    return session.isBookmarked
        ? removeFromMyAgenda(session)
        : addToMyAgenda(session);
  }

  Future<void> addToMyAgenda(SessionModel session) async {
    try {
      await _agendaService.bookmarkSession(currentEventId, session.idx.toString());
      await _fetchSessions();
      ToastMessageHelper.showToastMessage('Added to your agenda');
    } catch (e) {
      _showError(e, 'Could not add this session to your agenda.');
    }
  }

  Future<void> removeFromMyAgenda(SessionModel session) async {
    try {
      await _agendaService.removeBookmarkSession(currentEventId, session.idx.toString());
      await _fetchSessions();
      ToastMessageHelper.showToastMessage('Removed from your agenda');
    } catch (e) {
      _showError(e, 'Could not remove this session from your agenda.');
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }
}
