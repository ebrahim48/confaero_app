import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/announcement_crud_controller.dart';
import '../../../../announcements/data/models/announcement_model.dart';

/// Organizer screen for managing event announcements (create, edit, delete).
class OrganizerAnnouncementCrudScreen extends StatelessWidget {
  final String eventId;

  const OrganizerAnnouncementCrudScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AnnouncementCrudController(eventId: eventId),
      tag: eventId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Announcements',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(
            () =>
                controller.isSaving.value
                    ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Create form
          _buildCreateForm(controller),
          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
                );
              }
              if (controller.announcements.isEmpty) {
                return const Center(
                  child: Text(
                    'No announcements yet',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadAnnouncements,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.announcements.length,
                  itemBuilder: (ctx, i) {
                    final item = controller.announcements[i];
                    return _AnnouncementCard(
                      item: item,
                      onEdit: () => controller.updateAnnouncement(item),
                      onDelete: () => controller.deleteAnnouncement(item),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateForm(AnnouncementCrudController controller) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'New Announcement',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller.titleController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Title'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.contentController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Content'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: controller.createAnnouncement,
            icon: const Icon(Icons.add),
            label: const Text('Post Announcement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.deepPurpleAccent),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final AnnouncementModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnnouncementCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.deepPurpleAccent.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.description,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              item.createdAt,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.deepPurpleAccent,
                size: 20,
              ),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
