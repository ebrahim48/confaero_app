import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/volunteer_models.dart';

class CheckInHistoryCard extends StatelessWidget {
  final LastScanModel scan;

  const CheckInHistoryCard({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.borderColorD2D2D2,
            backgroundImage: scan.avatar.startsWith('http')
                ? NetworkImage(scan.avatar) as ImageProvider
                : const AssetImage('assets/images/profile.png'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.name.isNotEmpty ? scan.name : scan.email,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor252525),
                ),
                if (scan.email.isNotEmpty && scan.name.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(scan.email,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textColor7E7F7E)),
                ],
                SizedBox(height: 2.h),
                Text(scan.role,
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textColor7E7F7E)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(scan.scannedAt),
                style: TextStyle(fontSize: 10.sp, color: AppColors.textColor7E7F7E),
              ),
              Text(
                _formatTime(scan.scannedAt),
                style: TextStyle(fontSize: 11.sp, color: AppColors.textColor7E7F7E),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return '';
    }
  }

  String _formatTime(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final min = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$min $period';
    } catch (_) {
      return raw;
    }
  }
}
