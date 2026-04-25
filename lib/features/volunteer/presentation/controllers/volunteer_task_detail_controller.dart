import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/volunteer_service.dart';
import '../../data/models/volunteer_models.dart';
import 'volunteer_tasks_controller.dart';

class TaskDetailController extends GetxController {
  final VolunteerService _service = Get.find<VolunteerService>();

  final taskDetail = Rxn<TaskDetailModel>();
  final isLoading = false.obs;
  final isCompleting = false.obs;
  final showFullInstruction = false.obs;

  Future<void> loadDetail(String taskId) async {
    try {
      isLoading.value = true;
      final result = await _service.getTaskDetail(taskId);
      final data = result['data'] as Map<String, dynamic>?;
      if (data != null) {
        taskDetail.value = TaskDetailModel.fromJson(data);
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeTask(BuildContext context) async {
    final id = taskDetail.value?.taskId;
    if (id == null || id.isEmpty) return;
    try {
      isCompleting.value = true;
      await _service.completeTask(id);
      try {
        Get.find<TaskController>().loadData();
      } catch (_) {}
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {
    } finally {
      isCompleting.value = false;
    }
  }

  void toggleInstruction() =>
      showFullInstruction.value = !showFullInstruction.value;
}
