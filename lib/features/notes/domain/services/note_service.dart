import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/note_model.dart';

class NoteService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final CustomLogger _logger = CustomLogger('NoteService');

  NoteService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<Map<String, dynamic>> createNote({
    required String eventId,
    required String content,
  }) async {
    await _checkConnectivity();
    _logger.i('Creating note for event: $eventId');
    final response = await _apiService.post(
      ApiConstants.createNote,
      data: {'eventId': eventId, 'content': content},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateNote({
    required String noteId,
    required String content,
  }) async {
    await _checkConnectivity();
    _logger.i('Updating note: $noteId');
    final response = await _apiService.post(
      ApiConstants.updateNotes,
      data: {'noteId': noteId, 'content': content},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<NoteModel>> getNotes() async {
    await _checkConnectivity();
    _logger.i('Fetching all user notes');

    final response = await _apiService.get(ApiConstants.getNotes);

    if (response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      if ((resData['success'] == true) && resData['data'] is List) {
        return (resData['data'] as List)
            .map((e) => NoteModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }
}
