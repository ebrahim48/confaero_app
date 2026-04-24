import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles booth APIs for both organizer and exhibitor roles.
class BoothService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('BoothService');

  BoothService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  // ======================== Organizer ========================

  /// GET /organizerBooth/events/:eventId/booths
  Future<Map<String, dynamic>> getOrganizerBooths(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching booths for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getOrganizerBooths}/$eventId/booths',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /organizerBooth/booths/:id
  Future<Map<String, dynamic>> getBoothDetails(String boothId) async {
    await _checkConnectivity();
    _logger.i('Fetching booth details: $boothId');
    final response = await _apiService.get(
      '${ApiConstants.getBoothDetails}/$boothId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /organizerBooth/booths/:id/number
  Future<Map<String, dynamic>> updateBoothNumber(String boothId, String number) async {
    await _checkConnectivity();
    _logger.i('Updating booth number: $boothId');
    final response = await _apiService.patch(
      '${ApiConstants.updateBoothNumber}/$boothId/number',
      data: {'boothNumber': number},
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /organizerBooth/booths/:id/accept
  Future<Map<String, dynamic>> acceptBooth(String boothId) async {
    await _checkConnectivity();
    _logger.i('Accepting booth: $boothId');
    final response = await _apiService.patch(
      '${ApiConstants.acceptBooth}/$boothId/accept',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /organizerBooth/booths/:id/cancel
  Future<Map<String, dynamic>> cancelBooth(String boothId) async {
    await _checkConnectivity();
    _logger.i('Cancelling booth: $boothId');
    final response = await _apiService.patch(
      '${ApiConstants.cancelBooth}/$boothId/cancel',
    );
    return response.data as Map<String, dynamic>;
  }

  // ======================== Exhibitor ========================

  /// GET /booth/me
  Future<Map<String, dynamic>> getMyBooth() async {
    await _checkConnectivity();
    _logger.i('Fetching my booth');
    final response = await _apiService.get(ApiConstants.getMyBooth);
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /booth/me/:eventId
  Future<Map<String, dynamic>> updateMyBooth(
    String eventId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Updating my booth for event: $eventId');
    final response = await _apiService.patch(
      '${ApiConstants.updateMyBooth}/$eventId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /booth/create
  Future<Map<String, dynamic>> createBooth(Map<String, dynamic> data) async {
    await _checkConnectivity();
    _logger.i('Creating booth');
    final response = await _apiService.post(
      ApiConstants.createBooth,
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /booth/staff/:eventId
  Future<Map<String, dynamic>> getBoothStaff(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching booth staff for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getBoothStaff}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /booth/staff/:eventId
  Future<Map<String, dynamic>> addBoothStaff(String eventId, String email) async {
    await _checkConnectivity();
    _logger.i('Adding booth staff for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.addBoothStaff}/$eventId',
      data: {'email': email},
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /booth/analytics/:eventId
  Future<Map<String, dynamic>> getAnalytics(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching booth analytics for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getAnalytics}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /exhibitor/performance/:eventId
  Future<Map<String, dynamic>> getPerformance(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching exhibitor performance for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getPerformance}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /booth/me/:eventId
  Future<Map<String, dynamic>> getMyBoothByEvent(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching my booth for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getMyBooth}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }
}
