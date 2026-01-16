import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveMeetingController extends GetxController {
  // Current tab (0 = Polls, 1 = Chat)
  final currentTab = 0.obs;

  // Poll options selection state
  final pollOptions = <bool>[false, false, false].obs;

  // Switch between Polls and Chat tabs
  void switchTab(int index) {
    currentTab.value = index;
  }

  // Toggle poll option selection
  void togglePollOption(int index) {
    pollOptions[index] = !pollOptions[index];
    pollOptions.refresh(); // Update UI
  }

  // Submit poll vote
  void submitPollVote() {
    // Check if at least one option is selected
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

    // Show success message
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

    // TODO: Backend e pathano - pore add korba
    // await api.submitPollVote(pollOptions);
  }

  // Reset poll selections (optional)
  void resetPoll() {
    for (int i = 0; i < pollOptions.length; i++) {
      pollOptions[i] = false;
    }
    pollOptions.refresh();
  }
}