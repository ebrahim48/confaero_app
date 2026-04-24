import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/qr_service.dart';

class LeadController extends GetxController {
  late final QrService _qrService;

  // Loading / error
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Filter tabs — display labels
  final RxString selectedFilter = 'All Scans'.obs;
  final List<String> filters = ['All Scans', 'Hot Lead', 'Follow Up', 'General'];

  // All leads — stores API-mapped data
  final RxList<Map<String, dynamic>> allLeads = <Map<String, dynamic>>[].obs;

  // Available tag options: value = API enum, label = display text
  static const List<Map<String, String>> availableTagOptions = [
    {'value': 'HOT', 'label': 'Hot Lead'},
    {'value': 'FOLLOW_UP', 'label': 'Follow Up'},
    {'value': 'GENERAL', 'label': 'General'},
  ];

  // Tag dialog state
  final RxList<String> tempSelectedTags = <String>[].obs;
  final RxString selectedTagDropdown = ''.obs;
  final RxString currentTagLeadId = ''.obs;

  // Note dialog state
  final TextEditingController noteController = TextEditingController();
  final RxInt noteLength = 0.obs;
  final RxString currentNoteLeadId = ''.obs;

  // ── Filtered list ─────────────────────────────────────────────────────────

  RxList<Map<String, dynamic>> get filteredLeads {
    if (selectedFilter.value == 'All Scans') return allLeads;
    final apiTag = _filterToApiTag(selectedFilter.value);
    if (apiTag.isEmpty) return allLeads;
    return allLeads
        .where((lead) => (lead['tags'] as List<String>).contains(apiTag))
        .toList()
        .obs;
  }

  int get totalLeads => allLeads.length;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _qrService = QrService(
      apiService: Get.find<ApiService>(),
      connectivityService: Get.find<ConnectivityService>(),
    );
    noteController.addListener(() {
      noteLength.value = noteController.text.length;
    });

    final eventId = SessionController.to.eventId;
    if (eventId.isNotEmpty) {
      loadLeads();
    } else {
      ever(SessionController.to.eventIdRx, (String id) {
        if (id.isNotEmpty) loadLeads();
      });
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }

  // ── Load leads ────────────────────────────────────────────────────────────

