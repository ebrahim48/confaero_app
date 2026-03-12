import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/services/qr_service.dart';

/// Controller for exhibitor lead management scanned via QR.
class ExhibitorLeadsController extends GetxController {
  final QrService _qrService = Get.find<QrService>();

  final String boothId;
  ExhibitorLeadsController({required this.boothId});

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxList<Map<String, dynamic>> leads = <Map<String, dynamic>>[].obs;

  final noteController = TextEditingController();
  final tagController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadLeads();
  }

  @override
  void onClose() {
    noteController.dispose();
    tagController.dispose();
    super.onClose();
  }

  Future<void> loadLeads() async {
    isLoading.value = true;
    try {
      final data = await _qrService.getExhibitorLeads(boothId);
      leads.assignAll(data);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load leads');
    } finally {
      isLoading.value = false;
    }
  }

  String getLeadName(Map<String, dynamic> lead) {
    return lead['name']?.toString() ??
        lead['user']?['name']?.toString() ??
        'Unknown';
  }

  String getLeadEmail(Map<String, dynamic> lead) {
    return lead['email']?.toString() ??
        lead['user']?['email']?.toString() ??
        '';
  }

  String getLeadNote(Map<String, dynamic> lead) {
    return lead['note']?.toString() ?? '';
  }

  List<String> getLeadTags(Map<String, dynamic> lead) {
    final tags = lead['tags'];
    if (tags is List) return tags.map((t) => t.toString()).toList();
    return [];
  }

  Future<void> addNote(String leadId) async {
    noteController.clear();
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            hintText: 'Enter note about this lead',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    isSaving.value = true;
    try {
      await _qrService.addLeadNote(leadId, noteController.text.trim());
      SnackbarHelper.showSuccess('Success', 'Note saved');
      await loadLeads();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to save note');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> addTags(String leadId) async {
    tagController.clear();
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Add Tags'),
        content: TextField(
          controller: tagController,
          decoration: const InputDecoration(
            hintText: 'Enter tags separated by commas',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final tags =
        tagController.text
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();

    if (tags.isEmpty) return;

    isSaving.value = true;
    try {
      await _qrService.tagLead(leadId, tags);
      SnackbarHelper.showSuccess('Success', 'Tags saved');
      await loadLeads();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to save tags');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> refreshLeads() => loadLeads();
}
