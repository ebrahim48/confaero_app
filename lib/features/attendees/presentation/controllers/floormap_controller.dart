import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../data/floor_map_model.dart';
import '../../data/repository/floor_map_repository.dart';
import '../../domain/floor_map_service.dart';


class FloorMapController extends GetxController {
  late final FloorMapRepository _repository;

  final String eventId;
  FloorMapController({required this.eventId});

  // ── Floor maps list ───────────────────────────────────────────────────────
  final floorMaps = <FloorMapModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // ── Selected map for details screen ──────────────────────────────────────
  final selectedMap = Rxn<FloorMapModel>();
  final selectedIndex = 0.obs;

  // ── Map viewer state ──────────────────────────────────────────────────────
  final scale = 1.0.obs;
  final showAllArea = false.obs;

  @override
  void onInit() {
    super.onInit();
    _repository = FloorMapRepository(
      service: FloorMapService(
        apiService: Get.find<ApiService>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
    );
    if (eventId.isNotEmpty) loadFloorMaps();
  }

  // ── API ───────────────────────────────────────────────────────────────────

  Future<void> loadFloorMaps() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      floorMaps.value = await _repository.getFloorMaps(eventId);
      
      // Show message if no floor maps available
      if (floorMaps.isEmpty) {
      }
    } catch (e) {
      errorMessage.value =
          e.toString().replaceAll('Exception: ', '').replaceAll('Exception:', '');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void navigateToLocation(BuildContext context, int index) {
    if (index >= floorMaps.length) return;
    selectedMap.value = floorMaps[index];
    selectedIndex.value = index;
    context.pushNamed(AppRoutes.floorMapDetailsScreen);
  }

  void openMap(BuildContext context) {
    if (floorMaps.isEmpty) return;
    selectedMap.value = floorMaps[0];
    selectedIndex.value = 0;
    context.pushNamed(AppRoutes.floorMapDetailsScreen);
  }

  // ── Map viewer ────────────────────────────────────────────────────────────
  final transformationController = TransformationController();

  void zoomIn() {
    final newScale = (scale.value + 0.3).clamp(0.5, 3.0);
    scale.value = newScale;
    // Update the transformation matrix
    final matrix = transformationController.value.clone();
    matrix.setEntry(0, 0, newScale); // Scale X
    matrix.setEntry(1, 1, newScale); // Scale Y
    transformationController.value = matrix;
  }

  void zoomOut() {
    final newScale = (scale.value - 0.3).clamp(0.5, 3.0);
    scale.value = newScale;
    // Update the transformation matrix
    final matrix = transformationController.value.clone();
    matrix.setEntry(0, 0, newScale); // Scale X
    matrix.setEntry(1, 1, newScale); // Scale Y
    transformationController.value = matrix;
  }

  void recenter() {
    scale.value = 1.0;
    showAllArea.value = false;
    transformationController.value = Matrix4.identity();
  }

  void toggleShowAllArea() {
    showAllArea.value = !showAllArea.value;
    scale.value = showAllArea.value ? 0.7 : 1.0;
    final matrix = transformationController.value.clone();
    matrix.setEntry(0, 0, scale.value);
    matrix.setEntry(1, 1, scale.value);
    transformationController.value = matrix;
  }

  @override
  void onClose() {
    transformationController.dispose();
    super.onClose();
  }
}