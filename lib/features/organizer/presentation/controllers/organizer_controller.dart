import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/organizer_service.dart';

class OrganizerController extends GetxController {
  final OrganizerService _service = Get.find<OrganizerService>();

  final sessions = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final locationController = TextEditingController();

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadSessions();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    super.onClose();
  }

  /// Load sessions — placeholder until GET sessions endpoint is available
  Future<void> loadSessions() async {
    // Sessions managed client-side after creation for now
    isLoading.value = false;
  }

  /// Create a new session
  Future<void> createSession() async {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a session title');
      return;
    }

    try {
      isSaving.value = true;
      await _service.createSession(currentEventId, {
        'title': titleController.text,
        'description': descriptionController.text,
        'startTime': startTimeController.text,
        'endTime': endTimeController.text,
        'location': locationController.text,
      });
      _clearForm();
      Get.back();
      Get.snackbar('Success', 'Session created');
      loadSessions();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create session');
    } finally {
      isSaving.value = false;
    }
  }

  /// Update a session
  Future<void> updateSession(String sessionId) async {
    try {
      isSaving.value = true;
      await _service.updateSession(currentEventId, sessionId, {
        'title': titleController.text,
        'description': descriptionController.text,
        'startTime': startTimeController.text,
        'endTime': endTimeController.text,
        'location': locationController.text,
      });
      _clearForm();
      Get.back();
      Get.snackbar('Success', 'Session updated');
      loadSessions();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update session');
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete a session
  Future<void> deleteSession(String sessionId) async {
    try {
      await _service.deleteSession(currentEventId, sessionId);
      sessions.removeWhere((s) => s['_id'] == sessionId);
      Get.snackbar('Success', 'Session deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete session');
    }
  }

  /// Populate form for editing
  void populateForm(Map<String, dynamic> session) {
    titleController.text = session['title'] as String? ?? '';
    descriptionController.text = session['description'] as String? ?? '';
    startTimeController.text = session['startTime'] as String? ?? '';
    endTimeController.text = session['endTime'] as String? ?? '';
    locationController.text = session['location'] as String? ?? '';
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    startTimeController.clear();
    endTimeController.clear();
    locationController.clear();
  }
}
