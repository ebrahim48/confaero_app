import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentations/widgets/custom_text.dart';
import 'package:get/get.dart';
import '../controller/notifications_controller.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xffE0E0E0), width: 1),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child:
                    notification.avatarUrl != null
                        ? Image.asset(
                          notification.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 28.sp,
                              color: Colors.white,
                            );
                          },
                        )
                        : Icon(Icons.person, size: 28.sp, color: Colors.white),
              ),
            ),

            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: notification.title,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor424242,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: notification.time,
                        fontsize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor7E7F7E,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Message
                  CustomText(
                    text: notification.message,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor7E7F7E,
                    maxline: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  if (notification.title == 'Connection Request') ...[
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // The 'id' of NotificationItem here is the request ID.
                          Get.find<NotificationsController>().acceptConnection(
                            notification.id,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff32A69A),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: CustomText(
                            text: 'Accept',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
