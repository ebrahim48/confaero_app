import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/services/organizer_service.dart';

/// Controller for organizer attendee management:
/// listing registrations, viewing attendee details, and removing attendees.
class OrganizerAttendeeController extends GetxController {
  final OrganizerService _service = Get.find<OrganizerService>();

  final String eventId;
  OrganizerAttendeeController({required this.eventId});

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> registrations =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredRegistrations =
      <Map<String, dynamic>>[].obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadRegistrations();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadRegistrations() async {
    isLoading.value = true;
    try {
      final data = await _service.getAllRegistrations(eventId);
      registrations.assignAll(data);
      filteredRegistrations.assignAll(data);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load registrations');
    } finally {
      isLoading.value = false;
    }
  }

  void searchRegistrations(String query) {
    if (query.isEmpty) {
      filteredRegistrations.assignAll(registrations);
      return;
    }
    filteredRegistrations.assignAll(
      registrations.where((r) {
        final name = _getName(r).toLowerCase();
        final email = _getEmail(r).toLowerCase();
        final q = query.toLowerCase();
        return name.contains(q) || email.contains(q);
      }).toList(),
    );
  }

  String _getName(Map<String, dynamic> r) {
    return r['name']?.toString() ?? r['user']?['name']?.toString() ?? 'Unknown';
  }

  String _getEmail(Map<String, dynamic> r) {
    return r['email']?.toString() ?? r['user']?['email']?.toString() ?? '';
  }

  String getAttendeeName(Map<String, dynamic> r) => _getName(r);
  String getAttendeeEmail(Map<String, dynamic> r) => _getEmail(r);
  String getAttendeeStatus(Map<String, dynamic> r) =>
      r['status']?.toString() ?? 'PENDING';
  String getAttendeeId(Map<String, dynamic> r) =>
      r['_id']?.toString() ?? r['id']?.toString() ?? '';

  Future<void> viewAttendee(String attendeeId) async {
    try {
      final detail = await _service.getAttendeeDetail(eventId, attendeeId);
      final userData = detail['data'] ?? detail;
      Get.dialog(
        AlertDialog(
          title: const Text('Attendee Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:
                  userData.entries
                      .map<Widget>(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${e.key}: ${e.value}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),
          ],
        ),
      );
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load attendee details');
    }
  }

  Future<void> removeAttendee(String attendeeId, String name) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove Attendee'),
        content: Text('Remove "$name" from this event?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.removeAttendee(eventId, attendeeId);
      SnackbarHelper.showSuccess('Removed', '$name removed from event');
      await loadRegistrations();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to remove attendee');
    }
  }
}
