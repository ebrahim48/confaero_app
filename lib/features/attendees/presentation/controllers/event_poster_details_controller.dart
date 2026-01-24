import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';

class EventPosterDetailsController extends GetxController {
  // Event Details
  final RxString eventTitle = 'Engineering of the FRB domai...'.obs;
  final RxString eventDate = '12 Feb, 2:00-2:30 PM'.obs;
  final RxString eventCategory = 'Research'.obs;
  final RxString eventBanner = 'assets/images/bannerdetails.png'.obs;

  // Abstract
  final RxString abstractText = 'For 18 years, the Fastmarkets Lithium Supply and Battery Raw Materials Conference...'.obs;
  final RxBool isAbstractExpanded = false.obs;

  // Presenters
  final RxList<PresenterModel> presenters = <PresenterModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEventDetails();
  }

  void loadEventDetails() {
    // Load presenters
    presenters.value = [
      PresenterModel(
        id: '1',
        name: 'Devid Smith',
        role: 'Presenters',
        company: 'Sample Inc, Speaker',
        image: 'assets/images/profile.png',
      ),
      PresenterModel(
        id: '2',
        name: 'Devid Smith',
        role: 'Presenters',
        company: 'Sample Inc, Speaker',
        image: 'assets/images/profile.png',
      ),
    ];
  }

  void toggleAbstract() {
    isAbstractExpanded.value = !isAbstractExpanded.value;
  }

  void viewPDF(BuildContext context) {
    context.pushNamed(AppRoutes.pdfScreen);
  }

  void viewImage(BuildContext context) {
    context.pushNamed(AppRoutes.imagePdfScreen);
  }

  void watchVideo() {
    Get.snackbar('Video', 'Opening video player');
  }

  void viewPresenterDetails(String presenterId) {
    Get.snackbar('Presenter', 'Viewing presenter: $presenterId');
  }
}

// Presenter Model
class PresenterModel {
  final String id;
  final String name;
  final String role;
  final String company;
  final String image;

  PresenterModel({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.image,
  });
}