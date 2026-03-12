import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/organizer_resource_controller.dart';
import '../../../../resources/data/models/resource_model.dart';

/// Organizer screen for Q&A CRUD and Survey Analytics.
class OrganizerResourcesScreen extends StatelessWidget {
  final String eventId;

  const OrganizerResourcesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OrganizerResourceController(eventId: eventId),
      tag: eventId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Manage Resources',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          tabs: const [Tab(text: 'Q&A'), Tab(text: 'Survey Analytics')],
          labelColor: Colors.deepPurpleAccent,
          unselectedLabelColor: Colors.white54,
          indicatorColor: Colors.deepPurpleAccent,
          controller: TabController(length: 2, vsync: Scaffold.of(context)),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [Tab(text: 'Q&A'), Tab(text: 'Survey Analytics')],
              labelColor: Colors.deepPurpleAccent,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.deepPurpleAccent,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _QnATab(controller: controller),
                  _SurveyAnalyticsTab(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QnATab extends StatelessWidget {
  final OrganizerResourceController controller;

  const _QnATab({required this.controller});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Create form
        Container(
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
                'Add Q&A Item',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.questionController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Question'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.answerController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Answer'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: controller.createQnA,
                icon: const Icon(Icons.add),
                label: const Text('Add Q&A'),
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
        ),
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
            if (controller.qaList.isEmpty) {
              return const Center(
                child: Text(
                  'No Q&A items',
                  style: TextStyle(color: Colors.white54),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.qaList.length,
              itemBuilder: (ctx, i) {
                final item = controller.qaList[i];
                return _QnACard(
                  item: item,
                  onEdit: () => controller.updateQnA(item),
                  onDelete: () => controller.deleteQnA(item),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _QnACard extends StatelessWidget {
  final QnAModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QnACard({
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
          item.question,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.answer,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
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

class _SurveyAnalyticsTab extends StatelessWidget {
  final OrganizerResourceController controller;

  const _SurveyAnalyticsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
        );
      }
      final analytics = controller.surveyAnalytics;
      if (analytics.isEmpty) {
        return const Center(
          child: Text(
            'No survey data available',
            style: TextStyle(color: Colors.white54),
          ),
        );
      }
      return ListView(
        padding: const EdgeInsets.all(16),
        children:
            analytics.entries.map((e) {
              return Card(
                color: const Color(0xFF1A1A2E),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    e.key,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                  trailing: Text(
                    e.value.toString(),
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
      );
    });
  }
}
