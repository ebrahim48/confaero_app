import 'package:get/get.dart';

/// Holds the selected bottom-navigation tab so any screen inside the shell can
/// switch tabs (keeping the bottom navbar visible) instead of pushing a
/// full-screen route on top of it.
class MainNavController extends GetxController {
  static MainNavController get to => Get.find();

  final currentIndex = 0.obs;

  void changeTab(int index) {
    if (index != currentIndex.value) {
      currentIndex.value = index;
    }
  }
}
