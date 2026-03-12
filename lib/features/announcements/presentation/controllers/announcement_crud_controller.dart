import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../data/models/announcement_model.dart';
import '../../domain/services/announcement_service.dart';

/// Controller for organizer announcement CRUD operations.
class AnnouncementCrudController extends GetxController {
  final AnnouncementService _service = Get.find<AnnouncementService>();

  final String eventId;

  AnnouncementCrudController({required this.eventId});

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxList<AnnouncementModel> announcements = <AnnouncementModel>[].obs;

  // Form controllers
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  Future<void> loadAnnouncements() async {
    isLoading.value = true;
    try {
      final data = await _service.getAnnouncements(eventId);
      announcements.assignAll(data);
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to load announcements');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAnnouncement() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      SnackbarHelper.showError('Validation', 'Title and content are required');
      return;
    }
    isSaving.value = true;
    try {
      await _service.createAnnouncement(
        eventId,
        title: title,
        content: content,
      );
      titleController.clear();
      contentController.clear();
      SnackbarHelper.showSuccess('Success', 'Announcement created');
      await loadAnnouncements();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to create announcement');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateAnnouncement(AnnouncementModel item) async {
    titleController.text = item.title;
    contentController.text = item.content;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Edit Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
          ],
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
      await _service.updateAnnouncement(
        item.id,
        eventId,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
      );
      titleController.clear();
      contentController.clear();
      SnackbarHelper.showSuccess('Success', 'Announcement updated');
      await loadAnnouncements();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to update announcement');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteAnnouncement(AnnouncementModel item) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Announcement'),
        content: Text('Delete "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.deleteAnnouncement(item.id, eventId);
      SnackbarHelper.showSuccess('Deleted', 'Announcement deleted');
      await loadAnnouncements();
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to delete announcement');
    }
  }
}
