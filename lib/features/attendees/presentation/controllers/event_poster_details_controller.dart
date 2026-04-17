import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/poster_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

class EventPosterDetailsController extends GetxController {
  final PosterService _posterService = Get.find<PosterService>();

  final String posterId;
  EventPosterDetailsController({required this.posterId});

  final RxString eventTitle = ''.obs;
  final RxString eventDate = ''.obs;
  final RxString eventCategory = ''.obs;
  final RxString eventBanner = ''.obs;
  final RxString abstractText = ''.obs;
  final RxBool isAbstractExpanded = false.obs;
  final RxString videoLink = ''.obs;

  final RxList<PresenterModel> presenters = <PresenterModel>[].obs;
  // Only attachments with reviewStatus == 'approved'
  final RxList<PosterAttachmentModel> approvedAttachments =
      <PosterAttachmentModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (posterId.isNotEmpty) loadEventDetails();
  }

  Future<void> loadEventDetails() async {
    try {
      isLoading.value = true;
      final data = await _posterService.getSinglePoster(posterId);

      final success = data['success'] as bool? ?? false;
      if (success && data['data'] != null) {
        final poster = data['data'] as Map<String, dynamic>;

        eventTitle.value = poster['title']?.toString() ?? '';
        eventDate.value = _formatDate(poster['dueDate']?.toString() ?? '');
        eventCategory.value = poster['status']?.toString() ?? '';
        abstractText.value = poster['abstract']?.toString() ?? '';
        eventBanner.value = poster['banner']?.toString() ?? '';
        videoLink.value = poster['videoLink']?.toString() ?? '';

        // Presenters
        if (poster['presenters'] is List) {
          presenters.value = (poster['presenters'] as List)
              .map((p) => PresenterModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else if (poster['author'] != null) {
          final author = poster['author'] as Map<String, dynamic>;
          presenters.value = [
            PresenterModel(
              id: author['_id']?.toString() ?? '',
              name: author['name']?.toString() ?? '',
              role: 'Author',
              avatar: author['avatar']?.toString() ?? '',
            ),
          ];
        }

        // Attachments — only approved
        if (poster['attachments'] is List) {
          approvedAttachments.value = (poster['attachments'] as List)
              .map((a) =>
                  PosterAttachmentModel.fromJson(a as Map<String, dynamic>))
              .where((a) => a.reviewStatus == 'approved')
              .toList();
        }
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load poster details', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return iso;
    }
  }

  void toggleAbstract() => isAbstractExpanded.value = !isAbstractExpanded.value;

  Future<void> openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void viewPresenterDetails(String id) {}
}

class PresenterModel {
  final String id;
  final String name;
  final String role;
  final String avatar;

  PresenterModel({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
  });

  factory PresenterModel.fromJson(Map<String, dynamic> json) {
    return PresenterModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? 'Presenter',
      avatar: json['avatar']?.toString() ?? '',
    );
  }
}

class PosterAttachmentModel {
  final String id;
  final String url;
  final String type; // 'pdf' or 'image'
  final String name;
  final String reviewStatus;

  PosterAttachmentModel({
    required this.id,
    required this.url,
    required this.type,
    required this.name,
    required this.reviewStatus,
  });

  factory PosterAttachmentModel.fromJson(Map<String, dynamic> json) {
    return PosterAttachmentModel(
      id: json['_id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      reviewStatus: json['reviewStatus']?.toString() ?? '',
    );
  }
}
