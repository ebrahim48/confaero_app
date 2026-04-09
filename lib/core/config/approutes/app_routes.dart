import 'package:confaero_app/features/Events/presentation/widgets/view/event_details_screen.dart';
import 'package:confaero_app/features/Events/presentation/widgets/view/events_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/about_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/contact_qr_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/contact_us_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/event_posters_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/floormap_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/home_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/job_details_screen.dart';
import 'package:confaero_app/features/job/presentation/widgets/job_posting_form_screen.dart';
import 'package:confaero_app/features/job/presentation/widgets/my_jobs_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/new_event_proposal_screen.dart';
import 'package:confaero_app/features/auth/presentation/signin/login_screen.dart';
import 'package:confaero_app/features/auth/presentation/signup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../features/Events/presentation/widgets/view/event_speaker_screen.dart';
import '../../../features/agenda/presentation/widgets/view/agenda_details_screen.dart';
import '../../../features/agenda/presentation/widgets/view/spekar_profile_screen.dart';
import '../../../features/attendees/presentation/widgets/view/add_poster_screen.dart';
import '../../../features/attendees/presentation/widgets/view/change_password.dart';
import '../../../features/attendees/presentation/widgets/view/connectionlist_screen.dart';
import '../../../features/attendees/presentation/widgets/view/delete_account.dart';
import '../../../features/attendees/presentation/widgets/view/document_details.dart';
import '../../../features/attendees/presentation/widgets/view/document_screen.dart';
import '../../../features/attendees/presentation/widgets/view/event_checkIn_checkout_screen.dart';
import '../../../features/attendees/presentation/widgets/view/event_posters_details_screen.dart';
import '../../../features/attendees/presentation/widgets/view/exhibitors_details_screen.dart';
import '../../../features/attendees/presentation/widgets/view/exhibitors_screen.dart';
import '../../../features/attendees/presentation/widgets/view/floor_map_details_screen.dart';
import '../../../features/attendees/presentation/widgets/view/grganizers_guidelines_screen.dart';
import '../../../features/attendees/presentation/widgets/view/imagepdf_screen.dart';
import '../../../features/attendees/presentation/widgets/view/job_openings_screen.dart';
import '../../../features/attendees/presentation/widgets/view/live_meeting_screen.dart';
import '../../../features/attendees/presentation/widgets/view/my_profile_screen.dart';
import '../../../features/attendees/presentation/widgets/view/pdf_screen.dart';
import '../../../features/attendees/presentation/widgets/view/photos_screen.dart';
import '../../../features/attendees/presentation/widgets/view/poll_screen.dart';
import '../../../features/attendees/presentation/widgets/view/qr_scanner_screen.dart';
import '../../../features/attendees/presentation/widgets/view/quick_notes_screen.dart';
import '../../../features/attendees/presentation/widgets/view/resources_screen.dart';
import '../../../features/attendees/presentation/widgets/view/settings_screen.dart';
import '../../../features/attendees/presentation/widgets/view/sponsors_details_screen.dart';
import '../../../features/attendees/presentation/widgets/view/sponsors_screen.dart';
import '../../../features/attendees/presentation/widgets/view/terms_condition_screen.dart';
import '../../../features/attendees/presentation/widgets/view/write_note_screen.dart';
import '../../../features/auth/presentation/forget/forget_screen.dart';
import '../../../features/auth/presentation/reset/reset_password_screen.dart';
import '../../../features/auth/presentation/verify/verify_screen.dart';
import '../../../features/bottomNavbar/bottomNavbar_screen.dart';
import '../../../features/community/presentation/widgets/view/organizers_announcements.dart';
import '../../../features/mainattendees/presentation/widgets/view/attendees_details_screen.dart';
import '../../../features/message/presentation/widgets/view/message_chat_screen.dart';
import '../../../features/notification/presentation/widgets/view/notifications_screen.dart';
import '../../../features/onboarding/presentation/widgets/view/onboarding_screen.dart';
import '../../../features/organizer/presentation/widgets/organizer_dashboard_screen.dart';
import '../../../features/organizer/presentation/widgets/session_form_screen.dart';
import '../../../features/booth_management/presentation/widgets/booth_management_screen.dart';
import '../../../features/sponsor_dashboard/presentation/widgets/sponsor_dashboard_screen.dart';
import '../../../features/sponsor_dashboard/presentation/widgets/sponsor_form_screen.dart';
import '../../../features/poster_assign/presentation/widgets/poster_assign_screen.dart';
import '../../../features/reviewer/presentation/widgets/reviewer_dashboard_screen.dart';
import '../../../features/volunteer/presentation/widgets/volunteer_dashboard_screen.dart';
import '../../../features/volunteer/presentation/widgets/task_form_screen.dart';
import '../../../features/video_conference/presentation/widgets/live_session_screen.dart';
import '../../../features/organizer_messaging/presentation/widgets/organizer_conversations_screen.dart';
import '../../../features/attendees/presentation/widgets/view/resources_screen.dart' as resources_view;
import '../../../features/organizer_messaging/presentation/widgets/organizer_chat_screen.dart';
import '../../../features/invitations/presentation/widgets/invitations_screen.dart';
import '../../../features/announcements/presentation/widgets/view/organizer_announcements_screen.dart'
    as org_annc;
