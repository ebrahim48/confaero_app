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

  String _surveyId = '';

  final RxInt selectedRating = 0.obs;
  final RxString selectedOption = ''.obs;
  final TextEditingController suggestionController = TextEditingController();
  final RxString suggestionError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    suggestionController.addListener(() {
      suggestionError.value = '';
    });
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    await Future.wait([
      _service.getEventQnA(currentEventId).then(
        (data) => qaList.assignAll(data),
        onError: (_) => qaList.clear(),
      ),
      _service.getEventPolls(currentEventId).then(
        (data) => pollsList.assignAll(data),
        onError: (_) => pollsList.clear(),
      ),
      _service.getEventSurvey(currentEventId).then(
        (survey) { if (survey != null) _surveyId = survey.id; },
        onError: (_) {},
      ),
    ]);
    isLoading.value = false;
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

  Future<void> submitPollVote(String pollId, String optionId, int selectedOptionIndex) async {
    try {
      await _service.submitPollVote(
        pollId: pollId,
        optionId: optionId,
        selectedOptionIndex: selectedOptionIndex,
      );
      await fetchData();
    } catch (e) {
      // fail silently — UI already popped
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
      ToastMessageHelper.showToastMessage('Please select a rating', title: 'Required');
      return;
    }
    if (selectedOption.value.isEmpty) {
      ToastMessageHelper.showToastMessage('Please answer whether the sessions were helpful', title: 'Required');
      return;
    }
    final suggestion = suggestionController.text.trim();
    try {
      isSurveyLoading.value = true;
      // Use fetched surveyId; fall back to eventId if no survey document was loaded
      final surveyTarget = _surveyId.isNotEmpty ? _surveyId : currentEventId;
      final payload = <String, dynamic>{
        'rating': selectedRating.value,
        'helpful': selectedOption.value == 'Yes',
      };
      if (suggestion.isNotEmpty) {
        payload['suggestion'] = suggestion;
      }
      final result = await _service.submitSurvey(surveyTarget, payload);
      if (result['success'] == false) {
        ToastMessageHelper.showToastMessage(
          result['message']?.toString() ?? 'Failed to submit feedback.',
          title: 'Error',
        );
        return;
      }
      ToastMessageHelper.showToastMessage('Feedback submitted successfully!');
      selectedRating.value = 0;
      selectedOption.value = '';
      suggestionController.clear();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit feedback. Please try again.', title: 'Error');
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
