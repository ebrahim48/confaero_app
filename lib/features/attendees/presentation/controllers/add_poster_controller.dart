import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/services/poster_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class AddPosterController extends GetxController {
  final PosterService _posterService = Get.find<PosterService>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController abstractController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController presentersController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();

  final RxList<String> tags = <String>[].obs;
  final RxBool isSubmitting = false.obs;

  // Uploaded file paths
  final Rx<String?> bannerFilePath = Rx<String?>(null);
  final RxList<Map<String, dynamic>> attachments = <Map<String, dynamic>>[].obs;
  final RxList<String> attachmentFilePaths = <String>[].obs;

  // Event ID for poster creation
  String currentEventId = '';

  @override
  void onClose() {
    titleController.dispose();
    abstractController.dispose();
    tagController.dispose();
    presentersController.dispose();
    videoLinkController.dispose();
    super.onClose();
  }

  // Add Tag
  void addTag() {
    final tag = tagController.text.trim();
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
      tagController.clear();
    }
  }

  // Remove Tag
  void removeTag(String tag) {
    tags.remove(tag);
  }

  // Remove Attachment
  void removeAttachment(Map<String, dynamic> attachment) {
    final index = attachments.indexOf(attachment);
    attachments.remove(attachment);
    if (index >= 0 && index < attachmentFilePaths.length) {
      attachmentFilePaths.removeAt(index);
    }
  }

  /// Upload banner via file picker + PosterService
  Future<void> addBanner() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.path != null) {
        bannerFilePath.value = result.files.single.path;
        ToastMessageHelper.showToastMessage(
          'Banner selected: ${result.files.single.name}',
          title: 'Success',
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to pick banner image', title: 'Error');
    }
  }

  /// Upload attachment via file picker + PosterService
  Future<void> addAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        attachmentFilePaths.add(path);
        attachments.add({
          'name': result.files.single.name,
          'size': '${(result.files.single.size / 1024 / 1024).toStringAsFixed(1)} MB',
          'icon': Icons.attach_file,
        });
        ToastMessageHelper.showToastMessage(
          'Attachment added: ${result.files.single.name}',
          title: 'Success',
        );
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to pick attachment', title: 'Error');
    }
  }

  /// Submit poster via PosterService.createPoster()
  Future<void> submitForm() async {
    if (titleController.text.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter a title', title: 'Error');
      return;
    }
    if (abstractController.text.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter an abstract', title: 'Error');
      return;
    }

    try {
      isSubmitting.value = true;

      // Upload banner if selected
      String? bannerUrl;
      if (bannerFilePath.value != null) {
        final bannerResponse = await _posterService.uploadPosterFile(
          bannerFilePath.value!,
        );
        bannerUrl = bannerResponse['data']?['url'] as String?;
      }

      // Upload attachments if any
      if (attachmentFilePaths.isNotEmpty) {
        await _posterService.uploadPosterFiles(attachmentFilePaths);
      }

      // Create poster
      await _posterService.createPoster(currentEventId, {
        'title': titleController.text,
        'abstract': abstractController.text,
        'tags': tags,
        'presenters': presentersController.text,
        'videoLink': videoLinkController.text,
        if (bannerUrl != null) 'bannerUrl': bannerUrl,
      });

      ToastMessageHelper.showToastMessage('Poster submitted successfully!', title: 'Success');
      Get.back();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit poster', title: 'Error');
    } finally {
      isSubmitting.value = false;
    }
  }
}
