import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/video_conference_service.dart';
import '../../../resources/domain/services/resource_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

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
        eventId: currentEventId,
        optionId: selectedIndices.first.toString(),
      );

      ToastMessageHelper.showToastMessage('Your vote has been submitted', title: 'Success');
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit vote', title: 'Error');
    }
  }

  /// Join live session via VideoConferenceService
  Future<void> joinSession() async {
    try {
      final response = await _videoService.joinSession(currentEventId);
      final joinUrl = response['data']?['joinUrl'] as String?;
      if (joinUrl != null) {
        // TODO: Open join URL in browser or WebView
        ToastMessageHelper.showToastMessage('Joining live session...', title: 'Success');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to join session', title: 'Error');
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
