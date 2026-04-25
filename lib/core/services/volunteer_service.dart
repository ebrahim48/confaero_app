import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/logger_helper.dart';
import 'api_service.dart';
import 'connectivity_service.dart';

class VolunteerService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('VolunteerService');

  VolunteerService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// POST /volunteer/create
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    await _checkConnectivity();
    _logger.i('Creating volunteer task');
    final response = await _apiService.post(
      ApiConstants.createTask,
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /volunteer/my-tasks
  Future<Map<String, dynamic>> getMyTasks() async {
    await _checkConnectivity();
    _logger.i('Fetching my tasks');
    final response = await _apiService.get(ApiConstants.getMyTasks);
    return response.data as Map<String, dynamic>;
  }

  /// GET /volunteer/my-task/:id
  Future<Map<String, dynamic>> getTaskDetail(String taskId) async {
    await _checkConnectivity();
    _logger.i('Fetching task detail: $taskId');
    final response = await _apiService.get(
      '${ApiConstants.getTaskDetail}/$taskId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /volunteer/:eventId/volunteer/search
  Future<Map<String, dynamic>> searchVolunteer(String eventId) async {
    await _checkConnectivity();
    _logger.i('Searching volunteers for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.searchVolunteer}/$eventId/volunteer/search',
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /volunteer/today-progress
  Future<Map<String, dynamic>> getTodayProgress() async {
    await _checkConnectivity();
    _logger.i('Fetching today progress');
    final response = await _apiService.get(ApiConstants.getTodayProgress);
    return response.data as Map<String, dynamic>;
  }

  /// GET /volunteer/volunteers
  Future<Map<String, dynamic>> getDashboard() async {
    await _checkConnectivity();
    _logger.i('Fetching volunteer dashboard');
    final response = await _apiService.get(ApiConstants.getVolunteerDashboard);
    return response.data as Map<String, dynamic>;
  }

  /// GET /volunteer/:id (report detail)
  Future<Map<String, dynamic>> getReportDetail(String volunteerId) async {
    await _checkConnectivity();
    _logger.i('Fetching report detail: $volunteerId');
    final response = await _apiService.get(
      '${ApiConstants.getReportDetail}/$volunteerId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /volunteer/:id/complete
  Future<Map<String, dynamic>> completeTask(String taskId) async {
    await _checkConnectivity();
    _logger.i('Completing task: $taskId');
    final response = await _apiService.patch(
      '${ApiConstants.completeTask}/$taskId/complete',
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /report/report
  Future<Map<String, dynamic>> submitReport(Map<String, dynamic> data) async {
    await _checkConnectivity();
    _logger.i('Submitting report');
    final response = await _apiService.post(
      ApiConstants.submitReport,
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /qr/volunteer/:eventId
  Future<Map<String, dynamic>> getVolunteerAttendance(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching volunteer attendance history: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getVolunteerAttendance}/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }
}
