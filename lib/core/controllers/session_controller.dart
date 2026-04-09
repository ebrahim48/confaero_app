import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../helpers/prefs_helper.dart';
import '../services/socket_service.dart';

/// Global singleton controller that tracks the currently active event.
///
/// Usage:
///   - Write: SessionController.to.setEvent(eventId, eventTitle)
///   - Read:  SessionController.to.eventId
class SessionController extends GetxController {
  static SessionController get to => Get.find<SessionController>();

  /// Reactive event ID (observe this in Obx widgets).
  final RxString eventIdRx = ''.obs;

  /// Returns the live event ID string (empty string if none selected).
  final RxString eventTitle = ''.obs;

  /// Returns the live event ID string (empty string if none selected).
  String get eventId => eventIdRx.value;

  /// Returns true if an event has been selected.
  bool get hasEvent => eventIdRx.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final saved = await PrefsHelper.getString(AppConstants.currentEventId);
    if (saved.isNotEmpty) {
      eventIdRx.value = saved;
      // Auto-connect Socket.IO if user already has an event on startup
      _connectSocketOnStartup();
    }
  }

  /// Connects Socket.IO on app startup when a saved event exists.
  void _connectSocketOnStartup() {
    try {
      final socketService = Get.find<SocketService>();
      // Use Future.microtask to avoid blocking the init cycle
      Future.microtask(() => socketService.connect());
    } catch (_) {
      // SocketService may not be registered yet during early startup
    }
  }

  /// Call this whenever the user enters an event (from EventsController).
  Future<void> setEvent(String eventId, {String title = ''}) async {
    eventIdRx.value = eventId;
    eventTitle.value = title;
    await PrefsHelper.setString(AppConstants.currentEventId, eventId);

    // Connect (or reconnect) Socket.IO with the new event context
    try {
      final socketService = Get.find<SocketService>();
      await socketService.reconnect();
    } catch (_) {
      // SocketService may not be registered yet during early startup
    }
  }

  /// Clear the current event (e.g., on logout).
  Future<void> clearEvent() async {
    eventIdRx.value = '';
    eventTitle.value = '';
    await PrefsHelper.setString(AppConstants.currentEventId, '');

    // Disconnect socket when leaving event / logging out
    try {
      final socketService = Get.find<SocketService>();
      socketService.disconnect();
    } catch (_) {}
  }
}
