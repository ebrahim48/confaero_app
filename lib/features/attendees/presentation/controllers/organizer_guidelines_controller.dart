import 'package:get/get.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class OrganizerGuidelinesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();
  final LoggerHelper _logger = LoggerHelper('OrganizerGuidelinesController');

  final isLoading = false.obs;
  final title = ''.obs;
  final content = ''.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadContent();
  }

  Future<void> loadContent() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (!await _connectivityService.checkConnectivity()) {
        errorMessage.value =
            'No internet connection. Please check your network.';
        return;
      }

      final response = await _apiService.get(
        '${ApiConstants.getAppContent}/ORGANIZER_GUIDELINE',
      );

      if (response.data is Map<String, dynamic>) {
        final resData = response.data as Map<String, dynamic>;
        if (resData['success'] == true && resData['data'] != null) {
          final data = resData['data'] as Map<String, dynamic>;
          title.value = data['title']?.toString() ?? 'Organizer Guidelines';
          content.value = data['content']?.toString() ?? '';
          _logger.i('Organizer guidelines loaded successfully');
        }
      }
    } catch (e) {
      _logger.e('Failed to load organizer guidelines', error: e);
      errorMessage.value = 'Failed to load content. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
