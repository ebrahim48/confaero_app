import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/exhibitor_leads_controller.dart';

/// Screen for exhibitors_sponsors_booth to manage scanned QR leads.
class ExhibitorLeadsScreen extends StatelessWidget {
  final String boothId;

  const ExhibitorLeadsScreen({super.key, required this.boothId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ExhibitorLeadsController(boothId: boothId),
      tag: boothId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Scanned Leads',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshLeads,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
          );
        }
        if (controller.leads.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.white24),
                SizedBox(height: 16),
                Text(
                  'No leads scanned yet',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Scan attendee QR codes to collect leads',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refreshLeads,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.leads.length,
            itemBuilder: (ctx, i) {
              final lead = controller.leads[i];
              final leadId =
                  lead['_id']?.toString() ?? lead['id']?.toString() ?? '';
              final name = controller.getLeadName(lead);
              final email = controller.getLeadEmail(lead);
              final note = controller.getLeadNote(lead);
              final tags = controller.getLeadTags(lead);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: const Color(0xFF1A1A2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.deepPurpleAccent.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent
                                .withOpacity(0.2),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                if (email.isNotEmpty)
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (note.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.note_alt_outlined,
                                size: 14,
                                color: Colors.white54,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  note,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children:
                              tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text(
                                        tag,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                      backgroundColor: Colors.deepPurpleAccent
                                          .withOpacity(0.3),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => controller.addNote(leadId),
                              icon: const Icon(Icons.note_add, size: 16),
                              label: Text(
                                note.isEmpty ? 'Add Note' : 'Edit Note',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.deepPurpleAccent,
                                side: const BorderSide(
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => controller.addTags(leadId),
                              icon: const Icon(Icons.label_outline, size: 16),
                              label: Text(
                                tags.isEmpty ? 'Add Tags' : 'Edit Tags',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.tealAccent,
                                side: const BorderSide(
                                  color: Colors.tealAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
