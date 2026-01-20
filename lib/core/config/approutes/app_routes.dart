import 'package:confaero_app/features/Events/presentation/widgets/view/event_details_screen.dart';
import 'package:confaero_app/features/Events/presentation/widgets/view/events_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/contact_qr_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/contact_us_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/floormap_screen.dart';
import 'package:confaero_app/features/attendees/presentation/widgets/view/job_details_screen.dart';
import 'package:confaero_app/features/auth/presentation/signin/login_screen.dart';
import 'package:confaero_app/features/auth/presentation/signup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../features/attendees/presentation/widgets/view/event_checkIn_checkout_screen.dart';
import '../../../features/attendees/presentation/widgets/view/floor_map_details_screen.dart';
import '../../../features/attendees/presentation/widgets/view/job_openings_screen.dart';
import '../../../features/attendees/presentation/widgets/view/live_meeting_screen.dart';
import '../../../features/attendees/presentation/widgets/view/my_profile_screen.dart';
import '../../../features/attendees/presentation/widgets/view/qr_scanner_screen.dart';
import '../../../features/bottomNavbar/bottomNavbar_screen.dart';
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
