import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../presentations/widgets/custom_text.dart';
import '../controllers/event_poster_details_controller.dart';

class PresenterCardWidget extends StatelessWidget {
  final PresenterModel presenter;
  final VoidCallback onTap;

  const PresenterCardWidget({
    super.key,
    required this.presenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        margin: EdgeInsets.only(bottom: 16.h),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30.r,
              backgroundImage: presenter.avatar.isNotEmpty
                  ? NetworkImage(presenter.avatar)
                  : null,
              backgroundColor: const Color(0xFFE0E0E0),
              child: presenter.avatar.isEmpty
                  ? Icon(Icons.person, size: 24.sp, color: Colors.grey)
                  : null,
            ),
            SizedBox(width: 16.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: presenter.name,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF252525),
                    maxline: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: presenter.role,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF999999),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Arrow Button
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xFF32A69A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}