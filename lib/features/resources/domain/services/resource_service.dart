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
    try {
      final response = await _apiService.get(
        '${ApiConstants.getEventQnA}/$eventId',
      );
      if (response.data is Map<String, dynamic>) {
        final resData = response.data as Map<String, dynamic>;
        if ((resData['success'] == true) && resData['data'] is List) {
          final dataList = resData['data'] as List;
          _logger.i('Q&A count: ${dataList.length}');
          return dataList.map((e) => QnAModel.fromJson(e)).toList();
        }
      }
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        _logger.i('No Q&A found for event: $eventId');
        return [];
      }
      _logger.e('Error fetching Q&A: $e');
      rethrow;
    } catch (e) {
      _logger.e('Error fetching Q&A: $e');
      rethrow;
    }
    return [];
  }

  Future<List<PollModel>> getEventPolls(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching Polls for event: $eventId');
    try {
      final response = await _apiService.get(
        '${ApiConstants.getEventPolls}/$eventId',
      );
      if (response.data is Map<String, dynamic>) {
        final resData = response.data as Map<String, dynamic>;
        if ((resData['success'] == true) && resData['data'] is List) {
          final dataList = resData['data'] as List;
          _logger.i('Polls count: ${dataList.length}');
          return dataList.map((e) => PollModel.fromJson(e)).toList();
        }
      }
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        _logger.i('No polls found for event: $eventId');
        return [];
      }
      _logger.e('Error fetching Polls: $e');
      rethrow;
    } catch (e) {
      _logger.e('Error fetching Polls: $e');
      rethrow;
    }
    return [];
  }

  Future<void> submitPollVote({
    required String pollId,
    required String optionId,
    required int selectedOptionIndex,
  }) async {
    await _checkConnectivity();
    _logger.i('Submitting vote for poll: $pollId, option: $optionId, index: $selectedOptionIndex');
    try {
      await _apiService.post(
        '${ApiConstants.submitPollVote}/$pollId/$optionId/submit',
        data: {'selectedOptionIndex': selectedOptionIndex},
      );
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        _logger.w('Poll vote endpoint not available for poll: $pollId');
        return;
      }
      rethrow;
    }
  }

  Future<SurveyModel?> getEventSurvey(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching survey for event: $eventId');
    try {
      final response = await _apiService.get(
        '${ApiConstants.getEventSurvey}/$eventId',
      );
      if (response.data is Map<String, dynamic>) {
        final resData = response.data as Map<String, dynamic>;
        if (resData['success'] == true) {
          final data = resData['data'];
          if (data is Map<String, dynamic>) {
            return SurveyModel.fromJson(data);
          }
          if (data is List && data.isNotEmpty) {
            return SurveyModel.fromJson(data.first as Map<String, dynamic>);
          }
        }
      }
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        _logger.i('No survey found for event: $eventId');
        return null;
      }
      _logger.e('Error fetching survey: $e');
    } catch (e) {
      _logger.e('Error fetching survey: $e');
    }
    return null;
  }

  // --- Attendee Q&A ---

  Future<void> submitQuestion(String eventId, String question) async {
    await _checkConnectivity();
    _logger.i('Submitting question for event: $eventId');
    await _apiService.post(
      '${ApiConstants.createQnA}/$eventId',
      data: {'question': question},
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
    String surveyId,
    Map<String, dynamic> surveyData,
  ) async {
    await _checkConnectivity();
    _logger.i('Submitting survey: $surveyId');
    try {
      final response = await _apiService.post(
        '${ApiConstants.submitSurvey}/$surveyId/submit',
        data: surveyData,
      );
      return response.data as Map<String, dynamic>;
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        _logger.w('Survey not found: $surveyId');
        return {'success': false, 'message': 'Survey not available for this event'};
      }
      rethrow;
    }
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
