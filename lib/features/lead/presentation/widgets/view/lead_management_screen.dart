import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/approutes/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controller/leadmanagement_controller.dart';
import '../lead_card.dart';
import '../lead_filter_tab.dart';


class LeadManagementScreen extends StatelessWidget {
  const LeadManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeadController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lead Management',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor252525,
                      ),
                    ),
                  ),
                  Icon(Icons.search,
                      size: 24.sp, color: AppColors.textColor424242),
                ],
              ),
            ),

            SizedBox(
              height: 38.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.filters.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (_, i) {
                  final filter = controller.filters[i];
                  return Obx(() => LeadFilterTab(
                    label: filter,
                    isSelected:
                    controller.selectedFilter.value == filter,
                    onTap: () => controller.setFilter(filter),
                  ));
                },
              ),
            ),
            SizedBox(height: 14.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Leads',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor252525,
                    ),
                  ),
                  Obx(() => Text(
                    '${controller.totalLeads} Total',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textColor7E7F7E,
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xff32A69A)),
                  );
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48.sp, color: Colors.red),
                        SizedBox(height: 12.h),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textColor7E7F7E),
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: controller.loadLeads,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: const Color(0xff32A69A),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text('Retry',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final leads = controller.filteredLeads;
                if (leads.isEmpty) {
                  return Center(
                    child: Text(
                      'No leads found',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textColor7E7F7E),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: leads.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (ctx, i) => LeadCard(
                    lead: leads[i],
                    onAddNote: () =>
                        controller.openNoteDialog(ctx, leads[i]['id']),
                    onEditTags: () =>
                        controller.openTagDialog(ctx, leads[i]['id']),
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      floatingActionButton: GestureDetector(
        onTap: () async {
          final result = await context.pushNamed(AppRoutes.qrScannerScreen);
          if (result != null && result is String && result.isNotEmpty) {
            await controller.onQrScanned(result);
          }
        },
        child: SizedBox(
          width: 52.w,
          height: 52.h,
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/leadscan.svg',
            ),
          ),
        ),
      ),


    );
  }


}