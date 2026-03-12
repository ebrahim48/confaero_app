import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/organizer_attendee_controller.dart';

/// Screen for organizers to manage all event registrations/attendees.
class OrganizerAttendeeScreen extends StatelessWidget {
  final String eventId;

  const OrganizerAttendeeScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OrganizerAttendeeController(eventId: eventId),
      tag: eventId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Attendee Management',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller.searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: controller.searchRegistrations,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Stats header
          Obx(() {
            final total = controller.registrations.length;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$total Registrations',
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
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
              if (controller.filteredRegistrations.isEmpty) {
                return const Center(
                  child: Text(
                    'No registrations found',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadRegistrations,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.filteredRegistrations.length,
                  itemBuilder: (ctx, i) {
                    final reg = controller.filteredRegistrations[i];
                    final id = controller.getAttendeeId(reg);
                    final name = controller.getAttendeeName(reg);
                    final email = controller.getAttendeeEmail(reg);
                    final status = controller.getAttendeeStatus(reg);

                    Color statusColor;
                    switch (status) {
                      case 'VERIFIED':
                        statusColor = Colors.greenAccent;
                        break;
                      case 'PENDING':
                        statusColor = Colors.orangeAccent;
                        break;
                      case 'REJECTED':
                        statusColor = Colors.redAccent;
                        break;
                      default:
                        statusColor = Colors.white38;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: const Color(0xFF1A1A2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.deepPurpleAccent.withOpacity(0.2),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurpleAccent.withOpacity(
                            0.2,
                          ),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (email.isNotEmpty)
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            const SizedBox(height: 2),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white54,
                          ),
                          color: const Color(0xFF1A1A2E),
                          onSelected: (value) {
                            if (value == 'view') {
                              controller.viewAttendee(id);
                            } else if (value == 'remove') {
                              controller.removeAttendee(id, name);
                            }
                          },
                          itemBuilder:
                              (_) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'View Details',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'remove',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_remove,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Remove',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ),
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
}
