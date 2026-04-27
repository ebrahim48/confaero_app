import 'package:confaero_app/features/agenda/presentation/widgets/view/agenda_screen.dart';
import 'package:confaero_app/features/bottomNavbar/presentation/bottom_navbar_widgets.dart';
import 'package:confaero_app/features/bottomNavbar/presentation/role_based_bottom_navbar.dart';
import 'package:confaero_app/features/community/presentation/widgets/view/community_screen.dart';
import 'package:confaero_app/features/lead/presentation/widgets/view/lead_management_screen.dart';
import 'package:confaero_app/features/mainattendees/presentation/widgets/view/attendees_screen.dart';
import 'package:confaero_app/features/message/presentation/widgets/view/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/controllers/role_controller.dart';
import '../../core/controllers/session_controller.dart';
import '../attendees/presentation/widgets/view/home_screen.dart';
import '../volunteer/presentation/volunteer_home_screen.dart';
import '../volunteer/presentation/volunteer_dashboard_screen.dart';
import '../volunteer/presentation/volunteer_qr_scan_screen.dart';
import '../sponsor_dashboard/presentation/widgets/sponsor_dashboard_screen.dart';
import '../sponsors_profile/presentation/widgets/view/sponsor_home_screen.dart';
import '../reviewer/presentation/widgets/reviewer_dashboard_screen.dart';
import '../organizer/presentation/widgets/organizer_dashboard_screen.dart';
import '../booth_management/presentation/widgets/booth_management_screen.dart';
import '../exhibitors_sponsors_booth/presentations/widgets/view/exhibitors_booth_sponsors_screen.dart';
import '../speakers/presentation/widgets/speaker_home_screen.dart';
import '../attendees/presentation/widgets/sidebar_drawer.dart';
import '../speakers/presentation/widgets/speaker_sidebar_drawer.dart';
import '../abstractreviewer/presentation/content_home_screen.dart';
import '../abstractreviewer/presentation/abstracts_list_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Re-read the session eventId reactively
      final eventId = SessionController.to.eventIdRx.value;
      final activeRole = RoleController.to.activeRole.value.toUpperCase();

      // Get role-specific screens and navigation
      final roleData = _getRoleBasedData(eventId);
      final screens = roleData['screens'] as List<Widget>;
      final useRoleBasedNav = roleData['useRoleBasedNav'] as bool;

      // Make scaffold key accessible globally for opening drawer
      Get.delete<GlobalKey<ScaffoldState>>(force: true);
      Get.put<GlobalKey<ScaffoldState>>(_scaffoldKey, permanent: true);

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.backgroundColor,
        drawer: Obx(() {
          final role = RoleController.to.activeRole.value.toUpperCase();
          if (role == 'SPEAKER') {
            return const SpeakerSidebarDrawer();
          }
          return const SidebarDrawer();
        }),
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: useRoleBasedNav
            ? RoleBasedBottomNav(
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              )
            : BottomNavBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
      );
    });
  }

  /// Get role-specific screens and navigation configuration.
  Map<String, dynamic> _getRoleBasedData(String eventId) {
    final activeRole = RoleController.to.activeRole.value.toUpperCase();

    switch (activeRole) {
      case 'SPEAKER':
        return {
          'screens': [
            const SpeakerHomeScreen(), // Home - Speaker dashboard with invitations
            const AgendaScreen(), // Agenda
            const AttendeesScreen(), // Attendees
            const CommunityScreen(),
            const MessageScreen(),
          ],
          'useRoleBasedNav': false, // Use default nav for speaker
        };

      case 'VOLUNTEER':
        return {
          'screens': [
            const VolunteerHomeScreen(), // Home
            const VolunteerDashboardScreen(), // Tasks
            const VolunteerQRScanScreen(), // QR Scan
            const CommunityScreen(), // Community
            const MessageScreen(), // Message
          ],
          'useRoleBasedNav': true,
        };

      case 'EXHIBITOR':
      case 'BOOTH_STAFF':
      case 'STAFF':
        return {
          'screens': [
            HomeScreen(eventId: eventId), // Home
            const AgendaScreen(), // Agenda
            const BoothScreen(), // Booth
            const LeadManagementScreen(), // Lead
            const MessageScreen(),
          ],
          'useRoleBasedNav': true,
        };

      case 'SPONSOR':
        return {
          'screens': [
            const SponsorHomeScreen(), // Home
            const AgendaScreen(), // Agenda
            const SponsorHomeScreen(), // Booth (profile)
            const LeadManagementScreen(), // Lead
            const MessageScreen(),
          ],
          'useRoleBasedNav': true,
        };

      case 'ABSTRACT_REVIEWER':
        return {
          'screens': [
            const ContentHomeScreen(),   // Home - Abstract reviewer dashboard
            const AgendaScreen(),        // Agenda
            const AbstractsListScreen(), // Content - Authors & submissions list
            const CommunityScreen(),
            const MessageScreen(),
          ],
          'useRoleBasedNav': true,
        };

      case 'REVIEWER':
      case 'TRACK_CHAIR':
        return {
          'screens': [
            const ReviewerDashboardScreen(), // Home - Reviewer dashboard
            const AgendaScreen(),
            const ReviewerDashboardScreen(), // Content
            const CommunityScreen(),
            const MessageScreen(),
          ],
          'useRoleBasedNav': true,
        };

      case 'ORGANIZER':
        return {
          'screens': [
            const OrganizerDashboardScreen(), // Home - Organizer dashboard
            const AgendaScreen(),
            const AttendeesScreen(),
            const CommunityScreen(),
            const MessageScreen(),
          ],
          'useRoleBasedNav': false, // Use default nav for organizer
        };

      // Default: ATTENDEE, SPEAKER, and any other roles
      default:
        return {
          'screens': [
            HomeScreen(eventId: eventId), // Home — passes real event ID
            const AgendaScreen(),
            const AttendeesScreen(),
            const CommunityScreen(),
            const MessageScreen(),
          ],
          'useRoleBasedNav': false,
        };
    }
  }
}
