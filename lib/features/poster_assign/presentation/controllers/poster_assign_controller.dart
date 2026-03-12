import 'package:get/get.dart';

import '../../../../core/services/poster_assign_service.dart';

class PosterAssignController extends GetxController {
  final PosterAssignService _service = Get.find<PosterAssignService>();

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
      Get.snackbar('Error', 'Failed to load posters');
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
      Get.snackbar('Success', 'Poster assigned');
      loadAll();
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign poster');
    }
  }

  Future<void> reassignPoster(Map<String, dynamic> data) async {
    try {
      await _service.reassignPoster(currentEventId, data);
      Get.snackbar('Success', 'Poster reassigned');
      loadAll();
    } catch (e) {
      Get.snackbar('Error', 'Failed to reassign poster');
    }
  }

  Future<void> sendReminder(String assignmentId) async {
    try {
      await _service.sendReminder(assignmentId);
      Get.snackbar('Success', 'Reminder sent');
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reminder');
    }
  }

  Future<void> submitReview(Map<String, dynamic> data) async {
    try {
      await _service.submitReview(currentEventId, data);
      Get.back();
      Get.snackbar('Success', 'Review submitted');
      loadAll();
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit review');
    }
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
      Get.snackbar('Error', 'Search failed');
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
      Get.snackbar('Error', 'Search failed');
    }
  }
}
