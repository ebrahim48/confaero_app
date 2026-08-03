import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/helpers/toast_message_helper.dart';
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAnnouncement() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Enter both a title and content.',
        title: 'Warning',
      );
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
      await loadAnnouncements();
      ToastMessageHelper.showToastMessage('Announcement published');
    } catch (e) {
      _showError(e, 'Could not publish the announcement.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateAnnouncement(AnnouncementModel item) async {
    titleController.text = item.title;
    contentController.text = item.description;

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
      await loadAnnouncements();
      ToastMessageHelper.showToastMessage('Announcement updated');
    } catch (e) {
      _showError(e, 'Could not update the announcement.');
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
      await loadAnnouncements();
      ToastMessageHelper.showToastMessage('Announcement deleted');
    } catch (e) {
      _showError(e, 'Could not delete the announcement.');
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }
}
