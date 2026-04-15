import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/volunteer_service.dart';

class VolunteerController extends GetxController {
  final VolunteerService _service = Get.find<VolunteerService>();

  final tasks = <Map<String, dynamic>>[].obs;
  final dashboardData = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final isSaving = false.obs;

  final taskNameCtrl = TextEditingController();
  final taskDescCtrl = TextEditingController();
  final taskLocationCtrl = TextEditingController();

  String currentEventId = '';

  @override
  void onInit() {
    super.onInit();
    currentEventId = Get.arguments?['eventId'] as String? ?? '';
    if (currentEventId.isNotEmpty) loadDashboard();
  }

  @override
  void onClose() {
    taskNameCtrl.dispose();
    taskDescCtrl.dispose();
    taskLocationCtrl.dispose();
    super.onClose();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      final response = await _service.getDashboard();
      if (response['data'] != null) {
        dashboardData.value = response['data'] as Map<String, dynamic>;
        if (response['data']['tasks'] is List) {
          tasks.value =
              (response['data']['tasks'] as List)
                  .map((e) => e as Map<String, dynamic>)
                  .toList();
        }
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load dashboard', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTask() async {
    if (taskNameCtrl.text.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter task name', title: 'Error');
      return;
    }
    try {
      isSaving.value = true;
      await _service.createTask({
        'name': taskNameCtrl.text,
        'description': taskDescCtrl.text,
        'location': taskLocationCtrl.text,
      });
      taskNameCtrl.clear();
      taskDescCtrl.clear();
      taskLocationCtrl.clear();
      Get.back();
      ToastMessageHelper.showToastMessage('Task created', title: 'Success');
      loadDashboard();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to create task', title: 'Error');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> completeTask(String taskId) async {
    try {
      await _service.completeTask(taskId);
      ToastMessageHelper.showToastMessage('Task completed', title: 'Success');
      loadDashboard();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to complete task', title: 'Error');
    }
  }

  // ======================== Additional Methods ========================

  final myTasks = <Map<String, dynamic>>[].obs;
  final taskDetail = Rxn<Map<String, dynamic>>();
  final todayProgress = Rxn<Map<String, dynamic>>();
  final reportDetail = Rxn<Map<String, dynamic>>();

  Future<void> loadMyTasks() async {
    try {
      isLoading.value = true;
      final response = await _service.getMyTasks();
      if (response['data'] is List) {
        myTasks.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load tasks', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTaskDetail(String taskId) async {
    try {
      isLoading.value = true;
      final response = await _service.getTaskDetail(taskId);
      taskDetail.value = response['data'] as Map<String, dynamic>?;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load task detail', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchVolunteer(String eventId) async {
    try {
      final response = await _service.searchVolunteer(eventId);
      if (response['data'] is List) {
        myTasks.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Search failed', title: 'Error');
    }
  }

  Future<void> loadTodayProgress() async {
    try {
      final response = await _service.getTodayProgress();
      todayProgress.value = response['data'] as Map<String, dynamic>?;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load progress', title: 'Error');
    }
  }

  Future<void> loadReportDetail(String reportId) async {
    try {
      final response = await _service.getReportDetail(reportId);
      reportDetail.value = response['data'] as Map<String, dynamic>?;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load report', title: 'Error');
    }
  }

  Future<void> submitReport(Map<String, dynamic> data) async {
    try {
      isSaving.value = true;
      await _service.submitReport(data);
      ToastMessageHelper.showToastMessage('Report submitted', title: 'Success');
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to submit report', title: 'Error');
    } finally {
      isSaving.value = false;
    }
  }
}
