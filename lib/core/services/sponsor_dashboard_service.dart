import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles sponsor dashboard and organizer sponsor management APIs.
class SponsorDashboardService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('SponsorDashboardService');

  SponsorDashboardService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// POST /sponsor/create
  Future<Map<String, dynamic>> createSponsor(Map<String, dynamic> data) async {
    await _checkConnectivity();
    _logger.i('Creating sponsor');
    final response = await _apiService.post(
      ApiConstants.createSponsor,
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /sponsor/update/:id
  Future<Map<String, dynamic>> updateSponsor(
    String sponsorId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Updating sponsor: $sponsorId');
    final response = await _apiService.patch(
      '${ApiConstants.updateSponsor}/$sponsorId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /sponsor/get-my-sponsor/:eventId
  Future<Map<String, dynamic>> getMySponsor(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching my sponsor for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getMySponsor}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /sponsor/dashboard/:eventId
  Future<Map<String, dynamic>> getSponsorDashboard(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching sponsor dashboard for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getSponsorDashboard}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /organizerSponsor/:id/approve
  Future<Map<String, dynamic>> approveSponsor(String sponsorId) async {
    await _checkConnectivity();
    _logger.i('Approving sponsor: $sponsorId');
    final response = await _apiService.patch(
      '${ApiConstants.approveSponsor}/$sponsorId/approve',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /organizerSponsor/:id/reject
  Future<Map<String, dynamic>> rejectSponsor(String sponsorId) async {
    await _checkConnectivity();
    _logger.i('Rejecting sponsor: $sponsorId');
    final response = await _apiService.patch(
      '${ApiConstants.rejectSponsor}/$sponsorId/reject',
    );
    return response.data as Map<String, dynamic>;
  }
}
