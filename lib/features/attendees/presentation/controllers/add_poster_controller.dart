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

  final RxString titleError = ''.obs;
  final RxString abstractError = ''.obs;
  final RxString submitError = ''.obs;

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

  void _resetForm() {
    titleController.clear();
    abstractController.clear();
    tagController.clear();
    presentersController.clear();
    presenterRoleController.clear();
    videoLinkController.clear();
    tags.clear();
    presenters.clear();
    attachments.clear();
    bannerUrl.value = '';
    titleError.value = '';
    abstractError.value = '';
    submitError.value = '';
  }

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
        ToastMessageHelper.showToastMessage(
          'The banner could not be uploaded. Please try again.',
          title: 'Error',
        );
      }
    } catch (e) {
      _showError(e, 'The banner could not be uploaded.');
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
          'size': file.size,
          'icon': type == 'pdf' ? Icons.picture_as_pdf : Icons.image,
        });
      } else {
        ToastMessageHelper.showToastMessage(
          'The attachment could not be uploaded. Please try again.',
          title: 'Error',
        );
      }
    } catch (e) {
      _showError(e, 'The attachment could not be uploaded.');
    } finally {
      isAttachmentUploading.value = false;
    }
  }

  void _showError(Object e, String fallback) {
    final msg = e.toString().replaceAll('Exception: ', '').trim();
    ToastMessageHelper.showToastMessage(
      msg.isEmpty ? fallback : msg,
      title: 'Error',
    );
  }

  Future<void> submitForm({VoidCallback? onSuccess}) async {
    titleError.value = '';
    abstractError.value = '';
    submitError.value = '';

    if (titleController.text.trim().isEmpty) {
      titleError.value = 'Please enter a title';
      return;
    }
    if (abstractController.text.trim().isEmpty) {
      abstractError.value = 'Please enter an abstract';
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

      if (Get.isRegistered<PostersController>()) {
        Get.find<PostersController>().loadPosters();
      }

      _resetForm();
      onSuccess?.call();
    } catch (e) {
      submitError.value = 'Failed to submit poster. Please try again.';
    } finally {
      isSubmitting.value = false;
    }
  }
}
