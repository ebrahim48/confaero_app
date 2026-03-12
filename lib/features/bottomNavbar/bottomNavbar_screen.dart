import 'package:confaero_app/features/agenda/presentation/widgets/view/agenda_screen.dart';
import 'package:confaero_app/features/bottomNavbar/presentation/bottom_navbar_widgets.dart';
import 'package:confaero_app/features/community/presentation/widgets/view/community_screen.dart';
import 'package:confaero_app/features/mainattendees/presentation/widgets/view/attendees_screen.dart';
import 'package:confaero_app/features/message/presentation/widgets/view/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/controllers/session_controller.dart';
import '../attendees/presentation/widgets/view/home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Re-read the session eventId reactively
      final eventId = SessionController.to.eventIdRx.value;

      final screens = <Widget>[
        HomeScreen(eventId: eventId), // Home — passes real event ID
        const AgendaScreen(),
        const AttendeesScreen(),
        const CommunityScreen(),
        const MessageScreen(),
      ];

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: BottomNavBar(
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
}
