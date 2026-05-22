import 'package:get/get.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/reviewer_service.dart';

class ReviewerController extends GetxController {
  final ReviewerService _service = Get.find<ReviewerService>();

  final dashboardData = Rxn<Map<String, dynamic>>();
  final authors = <Map<String, dynamic>>[].obs;
  final submissions = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _service.getDashboard(currentEventId),
        _service.getAuthors(currentEventId),
      ]);
      dashboardData.value = results[0]['data'] as Map<String, dynamic>?;
      if (results[1]['data'] is List) {
        authors.value =
            (results[1]['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSubmissions(String authorId) async {
    try {
      isLoading.value = true;
      final response = await _service.getAuthorSubmissions(authorId);
      if (response['data'] is List) {
        submissions.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveAttachment(String id) async {
    try {
      await _service.approveAttachment(id);
    } catch (e) {
    }
  }

  Future<void> rejectAttachment(String id) async {
    try {
      await _service.rejectAttachment(id);
    } catch (e) {
    }
  }

  Future<void> requestRevision(String id) async {
    try {
      await _service.reviseAttachment(id);
    } catch (e) {
    }
  }

  Future<void> flagToAdmin(String id) async {
    try {
      await _service.flagToAdmin(id);
    } catch (e) {
    }
  }

  // ======================== Additional Methods ========================

  final attachmentDetail = Rxn<Map<String, dynamic>>();

  Future<void> loadAttachmentDetails(String attachmentId) async {
    try {
      isLoading.value = true;
      final response = await _service.getAttachmentDetails(attachmentId);
      attachmentDetail.value = response['data'] as Map<String, dynamic>?;
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reviewPosterImage(
    String attachmentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _service.reviewPosterImage(attachmentId, data);
    } catch (e) {
    }
  }
}
