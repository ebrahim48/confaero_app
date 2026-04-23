import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/booth_staff_controller.dart';


class BoothStaffScreen extends StatelessWidget {
  const BoothStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BoothStaffController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
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
              child: Obx(() => ListView.separated(
                itemCount: controller.staffList.length,
                separatorBuilder: (_, __) => SizedBox(height: 0.h),
                itemBuilder: (context, index) {
                  final staff = controller.staffList[index];
                  return _staffTile(staff, index, controller);
                },
              )),
            ),

            // Add Member Button
            GestureDetector(
              onTap: () => context.pushNamed(AppRoutes.addMemberScreen),
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

  Widget _staffTile(
      Map<String, dynamic> staff, int index, BoothStaffController controller) {
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
          // Avatar with teal border
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
              child: Image.asset(
                staff['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              staff['name'],
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor252525,
              ),
            ),
          ),
          // Three dot menu
          GestureDetector(
            onTap: () => _showOptions(index, controller),
            child: Icon(Icons.more_vert,
                size: 20.sp, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }

  void _showOptions(int index, BoothStaffController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
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
              leading: Icon(Icons.delete_outline,
                  color: Colors.red, size: 22.sp),
              title: Text(
                'Remove Member',
                style: TextStyle(
                    fontSize: 14.sp, color: Colors.red),
              ),
              onTap: () {
                Get.back();
                controller.removeMember(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.close,
                  color: AppColors.textColor424242, size: 22.sp),
              title: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 14.sp, color: AppColors.textColor424242),
              ),
              onTap: () => Get.back(),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}