import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/toast_message_helper.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text_field.dart';
import '../../controllers/booth_controllers.dart';

class BoothProfileScreen extends StatefulWidget {
  const BoothProfileScreen({super.key});

  @override
  State<BoothProfileScreen> createState() => _BoothProfileScreenState();
}

class _BoothProfileScreenState extends State<BoothProfileScreen> {
  late final BoothController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<BoothController>()) {
      controller = Get.put(BoothController());
    } else {
      controller = Get.find<BoothController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text(
          'Booth Profile',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer();
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // ── Visuals ──────────────────────────────────────────
              _sectionTitle('Visuals'),
              SizedBox(height: 10.h),
              Obx(() {
                final bannerVal = controller.boothBannerPath.value;
                if (bannerVal.isEmpty) {
                  return _bannerUploadEmpty();
                }
                // Tapping an existing banner lets it be replaced or removed.
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _editBanner,
                  child: Stack(
                    children: [
                      bannerVal.startsWith('http')
                          ? _bannerNetwork(bannerVal)
                          : _bannerAsset(bannerVal),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(Icons.edit,
                              size: 16.sp, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 4.h),
              Divider(color: AppColors.borderColorD2D2D2),
              SizedBox(height: 16.h),

              // ── Content ──────────────────────────────────────────
              _sectionTitle('Content'),
              SizedBox(height: 10.h),

              CustomTextField(
                controller: controller.companyNameController,
                labelText: 'Company Name',
                hintText: 'Company name',
              ),
              CustomTextField(
                controller: controller.offerTitleController,
                labelText: 'Offer Title',
                hintText: 'e.g., 20% Off Annual Plan',
              ),
              CustomTextField(
                controller: controller.boothOpeningController,
                labelText: 'Booth Opening',
                hintText: '7:00 AM- 10 PM',
              ),

              // Description with character counter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor252525,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextFormField(
                    controller: controller.descriptionController,
                    maxLines: 5,
                    maxLength: 500,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textColor424242),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      hintText: 'Enter booth description...',
                      hintStyle: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textColor7E7F7E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide:
                            BorderSide(color: AppColors.borderColorD2D2D2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide:
                            BorderSide(color: AppColors.borderColorD2D2D2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide:
                            BorderSide(color: AppColors.borderColorD2D2D2),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(() => Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${controller.descriptionLength.value}/500 characters',
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textColor7E7F7E),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 12.h),

              Divider(color: AppColors.borderColorD2D2D2),
              SizedBox(height: 16.h),

              // ── Logistics ─────────────────────────────────────────
              _sectionTitle('Logistics'),
              SizedBox(height: 10.h),
              CustomTextField(
                controller: controller.boothNumberController,
                labelText: 'Booth Number',
                hintText: '——',
              ),

              Divider(color: AppColors.borderColorD2D2D2),
              SizedBox(height: 16.h),

              // ── Connect & Resources ───────────────────────────────
              _sectionTitle('Connect & Resources'),
              SizedBox(height: 10.h),

              CustomTextField(
                controller: controller.websiteUrlController,
                labelText: 'Website URL',
                hintText: 'https://example.com',
                prefixIcon: Icon(Icons.language,
                    size: 18.sp, color: AppColors.textColor7E7F7E),
                keyboardType: TextInputType.url,
              ),
              CustomTextField(
                controller: controller.publicEmailController,
                labelText: 'Public Email',
                hintText: 'contact@example.com',
                prefixIcon: Icon(Icons.email_outlined,
                    size: 18.sp, color: AppColors.textColor7E7F7E),
                keyboardType: TextInputType.emailAddress,
              ),

              Divider(color: AppColors.borderColorD2D2D2),
              SizedBox(height: 16.h),

              // ── Downloadable Resources ────────────────────────────
              _sectionTitle('Downloadable Resources'),
              SizedBox(height: 10.h),

              Obx(() => Column(
                    children: controller.downloadableResources
                        .asMap()
                        .entries
                        .map((entry) =>
                            _resourceTile(entry.value, entry.key))
                        .toList(),
                  )),

              SizedBox(height: 24.h),

              // ── Button ────────────────────────────────────────────
              Obx(() => CustomButton(
                    title: controller.hasBooth.value
                        ? 'Save Changes'
                        : 'Create Booth',
                    loading: controller.isSaving.value,
                    onpress: () {
                      if (controller.hasBooth.value) {
                        controller.saveBoothChanges();
                      } else {
                        controller.createBooth();
                      }
                    },
                  )),
              SizedBox(height: 24.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textColor252525,
      ),
    );
  }

  /// The booth API stores the banner as an image URL, so the banner is set by
  /// entering/pasting a link. Also allows clearing an existing one.
  Future<void> _editBanner() async {
    final input =
        TextEditingController(text: controller.boothBannerPath.value);
    final hadBanner = controller.boothBannerPath.value.isNotEmpty;

    final result = await showDialog<String?>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Booth Banner',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste a link to your banner image (recommended 1200x600px).',
              style: TextStyle(
                  fontSize: 12.sp, color: AppColors.textColor7E7F7E),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: input,
              autofocus: true,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                hintText: 'https://example.com/banner.png',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          if (hadBanner)
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, ''),
              child: Text('Remove', style: TextStyle(color: Colors.red[400])),
            ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, input.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    input.dispose();
    if (result == null) return; // dismissed

    if (result.isEmpty) {
      controller.boothBannerPath.value = '';
      return;
    }

    final uri = Uri.tryParse(result);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      ToastMessageHelper.showToastMessage(
        'Please enter a valid image link starting with http:// or https://',
        title: 'Error',
      );
      return;
    }
    controller.boothBannerPath.value = result;
  }

  Widget _bannerUploadEmpty() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _editBanner,
      child: Container(
        width: double.infinity,
        height: 130.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.borderColorD2D2D2,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined,
                size: 30.sp, color: AppColors.textColor7E7F7E),
            SizedBox(height: 8.h),
            Text(
              'Upload Booth Banner',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor424242,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Recommended Size 1200*600px (16:9)',
              style: TextStyle(
                  fontSize: 10.sp, color: AppColors.textColor7E7F7E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerNetwork(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Image.network(
        url,
        width: double.infinity,
        height: 130.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _bannerUploadEmpty(),
      ),
    );
  }

  Widget _bannerAsset(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Image.asset(
        path,
        width: double.infinity,
        height: 130.h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _resourceTile(Map<String, dynamic> resource, int index) {
    final name = resource['name']?.toString() ?? '';
    final type = resource['type']?.toString() ?? '';
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
            color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(
            type.toLowerCase() == 'pdf'
                ? Icons.picture_as_pdf
                : Icons.insert_drive_file_outlined,
            color: type.toLowerCase() == 'pdf' ? Colors.red : Colors.blue,
            size: 24.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor252525),
                ),
                Text(
                  type.toUpperCase(),
                  style: TextStyle(
                      fontSize: 10.sp, color: AppColors.textColor7E7F7E),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.removeResource(index),
            child: Icon(Icons.delete_outline,
                color: AppColors.textColor7E7F7E, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Container(width: 80.w, height: 14.h, color: Colors.white),
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              height: 130.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),
            ...List.generate(
              6,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
