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

// Sidebar Menu Item Model
class SidebarMenuItem {
  final String icon;
  final String label;
  final String? route;
  final VoidCallback? onTap;
  final IconData? fallbackIcon;

  SidebarMenuItem({
    required this.icon,
    required this.label,
    this.route,
    this.onTap,
    this.fallbackIcon,
  });
}

class SidebarController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final ProfileService _profileService = Get.find<ProfileService>();

  // User info — loaded from API
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userAvatar = 'assets/images/profile.png'.obs;
  final isNetworkAvatar = false.obs;
  final isLoading = false.obs;

  // Sidebar menu items with proper routes
  final List<SidebarMenuItem> menuItems = [
    SidebarMenuItem(
      icon: 'assets/icons/qrcode.svg',
      label: 'Contact & QR',
      route: AppRoutes.contactQrScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/notebook.svg',
      label: 'Connection List',
      route: AppRoutes.connectionListScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/quicknotes.svg',
      label: 'Quick Notes',
      route: AppRoutes.quickNotesScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/exploreevents.svg',
      label: 'Explore Events',
      route: AppRoutes.eventsScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/eventposters.svg',
      label: 'Event Posters',
      route: AppRoutes.eventsPostersScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/organizer.svg',
      label: 'Organizers',
      route: AppRoutes.organizserGuidelinesScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/about.svg',
      label: 'About',
      route: AppRoutes.aboutUsScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/settings.svg',
      label: 'Settings',
      route: AppRoutes.settingsScreen,
    ),
    SidebarMenuItem(
      icon: 'assets/icons/termsconditions.svg',
      label: 'Terms & Conditions',
      route: AppRoutes.termsConditionScreen,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  /// Load user name/email from /auth/me and avatar from profile service
  Future<void> loadUserInfo() async {
    try {
      isLoading.value = true;

      final userResponse = await _authRepository.getMe();
      final success = userResponse['success'] as bool? ?? false;
      if (success && userResponse['data'] != null) {
        final userData = userResponse['data'] as Map<String, dynamic>;
        userName.value = userData['name'] as String? ?? '';
        userEmail.value = userData['email'] as String? ?? '';
        // Save userId so chat screens can determine sent/received correctly
        final userId = userData['_id']?.toString() ?? userData['id']?.toString() ?? '';
        if (userId.isNotEmpty) {
          await PrefsHelper.setString(AppConstants.userId, userId);
        }
      }

      // Try to load profile image
      final profile = await _profileService.getMyProfile();
      if (profile != null &&
          profile.avatar != null &&
          profile.avatar!.isNotEmpty) {
        userAvatar.value = profile.avatar!;
        isNetworkAvatar.value = true;
      }
    } catch (_) {
      // Fail silently — sidebar still works with defaults
    } finally {
      isLoading.value = false;
    }
  }

  // Handle menu item tap
  void handleMenuTap(BuildContext context, SidebarMenuItem item) {
    // Close drawer first
    Navigator.of(context).pop();

    // Small delay for smooth drawer close animation
    Future.delayed(const Duration(milliseconds: 200), () {
      // Navigate or execute custom action
      if (item.onTap != null) {
        item.onTap!();
      } else if (item.route != null) {
        context.push(item.route!);
      }
    });
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    await PrefsHelper.remove(AppConstants.bearerToken);
    await PrefsHelper.remove(AppConstants.refreshToken);
    await PrefsHelper.remove(AppConstants.userRole);
    await PrefsHelper.setBool(AppConstants.isLogged, false);

    await Get.find<RoleController>().clearRole();
    await Get.find<SessionController>().clearEvent();

    if (context.mounted) {
      context.go(AppRoutes.signInScreen);
    }

    // Delete all non-permanent controllers so the next user gets a clean state.
    // Services are fenix:true and will recreate on demand; permanent controllers
    // (SessionController, RoleController, SocketService) are not affected.
    // Deferred to a post-frame callback: go_router's notifyListeners() from
    // context.go() above can force one more rebuild of the outgoing screen
    // (e.g. Events, still showing behind the closing drawer) before the
    // transition removes it. Disposing controllers first — as this used to do
    // — left screens like EventsScreen rebuilding a TextField whose
    // TextEditingController had just been disposed, crashing with
    // "A TextEditingController was used after being disposed." Deleting after
    // the frame that performs navigation avoids that race.
    WidgetsBinding.instance.addPostFrameCallback((_) => Get.deleteAll());
  }
}
