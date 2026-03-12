import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/resource_model.dart';

class ResourceService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('ResourceService');

  ResourceService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<List<QnAModel>> getEventQnA(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching Q&A for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getEventQnA}/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if ((resData['success'] == true) && resData['data'] is List) {
        return (resData['data'] as List)
            .map((e) => QnAModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  Future<List<PollModel>> getEventPolls(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching Polls for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getEventPolls}/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if ((resData['success'] == true) && resData['data'] is List) {
        return (resData['data'] as List)
            .map((e) => PollModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  Future<void> submitPollVote({
    required String pollId,
    required String eventId,
    required String optionId,
  }) async {
    await _checkConnectivity();
    _logger.i('Submitting vote for poll: $pollId in event: $eventId');

    await _apiService.post(
      '${ApiConstants.submitPollVote}/$pollId/$eventId/submit',
      data: {'optionId': optionId},
    );
  }

  // --- Organizer Q&A CRUD ---

  Future<Map<String, dynamic>> createQnA(
    String eventId, {
    required String question,
    required String answer,
  }) async {
    await _checkConnectivity();
    _logger.i('Creating Q&A for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.createQnA}/$eventId',
      data: {'question': question, 'answer': answer},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateQnA(
    String id,
    String eventId, {
    required String question,
    required String answer,
  }) async {
    await _checkConnectivity();
    _logger.i('Updating Q&A $id for event: $eventId');
    final response = await _apiService.patch(
      '${ApiConstants.updateQnA}/$id/$eventId',
      data: {'question': question, 'answer': answer},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteQnA(String id, String eventId) async {
    await _checkConnectivity();
    _logger.i('Deleting Q&A $id from event: $eventId');
    await _apiService.delete('${ApiConstants.deleteQnA}/$id/$eventId');
  }

  // --- Survey ---

  Future<Map<String, dynamic>> submitSurvey(
    String eventId,
    Map<String, dynamic> surveyData,
  ) async {
    await _checkConnectivity();
    _logger.i('Submitting survey for event: $eventId');
    final response = await _apiService.post(
      '${ApiConstants.submitSurvey}/$eventId/submit',
      data: surveyData,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getSurveyAnalytics(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching survey analytics for event: $eventId');
    final response = await _apiService.get(
      '${ApiConstants.getSurveyAnalytics}/$eventId/analytics',
    );
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {};
  }
}
