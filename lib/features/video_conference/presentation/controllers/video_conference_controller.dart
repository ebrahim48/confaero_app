import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/video_conference_service.dart';
import '../widgets/live_chat_screen.dart';

class VideoConferenceController extends GetxController {
  final VideoConferenceService _service = Get.find<VideoConferenceService>();

  final sessions = <Map<String, dynamic>>[].obs;
  final userRole = ''.obs; // 'SPEAKER' or 'ATTENDEE' from API
  final isLoading = false.obs;

  // Tracks which sessionIndex is mid-action (loading spinner per card)
  final loadingIndex = Rxn<int>();

  // Zego credentials stored after join
  final zegoToken = ''.obs;
  final zegoRoomId = ''.obs;
  final zegoAppId = 0.obs;

  String get _eventId => SessionController.to.eventId;
  bool get isSpeaker => userRole.value == 'SPEAKER';

  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }

  Future<void> loadSessions() async {
    if (_eventId.isEmpty) return;
    try {
      isLoading.value = true;
      final response = await _service.getLiveSession(_eventId);
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) return;

      userRole.value = data['role']?.toString() ?? 'ATTENDEE';

      final rawSessions = data['sessions'] as List?;
      if (rawSessions != null) {
        sessions.value = rawSessions
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to load sessions',
          title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startSession(int sessionIndex) async {
    if (_eventId.isEmpty) return;
    loadingIndex.value = sessionIndex;
    try {
      await _service.startSession(_eventId, sessionIndex);
      ToastMessageHelper.showToastMessage('Session started', title: 'Success');
      await loadSessions();
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to start session',
          title: 'Error');
    } finally {
      loadingIndex.value = null;
    }
  }

  Future<void> joinSession(int sessionIndex) async {
    if (_eventId.isEmpty) return;
    loadingIndex.value = sessionIndex;
    try {
      final response = await _service.joinSession(_eventId, sessionIndex);
      final data = response['data'] as Map<String, dynamic>?;
      final zego = data?['zego'] as Map<String, dynamic>?;

      zegoToken.value = zego?['token']?.toString() ?? '';
      zegoRoomId.value =
          zego?['roomId']?.toString() ?? data?['roomId']?.toString() ?? '';
      zegoAppId.value = (zego?['appId'] as num?)?.toInt() ?? 0;

      loadingIndex.value = null;

      // Navigate to live chat for this session
      Get.to(() => LiveChatScreen(sessionIndex: sessionIndex));
    } catch (_) {
      loadingIndex.value = null;
      ToastMessageHelper.showToastMessage('Failed to join session',
          title: 'Error');
    }
  }

  Future<void> endSession(BuildContext context, int sessionIndex) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('End Session'),
        content:
            const Text('Are you sure you want to end this live session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('End', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    if (_eventId.isEmpty) return;
    loadingIndex.value = sessionIndex;
    try {
      await _service.endSession(_eventId, sessionIndex);
      ToastMessageHelper.showToastMessage('Session ended', title: 'Success');
      await loadSessions();
    } catch (_) {
      ToastMessageHelper.showToastMessage('Failed to end session',
          title: 'Error');
    } finally {
      loadingIndex.value = null;
    }
  }
}
