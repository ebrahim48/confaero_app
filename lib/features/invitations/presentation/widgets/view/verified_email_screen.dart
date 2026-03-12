import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/verified_email_controller.dart';

/// Screen for organizer to manage verified/invited email addresses.
class VerifiedEmailScreen extends StatelessWidget {
  final String eventId;

  const VerifiedEmailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      VerifiedEmailController(eventId: eventId),
      tag: eventId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Invite Emails',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildAddEmailForm(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
                );
              }
              if (controller.emails.isEmpty) {
                return const Center(
                  child: Text(
                    'No emails added yet',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadEmails,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.emails.length,
                  itemBuilder: (ctx, i) {
                    final email = controller.emails[i];
                    final id =
                        email['_id']?.toString() ??
                        email['id']?.toString() ??
                        '';
                    final address = email['email']?.toString() ?? 'Unknown';
                    final status = email['status']?.toString() ?? '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: const Color(0xFF1A1A2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.deepPurpleAccent.withOpacity(0.2),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurpleAccent.withOpacity(
                            0.2,
                          ),
                          child: const Icon(
                            Icons.email,
                            color: Colors.deepPurpleAccent,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          address,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        subtitle:
                            status.isNotEmpty
                                ? Text(
                                  status,
                                  style: TextStyle(
                                    color:
                                        status == 'VERIFIED'
                                            ? Colors.greenAccent
                                            : Colors.orangeAccent,
                                    fontSize: 12,
                                  ),
                                )
                                : null,
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => controller.deleteEmail(id, address),
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

  Widget _buildAddEmailForm(VerifiedEmailController controller) {
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
            'Add Invite Emails',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller.emailInputController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email(s) — comma separated',
              labelStyle: const TextStyle(color: Colors.white60),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.deepPurpleAccent),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => ElevatedButton.icon(
              onPressed:
                  controller.isSaving.value ? null : controller.addEmails,
              icon:
                  controller.isSaving.value
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.add),
              label: Text(
                controller.isSaving.value ? 'Adding...' : 'Add Emails',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
