import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

/// Handles poster assignment APIs for organizers.
class PosterAssignService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('PosterAssignService');

  PosterAssignService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// POST /poster-assign/create/:eventId
  Future<Map<String, dynamic>> assignPoster(
    String eventId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Assigning poster for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.assignPoster}/$eventId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /poster-assign/send-reminder/:id
  Future<Map<String, dynamic>> sendReminder(String assignmentId) async {
    await _checkConnectivity();
    _logger.i('Sending reminder: $assignmentId');
    final response = await _apiService.post(
      '${ApiConstants.sendPosterReminder}/$assignmentId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster-assign/speakers/search/:eventId
  Future<Map<String, dynamic>> searchReviewer(String eventId) async {
    await _checkConnectivity();
    _logger.i('Searching reviewers for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.searchReviewer}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster-assign/unassigned/search/:eventId
  Future<Map<String, dynamic>> searchUnassigned(String eventId) async {
    await _checkConnectivity();
    _logger.i('Searching unassigned posters for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.searchUnassigned}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /poster-assign/reassign/:eventId
  Future<Map<String, dynamic>> reassignPoster(
    String eventId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Reassigning poster for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.reassignPoster}/$eventId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster-assign/unassigned/:eventId
  Future<Map<String, dynamic>> getUnassignedPosters(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching unassigned posters for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getUnassignedPosters}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster-assign/assigned/:eventId
  Future<Map<String, dynamic>> getAssignedPosters(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching assigned posters for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getAssignedPosters}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /poster-assign/review/:eventId
  Future<Map<String, dynamic>> submitReview(
    String eventId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    _logger.i('Submitting review for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.submitPosterReview}/$eventId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /poster-assign/reported/:eventId
  Future<Map<String, dynamic>> getReportedPosters(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching reported posters for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getReportedPosters}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }
}
