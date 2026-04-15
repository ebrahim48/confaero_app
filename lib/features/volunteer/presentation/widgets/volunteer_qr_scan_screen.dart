import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/config/approutes/app_routes.dart';
import '../controllers/volunteer_qr_controller.dart';

/// Volunteer QR Scan Screen
class VolunteerQRScanScreen extends StatelessWidget {
  const VolunteerQRScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VolunteerQRController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.showHistory.value) {
          return _CheckInHistory(controller: controller);
        }
        if (controller.showHelp.value) {
          return _HelpScreen(controller: controller);
        }
        return _QRScannerView(controller: controller);
      }),
    );
  }
}

class _QRScannerView extends StatelessWidget {
  final VolunteerQRController controller;

  const _QRScannerView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, size: 24.sp, color: Colors.grey),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Ready to Scan',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.toggleFlash(),
                  child: Icon(
                    controller.flashOn.value
                        ? Icons.flash_on
                        : Icons.flash_off,
                    size: 24.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        // QR Scanner
        Expanded(
          child: Stack(
            children: [
              MobileScanner(
                controller: controller.scannerController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    controller.handleScan(barcode.rawValue);
                  }
                },
              ),
              // Scan overlay
              Center(
                child: Container(
                  width: 250.w,
                  height: 250.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF32A69A),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Scanning line animation
                      AnimatedBuilder(
                        animation: controller.scanAnimation,
                        builder: (context, child) {
                          return Container(
                            margin: EdgeInsets.only(
                              top: controller.scanAnimation.value * 200.h,
                            ),
                            height: 3,
                            color: const Color(0xFF32A69A),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Corner markers
              Center(
                child: Container(
                  width: 250.w,
                  height: 250.h,
                  child: Stack(
                    children: [
                      // Top-left
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                              left: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                      // Top-right
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                              right: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                      // Bottom-left
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                              left: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                      // Bottom-right
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                              right: BorderSide(
                                color: const Color(0xFF32A69A),
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Instructions
        Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            'Align QR Code within the frame to\nautomatically check in attendee.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),

        // Bottom actions
        Padding(
          padding: EdgeInsets.only(bottom: 32.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // History button
              GestureDetector(
                onTap: () => controller.showHistory.value = true,
                child: Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.history,
                    size: 24.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(width: 32.w),
              // Scan button
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.circle, size: 48.sp, color: Colors.white),
              ),
              SizedBox(width: 32.w),
              // Help button
              GestureDetector(
                onTap: () => controller.showHelp.value = true,
                child: Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.help_outline,
                    size: 24.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckInHistory extends StatelessWidget {
  final VolunteerQRController controller;

  const _CheckInHistory({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => controller.showHistory.value = false,
                  child: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black87),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Check In History',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),

        // History list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.scanHistory.length,
            itemBuilder: (context, index) {
              final scan = controller.scanHistory[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0D000000),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.person, size: 20.sp, color: Colors.grey),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scan['name'] ?? 'Attendee',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'VIP Pass: ${scan['passId'] ?? '#000000'}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Attendee',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      scan['time'] ?? 'Just Now',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HelpScreen extends StatelessWidget {
  final VolunteerQRController controller;

  const _HelpScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => controller.showHelp.value = false,
                  child: Icon(Icons.arrow_back, size: 24.sp, color: Colors.black87),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Help',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Help content
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListView(
                children: [
                  _helpBulletPoint(
                    'Lorem ipsum dolor sit amet consectetur. Lacus at venenatis gravida vivamus mauris.',
                  ),
                  _helpBulletPoint(
                    'Vel blandit mi nulla sodales consectetur. Egestas tristique ultrices gravida duis nisl odio.',
                  ),
                  _helpBulletPoint(
                    'Scelerisque tellus praesent condimentum euismod a faucibus.',
                  ),
                  _helpBulletPoint(
                    'Pretium pulvinar morbi suspendisse mattis.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _helpBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
