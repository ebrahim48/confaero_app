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
  final RxBool isSurveyLoading = false.obs;

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
    suggestionController.addListener(() {
      final text = suggestionController.text.trim();
      if (text.isNotEmpty && text.length < 80) {
        suggestionError.value = 'Minimum 80 characters required (${text.length}/80)';
      } else {
        suggestionError.value = '';
      }
    });
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

  Future<void> submitPollVote(String pollId, int selectedOptionIndex) async {
    try {
      await _service.submitPollVote(
        pollId: pollId,
        eventId: currentEventId,
        selectedOptionIndex: selectedOptionIndex,
      );
      SnackbarHelper.showSuccess('Success', 'Vote submitted successfully!');
      await fetchData();
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
  final RxString suggestionError = ''.obs;

  // Set rating
  void setRating(int rating) {
    selectedRating.value = rating;
  }

  // Set option
  void setOption(String option) {
    selectedOption.value = option;
  }

  // Submit survey
  Future<void> submitSurvey() async {
    if (selectedRating.value == 0) {
      SnackbarHelper.showError('Error', 'Please select a rating');
      return;
    }
    if (selectedOption.value.isEmpty) {
      SnackbarHelper.showError('Error', 'Please answer all questions');
      return;
    }
    final suggestion = suggestionController.text.trim();
    try {
      isSurveyLoading.value = true;
      final payload = <String, dynamic>{
        'rating': selectedRating.value,
        'helpful': selectedOption.value == 'Yes',
      };
      if (suggestion.isNotEmpty) {
        payload['suggestion'] = suggestion;
      }
      await _service.submitSurvey(currentEventId, payload);
      SnackbarHelper.showSuccess('Success', 'Survey submitted successfully!');
      selectedRating.value = 0;
      selectedOption.value = '';
      suggestionController.clear();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to submit survey');
    } finally {
      isSurveyLoading.value = false;
    }
  }

  @override
  void onClose() {
    suggestionController.dispose();
    super.onClose();
  }
}
