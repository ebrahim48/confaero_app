import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickNotesController extends GetxController {
  final RxList<Map<String, dynamic>> notes = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  //  notes
  void loadNotes() {
    isLoading.value = true;

    // Dummy data
    notes.value = [
      {
        'id': '1',
        'title': 'Felt strong today! Increased my s...',
        'content': 'Struggled with the last set of lunges, might reduce reps next time. Struggled with the last set of lunges, might reduce reps next time. Struggled with the last set of lunges, might reduce reps next time. Struggled with the last set of lunges, might reduce reps next time.',
        'date': DateTime.now(),
      },
      {
        'id': '2',
        'title': 'Upper body felt great, but I need...',
        'content': 'Upper body workout was intense today. Need to work on shoulder mobility.',
        'date': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': '3',
        'title': 'Core stability getting better ever...',
        'content': 'Core exercises are showing great progress. Plank time increased.',
        'date': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'id': '4',
        'title': 'Recovery daywith yoga — helped...',
        'content': 'Yoga session was very relaxing. Helped with muscle recovery.',
        'date': DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        'id': '5',
        'title': 'Did the HIIT version — super swe...',
        'content': 'HIIT workout was challenging but effective. Great cardio session.',
        'date': DateTime.now().subtract(const Duration(days: 4)),
      },
    ];

    isLoading.value = false;
  }

  // Add new note
  void addNote(String content) {
    if (content.trim().isEmpty) return;

    final title = content.length > 35
        ? '${content.substring(0, 35)}...'
        : content;

    final newNote = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'content': content,
      'date': DateTime.now(),
    };

    notes.insert(0, newNote);


    Get.snackbar(
      'Success',
      'Note saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff4DB6AC),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Update existing note
  void updateNote(String id, String content) {
    final index = notes.indexWhere((note) => note['id'] == id);
    if (index != -1) {
      final title = content.length > 35
          ? '${content.substring(0, 35)}...'
          : content;

      notes[index] = {
        'id': id,
        'title': title,
        'content': content,
        'date': notes[index]['date'],
      };

      Get.back();

      Get.snackbar(
        'Success',
        'Note updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff4DB6AC),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Delete note
  void deleteNote(String id) {
    notes.removeWhere((note) => note['id'] == id);

    Get.snackbar(
      'Deleted',
      'Note deleted successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Get formatted date
  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${_getMonthName(date.month)} ${date.day}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}