import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../notes/domain/services/note_service.dart';

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
    } finally {
      isLoading.value = false;
    }
  }

  // Add new note
  Future<bool> addNote(String content) async {
    if (content.trim().isEmpty) return false;
    try {
      await _noteService.createNote(eventId: currentEventId, content: content);
      await loadNotes();
      return true;
    } catch (_) {
      return false;
    }
  }

  // Update existing note
  Future<bool> updateNote(String id, String content) async {
    if (content.trim().isEmpty) return false;
    try {
      await _noteService.updateNote(noteId: id, content: content);
      await loadNotes();
      return true;
    } catch (_) {
      await loadNotes();
      return false;
    }
  }

  // Delete note
  void deleteNote(String id) {
    notes.removeWhere((note) => note['id'] == id);

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
