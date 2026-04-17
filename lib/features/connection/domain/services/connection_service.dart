import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/connection_model.dart';
import '../../data/models/connection_request_model.dart';

class ConnectionService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final _logger = LoggerHelper('ConnectionService');

  ConnectionService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<Map<String, dynamic>> sendRequest(String eventId, {required String receiverId}) async {
    await _checkConnectivity();
    _logger.i('Sending connection request for event: $eventId to: $receiverId');

    final response = await _apiService.post(
      '${ApiConstants.sendConnectionRequest}/$eventId',
      data: {'receiverId': receiverId},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> acceptRequest(String requestId) async {
    await _checkConnectivity();
    _logger.i('Accepting connection request: $requestId');

    final response = await _apiService.patch(
      '${ApiConstants.acceptConnectionRequest}/$requestId/accept',
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<ConnectionRequestModel>> getPendingRequests() async {
    await _checkConnectivity();
    _logger.i('Fetching pending requests');

    final response = await _apiService.get(ApiConstants.getPendingRequests);

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        return (data['data'] as List)
            .map(
              (e) => ConnectionRequestModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
    }
    return [];
  }

  Future<List<ConnectionModel>> getMyConnections() async {
    await _checkConnectivity();
    _logger.i('Fetching my connections');

    final response = await _apiService.get(ApiConstants.getMyConnections);

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        // Handling nested 'connection' object if present
        return (data['data'] as List).map((e) {
          final item = e as Map<String, dynamic>;
          if (item.containsKey('connection')) {
            return ConnectionModel.fromJson(
              item['connection'] as Map<String, dynamic>,
            );
          }
          return ConnectionModel.fromJson(item);
        }).toList();
      }
    }
    return [];
  }

  Future<ConnectionModel?> getConnectionDetails(String id) async {
    await _checkConnectivity();
    _logger.i('Fetching connection details for id: $id');

    final response = await _apiService.get(
      '${ApiConstants.getConnectionDetails}/$id',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] != null) {
        return ConnectionModel.fromJson(data['data'] as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> bookmarkConnection(String id) async {
    await _checkConnectivity();
    _logger.i('Bookmarking connection id: $id');

    final response = await _apiService.patch(
      '${ApiConstants.bookmarkConnection}/$id/bookmark',
    );
    return response.data as Map<String, dynamic>;
  }
}
