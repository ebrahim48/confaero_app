import '../../../core/helpers/logger_helper.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../data/floor_map_model.dart';

/// NOTE: getFloorMaps endpoint has been removed from backend API.
/// This service returns an empty list until a replacement endpoint is available.
class FloorMapService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final _logger = LoggerHelper('FloorMapService');

  FloorMapService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  })  : _apiService = apiService,
        _connectivityService = connectivityService;

  /// REMOVED: /organizer/events/{eventId}/floormaps endpoint no longer in backend
  Future<List<FloorMapModel>> getFloorMaps(String eventId) async {
    _logger.i('[FloorMapService] getFloorMaps endpoint removed from backend');
    return [];
  }
}