import '../../../features/resources/presentation/widgets/view/organizer_resources_screen.dart';
import '../../../features/invitations/presentation/widgets/view/verified_email_screen.dart';
import '../../../features/attendees/presentation/widgets/view/exhibitor_leads_screen.dart';
import '../../../features/organizer/presentation/widgets/organizer_attendee_screen.dart';
import '../../../features/auth/presentation/role_switch/role_switch_screen.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/prefs_helper.dart';

class AppRoutes {
  static const String onBoardingScreen = "/onBoardingScreen";
  static const String signUpScreen = "/signUpScreen";
  static const String signInScreen = "/signInScreen";

  // Password reset routes - using API constants paths
  static const String forgetPasswordScreen = ApiConstants.forgetPassword;
  static const String verifyScreen = ApiConstants.verifyResetCode;
  static const String resetPasswordScreen = ApiConstants.resetPassword;

  static const String eventsScreen = "/eventsScreen";
  static const String eventsDetailsScreen = "/eventsDetailsScreen";
  static const String eventsDetailsScreenWithId =
      "/eventsDetailsScreen/:eventId";
  static const String mainNavigationScreen = "/mainNavigationScreen";
  static const String floorMapScreen = "/floorMapScreen";
  static const String floorMapDetailsScreen = "/floorMapDetailsScreen";
  static const String eventCheckInCheckOutScreen =
      "/eventCheckInCheckOutScreen";
  static const String contactUsScreen = "/contactUsScreen";
  static const String contactQrScreen = "/contactQrScreen";
  static const String qrScannerScreen = "/qrScannerScreen";
  static const String liveMeetingScreen = "/liveMeetingScreen";
  static const String jobOpeningsScreen = "/jobOpeningsScreen";
  static const String jobDetailsScreen = "/jobDetailsScreen";
  static const String jobPostingFormScreen = "/jobPostingFormScreen";
  static const String myJobsScreen = "/myJobsScreen";
  static const String notificationsScreen = "/notificationsScreen";
  static const String myProfileScreen = "/myProfileScreen";
  static const String connectionListScreen = "/connectionListScreen";
  static const String quickNotesScreen = "/quickNotesScreen";
  static const String writeNoteScreen = "/writeNoteScreen";
  static const String organizserGuidelinesScreen =
      "/organizserGuidelinesScreen";
  static const String aboutUsScreen = "/aboutUsScreen";
  static const String newEventProposalScreen = "/newEventProposalScreen";
  static const String settingsScreen = "/settingsScreen";
  static const String changePasswordScreen = "/changePasswordScreen";
  static const String deleteAccountScreen = "/deleteAccountScreen";
  static const String termsConditionScreen = "/termsConditionScreen";
  static const String eventsPostersScreen = "/eventsPostersScreen";
  static const String eventPostersDetailsScreen = "/eventPostersDetailsScreen";
  static const String attendeeHomeScreen = "/attendeeHomeScreen";
  static const String attendeeHomeScreenWithId = "/attendeeHomeScreen/:eventId";
  static const String pdfScreen = "/pdfScreen";
  static const String imagePdfScreen = "/imagePdfScreen";
  static const String addPosterScreen = "/addPosterScreen";
  static const String resourcesScreen = "/resourcesScreen";
  static const String pollScreen = "/pollScreen";
  static const String documentScreen = "/documentScreen";
  static const String documentDetailsScreen = "/documentDetailsScreen";
  static const String photosScreen = "/photosScreen";
  static const String agendaDetailsScreen = "/agendaDetailsScreen";
  static const String speakarProfileScreen = "/speakarProfileScreen";
  static const String eventSpekarScreen = "/eventSpekarScreen";
  static const String organizerAnnouncementsScreen =
      "/organizerAnnouncementsScreen";
  static const String messageChatScreen = "/messageChatScreen";
  static const String attendeeDetailsScreen = "/attendeeDetailsScreen";
  static const String sponsorsScreen = "/sponsorsScreen";
  static const String sponsorsDetailsScreen = "/sponsorsDetailsScreen";
  static const String exHabitorsScreen = "/exHabitorsScreen";
  static const String exhibitorDetailsScreen = "/exhibitorDetailsScreen";

