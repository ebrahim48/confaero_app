import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../notes/domain/services/note_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class QuickNotesController extends GetxController {
  final NoteService _noteService = Get.find<NoteService>();

  final RxList<Map<String, dynamic>> notes = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;

  // Read event ID from global session state
  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  //  notes
  Future<void> loadNotes() async {
    isLoading.value = true;
    try {
      final data = await _noteService.getNotes();
      notes.value =
          data.map((n) {
            final content = n.content.isNotEmpty ? n.content : 'Empty note';
            return {
              'id': n.id,
              'title':
                  content.length > 35
                      ? '${content.substring(0, 35)}...'
                      : content,
              'content': content,
              'date': DateTime.tryParse(n.createdAt) ?? DateTime.now(),
            };
          }).toList();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load notes', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  // Add new note
  Future<void> addNote(String content) async {
    if (content.trim().isEmpty) return;

    try {
      // Optimistic UI update
      final title =
          content.length > 35 ? '${content.substring(0, 35)}...' : content;
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();

      final newNote = {
        'id': tempId,
        'title': title,
        'content': content,
        'date': DateTime.now(),
      };

      notes.insert(0, newNote);

      await _noteService.createOrUpdateNote(
        eventId: currentEventId,
        content: content,
      );

      // Reload from server to get actual ID
      await loadNotes();

      ToastMessageHelper.showToastMessage('Note saved successfully!', title: 'Success');
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to save note', title: 'Error');
      // Revert if failed
      await loadNotes();
    }
  }

  // Update existing note
  Future<void> updateNote(String id, String content) async {
    final index = notes.indexWhere((note) => note['id'] == id);
    if (index != -1) {
      try {
        final title =
            content.length > 35 ? '${content.substring(0, 35)}...' : content;

        // Optimistic update
        notes[index] = {
          'id': id,
          'title': title,
          'content': content,
          'date': notes[index]['date'],
        };
        notes.refresh();
        Get.back();

        await _noteService.createOrUpdateNote(
          eventId: currentEventId,
          content: content,
        );

        ToastMessageHelper.showToastMessage('Note updated successfully!', title: 'Success');
      } catch (e) {
        ToastMessageHelper.showToastMessage('Failed to update note', title: 'Error');
        await loadNotes(); // Revert on failure
      }
    }
  }

  // Delete note
  void deleteNote(String id) {
    notes.removeWhere((note) => note['id'] == id);

    ToastMessageHelper.showToastMessage('Note deleted successfully!', title: 'Deleted');
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
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
