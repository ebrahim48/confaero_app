import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/booth_management_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class BoothManagementScreen extends StatelessWidget {
  const BoothManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BoothManagementController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBarWidget(
            title: controller.isOrganizer ? 'Manage Booths' : 'My Booth',
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return controller.isOrganizer
                  ? _buildOrganizerView(context, controller)
                  : _buildExhibitorView(context, controller);
            }),
          ),
        ],
      ),
    );
  }

  // =================== Organizer View ===================
  Widget _buildOrganizerView(
    BuildContext context,
    BoothManagementController controller,
  ) {
    if (controller.booths.isEmpty) {
      return Center(
        child: Text(
          'No booth applications',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: controller.loadOrganizerBooths,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.booths.length,
        itemBuilder: (context, index) {
          final booth = controller.booths[index];
          final status = booth['status'] as String? ?? 'pending';
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFD7EAE8)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x0D000000),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booth['name'] as String? ?? 'Booth',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _statusBadge(status),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  booth['description'] as String? ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF7E7F7E),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                if (status == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => controller.cancelBooth(
                                booth['_id'] as String? ?? '',
                              ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              () => controller.acceptBooth(
                                booth['_id'] as String? ?? '',
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff32A69A),
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =================== Exhibitor View ===================
  Widget _buildExhibitorView(
    BuildContext context,
    BoothManagementController controller,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booth Name',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.boothNameController,
            decoration: InputDecoration(
              hintText: 'Enter booth name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Description',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.boothDescController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isSaving.value ? null : controller.updateMyBooth,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff32A69A),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                controller.isSaving.value ? 'Saving...' : 'Update Booth',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Staff section
          Text(
            'Staff Members',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Column(
              children:
                  controller.staffMembers
                      .map(
                        (s) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xff32A69A),
                            child: Text(
                              (s['name'] as String? ?? 'S')[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(s['name'] as String? ?? ''),
                          subtitle: Text(s['email'] as String? ?? ''),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed:
                                () => controller.removeStaff(
                                  s['_id'] as String? ?? '',
                                ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'accepted':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF4CAF50);
        break;
      case 'rejected':
      case 'cancelled':
        bg = const Color(0xFFFFEBEE);
        fg = Colors.red;
        break;
      default:
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFFFA000);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status.capitalize!,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
