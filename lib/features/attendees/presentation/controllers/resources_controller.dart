// lib/features/resources/controllers/resources_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../resources/data/models/resource_model.dart';
import '../../../resources/domain/services/resource_service.dart';

class ResourcesController extends GetxController {
  final ResourceService _service = Get.find<ResourceService>();
  final RxBool isLoading = false.obs;

  // Read event ID from global session state
  String get currentEventId => SessionController.to.eventId;
  // Selected tab index (0 = Q&A, 1 = Polls, 2 = Survey)
  final RxInt selectedTabIndex = 0.obs;

  // Q&A List
  final RxList<QnAModel> qaList = <QnAModel>[].obs;
  final RxSet<String> expandedQaIds = <String>{}.obs;

  // Polls List
  final RxList<PollModel> pollsList = <PollModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final qnaData = await _service.getEventQnA(currentEventId);
      qaList.assignAll(qnaData);

      final pollData = await _service.getEventPolls(currentEventId);
      pollsList.assignAll(pollData);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load resources');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitPollVote(String pollId, String optionId) async {
    try {
      await _service.submitPollVote(
        pollId: pollId,
        eventId: currentEventId,
        optionId: optionId,
      );
      SnackbarHelper.showSuccess('Success', 'Vote submitted successfully!');
      // Refresh
      fetchData();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to submit vote');
    }
  }

  // Change tab
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // Toggle Q&A expansion
  void toggleQA(String id) {
    if (expandedQaIds.contains(id)) {
      expandedQaIds.remove(id);
    } else {
      expandedQaIds.add(id);
    }
  }

  // Survey related
  final RxInt selectedRating = 0.obs;
  final RxString selectedOption = ''.obs;
  final TextEditingController suggestionController = TextEditingController();

  // Set rating
  void setRating(int rating) {
    selectedRating.value = rating;
  }

  // Set option
  void setOption(String option) {
    selectedOption.value = option;
  }

  // Submit survey
  void submitSurvey() {
    print('Rating: ${selectedRating.value}');
    print('Option: ${selectedOption.value}');
    print('Suggestion: ${suggestionController.text}');

    SnackbarHelper.showSuccess('Success', 'Survey submitted successfully!');

    // Reset
    selectedRating.value = 0;
    selectedOption.value = '';
    suggestionController.clear();
  }

  @override
  void onClose() {
    suggestionController.dispose();
    super.onClose();
  }
}