  // Role-specific screens
  static const String organizerDashboardScreen = "/organizerDashboardScreen";
  static const String sessionFormScreen = "/sessionFormScreen";
  static const String boothManagementScreen = "/boothManagementScreen";
  static const String sponsorDashboardScreen = "/sponsorDashboardScreen";
  static const String sponsorFormScreen = "/sponsorFormScreen";
  static const String posterAssignScreen = "/posterAssignScreen";
  static const String reviewerDashboardScreen = "/reviewerDashboardScreen";
  static const String volunteerDashboardScreen = "/volunteerDashboardScreen";
  static const String taskFormScreen = "/taskFormScreen";
  static const String liveSessionScreen = "/liveSessionScreen";
  static const String organizerConversationsScreen =
      "/organizerConversationsScreen";
  static const String organizerChatScreen = "/organizerChatScreen";
  static const String invitationsScreen = "/invitationsScreen";

  // --- New screens for 18 remaining endpoints ---
  static const String organizerAnnouncementsCrudScreen =
      "/organizerAnnouncementsCrudScreen";
  static const String organizerResourcesCrudScreen =
      "/organizerResourcesCrudScreen";
  static const String verifiedEmailScreen = "/verifiedEmailScreen";
  static const String exhibitorLeadsScreen = "/exhibitorLeadsScreen";
  static const String organizerAttendeeScreen = "/organizerAttendeeScreen";
  static const String roleSwitchScreen = "/roleSwitchScreen";

  // verifyScreen and resetPasswordScreen already defined above with API constants

