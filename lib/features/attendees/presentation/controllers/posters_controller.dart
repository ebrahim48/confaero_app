import 'package:confaero_app/core/config/approutes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/poster_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class PostersController extends GetxController {
  final PosterService _posterService = Get.find<PosterService>();

  // Search controller
  final searchController = TextEditingController();

  // Poster list
  final RxList<PosterModel> posters = <PosterModel>[].obs;
  final RxList<PosterModel> filteredPosters = <PosterModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosters();

    // Listen to search
    searchController.addListener(() {
      filterPosters(searchController.text);
    });
  }

  /// Load accepted posters from API
  Future<void> loadPosters() async {
    try {
      isLoading.value = true;
      final response = await _posterService.getAcceptedPosters();

      final success = response['success'] as bool? ?? false;
      if (success && response['data'] is List) {
        posters.value =
            (response['data'] as List)
                .map((e) => PosterModel.fromJson(e as Map<String, dynamic>))
                .toList();
      }
      filteredPosters.value = posters;
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load posters', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  void filterPosters(String query) {
    if (query.isEmpty) {
      filteredPosters.value = posters;
    } else {
      filteredPosters.value =
          posters
              .where(
                (poster) =>
                    poster.title.toLowerCase().contains(query.toLowerCase()) ||
                    poster.authorName.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
  }

  void downloadPoster(String posterId) {
    ToastMessageHelper.showToastMessage('Poster download started', title: 'Download');
  }

  void viewPoster(BuildContext context) {
    context.pushNamed(AppRoutes.eventPostersDetailsScreen);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

// Poster Model
class PosterModel {
  final String id;
  final String authorName;
  final String authorImage;
  final String title;
  final String description;
  final String uploadDate;
  final String posterImage;

  PosterModel({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.title,
    required this.description,
    required this.uploadDate,
    required this.posterImage,
  });

  factory PosterModel.fromJson(Map<String, dynamic> json) {
    return PosterModel(
      id: json['_id'] as String? ?? '',
      authorName:
          json['authorName'] as String? ??
          json['author']?['name'] as String? ??
          '',
      authorImage:
          json['authorImage'] as String? ?? 'assets/images/profile.png',
      title: json['title'] as String? ?? '',
      description:
          json['abstract'] as String? ?? json['description'] as String? ?? '',
      uploadDate: json['createdAt'] as String? ?? '',
      posterImage:
          json['bannerUrl'] as String? ?? 'assets/images/cardbanner.png',
    );
  }
}
