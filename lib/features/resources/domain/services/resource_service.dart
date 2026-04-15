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

      _logger.i('Q&A Response: ${response.data}');
      
      if (response.data is Map<String, dynamic>) {
        final resData = response.data as Map<String, dynamic>;
        _logger.i('Q&A success: ${resData['success']}, data type: ${resData['data'].runtimeType}');
        
        if ((resData['success'] == true) && resData['data'] is List) {
          final dataList = resData['data'] as List;
          _logger.i('Q&A count: ${dataList.length}');
          return dataList.map((e) => QnAModel.fromJson(e)).toList();
        } else if (resData['success'] != true) {
          _logger.e('Q&A API returned success=false. Response: $resData');
        }
      } else {
        _logger.w('Q&A response is not a Map. Type: ${response.data.runtimeType}');
      }
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

      _logger.i('Polls Response: ${response.data}');
      
      if (response.data is Map<String, dynamic>) {
        final resData = response.data as Map<String, dynamic>;
        _logger.i('Polls success: ${resData['success']}, data type: ${resData['data'].runtimeType}');
        
        if ((resData['success'] == true) && resData['data'] is List) {
          final dataList = resData['data'] as List;
          _logger.i('Polls count: ${dataList.length}');
          return dataList.map((e) => PollModel.fromJson(e)).toList();
        } else if (resData['success'] != true) {
          _logger.e('Polls API returned success=false. Response: $resData');
        }
      } else {
        _logger.w('Polls response is not a Map. Type: ${response.data.runtimeType}');
      }
    } catch (e) {
      _logger.e('Error fetching Polls: $e');
      rethrow;
    }
    return [];
  }

  Future<void> submitPollVote({
    required String pollId,
    required String eventId,
    required int selectedOptionIndex,
  }) async {
    await _checkConnectivity();
    _logger.i('Submitting vote for poll: $pollId in event: $eventId, index: $selectedOptionIndex');

    await _apiService.post(
      '${ApiConstants.submitPollVote}/$pollId/$eventId/submit',
      data: {'selectedOptionIndex': selectedOptionIndex},
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
