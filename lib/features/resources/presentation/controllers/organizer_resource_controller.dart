import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../domain/services/resource_service.dart';
import '../../data/models/resource_model.dart';

/// Controller for organizer Q&A CRUD and survey analytics.
class OrganizerResourceController extends GetxController {
  final ResourceService _service = Get.find<ResourceService>();

  final String eventId;
  OrganizerResourceController({required this.eventId});

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxList<QnAModel> qaList = <QnAModel>[].obs;
  final RxMap<String, dynamic> surveyAnalytics = <String, dynamic>{}.obs;

  // Forms
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    questionController.dispose();
    answerController.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final qna = await _service.getEventQnA(eventId);
      qaList.assignAll(qna);
      final analytics = await _service.getSurveyAnalytics(eventId);
      surveyAnalytics.assignAll(analytics);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createQnA() async {
    final question = questionController.text.trim();
    final answer = answerController.text.trim();
    if (question.isEmpty || answer.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Enter both a question and an answer.',
        title: 'Warning',
      );
      return;
    }
    isSaving.value = true;
    try {
      await _service.createQnA(eventId, question: question, answer: answer);
      questionController.clear();
      answerController.clear();
      await loadData();
      ToastMessageHelper.showToastMessage('Q&A added');
    } catch (e) {
      _showError(e, 'Could not add the Q&A.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateQnA(QnAModel item) async {
    questionController.text = item.question;
    answerController.text = item.answer;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Edit Q&A'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    isSaving.value = true;
    try {
      await _service.updateQnA(
        item.id,
        eventId,
        question: questionController.text.trim(),
        answer: answerController.text.trim(),
      );
      questionController.clear();
      answerController.clear();
      await loadData();
      ToastMessageHelper.showToastMessage('Q&A updated');
    } catch (e) {
      _showError(e, 'Could not update the Q&A.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteQnA(QnAModel item) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Q&A'),
        content: Text('Delete this Q&A item?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.deleteQnA(item.id, eventId);
      await loadData();
      ToastMessageHelper.showToastMessage('Q&A deleted');
    } catch (e) {
      _showError(e, 'Could not delete the Q&A.');
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }
}
