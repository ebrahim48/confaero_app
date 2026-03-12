import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/services/verified_email_service.dart';

/// Controller for organizer verified email / invite management.
class VerifiedEmailController extends GetxController {
  final VerifiedEmailService _service = Get.find<VerifiedEmailService>();

  final String eventId;
  VerifiedEmailController({required this.eventId});

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxList<Map<String, dynamic>> emails = <Map<String, dynamic>>[].obs;

  final emailInputController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadEmails();
  }

  @override
  void onClose() {
    emailInputController.dispose();
    super.onClose();
  }

  Future<void> loadEmails() async {
    isLoading.value = true;
    try {
      final data = await _service.getVerifiedEmails(eventId);
      emails.assignAll(data);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load emails');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add one or more comma-separated emails
  Future<void> addEmails() async {
    final raw = emailInputController.text.trim();
    if (raw.isEmpty) {
      SnackbarHelper.showError('Validation', 'Enter at least one email');
      return;
    }
    final emailList =
        raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    isSaving.value = true;
    try {
      await _service.addEmails(eventId, emailList);
      emailInputController.clear();
      SnackbarHelper.showSuccess(
        'Success',
        '${emailList.length} email(s) added',
      );
      await loadEmails();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to add emails');
    } finally {
      isSaving.value = false;
    }
  }

  /// Upload CSV file with email addresses
  Future<void> uploadCsv(File csvFile) async {
    isSaving.value = true;
    try {
      await _service.uploadCsv(eventId, csvFile);
      SnackbarHelper.showSuccess('Success', 'CSV uploaded successfully');
      await loadEmails();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to upload CSV');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteEmail(String emailId, String emailAddress) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove Email'),
        content: Text('Remove "$emailAddress" from invite list?'),
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
      await _service.deleteEmail(eventId, emailId);
      SnackbarHelper.showSuccess('Removed', 'Email removed');
      await loadEmails();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to remove email');
    }
  }
}