  static final GoRouter goRouter = GoRouter(
    initialLocation: onBoardingScreen,
    redirect: (context, state) async {
      final token = await PrefsHelper.getString(AppConstants.bearerToken);
      final isLogged = await PrefsHelper.getBool(AppConstants.isLogged);

      final authRoutes = <String>{
        AppRoutes.onBoardingScreen,
        AppRoutes.signInScreen,
        AppRoutes.signUpScreen,
        AppRoutes.forgetPasswordScreen,
        AppRoutes.verifyScreen,
        AppRoutes.resetPasswordScreen,
      };

      final currentPath = state.matchedLocation;
      final isGoingToAuth = authRoutes.contains(currentPath);

      if (token.isNotEmpty && isLogged && isGoingToAuth) {
        return AppRoutes.mainNavigationScreen;
      }

      if (token.isEmpty && !isGoingToAuth) {
        return AppRoutes.signInScreen;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: onBoardingScreen,
        name: onBoardingScreen,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: signUpScreen,
        name: signUpScreen,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: signInScreen,
        name: signInScreen,
        builder: (context, state) => SignInScreen(),
      ),

      GoRoute(
        path: eventsScreen,
        name: eventsScreen,
        builder: (context, state) => EventsScreen(),
      ),

      GoRoute(
        path: eventsDetailsScreen,
        name: eventsDetailsScreen,
        builder: (context, state) => EventDetailsScreen(),
      ),

      GoRoute(
        path: eventsDetailsScreenWithId,
        name: eventsDetailsScreenWithId,
        builder: (context, state) => EventDetailsScreen(),
      ),

      GoRoute(
        path: mainNavigationScreen,
        name: mainNavigationScreen,
        builder: (context, state) => MainNavigationScreen(),
      ),

      GoRoute(
        path: floorMapScreen,
        name: floorMapScreen,
        builder: (context, state) => FloorMapScreen(),
      ),

      GoRoute(
        path: floorMapDetailsScreen,
        name: floorMapDetailsScreen,
        builder: (context, state) => FloorMapDetailsScreen(),
      ),

      GoRoute(
        path: eventCheckInCheckOutScreen,
        name: eventCheckInCheckOutScreen,
        builder: (context, state) => EventCheckInCheckOutScreen(),
      ),

      GoRoute(
        path: attendeeHomeScreenWithId,
        name: attendeeHomeScreen,
        builder: (context, state) {
          final eventId = state.pathParameters['eventId'] ?? '';
          return HomeScreen(eventId: eventId);
        },
      ),

      GoRoute(
        path: contactUsScreen,
        name: contactUsScreen,
        builder: (context, state) => ContactUsScreen(),
      ),

      GoRoute(
        path: contactQrScreen,
        name: contactQrScreen,
        builder: (context, state) => ContactQrScreen(),
      ),

      GoRoute(
        path: qrScannerScreen,
        name: qrScannerScreen,
        builder: (context, state) => QrScannerScreen(),
      ),

      GoRoute(
        path: liveMeetingScreen,
        name: liveMeetingScreen,
        builder: (context, state) => LiveMeetingScreen(),
      ),

      GoRoute(
        path: jobOpeningsScreen,
        name: jobOpeningsScreen,
        builder: (context, state) => JobOpeningsScreen(),
      ),

      GoRoute(
        path: jobDetailsScreen,
        name: jobDetailsScreen,
        builder: (context, state) => JobDetailsScreen(),
      ),

      GoRoute(
        path: jobPostingFormScreen,
        name: jobPostingFormScreen,
        builder: (context, state) => const JobPostingFormScreen(),
      ),

      GoRoute(
        path: myJobsScreen,
        name: myJobsScreen,
        builder: (context, state) => const MyJobsScreen(),
      ),

      GoRoute(
        path: notificationsScreen,
        name: notificationsScreen,
        builder: (context, state) => NotificationsScreen(),
      ),
      GoRoute(
        path: myProfileScreen,
        name: myProfileScreen,
        builder: (context, state) => MyProfileScreen(),
      ),
      GoRoute(
        path: connectionListScreen,
        name: connectionListScreen,
        builder: (context, state) => ConnectionListScreen(),
      ),
      GoRoute(
        path: quickNotesScreen,
        name: quickNotesScreen,
        builder: (context, state) => QuickNotesScreen(),
      ),
      GoRoute(
        path: writeNoteScreen,
        name: writeNoteScreen,
        builder: (context, state) => WriteNoteScreen(),
      ),
      GoRoute(
        path: organizserGuidelinesScreen,
        name: organizserGuidelinesScreen,
        builder: (context, state) => OrganizserGuidelinesScreen(),
      ),
      GoRoute(
        path: aboutUsScreen,
        name: aboutUsScreen,
        builder: (context, state) => AboutUsScreen(),
      ),

      GoRoute(
        path: newEventProposalScreen,
        name: newEventProposalScreen,
        builder: (context, state) => NewEventProposalScreen(),
      ),

      GoRoute(
        path: settingsScreen,
        name: settingsScreen,
        builder: (context, state) => SettingsScreen(),
      ),
      GoRoute(
        path: changePasswordScreen,
        name: changePasswordScreen,
        builder: (context, state) => ChangePasswordScreen(),
      ),
      GoRoute(
        path: deleteAccountScreen,
        name: deleteAccountScreen,
        builder: (context, state) => DeleteAccountScreen(),
      ),
      GoRoute(
        path: termsConditionScreen,
        name: termsConditionScreen,
        builder: (context, state) => TermsConditionScreen(),
      ),
      GoRoute(
        path: eventsPostersScreen,
        name: eventsPostersScreen,
        builder: (context, state) => EventsPostersScreen(),
      ),
      GoRoute(
        path: eventPostersDetailsScreen,
        name: eventPostersDetailsScreen,
        builder: (context, state) => EventPosterDetailsScreen(),
      ),
      GoRoute(
        path: pdfScreen,
        name: pdfScreen,
        builder: (context, state) => PdfScreen(),
      ),
      GoRoute(
        path: imagePdfScreen,
        name: imagePdfScreen,
        builder: (context, state) => ImagePdfScreen(),
      ),
      GoRoute(
        path: addPosterScreen,
        name: addPosterScreen,
        builder: (context, state) => AddPosterScreen(),
      ),
      GoRoute(
        path: resourcesScreen,
        name: resourcesScreen,
        builder: (context, state) => const resources_view.ResourcesScreen(),
      ),
      GoRoute(
        path: pollScreen,
        name: pollScreen,
        builder: (context, state) {
          final poll = state.extra as Map<String, dynamic>?;
          if (poll != null && poll['poll'] != null) {
            return PollScreen(poll: poll['poll']);
          }
          return const Scaffold(
            body: Center(
              child: Text('No poll data provided'),
            ),
          );
        },
      ),
      GoRoute(
        path: documentScreen,
        name: documentScreen,
        builder: (context, state) => DocumentScreen(),
      ),
      GoRoute(
        path: documentDetailsScreen,
        name: documentDetailsScreen,
        builder: (context, state) => DocumentDetailsScreen(),
      ),
      GoRoute(
        path: photosScreen,
        name: photosScreen,
        builder: (context, state) => PhotosScreen(),
      ),
      GoRoute(
        path: agendaDetailsScreen,
        name: agendaDetailsScreen,
        builder: (context, state) => AgendaDetailsScreen(),
      ),
      GoRoute(
        path: speakarProfileScreen,
        name: speakarProfileScreen,
        builder: (context, state) => SpeakerProfileScreen(),
      ),
      GoRoute(
        path: eventSpekarScreen,
        name: eventSpekarScreen,
        builder: (context, state) => EventSpekarScreen(),
      ),
      GoRoute(
        path: organizerAnnouncementsScreen,
        name: organizerAnnouncementsScreen,
        builder: (context, state) => OrganizerAnnouncementsScreen(),
      ),
      GoRoute(
        path: messageChatScreen,
        name: messageChatScreen,
        builder: (context, state) {
          // extra is passed from MessageScreen as { conversationId, receiverId }
          if (state.extra != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.arguments ?? state.extra;
            });
          }
          return MessageChatScreen(args: state.extra as Map<String, dynamic>?);
        },
      ),
      GoRoute(
        path: attendeeDetailsScreen,
        name: attendeeDetailsScreen,
        builder: (context, state) {
          final attendeeId = (state.extra as Map<String, dynamic>?)?['attendeeId'] as String? ?? '';
          return AttendeeDetailsScreen(attendeeId: attendeeId);
        },
      ),
      GoRoute(
        path: sponsorsScreen,
        name: sponsorsScreen,
        builder: (context, state) => SponsorsScreen(),
      ),
      GoRoute(
        path: sponsorsDetailsScreen,
        name: sponsorsDetailsScreen,
        builder: (context, state) => SponsorsDetailsScreen(),
      ),
      GoRoute(
        path: exHabitorsScreen,
        name: exHabitorsScreen,
        builder: (context, state) => ExhibitorScreen(),
      ),
      GoRoute(
        path: exhibitorDetailsScreen,
        name: exhibitorDetailsScreen,
        builder: (context, state) => ExhibitorDetailsScreen(),
      ),

