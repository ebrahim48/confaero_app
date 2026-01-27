import 'package:confaero_app/features/Events/presentation/widgets/view/event_details_screen.dart';
import 'package:confaero_app/features/Events/presentation/widgets/view/events_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/about_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/contact_qr_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/contact_us_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/event_posters_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/floormap_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/job_details_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/new_event_proposal_screen.dart';
import 'package:confaero_app/features/auth/presentation/signin/login_screen.dart';
import 'package:confaero_app/features/auth/presentation/signup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
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
import '../../../features/bottomNavbar/bottomNavbar_screen.dart';
import '../../../features/community/presentation/widgets/view/organizers_announcements.dart';
import '../../../features/mainattendees/presentation/widgets/view/attendees_details_screen.dart';
import '../../../features/message/presentation/widgets/view/message_chat_screen.dart';
import '../../../features/notification/presentation/widgets/view/notifications_screen.dart';
import '../../../features/onboarding/presentation/widgets/view/onboarding_screen.dart';




class AppRoutes {

  static const String onBoardingScreen = "/onBoardingScreen";
  static const String signUpScreen = "/signUpScreen";
  static const String signInScreen = "/signInScreen";
  static const String eventsScreen = "/eventsScreen";
  static const String eventsDetailsScreen = "/eventsDetailsScreen";
  static const String mainNavigationScreen = "/mainNavigationScreen";
  static const String floorMapScreen = "/floorMapScreen";
  static const String floorMapDetailsScreen = "/floorMapDetailsScreen";
  static const String eventCheckInCheckOutScreen = "/eventCheckInCheckOutScreen";
  static const String contactUsScreen = "/contactUsScreen";
  static const String contactQrScreen = "/contactQrScreen";
  static const String qrScannerScreen = "/qrScannerScreen";
  static const String liveMeetingScreen = "/liveMeetingScreen";
  static const String jobOpeningsScreen = "/jobOpeningsScreen";
  static const String jobDetailsScreen = "/jobDetailsScreen";
  static const String notificationsScreen = "/notificationsScreen";
  static const String myProfileScreen = "/myProfileScreen";
  static const String connectionListScreen = "/connectionListScreen";
  static const String quickNotesScreen = "/quickNotesScreen";
  static const String writeNoteScreen = "/writeNoteScreen";
  static const String organizserGuidelinesScreen = "/organizserGuidelinesScreen";
  static const String aboutUsScreen = "/aboutUsScreen";
  static const String newEventProposalScreen = "/newEventProposalScreen";
  static const String settingsScreen = "/settingsScreen";
  static const String changePasswordScreen = "/changePasswordScreen";
  static const String deleteAccountScreen = "/deleteAccountScreen";
  static const String termsConditionScreen = "/termsConditionScreen";
  static const String eventsPostersScreen = "/eventsPostersScreen";
  static const String eventPostersDetailsScreen = "/eventPostersDetailsScreen";
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
  static const String organizerAnnouncementsScreen = "/organizerAnnouncementsScreen";
  static const String messageChatScreen = "/messageChatScreen";
  static const String attendeeDetailsScreen = "/attendeeDetailsScreen";
  static const String sponsorsScreen = "/sponsorsScreen";
  static const String sponsorsDetailsScreen = "/sponsorsDetailsScreen";
  static const String exHabitorsScreen = "/exHabitorsScreen";
  static const String exhibitorDetailsScreen = "/exhibitorDetailsScreen";


  static final GoRouter goRouter = GoRouter(
    initialLocation: onBoardingScreen,
    redirect: (context, state) async {


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
        builder: (context, state) => ResourcesScreen(),
      ),
      GoRoute(
        path: pollScreen,
        name: pollScreen,
        builder: (context, state) => PollScreen(),
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
        builder: (context, state) => MessageChatScreen(),
      ),
      GoRoute(
        path: attendeeDetailsScreen,
        name: attendeeDetailsScreen,
        builder: (context, state) => AttendeeDetailsScreen(),
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
