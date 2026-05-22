import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/organizer_service.dart';

class OrganizerController extends GetxController {
  final OrganizerService _service = Get.find<OrganizerService>();

  final sessions = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
  }

  /// Load sessions — placeholder, session CRUD endpoints removed from backend
  Future<void> loadSessions() async {
    isLoading.value = false;
  }

  // REMOVED: createSession, updateSession, deleteSession — endpoints no longer in backend API
}
