import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../../../../core/services/poster_service.dart';

class EventPosterDetailsController extends GetxController {
  final PosterService _posterService = Get.find<PosterService>();

  // Poster ID — read from Get.arguments or route params
  late final String posterId;

  // Event Details — loaded from API
  final RxString eventTitle = ''.obs;
  final RxString eventDate = ''.obs;
  final RxString eventCategory = ''.obs;
  final RxString eventBanner = 'assets/images/bannerdetails.png'.obs;

  // Abstract
  final RxString abstractText = ''.obs;
  final RxBool isAbstractExpanded = false.obs;

  // Presenters
  final RxList<PresenterModel> presenters = <PresenterModel>[].obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    posterId = Get.arguments?['posterId'] as String? ?? '';
    if (posterId.isNotEmpty) {
      loadEventDetails();
    }
  }

  /// Load poster details from API
  Future<void> loadEventDetails() async {
    try {
      isLoading.value = true;
      final data = await _posterService.getSinglePoster(posterId);

      final success = data['success'] as bool? ?? false;
      if (success && data['data'] != null) {
        final poster = data['data'] as Map<String, dynamic>;
        eventTitle.value = poster['title'] as String? ?? '';
        eventDate.value = poster['createdAt'] as String? ?? '';
        eventCategory.value = poster['category'] as String? ?? 'Research';
        abstractText.value = poster['abstract'] as String? ?? '';

        if (poster['bannerUrl'] != null) {
          eventBanner.value = poster['bannerUrl'] as String;
        }

        // Parse presenters if available
        if (poster['presenters'] is List) {
          presenters.value =
              (poster['presenters'] as List)
                  .map(
                    (p) => PresenterModel.fromJson(p as Map<String, dynamic>),
                  )
                  .toList();
        } else if (poster['author'] != null) {
          final author = poster['author'] as Map<String, dynamic>;
          presenters.value = [
            PresenterModel(
              id: author['_id'] as String? ?? '',
              name: author['name'] as String? ?? '',
              role: 'Author',
              company: author['company'] as String? ?? '',
              image: author['avatar'] as String? ?? 'assets/images/profile.png',
            ),
          ];
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load poster details');
    } finally {
      isLoading.value = false;
    }
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

  factory PresenterModel.fromJson(Map<String, dynamic> json) {
    return PresenterModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'Presenter',
      company: json['company'] as String? ?? '',
      image: json['avatar'] as String? ?? 'assets/images/profile.png',
    );
  }
}
