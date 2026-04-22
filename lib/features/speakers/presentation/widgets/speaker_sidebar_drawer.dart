import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/controllers/role_controller.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../../../attendees/presentation/controllers/sidebar_controller.dart';

// Import SidebarMenuItem model
export '../../../attendees/presentation/controllers/sidebar_controller.dart' show SidebarMenuItem;

/// Speaker-specific sidebar drawer
///
/// Includes:
/// - My Events (to switch events)
/// - Contact & QR
/// - Connection List
/// - Quick Notes
/// - Documents (speaker-specific)
/// - Explore Events
/// - Event Posters
/// - Organizers Guidelines
/// - Settings
/// - Logout
class SpeakerSidebarDrawer extends StatelessWidget {
  const SpeakerSidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SidebarController());

    // Speaker-specific menu items
    final menuItems = [
      SidebarMenuItem(
        icon: 'assets/icons/exploreevents.svg',
        label: 'My Events',
        route: AppRoutes.eventsScreen,
      ),
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
      // Documents - Speaker specific (use fallback icon)
      SidebarMenuItem(
        icon: 'assets/icons/document.svg',
        label: 'Documents',
        route: AppRoutes.documentScreen,
        fallbackIcon: Icons.description_outlined,
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

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header with Profile
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xffE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xff32A69A),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Obx(
                        () => Image.asset(
                          controller.userAvatar.value,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 30.sp,
                              color: AppColors.textColor7E7F7E,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => CustomText(
                            text: controller.userName.value,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor424242,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 14.w,
                              color: AppColors.primaryColor32A69A,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: CustomText(
                                text: 'Speaker',
                                fontsize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor32A69A,
                                maxline: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildMenuItem(context, item);
                },
              ),
            ),

            // Logout Button
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color(0xffE0E0E0),
                    width: 1,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () => controller.logout(context),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/logout.svg',
                      width: 24.w,
                      height: 24.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.red,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    CustomText(
                      text: 'Logout',
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, SidebarMenuItem item) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (item.route != null) {
            context.push(item.route!);
          }
        });
      },
      leading: _buildIcon(item),
      title: CustomText(
        textAlign: TextAlign.start,
        text: item.label,
        fontsize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textColor424242,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
    );
  }

  Widget _buildIcon(SidebarMenuItem item) {
    // Try to load SVG, fallback to Icon if it fails
    return SvgPicture.asset(
      item.icon,
      width: 24.w,
      height: 24.h,
      colorFilter: const ColorFilter.mode(
        AppColors.textColor707070,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (context) => Icon(
        item.fallbackIcon ?? Icons.circle_outlined,
        size: 24.w,
        color: AppColors.textColor707070,
      ),
    );
  }
}