      // =================== Role-Specific Routes ===================
      GoRoute(
        path: organizerDashboardScreen,
        name: organizerDashboardScreen,
        builder: (context, state) => const OrganizerDashboardScreen(),
      ),
      GoRoute(
        path: sessionFormScreen,
        name: sessionFormScreen,
        builder: (context, state) => const SessionFormScreen(),
      ),
      GoRoute(
        path: boothManagementScreen,
        name: boothManagementScreen,
        builder: (context, state) => const BoothManagementScreen(),
      ),
      GoRoute(
        path: sponsorDashboardScreen,
        name: sponsorDashboardScreen,
        builder: (context, state) => const SponsorDashboardScreen(),
      ),
      GoRoute(
        path: sponsorFormScreen,
        name: sponsorFormScreen,
        builder: (context, state) => const SponsorFormScreen(),
      ),
      GoRoute(
        path: posterAssignScreen,
        name: posterAssignScreen,
        builder: (context, state) => const PosterAssignScreen(),
      ),
      GoRoute(
        path: reviewerDashboardScreen,
        name: reviewerDashboardScreen,
        builder: (context, state) => const ReviewerDashboardScreen(),
      ),
      GoRoute(
        path: volunteerDashboardScreen,
        name: volunteerDashboardScreen,
        builder: (context, state) => const VolunteerDashboardScreen(),
      ),
      GoRoute(
        path: taskFormScreen,
        name: taskFormScreen,
        builder: (context, state) => const TaskFormScreen(),
      ),
      GoRoute(
        path: liveSessionScreen,
        name: liveSessionScreen,
        builder: (context, state) => const LiveSessionScreen(),
      ),
      GoRoute(
        path: organizerConversationsScreen,
        name: organizerConversationsScreen,
        builder: (context, state) => const OrganizerConversationsScreen(),
      ),
      GoRoute(
        path: organizerChatScreen,
        name: organizerChatScreen,
        builder: (context, state) => const OrganizerChatScreen(),
      ),
      GoRoute(
        path: invitationsScreen,
        name: invitationsScreen,
        builder: (context, state) => const InvitationsScreen(),
      ),

