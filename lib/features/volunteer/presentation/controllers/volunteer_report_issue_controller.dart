import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/volunteer_service.dart';

class ReportIssueController extends GetxController {
  final VolunteerService _service = Get.find<VolunteerService>();

  final String taskId;
  ReportIssueController({required this.taskId});

  final selectedCategory = 'Logistics'.obs;
  final selectedUrgency = 'Medium Priority'.obs;
  final attachments = <File>[].obs;
  final isLoading = false.obs;

  final TextEditingController descriptionController = TextEditingController();

  final categories = ['Safety', 'Logistics', 'Attendee', 'Other'];
  final urgencyLevels = [
    'Low Priority',
    'Medium Priority',
    'High Priority',
    'Critical',
  ];

  static const _urgencyMap = {
    'Low Priority': 'Low',
    'Medium Priority': 'Medium',
    'High Priority': 'High',
    'Critical': 'Critical',
  };

  void selectCategory(String cat) => selectedCategory.value = cat;
  void selectUrgency(String u) => selectedUrgency.value = u;

  void addAttachment(File file) => attachments.add(file);
  void removeAttachment(int index) => attachments.removeAt(index);

  Future<void> submitReport(BuildContext context) async {
    if (descriptionController.text.trim().isEmpty) return;
    try {
      isLoading.value = true;
      await _service.submitReport({
        'taskId': taskId,
        'category': selectedCategory.value,
        'urgency': _urgencyMap[selectedUrgency.value] ?? selectedUrgency.value,
        'description': descriptionController.text.trim(),
        'images': <String>[],
      });
      _resetFields();
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void _resetFields() {
    descriptionController.clear();
    selectedCategory.value = 'Logistics';
    selectedUrgency.value = 'Medium Priority';
    attachments.clear();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
