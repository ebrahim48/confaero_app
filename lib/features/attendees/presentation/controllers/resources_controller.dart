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
  final RxBool isSurveyLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  String get currentEventId => SessionController.to.eventId;

  // Selected tab index (0 = Q&A, 1 = Polls, 2 = Survey)
  final RxInt selectedTabIndex = 0.obs;

  // Q&A List
  final RxList<QnAModel> qaList = <QnAModel>[].obs;
  final RxSet<String> expandedQaIds = <String>{}.obs;
  final TextEditingController questionController = TextEditingController();

  // Polls List
  final RxList<PollModel> pollsList = <PollModel>[].obs;
  final RxMap<String, List<bool>> pollSelectedOptions = <String, List<bool>>{}.obs;

  // Survey related
  final RxInt selectedRating = 0.obs;
  final RxString selectedOption = ''.obs;
  final TextEditingController suggestionController = TextEditingController();
  final RxString suggestionError = ''.obs;

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
      if (!e.toString().contains('404')) {
        ToastMessageHelper.showToastMessage('Failed to load resources', title: 'Error');
      }
      qaList.clear();
      pollsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  Future<void> submitPollVote(String pollId, int selectedOptionIndex) async {
    try {
      await _service.submitPollVote(
        pollId: pollId,
        eventId: currentEventId,
        selectedOptionIndex: selectedOptionIndex,
      );
      ToastMessageHelper.showToastMessage('Vote submitted successfully!', title: 'Success');
      await fetchData();
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

  void setRating(int rating) {
    selectedRating.value = rating;
  }

  void setOption(String option) {
    selectedOption.value = option;
  }

  Future<void> submitSurvey() async {
    if (selectedRating.value == 0) {
      ToastMessageHelper.showToastMessage('Please select a rating', title: 'Error');
      return;
    }
    if (selectedOption.value.isEmpty) {
      ToastMessageHelper.showToastMessage('Please answer all questions', title: 'Error');
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
      ToastMessageHelper.showToastMessage('Survey submitted successfully!', title: 'Success');
      selectedRating.value = 0;
      selectedOption.value = '';
      suggestionController.clear();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit survey', title: 'Error');
    } finally {
      isSurveyLoading.value = false;
    }
  }

  @override
  void onClose() {
    questionController.dispose();
    suggestionController.dispose();
    super.onClose();
  }
}
