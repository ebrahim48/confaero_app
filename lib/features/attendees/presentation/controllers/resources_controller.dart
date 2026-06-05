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

  final RxInt selectedTabIndex = 0.obs;

  final RxList<QnAModel> qaList = <QnAModel>[].obs;
  final RxSet<String> expandedQaIds = <String>{}.obs;
  final TextEditingController questionController = TextEditingController();

  final RxList<PollModel> pollsList = <PollModel>[].obs;
  final RxMap<String, List<bool>> pollSelectedOptions = <String, List<bool>>{}.obs;

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

  Future<bool> submitQuestion(String question) async {
    if (question.trim().isEmpty) return false;
    isSubmitting.value = true;
    try {
      await _service.submitQuestion(currentEventId, question.trim());
      ToastMessageHelper.showToastMessage('Question submitted successfully!');
      await fetchData();
      return true;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit question. Please try again.', title: 'Error');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> submitPollVote(String pollId, int selectedOptionIndex) async {
    try {
      await _service.submitPollVote(
        pollId: pollId,
        eventId: currentEventId,
        selectedOptionIndex: selectedOptionIndex,
      );
      await fetchData();
    } catch (e) {
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
      return;
    }
    if (selectedOption.value.isEmpty) {
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
      selectedRating.value = 0;
      selectedOption.value = '';
      suggestionController.clear();
    } catch (e) {
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