  Future<void> loadLeads() async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final rawLeads = await _qrService.getExhibitorLeads(eventId);
      allLeads.value = rawLeads.map(_mapLead).toList();
    } catch (e) {
      errorMessage.value = e.toString()
          .replaceAll('Exception: ', '')
          .replaceAll('Exception:', '')
          .trim();
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _mapLead(Map<String, dynamic> raw) {
    final designation = raw['designation'] as String? ?? '';
    final company = raw['company'] as String? ?? '';
    final role = [designation, company].where((s) => s.isNotEmpty).join(' @ ');
    final tags = (raw['tags'] as List?)?.map((t) => t.toString()).toList() ?? <String>[];
    return {
      'id': raw['leadId'] as String? ?? '',
      'name': raw['name'] as String? ?? 'Unknown',
      'role': role,
      'time': _formatTime(raw['createdAt'] as String?),
      'image': raw['avatar'] as String? ?? '',
      'tags': tags,
      'note': raw['note'] as String? ?? '',
      'email': raw['email'] as String? ?? '',
    };
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) {
        final h = dt.hour;
        final m = dt.minute.toString().padLeft(2, '0');
        final period = h >= 12 ? 'PM' : 'AM';
        final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        return '$hour:$m $period';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else {
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return '${months[dt.month - 1]} ${dt.day}';
      }
    } catch (_) {
      return '';
    }
  }

  // ── QR scan → add lead ───────────────────────────────────────────────────

  Future<void> onQrScanned(String qrToken) async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty || qrToken.isEmpty) return;
    try {
      await _qrService.scanExhibitorLead(eventId, qrToken);
      await loadLeads(); // refresh list to show new lead
    } catch (e) {
      // silently ignore — user will see unchanged list
    }
  }

  // ── Filter ────────────────────────────────────────────────────────────────

  void setFilter(String filter) => selectedFilter.value = filter;

  String _filterToApiTag(String filter) {
    switch (filter) {
      case 'Hot Lead': return 'HOT';
      case 'Follow Up': return 'FOLLOW_UP';
      case 'General': return 'GENERAL';
      default: return '';
    }
  }

  // ── Tag dialog ────────────────────────────────────────────────────────────

  void openTagDialog(BuildContext context, String leadId) {
    currentTagLeadId.value = leadId;
    final lead = allLeads.firstWhere(
      (l) => l['id'] == leadId,
      orElse: () => {'tags': <String>[]},
    );
    tempSelectedTags.value = List<String>.from(lead['tags'] as List? ?? []);
    selectedTagDropdown.value = '';
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => LeadTagDialog(controller: this),
    );
  }

  void removeTag(String tag) => tempSelectedTags.remove(tag);

  void addTagFromDropdown() {
    final tag = selectedTagDropdown.value;
    if (tag.isEmpty) return;
    if (tempSelectedTags.length >= 2) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Only up to 2 tags can be added.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (!tempSelectedTags.contains(tag)) {
      tempSelectedTags.add(tag);
    }
    selectedTagDropdown.value = '';
  }

  Future<void> saveTags(BuildContext context) async {
    final leadId = currentTagLeadId.value;
    final tags = List<String>.from(tempSelectedTags);
    Navigator.of(context).pop();
    // Update local list immediately so UI reflects change
    final index = allLeads.indexWhere((l) => l['id'] == leadId);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(allLeads[index]);
      updated['tags'] = tags;
      allLeads[index] = updated;
      allLeads.refresh();
    }
    try {
      await _qrService.tagLead(leadId, tags);
    } catch (e) {
      // silently ignore — local state already updated
    }
  }

  // ── Note dialog ───────────────────────────────────────────────────────────

  void openNoteDialog(BuildContext context, String leadId) {
    currentNoteLeadId.value = leadId;
    final lead = allLeads.firstWhere(
      (l) => l['id'] == leadId,
      orElse: () => {'note': ''},
    );
    noteController.text = lead['note'] as String? ?? '';
    noteLength.value = noteController.text.length;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => LeadNoteDialog(controller: this),
    );
  }

  Future<void> saveNote(BuildContext context) async {
    final leadId = currentNoteLeadId.value;
    final note = noteController.text.trim();
    Navigator.of(context).pop();
    noteController.clear();
    // Update local list immediately so UI reflects change
    final index = allLeads.indexWhere((l) => l['id'] == leadId);
    if (index != -1) {
      final updated = Map<String, dynamic>.from(allLeads[index]);
      updated['note'] = note;
      allLeads[index] = updated;
      allLeads.refresh();
    }
    try {
      await _qrService.addLeadNote(leadId, note);
    } catch (e) {
      // silently ignore — local state already updated
    }
  }
}

// ── Tag label helper ──────────────────────────────────────────────────────────

String tagDisplayLabel(String apiTag) {
  switch (apiTag) {
    case 'HOT': return 'Hot Lead';
    case 'FOLLOW_UP': return 'Follow Up';
    case 'GENERAL': return 'General';
    default: return apiTag;
  }
}

// ── Tag Dialog ────────────────────────────────────────────────────────────────

class LeadTagDialog extends StatelessWidget {
  final LeadController controller;
  const LeadTagDialog({super.key, required this.controller});

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
                const Text('Add Tag',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Add Options:',
                style: TextStyle(fontSize: 13, color: Color(0xff7E7F7E))),
            const SizedBox(height: 10),

            // Selected tag chips
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
                border: Border.all(color: const Color(0xffD2D2D2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('select tag',
                      style: TextStyle(fontSize: 13, color: Color(0xff7E7F7E))),
                  value: controller.selectedTagDropdown.value.isEmpty
                      ? null
                      : controller.selectedTagDropdown.value,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: LeadController.availableTagOptions
                      .where((opt) => !controller.tempSelectedTags.contains(opt['value']))
                      .map((opt) => DropdownMenuItem(
                    value: opt['value'],
                    child: Text(opt['label']!,
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

            ElevatedButton(
              onPressed: () => controller.saveTags(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff32A69A),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagChip(String apiTag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD2D2D2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tagDisplayLabel(apiTag),
              style: const TextStyle(fontSize: 12, color: Color(0xff424242))),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => controller.removeTag(apiTag),
            child: const Icon(Icons.close, size: 14, color: Color(0xff7E7F7E)),
          ),
        ],
      ),
    );
  }
}

// ── Note Dialog ───────────────────────────────────────────────────────────────

class LeadNoteDialog extends StatelessWidget {
  final LeadController controller;
  const LeadNoteDialog({super.key, required this.controller});

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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
                style: TextStyle(fontSize: 11, color: Color(0xff7E7F7E)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.saveNote(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff32A69A),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
