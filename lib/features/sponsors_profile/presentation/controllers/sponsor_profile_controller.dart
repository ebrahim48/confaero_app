import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/sponsor_dashboard_service.dart';

class SponsorProfileController extends GetxController {
  late final SponsorDashboardService _service;

  // Loading states
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Profile state
  final hasProfile = false.obs;
  final sponsorId = ''.obs;
  final companyName = ''.obs;
  final description = ''.obs;
  final logoUrl = ''.obs;
  final websiteUrl = ''.obs;
  final publicEmail = ''.obs;
  final sponsorStatus = ''.obs;
  final isApproved = false.obs;

  // Dashboard stats
  final totalAttendee = 0.obs;
  final profileView = 0.obs;

  // Derived display
  final RxInt descriptionLength = 0.obs;

  // Form controllers
  final companyNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final publicEmailController = TextEditingController();

  // Logo: network URL from API or local picked file path
  final logoPath = ''.obs;
  final Rxn<File> pickedImageFile = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    _service = SponsorDashboardService(
      apiService: Get.find<ApiService>(),
      connectivityService: Get.find<ConnectivityService>(),
    );
    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.length;
    });

    final eventId = SessionController.to.eventId;
    if (eventId.isNotEmpty) {
      loadProfile();
    } else {
      ever(SessionController.to.eventIdRx, (String id) {
        if (id.isNotEmpty) loadProfile();
      });
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    descriptionController.dispose();
    websiteUrlController.dispose();
    publicEmailController.dispose();
    super.onClose();
  }

  // ── Load profile + dashboard ──────────────────────────────────────────────

  Future<void> loadProfile() async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _service.getMySponsor(eventId).catchError((_) => <String, dynamic>{}),
        _service.getSponsorDashboard(eventId).catchError((_) => <String, dynamic>{}),
      ]);

      final profileResp = results[0];
      final dashResp = results[1];

      if (profileResp['success'] == true && profileResp['data'] != null) {
        _applyProfile(profileResp['data'] as Map<String, dynamic>);
        hasProfile.value = true;
      } else {
        hasProfile.value = false;
      }

      if (dashResp['success'] == true && dashResp['data'] != null) {
        final d = dashResp['data'] as Map<String, dynamic>;
        totalAttendee.value = (d['totalAttendee'] as num?)?.toInt() ?? 0;
        profileView.value = (d['profileView'] as num?)?.toInt() ?? 0;
        // dashboard status overrides if available
        if ((d['status'] as String?)?.isNotEmpty == true) {
          sponsorStatus.value = d['status'] as String;
        }
      }
    } catch (_) {
      hasProfile.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void _applyProfile(Map<String, dynamic> d) {
    sponsorId.value = d['_id'] as String? ?? '';
    companyName.value = d['companyName'] as String? ?? '';
    description.value = d['description'] as String? ?? '';
    logoUrl.value = d['logoUrl'] as String? ?? '';
    logoPath.value = logoUrl.value;
    pickedImageFile.value = null; // clear any local pick after server save
    websiteUrl.value = d['websiteUrl'] as String? ?? '';
    publicEmail.value = d['publicEmail'] as String? ?? '';
    sponsorStatus.value = d['status'] as String? ?? '';
    isApproved.value = d['isApproved'] as bool? ?? false;
    profileView.value = (d['profileView'] as num?)?.toInt() ?? profileView.value;

    // Pre-fill form
    companyNameController.text = companyName.value;
    descriptionController.text = description.value;
    websiteUrlController.text = websiteUrl.value;
    publicEmailController.text = publicEmail.value;
    descriptionLength.value = descriptionController.text.length;
  }

  // ── Logo picker ───────────────────────────────────────────────────────────

  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      pickedImageFile.value = File(picked.path);
      logoPath.value = picked.path;
    }
  }

  // ── Create profile ────────────────────────────────────────────────────────

  Future<void> createProfile(BuildContext context) async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Select an event first.',
        title: 'Warning',
      );
      return;
    }
    try {
      isSaving.value = true;
      final body = {
        'eventId': eventId,
        'companyName': companyNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'logoUrl': logoPath.value,
        'websiteUrl': websiteUrlController.text.trim(),
        'publicEmail': publicEmailController.text.trim(),
      };
      final result = await _service.createSponsor(body);
      if (result['success'] == true) {
        if (result['data'] != null) _applyProfile(result['data'] as Map<String, dynamic>);
        hasProfile.value = true;
        ToastMessageHelper.showToastMessage('Sponsor profile created');
        if (context.mounted) Navigator.of(context).pop();
      } else {
        ToastMessageHelper.showToastMessage(
          result['message'] as String? ?? 'Could not create the profile.',
          title: 'Error',
        );
      }
    } catch (e) {
      _showError(e, 'Could not create the profile.');
    } finally {
      isSaving.value = false;
    }
  }

  // ── Update profile ────────────────────────────────────────────────────────

  Future<void> saveProfile(BuildContext context) async {
    if (sponsorId.value.isEmpty) {
      ToastMessageHelper.showToastMessage(
        'Create your sponsor profile first.',
        title: 'Warning',
      );
      return;
    }
    try {
      isSaving.value = true;
      final body = {
        'companyName': companyNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'logoUrl': logoPath.value,
        'websiteUrl': websiteUrlController.text.trim(),
        'publicEmail': publicEmailController.text.trim(),
      };
      final result = await _service.updateSponsor(sponsorId.value, body);
      if (result['success'] == true) {
        if (result['data'] != null) _applyProfile(result['data'] as Map<String, dynamic>);
        ToastMessageHelper.showToastMessage('Sponsor profile updated');
        if (context.mounted) Navigator.of(context).pop();
      } else {
        ToastMessageHelper.showToastMessage(
          result['message'] as String? ?? 'Could not save your changes.',
          title: 'Error',
        );
      }
    } catch (e) {
      _showError(e, 'Could not save your changes.');
    } finally {
      isSaving.value = false;
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
