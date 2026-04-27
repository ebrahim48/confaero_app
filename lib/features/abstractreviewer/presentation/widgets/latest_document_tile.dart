import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class LatestDocumentTile extends StatelessWidget {
  final Map<String, dynamic> doc;
  final VoidCallback onTap;

  const LatestDocumentTile({
    super.key,
    required this.doc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPoster = doc['type'] == 'poster';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xffF0FBF9),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: AppColors.primaryColor32A69A.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor32A69A,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                isPoster ? Icons.search : Icons.description_outlined,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc['title'],
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor252525)),
                  SizedBox(height: 2.h),
                  RichText(
                    text: TextSpan(
                      text: 'Submitted by ',
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textColor7E7F7E),
                      children: [
                        TextSpan(
                          text: doc['submittedBy'],
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor424242),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                size: 20.sp, color: AppColors.textColor7E7F7E),
          ],
        ),
      ),
    );
  }
}