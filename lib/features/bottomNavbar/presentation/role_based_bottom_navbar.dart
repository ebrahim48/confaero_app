import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/controllers/role_controller.dart';
import '../../../../core/config/approutes/app_routes.dart';

/// Role-aware bottom navigation bar that changes based on user's active role.
///
/// Different roles have different navigation items:
/// - ATTENDEE: Home, Agenda, Attendees, Community, Messages
/// - SPEAKER: Home, Agenda, Attendees, Community, Messages
/// - VOLUNTEER: Home, Tasks, QR Scan, Community, Messages
/// - ORGANIZER: Home, Agenda, Attendees, Community, Messages
/// - EXHIBITOR: Home, Agenda, Booth, Lead, Messages
/// - SPONSOR: Home, Agenda, Booth, Lead, Messages
/// - ABSTRACT_REVIEWER: Home, Agenda, Content, Community, Messages
/// - REVIEWER: Home, Agenda, Content, Community, Messages
/// - TRACK_CHAIR: Home, Agenda, Content, Community, Messages
/// - BOOTH_STAFF: Home, Agenda, Booth, Lead, Messages
class RoleBasedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const RoleBasedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeRole = RoleController.to.activeRole.value.toUpperCase();
      final navItems = _getNavItemsForRole(activeRole);

      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(
            top: BorderSide(
              color: Color(0xFFF0EBE7),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                navItems.length,
                (index) => _buildNavItem(
                  context,
                  index,
                  navItems[index]['icon']!,
                  navItems[index]['label']!,
                  navItems[index]['iconType'] ?? 'svg',
                  navItems[index]['route'],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String iconPath,
    String label,
    String iconType,
    String? route,
  ) {
    bool isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Just switch tabs - don't navigate away from MainNavigationScreen
          onTap(index);
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconType == 'svg')
                SvgPicture.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? const Color(0xff32A69A)
                        : const Color(0xff252525),
                    BlendMode.srcIn,
                  ),
                )
              else
                Icon(
                  _getIconData(iconPath),
                  size: 24.w,
                  color: isSelected
                      ? const Color(0xff32A69A)
                      : const Color(0xff252525),
                ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xff32A69A)
                      : const Color(0xff252525),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home_outlined;
      case 'calendar':
        return Icons.calendar_today_outlined;
      case 'people':
        return Icons.people_outlined;
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'task':
        return Icons.task_outlined;
      case 'qr_code':
        return Icons.qr_code_scanner;
      case 'store':
        return Icons.store_outlined;
      case 'leaderboard':
        return Icons.leaderboard_outlined;
      case 'description':
        return Icons.description_outlined;
      case 'community':
        return Icons.groups_outlined;
      case 'resources':
        return Icons.auto_stories_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  /// Get navigation items based on the user's active role.
  List<Map<String, String>> _getNavItemsForRole(String role) {
    switch (role) {
      case 'VOLUNTEER':
        return [
          {'icon': 'home', 'label': 'Home', 'iconType': 'icon'},
          {'icon': 'task', 'label': 'Tasks', 'iconType': 'icon'},
          {'icon': 'qr_code', 'label': 'QR Scan', 'iconType': 'icon'},
          {'icon': 'community', 'label': 'Community', 'iconType': 'icon'},
          {'icon': 'chat', 'label': 'Messages', 'iconType': 'icon'},
        ];

      case 'EXHIBITOR':
      case 'SPONSOR':
      case 'BOOTH_STUFF':
      case 'BOOTH_STAFF':
      case 'STAFF':
        return [
          {'icon': 'home', 'label': 'Home', 'iconType': 'icon'},
          {'icon': 'calendar', 'label': 'Agenda', 'iconType': 'icon'},
          {'icon': 'store', 'label': 'Booth', 'iconType': 'icon'},
          {'icon': 'leaderboard', 'label': 'Lead', 'iconType': 'icon', 'route': AppRoutes.myJobsScreen},
          {'icon': 'chat', 'label': 'Messages', 'iconType': 'icon'},
        ];

      case 'ABSTRACT_REVIEWER':
        return [
          {'icon': 'home', 'label': 'Home', 'iconType': 'icon'},
          {'icon': 'calendar', 'label': 'Agenda', 'iconType': 'icon'},
          {'icon': 'description', 'label': 'Content', 'iconType': 'icon'},
          {'icon': 'community', 'label': 'Community', 'iconType': 'icon'},
          {'icon': 'chat', 'label': 'Messages', 'iconType': 'icon'},
        ];

      case 'REVIEWER':
      case 'TRACK_CHAIR':
        return [
          {'icon': 'home', 'label': 'Home', 'iconType': 'icon'},
          {'icon': 'calendar', 'label': 'Agenda', 'iconType': 'icon'},
          {'icon': 'description', 'label': 'Content', 'iconType': 'icon'},
          {'icon': 'community', 'label': 'Community', 'iconType': 'icon'},
          {'icon': 'chat', 'label': 'Messages', 'iconType': 'icon'},
        ];

      // Default: ATTENDEE, SPEAKER, ORGANIZER, and any other roles
      default:
        return [
          {'icon': 'assets/icons/home.svg', 'label': 'Home'},
          {'icon': 'assets/icons/calendar.svg', 'label': 'Agenda'},
          {'icon': 'assets/icons/ateendees.svg', 'label': 'Attendees'},
          {'icon': 'assets/icons/community.svg', 'label': 'Community'},
          {'icon': 'assets/icons/message.svg', 'label': 'Messages'},
        ];
    }
  }
}
