import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/toast_message_helper.dart';

/// Controller for organizer attendee management.
/// NOTE: Backend endpoints for organizer attendee detail/remove/registrations
/// have been removed. This controller is kept as a stub for future use.
class OrganizerAttendeeController extends GetxController {
  final String eventId;
  OrganizerAttendeeController({required this.eventId});

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> registrations =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredRegistrations =
      <Map<String, dynamic>>[].obs;
  final searchController = TextEditingController();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadRegistrations() async {
    // REMOVED: getAllRegistrations endpoint no longer available in backend API
  }

  void searchRegistrations(String query) {
    if (query.isEmpty) {
      filteredRegistrations.assignAll(registrations);
      return;
    }
    filteredRegistrations.assignAll(
      registrations.where((r) {
        final name = (r['name']?.toString() ?? '').toLowerCase();
        final email = (r['email']?.toString() ?? '').toLowerCase();
        final q = query.toLowerCase();
        return name.contains(q) || email.contains(q);
      }).toList(),
    );
  }

  String getAttendeeName(Map<String, dynamic> r) =>
      r['name']?.toString() ?? r['user']?['name']?.toString() ?? 'Unknown';
  String getAttendeeEmail(Map<String, dynamic> r) =>
      r['email']?.toString() ?? r['user']?['email']?.toString() ?? '';
  String getAttendeeStatus(Map<String, dynamic> r) =>
      r['status']?.toString() ?? 'PENDING';
  String getAttendeeId(Map<String, dynamic> r) =>
      r['_id']?.toString() ?? r['id']?.toString() ?? '';

  Future<void> viewAttendee(String attendeeId) async {
    // REMOVED: endpoint no longer available in backend API
  }

  Future<void> removeAttendee(String attendeeId, String name) async {
    // REMOVED: endpoint no longer available in backend API
  }
}
