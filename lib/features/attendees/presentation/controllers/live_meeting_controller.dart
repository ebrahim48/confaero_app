import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Event/session context
  String currentEventId = '';

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
      Get.snackbar(
        'Error',
        'Please select at least one option',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
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
        eventId: currentEventId,
        selectedOptionIndex: selectedIndices.first,
      );

      Get.snackbar(
        'Success',
        'Your vote has been submitted',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xff32A69A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit vote');
    }
  }

  /// Join live session via VideoConferenceService
  Future<void> joinSession() async {
    try {
      final response = await _videoService.joinSession(currentEventId);
      final joinUrl = response['data']?['joinUrl'] as String?;
      if (joinUrl != null) {
        // TODO: Open join URL in browser or WebView
        Get.snackbar('Success', 'Joining live session...');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to join session');
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
