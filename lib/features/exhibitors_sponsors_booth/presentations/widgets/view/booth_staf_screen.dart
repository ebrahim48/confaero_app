import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/booth_staff_controller.dart';

class BoothStaffScreen extends StatefulWidget {
  const BoothStaffScreen({super.key});

  @override
  State<BoothStaffScreen> createState() => _BoothStaffScreenState();
}

class _BoothStaffScreenState extends State<BoothStaffScreen> {
  late final BoothStaffController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<BoothStaffController>()) {
      controller = Get.put(BoothStaffController());
    } else {
      controller = Get.find<BoothStaffController>();
      controller.loadStaff();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text(
          'Booth Staff',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booth staff have access to the event.',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textColor7E7F7E,
              ),
            ),
            SizedBox(height: 16.h),

            // Staff List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmer();
                }
                if (controller.staffList.isEmpty) {
                  return Center(
                    child: Text(
                      'No staff members yet',
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColors.textColor7E7F7E),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: controller.staffList.length,
                  separatorBuilder: (_, __) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    final staff = controller.staffList[index];
                    return _staffTile(staff, index);
                  },
                );
              }),
            ),

            // Add Member Button
            GestureDetector(
              onTap: () => context.push(AppRoutes.addMemberScreen),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color: AppColors.borderColorD2D2D2.withOpacity(0.8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add,
                        size: 18.sp, color: AppColors.textColor424242),
                    SizedBox(width: 6.w),
                    Text(
                      'Add Member',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor424242,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _staffTile(Map<String, dynamic> staff, int index) {
    final imageUrl = staff['image']?.toString() ?? '';
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColorD2D2D2.withOpacity(0.4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor32A69A,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _avatarFallback(),
                    )
                  : _avatarFallback(),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff['name']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor252525,
                  ),
                ),
                if ((staff['email']?.toString() ?? '').isNotEmpty)
                  Text(
                    staff['email'].toString(),
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textColor7E7F7E),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showOptions(context, index),
            child: Icon(Icons.more_vert,
                size: 20.sp, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    return Image.asset(
      'assets/images/profile.png',
      fit: BoxFit.cover,
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.borderColorD2D2D2,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading:
                  Icon(Icons.delete_outline, color: Colors.red, size: 22.sp),
              title: Text(
                'Remove Member',
                style: TextStyle(fontSize: 14.sp, color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                controller.removeMember(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.close,
                  color: AppColors.textColor424242, size: 22.sp),
              title: Text(
                'Cancel',
                style:
                    TextStyle(fontSize: 14.sp, color: AppColors.textColor424242),
              ),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.separated(
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox.shrink(),
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 46.w,
                height: 46.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 140.w, height: 13.h, color: Colors.white),
                  SizedBox(height: 4.h),
                  Container(
                      width: 100.w, height: 10.h, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
