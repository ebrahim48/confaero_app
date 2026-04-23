import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
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
    controller = Get.put(BoothController());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // ── Visuals ──────────────────────────────────────────
            _sectionTitle('Visuals'),
            SizedBox(height: 10.h),
            Obx(() => controller.boothBannerPath.value.isEmpty
                ? _bannerUploadEmpty(controller)
                : _bannerFilled()),
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
                      borderSide: BorderSide(
                          color: AppColors.borderColorD2D2D2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                          color: AppColors.borderColorD2D2D2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                          color: AppColors.borderColorD2D2D2),
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
              hintText: 'https://example.com',
              prefixIcon: Icon(Icons.language,
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
                  .map((entry) => _resourceTile(
                  entry.value, entry.key, controller))
                  .toList(),
            )),

            SizedBox(height: 24.h),

            // ── Button ────────────────────────────────────────────
            Obx(() => CustomButton(
              title: controller.hasBooth.value
                  ? 'Save Changes'
                  : 'Create Booth',
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
      ),
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

  Widget _bannerUploadEmpty(BoothController controller) {
    return GestureDetector(
      onTap: () {
        // image picker logic
      },
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

  Widget _bannerFilled() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Image.asset(
        'assets/images/booth.png',
        width: double.infinity,
        height: 130.h,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _resourceTile(
      Map<String, dynamic> resource, int index, BoothController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border:
        Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf,
              color: Colors.red, size: 24.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource['name'],
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor252525),
                ),
                Text(
                  resource['size'],
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
}