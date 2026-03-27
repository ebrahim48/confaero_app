import 'package:get/get.dart';

import '../../../../core/helpers/toast_message_helper.dart';
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
      ToastMessageHelper.showToastMessage('Failed to load sessions', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startSession(String sessionId) async {
    try {
      final response = await _service.startSession(sessionId);
      currentSession.value = response['data'] as Map<String, dynamic>?;
      ToastMessageHelper.showToastMessage('Session started', title: 'Success');
      loadSessions();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to start session', title: 'Error');
    }
  }

  Future<void> joinSession(String sessionId) async {
    try {
      final response = await _service.joinSession(sessionId);
      final joinUrl = response['data']?['joinUrl'] as String?;
      if (joinUrl != null) {
        ToastMessageHelper.showToastMessage('Joining session...', title: 'Success');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to join session', title: 'Error');
    }
  }

  Future<void> endSession(String sessionId) async {
    try {
      await _service.endSession(sessionId);
      currentSession.value = null;
      ToastMessageHelper.showToastMessage('Session ended', title: 'Success');
      loadSessions();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to end session', title: 'Error');
    }
  }
}
