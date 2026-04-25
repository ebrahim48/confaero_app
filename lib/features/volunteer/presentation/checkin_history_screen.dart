import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../attendees/presentation/widgets/view/qr_scanner_screen.dart';
import 'controllers/volunteer_checkIn_history_controller.dart';
import 'widgets/check_in_history_card.dart';

class CheckHistoryScreen extends StatelessWidget {
  final bool showBackButton;
  const CheckHistoryScreen({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckInHistoryController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: showBackButton
            ? GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back,
                    color: AppColors.textColor252525, size: 22.sp),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(
          'Check In History',
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor252525),
        ),
        centerTitle: false,
        actions: [
          Obx(() => controller.isLoading.value
              ? Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor32A69A),
                  ),
                )
              : GestureDetector(
                  onTap: controller.loadHistory,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Icon(Icons.refresh,
                        size: 22.sp, color: AppColors.textColor424242),
                  ),
                )),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),

            // Ready to Scan section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffE8F8F5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.qr_code_scanner,
                        size: 26.sp, color: AppColors.primaryColor32A69A),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ready to Scan',
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor252525)),
                        SizedBox(height: 2.h),
                        Obx(() => Text(
                              '${controller.totalCheckedIn.value} attendees checked in',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textColor7E7F7E),
                            )),
                      ],
                    ),
                  ),
                  Obx(() => GestureDetector(
                    onTap: controller.isCheckingIn.value
                        ? null
                        : () async {
                            final result = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QrScannerScreen(),
                              ),
                            );
                            if (result != null && result.isNotEmpty) {
                              await controller.checkIn(result);
                            }
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: controller.isCheckingIn.value
                            ? AppColors.primaryColor32A69A.withOpacity(0.6)
                            : AppColors.primaryColor32A69A,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: controller.isCheckingIn.value
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text('Scan QR',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                    ),
                  )),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              'Last Scan',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor252525),
            ),
            SizedBox(height: 12.h),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor32A69A),
                  );
                }

                if (controller.lastScans.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_outlined,
                            size: 48.sp, color: AppColors.textColor7E7F7E),
                        SizedBox(height: 12.h),
                        Text('No scans yet',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textColor7E7F7E)),
                        SizedBox(height: 6.h),
                        Text('Scan an attendee QR code to get started',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textColor7E7F7E)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: controller.lastScans.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) => CheckInHistoryCard(
                    scan: controller.lastScans[i],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
