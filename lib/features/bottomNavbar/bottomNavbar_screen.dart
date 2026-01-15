import 'package:confaero_app/features/bottomNavbar/presentation/bottom_navbar_widgets.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../Events/presentation/widgets/view/events_screen.dart';
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
    const Center(child: Text('Agenda')), // Agenda
    const Center(child: Text('Attendees')), // Attendees
    const Center(child: Text('Community')), // Community
    const Center(child: Text('Messages')), // Messages
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