import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../presentations/widgets/custom_button.dart';
import '../../../../../presentations/widgets/custom_text.dart';
import '../../controllers/contact_qr_controller.dart';
import '../qr_item_widget.dart';

class ContactQrScreen extends StatefulWidget {
  const ContactQrScreen({super.key});

  @override
  State<ContactQrScreen> createState() => _ContactQrScreenState();
}

class _ContactQrScreenState extends State<ContactQrScreen>
    with SingleTickerProviderStateMixin {
  late final ContactQrController controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ContactQrController());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 98.h,
            color: const Color(0xffF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.textColor424242,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  CustomText(
                    text: 'Contact & QR',
                    fontsize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor424242,
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xff32A69A),
              indicatorWeight: 3,
              labelColor: const Color(0xff32A69A),
              unselectedLabelColor: AppColors.textColor7E7F7E,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'My QR'),
                Tab(text: 'Scan QR'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _MyQrTab(controller: controller),
                _ScanQrTab(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── My QR Tab ─────────────────────────────────────────────────────────────────

class _MyQrTab extends StatelessWidget {
  const _MyQrTab({required this.controller});
  final ContactQrController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Obx(() {
        final loading = controller.isLoadingQr.value;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffE0E0E0), width: 2),
                ),
                child: ClipOval(
                  child: loading
                      ? _shimmerCircle(80.w)
                      : controller.isNetworkAvatar
                          ? Image.network(
                              controller.userAvatar,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _personIcon(),
                            )
                          : Image.asset(
                              controller.userAvatar,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _personIcon(),
                            ),
                ),
              ),

              SizedBox(height: 14.h),

              // Name
              loading
                  ? _shimmerBox(120.w, 18.h)
                  : CustomText(
                      text: controller.userName.isEmpty
                          ? 'Attendee'
                          : controller.userName,
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor424242,
                    ),

              SizedBox(height: 10.h),

              // Role badge
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: 'Attendee',
                  fontsize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor7E7F7E,
                ),
              ),

              SizedBox(height: 24.h),

              // QR Code area
              Container(
                width: 200.w,
                height: 200.h,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xffE0E0E0)),
                ),
                child: loading
                    ? _shimmerBox(176.w, 176.h)
                    : controller.qrToken.value.isEmpty
                        ? _qrErrorPlaceholder()
                        : QrImageView(
                            data: controller.qrToken.value,
                            version: QrVersions.auto,
                            size: 176.w,
                            backgroundColor: Colors.white,
                            errorStateBuilder: (_, __) => _qrErrorPlaceholder(),
                          ),
              ),

              SizedBox(height: 16.h),

              // Refresh if failed
              if (!loading && controller.qrToken.value.isEmpty)
                TextButton.icon(
                  onPressed: controller.loadQrToken,
                  icon: const Icon(Icons.refresh,
                      color: Color(0xff32A69A), size: 18),
                  label: CustomText(
                    text: 'Retry',
                    fontsize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff32A69A),
                  ),
                ),

              SizedBox(height: 8.h),

              // Info header
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: 'Use this code to',
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor424242,
                ),
              ),
              SizedBox(height: 8.h),

              QrInfoItem(icon: 'assets/icons/checkin.svg', text: 'Check in'),
              QrInfoItem(
                icon: 'assets/icons/share.svg',
                text: 'Share your contact info with Exhibitors/Vendors',
              ),
              QrInfoItem(
                icon: 'assets/icons/userprofile.svg',
                text: 'Connect with fellow attendees',
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _personIcon() => Container(
        color: Colors.grey[200],
        child: Icon(Icons.person, size: 40.sp, color: Colors.grey[500]),
      );

  Widget _qrErrorPlaceholder() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code, size: 60.sp, color: Colors.grey[400]),
          SizedBox(height: 8.h),
          CustomText(
            text: 'QR unavailable',
            fontsize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor7E7F7E,
          ),
        ],
      );
}

// ── Scan QR Tab ───────────────────────────────────────────────────────────────

