import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadController extends GetxController {
  // Filter tabs
  final RxString selectedFilter = 'All Scans'.obs;
  final List<String> filters = ['All Scans', 'Hot Lead', 'Follow-up', 'Reached'];

  // Leads list
  final RxList<Map<String, dynamic>> allLeads = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Ronald Richards',
      'role': 'VP of Marketing @ TecGlobl',
      'time': '2:30 PM',
      'image': 'assets/images/profile.png',
      'tags': <String>[],
      'note': '',
    },
    {
      'id': '2',
      'name': 'Sarah Jenkins',
      'role': 'VP of Marketing @ TecGlobl',
      'time': '2:30 PM',
      'image': 'assets/images/profile.png',
      'tags': <String>['Hot Lead'],
      'note': '',
    },
    {
      'id': '3',
      'name': 'Arlene McCoy',
      'role': 'VP of Marketing @ TecGlobl',
      'time': '2:30 PM',
      'image': 'assets/images/profile.png',
      'tags': <String>['Follow-Up', 'Demo'],
      'note': '',
    },
    {
      'id': '4',
      'name': 'Floyd Miles',
      'role': 'VP of Marketing @ TecGlobl',
      'time': '2:30 PM',
      'image': 'assets/images/profile.png',
      'tags': <String>['Follow-Up', 'Demo'],
      'note': '',
    },
    {
      'id': '5',
      'name': 'Eleanor Pena',
      'role': 'VP of Marketing @ TecGlobl',
      'time': '2:30 PM',
      'image': 'assets/images/profile.png',
      'tags': <String>[],
      'note': '',
    },
  ].obs;

  // Available tag options
  final List<String> availableTags = [
    'Hot Lead',
    'Follow-Up',
    'Demo',
    'Reached',
    'Cold Lead',
  ];

  // Tag dialog state
  final RxList<String> tempSelectedTags = <String>[].obs;
  final RxString selectedTagDropdown = ''.obs;

  // Note dialog state
  final TextEditingController noteController = TextEditingController();
  final RxInt noteLength = 0.obs;
  final RxString currentNoteLeadId = ''.obs;

  // Add tag dialog state
  final RxString currentTagLeadId = ''.obs;

  RxList<Map<String, dynamic>> get filteredLeads {
    if (selectedFilter.value == 'All Scans') return allLeads;
    return allLeads
        .where((lead) =>
        (lead['tags'] as List<String>).contains(selectedFilter.value))
        .toList()
        .obs;
  }

  int get totalLeads => allLeads.length;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Tag dialog
  void openTagDialog(String leadId) {
    currentTagLeadId.value = leadId;
    final lead = allLeads.firstWhere((l) => l['id'] == leadId);
    tempSelectedTags.value = List<String>.from(lead['tags']);
    selectedTagDropdown.value = '';
    Get.dialog(_TagDialog());
  }

  void removeTag(String tag) {
    tempSelectedTags.remove(tag);
  }

  void addTagFromDropdown() {
    final tag = selectedTagDropdown.value;
    if (tag.isEmpty) return;
    if (tempSelectedTags.length >= 2) {
      Get.snackbar('Limit Reached', 'Only up to 2 tags can be added.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!tempSelectedTags.contains(tag)) {
      tempSelectedTags.add(tag);
    }
    selectedTagDropdown.value = '';
  }

  void saveTags() {
    final index =
    allLeads.indexWhere((l) => l['id'] == currentTagLeadId.value);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(allLeads[index]);
      updated['tags'] = List<String>.from(tempSelectedTags);
      allLeads[index] = updated;
      allLeads.refresh();
    }
    Get.back();
  }

  // Note dialog
  void openNoteDialog(String leadId) {
    currentNoteLeadId.value = leadId;
    final lead = allLeads.firstWhere((l) => l['id'] == leadId);
    noteController.text = lead['note'] ?? '';
    noteLength.value = noteController.text.length;
    Get.dialog(_NoteDialog());
  }

  void saveNote() {
    final index =
    allLeads.indexWhere((l) => l['id'] == currentNoteLeadId.value);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(allLeads[index]);
      updated['note'] = noteController.text;
      allLeads[index] = updated;
      allLeads.refresh();
    }
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    noteController.addListener(() {
      noteLength.value = noteController.text.length;
    });
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}

// ── Dialogs ──────────────────────────────────────────────────────────────────

class _TagDialog extends GetWidget<LeadController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Tag',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Add Options:',
                style: TextStyle(fontSize: 13, color: Color(0xff7E7F7E))),
            const SizedBox(height: 10),

            // Selected tags chips
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 6,
              children: controller.tempSelectedTags
                  .map((tag) => _tagChip(tag))
                  .toList(),
            )),
            const SizedBox(height: 12),

            // Dropdown
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border:
                Border.all(color: const Color(0xffD2D2D2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('select tag',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xff7E7F7E))),
                  value: controller.selectedTagDropdown.value.isEmpty
                      ? null
                      : controller.selectedTagDropdown.value,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: controller.availableTags
                      .where((t) =>
                  !controller.tempSelectedTags.contains(t))
                      .map((tag) => DropdownMenuItem(
                    value: tag,
                    child: Text(tag,
                        style: const TextStyle(fontSize: 13)),
                  ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.selectedTagDropdown.value = val;
                      controller.addTagFromDropdown();
                    }
                  },
                ),
              ),
            )),
            const SizedBox(height: 8),

            const Text(
              'Please note: only up to 2 tags can be added.',
              style: TextStyle(fontSize: 11, color: Color(0xffE5A000)),
            ),
            const SizedBox(height: 16),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.saveTags,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff32A69A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD2D2D2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xff424242))),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => controller.removeTag(tag),
            child: const Icon(Icons.close, size: 14, color: Color(0xff7E7F7E)),
          ),
        ],
      ),
    );
  }
}

class _NoteDialog extends GetWidget<LeadController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Write A Note',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD2D2D2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: controller.noteController,
                maxLines: 8,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  hintText: 'Write your note here...',
                  hintStyle:
                  TextStyle(fontSize: 13, color: Color(0xff7E7F7E)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Write at least 200 characters.',
                style:
                TextStyle(fontSize: 11, color: Color(0xff7E7F7E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}