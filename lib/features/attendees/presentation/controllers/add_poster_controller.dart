import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/poster_service.dart';
import 'posters_controller.dart';

class AddPosterController extends GetxController {
  final PosterService _posterService = Get.find<PosterService>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController abstractController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController presentersController = TextEditingController();
  final TextEditingController presenterRoleController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();

  final RxList<String> tags = <String>[].obs;
  final RxList<Map<String, String>> presenters = <Map<String, String>>[].obs;
  final RxBool isSubmitting = false.obs;

  // Uploaded URLs
  final RxString bannerUrl = ''.obs;
  final RxBool isBannerUploading = false.obs;

  final RxList<Map<String, dynamic>> attachments = <Map<String, dynamic>>[].obs;
  final RxBool isAttachmentUploading = false.obs;

  String get currentEventId => SessionController.to.eventId;

  @override
  void onClose() {
    titleController.dispose();
    abstractController.dispose();
    tagController.dispose();
    presentersController.dispose();
    presenterRoleController.dispose();
    videoLinkController.dispose();
    super.onClose();
  }

  void addTag() {
    final tag = tagController.text.trim();
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
      tagController.clear();
    }
  }

  void removeTag(String tag) => tags.remove(tag);

  void addPresenter() {
    final name = presentersController.text.trim();
    final role = presenterRoleController.text.trim();
    if (name.isNotEmpty) {
      presenters.add({'name': name, 'role': role.isEmpty ? 'Presenter' : role});
      presentersController.clear();
      presenterRoleController.clear();
    }
  }

  void removePresenter(Map<String, String> p) => presenters.remove(p);

  void removeAttachment(Map<String, dynamic> attachment) =>
      attachments.remove(attachment);

  Future<void> addBanner() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path!;
    try {
      isBannerUploading.value = true;
      final response = await _posterService.uploadPosterFile(path);
      final url = response['data']?['url'] as String? ??
          response['url'] as String? ??
          '';
      if (url.isNotEmpty) {
        bannerUrl.value = url;
      } else {
        ToastMessageHelper.showToastMessage('Failed to get banner URL', title: 'Error');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Banner upload failed', title: 'Error');
    } finally {
      isBannerUploading.value = false;
    }
  }

  Future<void> addAttachment() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    final path = file.path!;
    try {
      isAttachmentUploading.value = true;
      final response = await _posterService.uploadPosterFile(path);
      final url = response['data']?['url'] as String? ??
          response['url'] as String? ??
          '';
      if (url.isNotEmpty) {
        final ext = file.extension?.toLowerCase() ?? '';
        final type = ext == 'pdf' ? 'pdf' : 'image';
        attachments.add({
          'url': url,
          'type': type,
          'name': file.name,
          'size': '${(file.size / 1024).toStringAsFixed(1)} KB',
          'icon': type == 'pdf' ? Icons.picture_as_pdf : Icons.image,
        });
      } else {
        ToastMessageHelper.showToastMessage('Failed to get attachment URL', title: 'Error');
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Attachment upload failed', title: 'Error');
    } finally {
      isAttachmentUploading.value = false;
    }
  }

  Future<void> submitForm() async {
    if (titleController.text.trim().isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter a title', title: 'Error');
      return;
    }
    if (abstractController.text.trim().isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter an abstract', title: 'Error');
      return;
    }

    try {
      isSubmitting.value = true;

      final body = <String, dynamic>{
        'title': titleController.text.trim(),
        'abstract': abstractController.text.trim(),
        if (bannerUrl.value.isNotEmpty) 'banner': bannerUrl.value,
        if (tags.isNotEmpty) 'tags': tags.toList(),
        if (presenters.isNotEmpty)
          'presenters': presenters.map((p) => {'name': p['name'], 'role': p['role']}).toList(),
        if (videoLinkController.text.trim().isNotEmpty)
          'videoLink': videoLinkController.text.trim(),
        if (attachments.isNotEmpty)
          'attachments': attachments
              .map((a) => {
                    'url': a['url'],
                    'type': a['type'],
                    'name': a['name'],
                    'size': a['size'],
                  })
              .toList(),
      };

      await _posterService.createPoster(currentEventId, body);

      ToastMessageHelper.showToastMessage('Poster submitted successfully!', title: 'Success');

      // Refresh poster list if controller is active
      if (Get.isRegistered<PostersController>()) {
        Get.find<PostersController>().loadPosters();
      }

      Get.back();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit poster', title: 'Error');
    } finally {
      isSubmitting.value = false;
    }
  }
}