class _ScanQrTab extends StatelessWidget {
  const _ScanQrTab({required this.controller});
  final ContactQrController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Obx(() {
        final loading = controller.isScanLoading.value;
        final success = controller.scanSuccess.value;
        final error = controller.scanError.value;

        if (loading) {
          return _loadingState();
        }

        if (success) {
          return _successState(context);
        }

        if (error.isNotEmpty) {
          return _errorState(context, error);
        }

        return _idleState(context);
      }),
    );
  }

  Widget _idleState(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            color: const Color(0xffF0FAF9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.qr_code_scanner,
            size: 60.sp,
            color: const Color(0xff32A69A),
          ),
        ),
        SizedBox(height: 24.h),
        CustomText(
          text: 'Scan an Attendee\'s QR',
          fontsize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textColor424242,
        ),
        SizedBox(height: 10.h),
        CustomText(
          text: 'Point your camera at another attendee\'s QR code to connect with them.',
          fontsize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        CustomButton(
          title: 'Open Scanner',
          onpress: () => controller.scanAttendeeQR(context),
          color: const Color(0xff32A69A),
          height: 52.h,
          borderRadius: 12.r,
          prefixIcon:
              const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
        ),
      ],
    );
  }

  Widget _loadingState() {
    return Column(
      children: [
        SizedBox(height: 60.h),
        const CircularProgressIndicator(color: Color(0xff32A69A)),
        SizedBox(height: 24.h),
        CustomText(
          text: 'Processing scan...',
          fontsize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor7E7F7E,
        ),
      ],
    );
  }

  Widget _successState(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Container(
          width: 120.w,
          height: 120.h,
          decoration: const BoxDecoration(
            color: Color(0xffE8F8F5),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, size: 64.sp, color: const Color(0xff32A69A)),
        ),
        SizedBox(height: 24.h),
        CustomText(
          text: 'Connected!',
          fontsize: 22.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xff32A69A),
        ),
        SizedBox(height: 10.h),
        CustomText(
          text: 'You\'ve successfully connected with this attendee.',
          fontsize: 13.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor7E7F7E,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        CustomButton(
          title: 'Scan Another',
          onpress: () {
            controller.resetScanState();
            controller.scanAttendeeQR(context);
          },
          color: const Color(0xff32A69A),
          height: 52.h,
          borderRadius: 12.r,
          prefixIcon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
        ),
      ],
    );
  }

  Widget _errorState(BuildContext context, String errorMsg) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Container(
          width: 120.w,
          height: 120.h,
          decoration: const BoxDecoration(
            color: Color(0xffFFF0F0),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.cancel, size: 64.sp, color: Colors.red[400]),
        ),
        SizedBox(height: 24.h),
        CustomText(
          text: 'Scan Failed',
          fontsize: 22.sp,
          fontWeight: FontWeight.w700,
          color: Colors.red[400]!,
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xffFFF5F5),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xffFFCDD2)),
          ),
          child: CustomText(
            text: errorMsg,
            fontsize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.red[700]!,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        CustomButton(
          title: 'Try Again',
          onpress: () {
            controller.resetScanState();
            controller.scanAttendeeQR(context);
          },
          color: const Color(0xff32A69A),
          height: 52.h,
          borderRadius: 12.r,
          prefixIcon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
        ),
        SizedBox(height: 12.h),
        TextButton(
          onPressed: controller.resetScanState,
          child: CustomText(
            text: 'Cancel',
            fontsize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor7E7F7E,
          ),
        ),
      ],
    );
  }
}

// ── Shimmer helpers ───────────────────────────────────────────────────────────

Widget _shimmerCircle(double size) {
  return Shimmer.fromColors(
    baseColor: const Color(0xFFE0E0E0),
    highlightColor: const Color(0xFFF5F5F5),
    child: Container(
      width: size,
      height: size,
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    ),
  );
}

Widget _shimmerBox(double w, double h) {
  return Shimmer.fromColors(
    baseColor: const Color(0xFFE0E0E0),
    highlightColor: const Color(0xFFF5F5F5),
    child: Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
