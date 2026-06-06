import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/live_poll.dart';

/// Service for Event Live Session REST APIs.
///
/// Handles poll creation, voting, and other live session operations
/// that require REST API calls (socket is used for real-time updates).
class EventLiveService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final _logger = LoggerHelper('EventLiveService');

  EventLiveService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  /// GET /resource/event/poll/:eventId
  ///
  /// Fetches all polls for an event.
  Future<List<LivePoll>> getEventPolls(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching polls for event: $eventId');

    try {
      final response = await _apiService.get(
        '${ApiConstants.getEventPolls}/$eventId',
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => LivePoll.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // If response has nested data field
      if (data is Map && data['polls'] is List) {
        return (data['polls'] as List)
            .map((e) => LivePoll.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      _logger.e('Failed to fetch polls: $e');
      rethrow;
    }
  }

  /// POST /resource/poll/:eventId
  ///
  /// Creates a new poll (typically done via socket, but REST fallback available).
  Future<Map<String, dynamic>> createPoll({
    required String eventId,
    required String question,
    required List<String> options,
  }) async {
    await _checkConnectivity();
    _logger.i('Creating poll for event: $eventId');

    final payload = {
      'question': question,
      'options': options,
    };

    final response = await _apiService.post(
      '${ApiConstants.createPoll}/$eventId',
      data: payload,
    );

    return response.data as Map<String, dynamic>;
  }

  /// POST /resource/poll/:pollId/:optionId/submit
  ///
  /// Submits a vote for a poll.
  Future<Map<String, dynamic>> submitPollVote({
    required String pollId,
    required String optionId,
    required int optionIndex,
  }) async {
    await _checkConnectivity();
    _logger.i('Submitting vote for poll: $pollId, option: $optionId');

    final payload = {
      'selectedOptionIndex': optionIndex,
    };

    final response = await _apiService.post(
      '${ApiConstants.submitPollVote}/$pollId/$optionId/submit',
      data: payload,
    );

    return response.data as Map<String, dynamic>;
  }

  /// GET /resource/poll/:id/:eventId/votes
  ///
  /// Fetches vote counts for a poll.
  Future<Map<String, dynamic>> getPollVotes({
    required String pollId,
    required String eventId,
  }) async {
    await _checkConnectivity();
    _logger.i('Fetching votes for poll: $pollId');

    final response = await _apiService.get(
      '${ApiConstants.getPollVotes}/$pollId/$eventId/votes',
    );

    return response.data as Map<String, dynamic>;
  }
}
