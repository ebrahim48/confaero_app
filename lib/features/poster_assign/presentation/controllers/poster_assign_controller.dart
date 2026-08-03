import 'package:get/get.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/poster_assign_service.dart';
import '../../../../core/services/reviewer_service.dart';

class PosterAssignController extends GetxController {
  final PosterAssignService _service = Get.find<PosterAssignService>();
  final ReviewerService _reviewerService = Get.find<ReviewerService>();

  final unassigned = <Map<String, dynamic>>[].obs;
  final assigned = <Map<String, dynamic>>[].obs;
  final reported = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final currentTab = 0.obs;

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadAll();
  }

  Future<void> loadAll() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _service.getUnassignedPosters(currentEventId),
        _service.getAssignedPosters(currentEventId),
        _service.getReportedPosters(currentEventId),
      ]);
      _parseList(results[0], unassigned);
      _parseList(results[1], assigned);
      _parseList(results[2], reported);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void _parseList(
    Map<String, dynamic> resp,
    RxList<Map<String, dynamic>> target,
  ) {
    if (resp['data'] is List) {
      target.value =
          (resp['data'] as List).map((e) => e as Map<String, dynamic>).toList();
    }
  }

  Future<void> assignPoster(Map<String, dynamic> data) async {
    try {
      await _service.assignPoster(currentEventId, data);
      ToastMessageHelper.showToastMessage('Poster assigned');
      loadAll();
    } catch (e) {
      _showError(e, 'Could not assign the poster.');
    }
  }

  Future<void> reassignPoster(Map<String, dynamic> data) async {
    try {
      await _service.reassignPoster(currentEventId, data);
      ToastMessageHelper.showToastMessage('Poster reassigned');
      loadAll();
    } catch (e) {
      _showError(e, 'Could not reassign the poster.');
    }
  }

  Future<void> sendReminder(String assignmentId) async {
    try {
      await _service.sendReminder(assignmentId);
      ToastMessageHelper.showToastMessage('Reminder sent');
    } catch (e) {
      _showError(e, 'Could not send the reminder.');
    }
  }

  Future<void> submitReview(String attachmentId, Map<String, dynamic> data) async {
    try {
      await _reviewerService.reviewPosterImage(attachmentId, data);
      ToastMessageHelper.showToastMessage('Review submitted');
      Get.back();
      loadAll();
    } catch (e) {
      _showError(e, 'Could not submit the review.');
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }

  void switchTab(int index) => currentTab.value = index;

  // ======================== Search Methods ========================

  final searchResults = <Map<String, dynamic>>[].obs;

  Future<void> searchReviewer() async {
    try {
      final response = await _service.searchReviewer(currentEventId);
      if (response['data'] is List) {
        searchResults.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
    }
  }

  Future<void> searchUnassigned() async {
    try {
      final response = await _service.searchUnassigned(currentEventId);
      if (response['data'] is List) {
        searchResults.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
    }
  }
}
