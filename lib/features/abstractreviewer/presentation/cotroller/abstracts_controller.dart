import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/reviewer_service.dart';
import '../../data/reviewer_models.dart';

class AbstractsController extends GetxController {
  final ReviewerService _service = Get.find<ReviewerService>();

  final TextEditingController searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final authors = <AuthorModel>[].obs;

  int get pendingCount => authors.fold(0, (sum, a) => sum + a.pending);

  List<AuthorModel> get filteredAuthors {
    if (searchQuery.value.isEmpty) return authors;
    final q = searchQuery.value.toLowerCase();
    return authors.where((a) => a.name.toLowerCase().contains(q)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() => searchQuery.value = searchController.text);
    loadAuthors();
  }

  Future<void> loadAuthors() async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;
      final result = await _service.getAuthors(eventId);
      final list = result['data'] as List? ?? [];
      authors.value = list
          .map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
