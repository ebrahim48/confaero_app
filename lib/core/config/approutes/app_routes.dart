import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../features/onboarding/onboarding_screen.dart';



class AppRoutes {

  static const String onBoardingScreen = "/onBoardingScreen";


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
