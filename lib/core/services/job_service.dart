import '../../core/constants/api_constants.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';
import '../../core/services/connectivity_service.dart';

class JobService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  JobService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// Get all job openings
  Future<List<Map<String, dynamic>>> getJobs() async {
    await _checkConnectivity();
    final response = await _apiService.get(ApiConstants.getJobs);

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    }
    return [];
  }

  /// Get job details by ID
  Future<Map<String, dynamic>?> getJobDetails(String jobId) async {
    await _checkConnectivity();
    final response = await _apiService.get(
      '${ApiConstants.getJobDetails}/$jobId',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] != null) {
        return data['data'] as Map<String, dynamic>;
      }
    }
    return null;
  }

  // ======================== Organizer/Exhibitor ========================

  /// POST /job — create a new job
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> data) async {
    await _checkConnectivity();
    final response = await _apiService.post(ApiConstants.createJob, data: data);
    return response.data as Map<String, dynamic>;
  }

  /// GET /job/my — get my posted jobs
  Future<Map<String, dynamic>> getMyJobPosts() async {
    await _checkConnectivity();
    final response = await _apiService.get(ApiConstants.getMyJobPosts);
    return response.data as Map<String, dynamic>;
  }

  /// GET /job/review — get all jobs for review
  Future<Map<String, dynamic>> getJobReview() async {
    await _checkConnectivity();
    final response = await _apiService.get(ApiConstants.getJobReview);
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /job/:id/status — update job status
  Future<Map<String, dynamic>> updateJobStatus(
    String jobId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.updateJobStatus}/$jobId/status',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /job/:id — update job
  Future<Map<String, dynamic>> updateJob(
    String jobId,
    Map<String, dynamic> data,
  ) async {
    await _checkConnectivity();
    final response = await _apiService.patch(
      '${ApiConstants.updateJob}/$jobId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  /// DELETE /job/:id — delete job
  Future<void> deleteJob(String jobId) async {
    await _checkConnectivity();
    await _apiService.delete('${ApiConstants.deleteJob}/$jobId');
  }
}
