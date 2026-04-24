import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/booth_service.dart';

class BoothStaffController extends GetxController {
  final BoothService _service = Get.find<BoothService>();

  final TextEditingController emailController = TextEditingController();

  final RxList<Map<String, dynamic>> staffList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isAdding = false.obs;

  String get eventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    if (SessionController.to.eventId.isNotEmpty) {
      loadStaff();
    } else {
      ever(SessionController.to.eventIdRx, (String id) {
        if (id.isNotEmpty && staffList.isEmpty && !isLoading.value) loadStaff();
      });
    }
  }

  Future<void> loadStaff() async {
    if (eventId.isEmpty) return;
    isLoading.value = true;
    try {
      final res = await _service.getBoothStaff(eventId);
      if (res['success'] == true && res['data'] is List) {
        final list = (res['data'] as List)
            .map((e) => _parseStaffMember(e as Map<String, dynamic>))
            .toList();
        staffList.assignAll(list);
      }
    } catch (_) {
      staffList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _parseStaffMember(Map<String, dynamic> raw) {
    final user = raw['user'] as Map<String, dynamic>? ?? {};
    final profile = user['profile'] as Map<String, dynamic>? ?? {};
    final name = profile['name']?.toString() ?? user['email']?.toString() ?? 'Staff';
    final avatar = profile['avatar']?.toString() ?? '';
    return <String, dynamic>{
      'id': raw['_id']?.toString() ?? '',
      'name': name,
      'email': user['email']?.toString() ?? '',
      'image': avatar,
    };
  }

  Future<void> addMember() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ToastMessageHelper.showToastMessage('Please enter an email address',
          title: 'Error');
      return;
    }
    if (eventId.isEmpty) {
      ToastMessageHelper.showToastMessage('No event selected', title: 'Error');
      return;
    }

    isAdding.value = true;
    try {
      final res = await _service.addBoothStaff(eventId, email);
      if (res['success'] == true) {
        emailController.clear();
        Navigator.pop(Get.context!);
        ToastMessageHelper.showToastMessage('Member added successfully',
            title: 'Success');
        await loadStaff();
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to add member', title: 'Error');
    } finally {
      isAdding.value = false;
    }
  }

  void removeMember(int index) {
    staffList.removeAt(index);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