      // --- New routes for 18 remaining endpoints ---
      GoRoute(
        path: organizerAnnouncementsCrudScreen,
        name: organizerAnnouncementsCrudScreen,
        builder: (context, state) {
          final eventId = state.extra as String? ?? '';
          return org_annc.OrganizerAnnouncementCrudScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: organizerResourcesCrudScreen,
        name: organizerResourcesCrudScreen,
        builder: (context, state) {
          final eventId = state.extra as String? ?? '';
          return OrganizerResourcesScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: verifiedEmailScreen,
        name: verifiedEmailScreen,
        builder: (context, state) {
          final eventId = state.extra as String? ?? '';
          return VerifiedEmailScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: exhibitorLeadsScreen,
        name: exhibitorLeadsScreen,
        builder: (context, state) {
          final boothId = state.extra as String? ?? '';
          return ExhibitorLeadsScreen(boothId: boothId);
        },
      ),
      GoRoute(
        path: organizerAttendeeScreen,
        name: organizerAttendeeScreen,
        builder: (context, state) {
          final eventId = state.extra as String? ?? '';
          return OrganizerAttendeeScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: roleSwitchScreen,
        name: roleSwitchScreen,
        builder: (context, state) => const RoleSwitchScreen(),
      ),

      GoRoute(
        path: forgetPasswordScreen,
        name: forgetPasswordScreen,
        builder: (context, state) {
          String email = state.extra as String;
          return ForgetPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: verifyScreen,
        name: verifyScreen,
        builder: (context, state) => VerifyScreen(),
      ),
      GoRoute(
        path: resetPasswordScreen,
        name: resetPasswordScreen,
        builder: (context, state) => ResetPasswordScreen(),
      ),
    ],
  );

  static Page<dynamic> _customTransitionPage(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
