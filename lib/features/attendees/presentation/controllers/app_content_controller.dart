import 'package:get/get.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/helpers/logger_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';

class AppContentController extends GetxController {
  final String contentType;
  final String defaultTitle;

  AppContentController({required this.contentType, required this.defaultTitle});

  final ApiService _apiService = Get.find<ApiService>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();
  late final LoggerHelper _logger =
      LoggerHelper('AppContentController[$contentType]');

  final isLoading = false.obs;
  final title = ''.obs;
  final content = ''.obs;
  final imageUrl = ''.obs;
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
        '${ApiConstants.getAppContent}/$contentType',
      );

      if (response.data is Map<String, dynamic>) {
        final resData = response.data as Map<String, dynamic>;
        if (resData['success'] == true && resData['data'] != null) {
          final data = resData['data'] as Map<String, dynamic>;
          title.value = data['title']?.toString() ?? defaultTitle;
          content.value = data['content']?.toString() ?? '';
          imageUrl.value = data['imageUrl']?.toString() ?? '';
          _logger.i('$contentType loaded successfully');
        }
      }
    } catch (e) {
      _logger.e('Failed to load $contentType', error: e);
      errorMessage.value = 'Failed to load content. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
