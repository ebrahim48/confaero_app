import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/reviewer_service.dart';
import '../../data/reviewer_models.dart';

class ContentController extends GetxController {
  final ReviewerService _service = Get.find<ReviewerService>();

  final isLoading = false.obs;
  final dashboard = Rxn<ReviewerDashboardModel>();

  int get totalTasks => dashboard.value?.totalAssigned ?? 0;
  int get completedTasks => dashboard.value?.reviewed ?? 0;
  int get remainingTasks => dashboard.value?.remaining ?? 0;
  double get progressPercent => dashboard.value?.progressFraction ?? 0;
  int get totalAbstracts => dashboard.value?.totalAbstracts ?? 0;
  int get totalPosters => dashboard.value?.totalPosters ?? 0;
  List<LatestDocumentModel> get latestDocuments => dashboard.value?.latestDocuments ?? [];

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final eventId = SessionController.to.eventId;
    if (eventId.isEmpty) return;
    try {
      isLoading.value = true;
      final result = await _service.getDashboard(eventId);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      dashboard.value = ReviewerDashboardModel.fromJson(data);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
