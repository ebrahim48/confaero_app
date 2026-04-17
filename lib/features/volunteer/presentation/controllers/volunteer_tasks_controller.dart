import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/api_service.dart';

/// Controller for Volunteer Tasks Screen
class VolunteerTasksController extends GetxController {
  final _logger = LoggerHelper('VolunteerTasksController');
  final ApiService _apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;
  final RxBool showHistory = false.obs;

  final RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
  final RxInt completedCount = 0.obs;
  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      final eventId = SessionController.to.eventId;
      if (eventId.isEmpty) {
        isLoading.value = false;
        return;
      }

      // Fetch volunteer tasks
      final response = await _apiService.get(
        '/volunteer/my-tasks',
        queryParameters: {'eventId': eventId},
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] is List) {
          final taskList = (data['data'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();

          tasks.value = taskList;
          totalCount.value = taskList.length;
          completedCount.value = taskList
              .where((t) =>
                  t['status']?.toString().toLowerCase() == 'completed')
              .length;
        }
      }
    } catch (e) {
      _logger.e('Failed to load tasks: $e');
      // Use sample data for demo
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadSampleData() {
    tasks.value = [
      {
        'id': '1',
        'name': 'Manage Gate -2',
        'time': '08:30 - 09:00',
        'location': 'Entrance Hall B',
        'status': 'in_progress',
        'image': '',
      },
      {
        'id': '2',
        'name': 'Manage Registration Desk',
        'time': '08:30 - 09:00',
        'location': 'Entrance Hall B',
        'status': 'pending',
        'image': '',
      },
      {
        'id': '3',
        'name': 'Manage Gate -2',
        'time': '08:30 - 09:00',
        'location': 'Entrance Hall B',
        'status': 'pending',
        'image': '',
      },
    ];
    totalCount.value = tasks.length;
    completedCount.value = 0;
  }

  Future<void> completeTask(String taskId) async {
    try {
      await _apiService.patch('/volunteer/$taskId/complete');
      loadTasks();
    } catch (e) {
      _logger.e('Failed to complete task: $e');
    }
  }
}
