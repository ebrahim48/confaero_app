import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/sponsor_model.dart';

class SponsorService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('SponsorService');

  SponsorService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<List<SponsorModel>> getAllSponsors(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching all sponsors for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getAllSponsors}/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if (resData['success'] == true && resData['data'] is Map) {
        final dataMap = resData['data'] as Map<String, dynamic>;
        if (dataMap['data'] is List) {
          return (dataMap['data'] as List)
              .map((e) => SponsorModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    }
    return [];
  }

  Future<SponsorModel?> getSponsorDetails(String sponsorId) async {
    await _checkConnectivity();
    _logger.i('Fetching details for sponsor: $sponsorId');
    final response = await _apiService.get(
      '${ApiConstants.getSponsorDetails}/$sponsorId',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if ((resData['success'] == true) && resData['data'] != null) {
        return SponsorModel.fromJson(resData['data']);
      }
    }
    return null;
  }

  Future<void> incrementSponsorView(String sponsorId) async {
    await _checkConnectivity();
    _logger.i('Incrementing view for sponsor: $sponsorId');
    await _apiService.patch('${ApiConstants.incrementSponsorView}/$sponsorId');
  }
}
