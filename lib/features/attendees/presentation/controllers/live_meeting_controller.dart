import 'package:get/get.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/video_conference_service.dart';
import '../../../resources/domain/services/resource_service.dart';

class LiveMeetingController extends GetxController {
  final ResourceService _resourceService = Get.find<ResourceService>();
  final VideoConferenceService _videoService =
      Get.find<VideoConferenceService>();

  // Current tab (0 = Polls, 1 = Chat)
  final currentTab = 0.obs;

  // Poll options selection state
  final pollOptions = <bool>[false, false, false].obs;

  String get _eventId => SessionController.to.eventId;

  // Switch between Polls and Chat tabs
  void switchTab(int index) {
    currentTab.value = index;
  }

  // Toggle poll option selection
  void togglePollOption(int index) {
    pollOptions[index] = !pollOptions[index];
    pollOptions.refresh();
  }

  /// Submit poll vote via ResourceService
  Future<void> submitPollVote({required String pollId}) async {
    final hasSelection = pollOptions.any((selected) => selected);

    if (!hasSelection) {
      ToastMessageHelper.showToastMessage('Please select at least one option', title: 'Error');
      return;
    }

    try {
      // Build selected options
      final selectedIndices = <int>[];
      for (int i = 0; i < pollOptions.length; i++) {
        if (pollOptions[i]) selectedIndices.add(i);
      }

      await _resourceService.submitPollVote(
        pollId: pollId,
        eventId: _eventId,
        selectedOptionIndex: selectedIndices.first,
      );

      ToastMessageHelper.showToastMessage('Your vote has been submitted', title: 'Success');
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit vote', title: 'Error');
    }
  }

  final isJoining = false.obs;

  Future<void> joinSession({int sessionIndex = 0}) async {
    if (_eventId.isEmpty) return;
    isJoining.value = true;
    try {
      final response = await _videoService.joinSession(_eventId, sessionIndex);
      final data = response['data'] as Map<String, dynamic>?;
      final zego = data?['zego'] as Map<String, dynamic>?;

      final token = zego?['token']?.toString() ?? '';
      final roomId =
          zego?['roomId']?.toString() ?? data?['roomId']?.toString() ?? '';
      final appId = (zego?['appId'] as num?)?.toInt() ?? 0;
      final role = data?['role']?.toString() ?? 'ATTENDEE';

      if (token.isEmpty || roomId.isEmpty || appId == 0) {
        ToastMessageHelper.showToastMessage('Invalid session credentials',
            title: 'Error');
        return;
      }

      final userId = await PrefsHelper.getString(AppConstants.userId);
      final userName = await PrefsHelper.getString(AppConstants.name);

      AppRoutes.goRouter.push(
        AppRoutes.zegoConferenceScreen,
        extra: {
          'appId': appId,
          'token': token,
          'roomId': roomId,
          'userId': userId.isEmpty
              ? 'user_${DateTime.now().millisecondsSinceEpoch}'
              : userId,
          'userName': userName.isEmpty ? 'Conference User' : userName,
          'role': role,
        },
      );
    } catch (e, s) {
      // ignore: avoid_print
      print('JOIN SESSION ERROR: $e\n$s');
      ToastMessageHelper.showToastMessage('Failed to join session: $e',
          title: 'Error');
    } finally {
      isJoining.value = false;
    }
  }

  // Reset poll selections
  void resetPoll() {
    for (int i = 0; i < pollOptions.length; i++) {
      pollOptions[i] = false;
    }
    pollOptions.refresh();
  }
}
