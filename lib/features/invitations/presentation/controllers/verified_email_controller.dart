import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/toast_message_helper.dart';

/// Controller for organizer verified email / invite management.
/// NOTE: Backend verifyEmail endpoints have been removed.
/// This controller is kept as a stub for future use.
class VerifiedEmailController extends GetxController {
  final String eventId;
  VerifiedEmailController({required this.eventId});

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxList<Map<String, dynamic>> emails = <Map<String, dynamic>>[].obs;
  final emailInputController = TextEditingController();

  @override
  void onClose() {
    emailInputController.dispose();
    super.onClose();
  }

  Future<void> loadEmails() async {
    // REMOVED: verifyEmail endpoints no longer available in backend API
  }

  Future<void> addEmails() async {
  }

  Future<void> deleteEmail(String emailId, String emailAddress) async {
  }
}
