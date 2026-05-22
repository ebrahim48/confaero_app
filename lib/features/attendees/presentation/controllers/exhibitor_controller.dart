import 'package:get/get.dart';
import '../../../../core/controllers/session_controller.dart';
import '../../../../core/helpers/toast_message_helper.dart';
import '../../../../core/services/booth_service.dart';
import '../../../exhibitors_sponsors_booth/data/models/booth_model.dart';

class ExhibitorController extends GetxController {
  final BoothService _service = Get.find<BoothService>();

  final RxList<BoothModel> booths = <BoothModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<BoothModel?> selectedBooth = Rx<BoothModel?>(null);
  final RxBool isDetailLoading = false.obs;

  String get currentEventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    fetchBooths();
  }

  Future<void> fetchBooths() async {
    isLoading.value = true;
    try {
      final res = await _service.getOrganizerBooths(currentEventId);
      if (res['success'] == true && res['data'] is List) {
        final list = (res['data'] as List)
            .map((e) => BoothModel.fromJson(e as Map<String, dynamic>))
            .toList();
        booths.assignAll(list);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBoothDetails(String boothId) async {
    isDetailLoading.value = true;
    try {
      final res = await _service.getBoothDetails(boothId);
      if (res['success'] == true && res['data'] != null) {
        selectedBooth.value =
            BoothModel.fromJson(res['data'] as Map<String, dynamic>);
      }
    } catch (e) {
    } finally {
      isDetailLoading.value = false;
    }
  }
}
