import 'package:get/get.dart';

import '../../../../core/services/video_conference_service.dart';

class VideoConferenceController extends GetxController {
  final VideoConferenceService _service = Get.find<VideoConferenceService>();

  final sessions = <Map<String, dynamic>>[].obs;
  final currentSession = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadSessions();
  }

  Future<void> loadSessions() async {
    try {
      isLoading.value = true;
      final response = await _service.getLiveSession(currentEventId);
      if (response['data'] is List) {
        sessions.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sessions');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startSession(String sessionId) async {
    try {
      final response = await _service.startSession(sessionId);
      currentSession.value = response['data'] as Map<String, dynamic>?;
      Get.snackbar('Success', 'Session started');
      loadSessions();
    } catch (e) {
      Get.snackbar('Error', 'Failed to start session');
    }
  }

  Future<void> joinSession(String sessionId) async {
    try {
      final response = await _service.joinSession(sessionId);
      final joinUrl = response['data']?['joinUrl'] as String?;
      if (joinUrl != null) {
        Get.snackbar('Success', 'Joining session...');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to join session');
    }
  }

  Future<void> endSession(String sessionId) async {
    try {
      await _service.endSession(sessionId);
      currentSession.value = null;
      Get.snackbar('Success', 'Session ended');
      loadSessions();
    } catch (e) {
      Get.snackbar('Error', 'Failed to end session');
    }
  }
}
