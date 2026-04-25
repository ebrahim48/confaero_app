import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:confaero_app/core/constants/app_constants.dart';
import 'package:confaero_app/core/controllers/role_controller.dart';
import 'package:confaero_app/core/controllers/session_controller.dart';
import 'package:confaero_app/core/helpers/prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/repositories/auth_repository.dart';
import '../../../profile/domain/services/profile_service.dart';

class VolunteerSidebarController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final ProfileService _profileService = Get.find<ProfileService>();

  final userName = ''.obs;
  final userAvatar = 'assets/images/profile.png'.obs;
  final isNetworkAvatar = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final res = await _authRepository.getMe();
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'] as Map<String, dynamic>;
        userName.value = data['name'] as String? ?? '';
      }
      final profile = await _profileService.getMyProfile();
      if (profile != null && (profile.avatar?.isNotEmpty ?? false)) {
        userAvatar.value = profile.avatar!;
        isNetworkAvatar.value = true;
      }
    } catch (_) {}
  }

  void handleMenuTap(BuildContext context, String route) {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 200), () {
      context.push(route);
    });
  }

  Future<void> logout(BuildContext context) async {
    await PrefsHelper.remove(AppConstants.bearerToken);
    await PrefsHelper.remove(AppConstants.refreshToken);
    await PrefsHelper.remove(AppConstants.userRole);
    await PrefsHelper.setBool(AppConstants.isLogged, false);
    await Get.find<RoleController>().clearRole();
    Get.find<SessionController>().clearEvent();
    if (context.mounted) {
      context.pushNamed(AppRoutes.signInScreen);
    }
  }
}
