import 'package:get/get.dart';
import '../../../../core/services/volunteer_service.dart';
import '../../data/models/volunteer_models.dart';

class TaskController extends GetxController {
  final VolunteerService _service = Get.find<VolunteerService>();

  final selectedTab = 'Current Task'.obs;
  final isLoading = false.obs;
  final isCompleting = false.obs;

  final totalTasks = 0.obs;
  final completedTasks = 0.obs;
  final remainingTasks = 0.obs;
  final progressFraction = 0.0.obs;

  final currentTasks = <TaskModel>[].obs;
  final historyTasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([_loadTasks(), _loadTodayProgress()]);
  }

  Future<void> _loadTasks() async {
    try {
      isLoading.value = true;
      final result = await _service.getMyTasks();
      final list = (result['data'] as List? ?? [])
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
      const activeStatuses = {'PENDING', 'IN_PROGRESS', 'DUE'};
      currentTasks.value = list.where((t) => activeStatuses.contains(t.status)).toList();
      historyTasks.value =
          list.where((t) => !activeStatuses.contains(t.status)).toList();
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTodayProgress() async {
    try {
      final result = await _service.getTodayProgress();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final model = TodayProgressModel.fromJson(data);
      totalTasks.value = model.totalTasks;
      completedTasks.value = model.completedTasks;
      remainingTasks.value = model.remainingTasks;
      progressFraction.value = model.progressFraction;
    } catch (_) {}
  }

  void selectTab(String tab) => selectedTab.value = tab;

  Future<void> completeTask(String taskId) async {
    try {
      isCompleting.value = true;
      await _service.completeTask(taskId);
      await loadData();
    } catch (_) {
    } finally {
      isCompleting.value = false;
    }
  }
}
