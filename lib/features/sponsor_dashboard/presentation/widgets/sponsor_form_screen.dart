import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/sponsor_dashboard_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';
import '../../../../presentations/widgets/custom_button.dart';

class SponsorFormScreen extends StatelessWidget {
  const SponsorFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SponsorDashboardController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Add Sponsor'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Sponsor Name *'),
                  _textField(controller.nameController, 'Enter sponsor name'),
                  SizedBox(height: 16.h),
                  _label('Description'),
                  _textField(
                    controller.descController,
                    'Enter description',
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.h),
                  _label('Website'),
                  _textField(controller.websiteController, 'https://...'),
                  SizedBox(height: 16.h),
                  _label('Tier'),
                  _textField(
                    controller.tierController,
                    'e.g. Gold, Silver, Bronze',
                  ),
                  SizedBox(height: 32.h),
                  Obx(
                    () => CustomButton(
                      title: 'Create Sponsor',
                      onpress:
                          controller.isSaving.value
                              ? () {}
                              : () => controller.createSponsor(),
                      color: const Color(0xff32A69A),
                      height: 52.h,
                      borderRadius: 12.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF252525),
      ),
    ),
  );

  Widget _textField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xff32A69A)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
