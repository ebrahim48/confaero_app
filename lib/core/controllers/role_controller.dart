import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../helpers/prefs_helper.dart';
import '../helpers/logger_helper.dart';

/// Centralized controller for managing the user's active role.
///
/// This controller is a singleton that holds the current active role
/// and notifies the UI when it changes. All role-based UI decisions
/// should observe this controller's `activeRole` property.
///
/// **Usage:**
/// ```dart
/// // Get the current role
/// final role = RoleController.to.activeRole.value;
///
/// // Observe role changes
/// Obx(() => Text(RoleController.to.activeRole.value));
///
/// // Update the role
/// await RoleController.to.setRole('SPEAKER');
/// ```
class RoleController extends GetxController {
  static RoleController get to => Get.find<RoleController>();

  final _logger = LoggerHelper('RoleController');

  /// The user's currently active role (reactive).
  ///
  /// Observe this in widgets to rebuild UI when role changes:
  /// ```dart
  /// Obx(() {
  ///   final role = RoleController.to.activeRole.value;
  ///   return buildUIForRole(role);
  /// });
  /// ```
  final RxString activeRole = ''.obs;

  /// All roles assigned to the current user.
  final RxList<String> userRoles = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRoleFromPrefs();
  }

  /// Load the active role from SharedPreferences on app start.
  Future<void> _loadRoleFromPrefs() async {
    try {
      final savedRole = await PrefsHelper.getString(AppConstants.userRole);
      if (savedRole.isNotEmpty) {
        activeRole.value = savedRole.toUpperCase();
        _logger.d('Loaded role from prefs: ${activeRole.value}');
      } else {
        // Default to ATTENDEE if no role is saved
        activeRole.value = 'ATTENDEE';
        _logger.d('No role saved, defaulting to ATTENDEE');
      }
    } catch (e) {
      _logger.e('Failed to load role from prefs: $e');
      activeRole.value = 'ATTENDEE';
    }
  }

  /// Set the active role and save it to SharedPreferences.
  ///
  /// This method should be called when:
  /// - User logs in (set initial role from server response)
  /// - User switches roles via the role switcher
  /// - Server updates the user's active role
  ///
  /// After calling this, all UI observing [activeRole] will rebuild.
  Future<void> setRole(String role) async {
    try {
      final normalizedRole = role.toUpperCase();
      activeRole.value = normalizedRole;
      await PrefsHelper.setString(AppConstants.userRole, normalizedRole);
      _logger.d('Role set to: $normalizedRole');
    } catch (e) {
      _logger.e('Failed to set role: $e');
      rethrow;
    }
  }

  /// Set all available roles for the current user.
  void setUserRoles(List<String> roles) {
    userRoles.assignAll(roles.map((r) => r.toUpperCase()).toList());
    _logger.d('User roles updated: $userRoles');
  }

  /// Clear the role (on logout).
  Future<void> clearRole() async {
    try {
      activeRole.value = '';
      userRoles.clear();
      await PrefsHelper.remove(AppConstants.userRole);
      _logger.d('Role cleared');
    } catch (e) {
      _logger.e('Failed to clear role: $e');
    }
  }

  /// Check if the current role matches the given role.
  bool isRole(String role) => activeRole.value.toUpperCase() == role.toUpperCase();

  /// Check if user has a specific role in their available roles.
  bool hasRole(String role) =>
      userRoles.any((r) => r.toUpperCase() == role.toUpperCase());

  /// Get a human-readable role name.
  static String formatRoleName(String role) {
    switch (role.toUpperCase()) {
      case 'ATTENDEE':
        return 'Attendee';
      case 'ORGANIZER':
        return 'Organizer';
      case 'SPONSOR':
        return 'Sponsor';
      case 'EXHIBITOR':
        return 'Exhibitor';
      case 'REVIEWER':
      case 'ABSTRACT_REVIEWER':
        return 'Reviewer';
      case 'VOLUNTEER':
        return 'Volunteer';
      case 'SPEAKER':
        return 'Speaker';
      case 'TRACK_CHAIR':
        return 'Track Chair';
      case 'BOOTH_STUFF':
      case 'BOOTH_STAFF':
        return 'Booth Staff';
      case 'STAFF':
        return 'Staff';
      default:
        if (role.isEmpty) return 'Unknown';
        return role[0].toUpperCase() + role.substring(1).toLowerCase();
    }
  }

  /// Get an icon for each role.
  static IconData getRoleIcon(String role) {
    switch (role.toUpperCase()) {
      case 'ATTENDEE':
        return Icons.person_outline;
      case 'ORGANIZER':
        return Icons.event_note_outlined;
      case 'SPONSOR':
        return Icons.diamond_outlined;
      case 'EXHIBITOR':
        return Icons.storefront_outlined;
      case 'REVIEWER':
      case 'ABSTRACT_REVIEWER':
        return Icons.rate_review_outlined;
      case 'VOLUNTEER':
        return Icons.volunteer_activism_outlined;
      case 'SPEAKER':
        return Icons.mic_outlined;
      case 'TRACK_CHAIR':
        return Icons.chair_outlined;
      case 'BOOTH_STUFF':
      case 'BOOTH_STAFF':
        return Icons.store_outlined;
      case 'STAFF':
        return Icons.badge_outlined;
      default:
        return Icons.account_circle_outlined;
    }
  }
}
