import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/reviewer_service.dart';
import '../../data/reviewer_models.dart';

class ReviewDocumentsController extends GetxController {
  final ReviewerService _service = Get.find<ReviewerService>();
  final String authorId;
  final AuthorModel author;

  ReviewDocumentsController({required this.authorId, required this.author});

  final selectedTab = 'Abstracts'.obs;
  final isLoading = false.obs;
  final abstractDocs = <SubmissionModel>[].obs;
  final posterDocs = <SubmissionModel>[].obs;

  // Review bottom sheet
  final reviewType = 'Reject'.obs;
  final TextEditingController reasonController = TextEditingController();
  final List<String> reviewTypes = ['Reject', 'Revise', 'Approve'];
  final isSubmitting = false.obs;
  String? _currentAttachmentId;

  // Poster scoring
  final posterScores = <String, double>{
    'originality': 0,
    'scientificRigor': 0,
    'clarity': 0,
    'visualDesign': 0,
    'impact': 0,
    'presentation': 0,
  }.obs;
  final posterOverall = false.obs;

  void updateScore(String key, double val) => posterScores[key] = val;

  @override
  void onInit() {
    super.onInit();
    loadSubmissions();
  }

  Future<void> loadSubmissions() async {
    try {
      isLoading.value = true;
      final result = await _service.getAuthorSubmissions(authorId);
      final list = result['data'] as List? ?? [];
      final submissions = list
          .map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>)
              .copyWith(authorId: authorId))
          .toList();
      abstractDocs.value = submissions.where((s) => s.isAbstract).toList();
      posterDocs.value = submissions.where((s) => s.isPoster).toList();
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void setTab(String tab) => selectedTab.value = tab;

  void prepareReview(String attachmentId, String type) {
    _currentAttachmentId = attachmentId;
    reviewType.value = type;
    reasonController.clear();
  }

  Future<void> submitReview(BuildContext context) async {
    final id = _currentAttachmentId;
    if (id == null) return;
    final reason = reasonController.text.trim();

    try {
      isSubmitting.value = true;
      switch (reviewType.value) {
        case 'Approve':
          await _service.approveAttachment(id);
          break;
        case 'Reject':
          await _service.rejectAttachment(id, reason);
          break;
        case 'Revise':
          await _service.reviseAttachment(id, reason);
          break;
      }
      reasonController.clear();
      ToastMessageHelper.showToastMessage('Review submitted');
      if (context.mounted) Navigator.of(context).pop();
      await loadSubmissions();
    } catch (e) {
      _showError(e, 'Could not submit the review.');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> submitPosterReview(BuildContext context, String attachmentId) async {
    try {
      isSubmitting.value = true;
      final scores = Map<String, int>.fromEntries(
        posterScores.entries.map((e) => MapEntry(e.key, e.value.toInt())),
      );
      final payload = <String, dynamic>{
        ...scores.map((k, v) => MapEntry(k, v)),
        'overall': posterOverall.value,
      };
      await _service.reviewPosterImage(attachmentId, payload);
      ToastMessageHelper.showToastMessage('Poster review submitted');
      if (context.mounted) Navigator.of(context).pop();
      await loadSubmissions();
    } catch (e) {
      _showError(e, 'Could not submit the poster review.');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> rejectPoster(BuildContext context, String attachmentId, String reason) async {
    try {
      isSubmitting.value = true;
      await _service.rejectPoster(attachmentId, reason: reason);
      ToastMessageHelper.showToastMessage('Poster rejected');
      if (context.mounted) Navigator.of(context).pop();
      await loadSubmissions();
    } catch (e) {
      _showError(e, 'Could not reject the poster.');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> flagToAdmin(String attachmentId, String reason) async {
    try {
      await _service.flagToAdmin(attachmentId, reason);
      ToastMessageHelper.showToastMessage('Flagged to admin');
    } catch (e) {
      _showError(e, 'Could not flag this submission.');
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
