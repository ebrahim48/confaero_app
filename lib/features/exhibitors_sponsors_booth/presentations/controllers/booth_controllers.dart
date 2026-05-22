import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/session_controller.dart';
import '../../../../core/services/booth_service.dart';
import '../../data/models/booth_model.dart';

class BoothController extends GetxController {
  final BoothService _service = Get.find<BoothService>();

  // ── Booth state ──────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool hasBooth = false.obs;
  final Rx<BoothModel?> booth = Rx<BoothModel?>(null);

  // Derived display fields
  String get boothName => booth.value?.companyName ?? '';
  String get boothNumber => booth.value?.boothNumber ?? '';
  String get boothStatus => booth.value?.status ?? '';
  String get boothBannerUrl => booth.value?.banner ?? '';

  // Analytics
  final RxInt totalLeads = 0.obs;
  final RxInt totalStaff = 0.obs;

  // Performance
  final RxInt totalScans = 0.obs;
  final RxList<Map<String, dynamic>> trafficData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> recentLeads = <Map<String, dynamic>>[].obs;

  // Booth Profile Form
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController offerTitleController = TextEditingController();
  final TextEditingController boothOpeningController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController boothNumberController = TextEditingController();
  final TextEditingController websiteUrlController = TextEditingController();
  final TextEditingController publicEmailController = TextEditingController();

  final RxString boothBannerPath = ''.obs;
  final RxList<Map<String, dynamic>> downloadableResources =
      <Map<String, dynamic>>[].obs;
  final RxInt descriptionLength = 0.obs;

  // Save/Create loading
  final RxBool isSaving = false.obs;

  String get eventId => SessionController.to.eventId;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.length;
    });
    // Wait for eventId to be loaded from prefs before calling APIs
    if (SessionController.to.eventId.isNotEmpty) {
      loadAll();
    } else {
      ever(SessionController.to.eventIdRx, (String id) {
        if (id.isNotEmpty && !hasBooth.value && !isLoading.value) {
          loadAll();
        }
      });
    }
  }

  Future<void> loadAll() async {
    if (eventId.isEmpty) return;
    await Future.wait([
      _loadBooth(),
      _loadAnalytics(),
    ]);
  }

  Future<void> _loadBooth() async {
    if (eventId.isEmpty) return;
    isLoading.value = true;
    try {
      final res = await _service.getMyBoothByEvent(eventId);
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'] as Map<String, dynamic>;
        final model = BoothModel.fromJson(data);
        booth.value = model;
        hasBooth.value = true;
        _populateForm(model);
      } else {
        hasBooth.value = false;
      }
    } catch (e) {
      hasBooth.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void _populateForm(BoothModel model) {
    companyNameController.text = model.companyName;
    offerTitleController.text = model.offerTitle;
    boothOpeningController.text = model.boothOpening;
    descriptionController.text = model.description;
    boothNumberController.text = model.boothNumber;
    websiteUrlController.text = model.websiteUrl;
    publicEmailController.text = model.publicEmail;
    boothBannerPath.value = model.banner;
    downloadableResources.assignAll(
      model.resources
          .map((r) => <String, dynamic>{'name': r.name, 'url': r.url, 'type': r.type})
          .toList(),
    );
  }

  Future<void> _loadAnalytics() async {
    if (eventId.isEmpty) return;
    try {
      final res = await _service.getAnalytics(eventId);
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'] as Map<String, dynamic>;
        totalLeads.value = (data['totalLeads'] as num?)?.toInt() ?? 0;
        totalStaff.value = (data['totalStaff'] as num?)?.toInt() ?? 0;
      }
    } catch (_) {}
  }

  Future<void> loadPerformance() async {
    if (eventId.isEmpty) return;
    try {
      final res = await _service.getPerformance(eventId);
      if (res['success'] == true && res['data'] != null) {
        final data = res['data'] as Map<String, dynamic>;
        totalScans.value = (data['totalScans'] as num?)?.toInt() ?? 0;

        final traffic = data['trafficOverTime'] as Map<String, dynamic>?;
        if (traffic != null && traffic['data'] is List) {
          trafficData.assignAll(
            (traffic['data'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList(),
          );
        }

        if (data['recentLeads'] is List) {
          recentLeads.assignAll(
            (data['recentLeads'] as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList(),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> createBooth() async {
    isSaving.value = true;
    try {
      final body = <String, dynamic>{
        'eventId': eventId,
        'companyName': companyNameController.text.trim(),
        'banner': boothBannerPath.value,
        'offerTitle': offerTitleController.text.trim(),
        'boothOpening': boothOpeningController.text.trim(),
        'description': descriptionController.text.trim(),
        'websiteUrl': websiteUrlController.text.trim(),
        'publicEmail': publicEmailController.text.trim(),
        'resources': downloadableResources
            .map((r) => <String, dynamic>{'name': r['name'], 'url': r['url'], 'type': r['type']})
            .toList(),
      };

      final res = await _service.createBooth(body);
      if (res['success'] == true) {
        hasBooth.value = true;
        await _loadBooth();
        await _loadAnalytics();
        Navigator.pop(Get.context!);
      }
    } catch (e) {
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> saveBoothChanges() async {
    isSaving.value = true;
    try {
      final body = <String, dynamic>{
        'companyName': companyNameController.text.trim(),
        'offerTitle': offerTitleController.text.trim(),
        'boothOpening': boothOpeningController.text.trim(),
        'description': descriptionController.text.trim(),
        'boothNumber': boothNumberController.text.trim(),
        'websiteUrl': websiteUrlController.text.trim(),
        'publicEmail': publicEmailController.text.trim(),
        'resources': downloadableResources
            .map((r) => <String, dynamic>{'name': r['name'], 'url': r['url'], 'type': r['type']})
            .toList(),
      };

      final res = await _service.updateMyBooth(eventId, body);
      if (res['success'] == true) {
        await _loadBooth();
        Navigator.pop(Get.context!);
      }
    } catch (e) {
    } finally {
      isSaving.value = false;
    }
  }

  void removeResource(int index) {
    downloadableResources.removeAt(index);
  }

  // Computed line chart data (scan counts from traffic)
  List<double> get chartScanValues {
    if (trafficData.isEmpty) return [];
    return trafficData
        .map((d) => ((d['scans'] as num?)?.toDouble() ?? 0.0))
        .toList();
  }

  List<String> get chartLabels {
    return trafficData
        .map((d) => d['label']?.toString() ?? '')
        .toList();
  }

  @override
  void onClose() {
    companyNameController.dispose();
    offerTitleController.dispose();
    boothOpeningController.dispose();
    descriptionController.dispose();
    boothNumberController.dispose();
    websiteUrlController.dispose();
    publicEmailController.dispose();
    super.onClose();
  }
}
