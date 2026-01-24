import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Sidebar Menu Item Model
class SidebarMenuItem {
  final String icon;
  final String label;
  final String? route;
  final VoidCallback? onTap;

  SidebarMenuItem({
    required this.icon,
    required this.label,
    this.route,
    this.onTap,
  });
}

class SidebarController extends GetxController {
  // User info
  final userName = 'Albert Flamingo'.obs;
  final userEmail = 'albert@example.com'.obs;
  final userAvatar = 'assets/images/profile.png'.obs;

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
        // Use pushNamed if route is defined in AppRoutes
        if (item.route == AppRoutes.contactQrScreen) {
          context.pushNamed(AppRoutes.contactQrScreen);
        } else {
          // Use push for other routes
          context.push(item.route!);
        }
      }
    });
  }

  // Logout
  void logout(BuildContext context) {
    Navigator.of(context).pop(); // Close drawer

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();

              // TODO: Clear user data
              // final prefs = await SharedPreferences.getInstance();
              // await prefs.clear();

              // Navigate to login (uncomment when login route is ready)
              // context.go('/login');

              Get.snackbar(
                'Logged Out',
                'You have been logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}