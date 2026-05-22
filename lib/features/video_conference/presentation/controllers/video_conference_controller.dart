import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/video_conference_service.dart';
import '../../../../core/config/approutes/app_routes.dart';

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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startSession(int sessionIndex) async {
    if (_eventId.isEmpty) return;
    loadingIndex.value = sessionIndex;
    try {
      await _service.startSession(_eventId, sessionIndex);
      await loadSessions();
    } catch (_) {
    } finally {
      loadingIndex.value = null;
    }
  }

  Future<void> joinSession(int sessionIndex) async {
    if (_eventId.isEmpty) return;

    // Request camera + mic permissions before entering the conference
    final camStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (camStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    if (camStatus.isDenied || micStatus.isDenied) {
      return;
    }

    loadingIndex.value = sessionIndex;
    try {
      final response = await _service.joinSession(_eventId, sessionIndex);
      final data = response['data'] as Map<String, dynamic>?;
      final zego = data?['zego'] as Map<String, dynamic>?;

      zegoToken.value = zego?['token']?.toString() ?? '';
      zegoRoomId.value =
          zego?['roomId']?.toString() ?? data?['roomId']?.toString() ?? '';
      zegoAppId.value = (zego?['appId'] as num?)?.toInt() ?? 0;

      final role = data?['role']?.toString() ?? userRole.value;

      loadingIndex.value = null;

      final userId = await PrefsHelper.getString(AppConstants.userId);
      final userName = await PrefsHelper.getString(AppConstants.name);

      if (zegoToken.value.isEmpty || zegoRoomId.value.isEmpty || zegoAppId.value == 0) {
        return;
      }

      AppRoutes.goRouter.push(
        AppRoutes.zegoConferenceScreen,
        extra: {
          'appId': zegoAppId.value,
          'token': zegoToken.value,
          'roomId': zegoRoomId.value,
          'userId': userId.isEmpty
              ? 'user_${DateTime.now().millisecondsSinceEpoch}'
              : userId,
          'userName': userName.isEmpty ? 'Conference User' : userName,
          'role': role,
        },
      );
    } catch (e, s) {
      loadingIndex.value = null;
      // ignore: avoid_print
      print('JOIN SESSION ERROR: $e\n$s');
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
      await loadSessions();
    } catch (_) {
    } finally {
      loadingIndex.value = null;
    }
  }
}
