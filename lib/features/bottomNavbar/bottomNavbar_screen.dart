import 'package:confaero_app/features/agenda/presentation/widgets/view/agenda_screen.dart';
import 'package:confaero_app/features/bottomNavbar/presentation/bottom_navbar_widgets.dart';
import 'package:confaero_app/features/community_screen.dart';
import 'package:confaero_app/features/mainattendees/presentation/widgets/view/attendees_screen.dart';
import 'package:confaero_app/features/message/message_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../attendees/presentation/widgets/view/home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(), // Home
    const AgendaScreen(), // Agenda
    const AttendeesScreen(), // Attendees
    const CommunityScreen(), // Community
    const MessageScreen(), // Messages
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}