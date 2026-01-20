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

  // Sidebar menu items
  final List<SidebarMenuItem> menuItems = [
    SidebarMenuItem(
      icon: 'assets/icons/qrcode.svg',
      label: 'Contact & QR',
      route: '/contact-qr',
    ),
    SidebarMenuItem(
      icon: 'assets/icons/notebook.svg',
      label: 'Connection List',
      route: '/connection-list',
    ),
    SidebarMenuItem(
      icon: 'assets/icons/quicknotes.svg',
      label: 'Quick Notes',
      route: '/quick-notes',
    ),
    SidebarMenuItem(
      icon: 'assets/icons/exploreevents.svg',
      label: 'Explore Events',
      route: '/explore-events',
    ),

    SidebarMenuItem(
      icon: 'assets/icons/eventposters.svg',
      label: 'Event Posters',
      route: '/event-posters',
    ),

    SidebarMenuItem(
      icon: 'assets/icons/organizer.svg',
      label: 'Organizers',
      route: '/organizers',
    ),

    SidebarMenuItem(
      icon: 'assets/icons/about.svg',
      label: 'About',
      route: '/about',
    ),
    SidebarMenuItem(
      icon: 'assets/icons/settings.svg',
      label: 'Settings',
      route: '/settings',
    ),
    SidebarMenuItem(
      icon: 'assets/icons/termsconditions.svg',
      label: 'Terms & Conditions',
      route: '/terms-conditions',
    ),
  ];

  // Handle menu item tap
  void handleMenuTap(BuildContext context, SidebarMenuItem item) {
    // Close drawer first
    Navigator.of(context).pop();

    // Navigate or execute custom action
    if (item.onTap != null) {
      item.onTap!();
    } else if (item.route != null) {
      context.push(item.route!);
    }
  }

  // Logout
  void logout(BuildContext context) {
    Navigator.of(context).pop(); // Close drawer

    Get.dialog(
      AlertDialog(
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
              // TODO: Clear user data and navigate to login
              // context.go('/login');
              Get.snackbar(
                'Logged Out',
                'You have been logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}