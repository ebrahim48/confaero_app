import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/invitation_controller.dart';
import '../../../../features/attendees/presentation/widgets/custom_app_bar_widget.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvitationController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomAppBarWidget(title: 'Invitations'),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.invitations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mail_outline,
                        size: 64.r,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No invitations',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadInvitations,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.invitations.length,
                  itemBuilder: (context, index) {
                    final inv = controller.invitations[index];
                    final status = inv['status'] as String? ?? 'pending';
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
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: const Color(0xff32A69A),
                                child: Icon(
                                  Icons.event,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inv['eventName'] as String? ??
                                          'Event Invitation',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      inv['role'] as String? ?? '',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      status == 'accepted'
                                          ? const Color(
                                            0xFF4CAF50,
                                          ).withAlpha(25)
                                          : status == 'rejected'
                                          ? Colors.red.withAlpha(25)
                                          : Colors.orange.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  status.capitalize!,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        status == 'accepted'
                                            ? const Color(0xFF4CAF50)
                                            : status == 'rejected'
                                            ? Colors.red
                                            : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (status == 'pending') ...[
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () => controller.acceptInvitation(
                                          inv['_id'] as String? ?? '',
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff32A69A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed:
                                        () => controller.rejectInvitation(
                                          inv['_id'] as String? ?? '',
                                        ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.red),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
