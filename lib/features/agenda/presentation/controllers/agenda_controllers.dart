// lib/features/agenda/controllers/agenda_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AgendaController extends GetxController {
  // Selected tab (0 = All Sessions, 1 = My Agenda)
  final RxInt selectedTab = 0.obs;

  // Selected month/year
  final RxString selectedMonth = 'JUL 2026'.obs;

  // Selected day
  final RxInt selectedDay = 3.obs;

  // Week days
  final List<Map<String, dynamic>> weekDays = [
    {'day': 'Mon', 'date': 3},
    {'day': 'Tue', 'date': 4},
    {'day': 'Wed', 'date': 5},
    {'day': 'Thu', 'date': 6},
    {'day': 'Fri', 'date': 7},
    {'day': 'Sat', 'date': 8},
  ];

  // All sessions (Image 1 - All Sessions Tab)
  final RxList<Map<String, dynamic>> allSessions = <Map<String, dynamic>>[
    {
      'time': '08:30 AM',
      'type': 'KEYNOTE',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '08:30 - 09:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
    {
      'time': '09:00 AM',
      'type': 'WORKSHOP',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '9:00 - 11:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
    {
      'time': '11:00 AM',
      'type': 'BREAK',
      'title': 'Coffee Break / Posters & Exhibit',
      'duration': '11:00 AM - 11:30 AM',
      'location': 'Exhibit Area',
      'isBreak': true,
    },
  ].obs;

  // My Agenda sessions (Image 2 - My Agenda Tab)
  final RxList<Map<String, dynamic>> myAgendaSessions = <Map<String, dynamic>>[
    {
      'time': '08:30 AM',
      'type': 'KEYNOTE',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '08:30 - 09:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
    {
      'time': '09:00 AM',
      'type': 'KEYNOTE',
      'title': 'Unlocking higher energy density in LFP cells',
      'duration': '08:30 - 09:00',
      'attendees': 1,
      'favorites': 0,
      'isBreak': false,
    },
  ].obs;

  // Get current sessions based on selected tab
  RxList<Map<String, dynamic>> get currentSessions {
    return selectedTab.value == 0 ? allSessions : myAgendaSessions;
  }

  // Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Change day
  void changeDay(int day) {
    selectedDay.value = day;
  }

  // Toggle favorite
  void toggleFavorite(int index) {
    final sessions = currentSessions;
    if (sessions[index]['isBreak'] != true) {
      sessions[index]['favorites'] = sessions[index]['favorites'] == 0 ? 1 : 0;
      sessions.refresh();
    }
  }

  // Add session to my agenda
  void addToMyAgenda(Map<String, dynamic> session) {
    if (!myAgendaSessions.contains(session)) {
      myAgendaSessions.add(session);
    }
  }

  // Remove session from my agenda
  void removeFromMyAgenda(Map<String, dynamic> session) {
    myAgendaSessions.remove(session);
  }
}