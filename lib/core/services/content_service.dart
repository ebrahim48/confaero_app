import '../../core/constants/api_constants.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/services/connectivity_service.dart';

class ContentService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  ContentService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  // REMOVED: endpoint no longer available in backend API
  // /// Get Terms & Conditions content
  // Future<String> getTermsAndConditions() async {
  //   await _checkConnectivity();
  //   final response = await _apiService.get(ApiConstants.getTermsCondition);
  //
  //   if (response.data is Map<String, dynamic>) {
  //     final data = response.data as Map<String, dynamic>;
  //     if ((data['success'] as bool? ?? false) && data['data'] != null) {
  //       return data['data']['content']?.toString() ?? '';
  //     }
  //   }
  //   return '';
  // }

  // REMOVED: endpoint no longer available in backend API
  // /// POST /appContent/create — create app content (admin)
  // Future<Map<String, dynamic>> createAppContent(
  //   Map<String, dynamic> data,
  // ) async {
  //   await _checkConnectivity();
  //   final response = await _apiService.post(
  //     ApiConstants.createAppContent,
  //     data: data,
  //   );
  //   return response.data as Map<String, dynamic>;
  // }
}
