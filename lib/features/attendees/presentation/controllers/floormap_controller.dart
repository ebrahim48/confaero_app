import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class FloorMapController extends GetxController {
  final locations = [
    'Conference Hall',
    'CATL booth',
    'Panasonic booth',
    'Samsung SDI booth',
  ];

  void openMap() {

  }

  void navigateToLocation(BuildContext context, int index) {

    context.pushNamed(AppRoutes.floorMapDetailsScreen);

  }

  RxDouble scale = 1.0.obs;
  RxBool showAllArea = false.obs;

  void zoomIn() {
    if (scale.value < 2.0) {
      scale.value += 0.1;
    }
  }

  void zoomOut() {
    if (scale.value > 0.5) {
      scale.value -= 0.1;
    }
  }

  void recenter() {
    scale.value = 1.0;
    showAllArea.value = false;
  }

  void toggleShowAllArea() {
    showAllArea.value = !showAllArea.value;
    if (showAllArea.value) {
      scale.value = 0.7; // Adjust as needed to fit entire map
    } else {
      scale.value = 1.0;
    }
  }
}
