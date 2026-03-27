// lib/features/resources/controllers/resources_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
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
      ToastMessageHelper.showToastMessage('Failed to load resources', title: 'Error');
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
      ToastMessageHelper.showToastMessage('Vote submitted successfully!', title: 'Success');
      // Refresh
      fetchData();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit vote', title: 'Error');
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

  // Submit survey — calls actual API
  Future<void> submitSurvey() async {
    if (selectedRating.value == 0 && selectedOption.value.isEmpty) {
      ToastMessageHelper.showToastMessage('Please provide a rating or select an option', title: 'Error');
      return;
    }

    try {
      final surveyData = <String, dynamic>{};
      if (selectedRating.value > 0) surveyData['rating'] = selectedRating.value;
      if (selectedOption.value.isNotEmpty) surveyData['option'] = selectedOption.value;
      if (suggestionController.text.trim().isNotEmpty) {
        surveyData['suggestion'] = suggestionController.text.trim();
      }

      await _service.submitSurvey(currentEventId, surveyData);
      ToastMessageHelper.showToastMessage('Survey submitted successfully!', title: 'Success');

      // Reset
      selectedRating.value = 0;
      selectedOption.value = '';
      suggestionController.clear();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit survey', title: 'Error');
    }
  }

  @override
  void onClose() {
    suggestionController.dispose();
    super.onClose();
  }
}
