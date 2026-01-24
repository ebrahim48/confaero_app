import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddPosterController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController abstractController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController presentersController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();

  final RxList<String> tags = <String>[].obs;

  final RxList<Map<String, dynamic>> attachments = <Map<String, dynamic>>[
    {
      'name': '2025_Product_Catalog.pdf',
      'size': '2.4 MB',
      'icon': Icons.picture_as_pdf
    },
    {
      'name': 'Poster for the event.jpg',
      'size': '1.1 MB',
      'icon': Icons.image
    },
  ].obs;

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
    attachments.remove(attachment);
  }

  // Add Banner
  void addBanner() {
    // File picker logic here
    print('Add banner clicked');
  }

  // Add Attachment
  void addAttachment() {
    // File picker logic here
    print('Add attachment clicked');
  }

  // Submit Form
  void submitForm() {
    print('Title: ${titleController.text}');
    print('Abstract: ${abstractController.text}');
    print('Tags: $tags');
    print('Presenters: ${presentersController.text}');
    print('Video Link: ${videoLinkController.text}');
    print('Attachments: ${attachments.length}');

    Get.snackbar(
      'Success',
      'Poster submitted successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff32A69A),
      colorText: Colors.white,
    );
  }
}