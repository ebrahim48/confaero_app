import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';

class SponsorHeaderCard extends StatelessWidget {
  final bool hasProfile;
  final String displayName;
  final String description;
  final String status;
  final String logoPath;
  final File? pickedFile;
  final VoidCallback onEditTap;
  final VoidCallback? onCreateTap;

  const SponsorHeaderCard({
    super.key,
    required this.hasProfile,
    required this.displayName,
    required this.description,
    required this.status,
    required this.logoPath,
    required this.onEditTap,
    this.pickedFile,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasProfile) return _buildNoProfile(context);
    return _buildProfile();
  }

  Widget _buildNoProfile(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.store_outlined, size: 48.sp, color: AppColors.iconColorAEAEAE),
          SizedBox(height: 12.h),
          Text(
            'No Sponsor Profile Yet',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor252525,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Set up your sponsor profile to get started',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textColor7E7F7E),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor32A69A,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Create Profile',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final statusColors = _statusColors(status);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildLogo(),
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor252525,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textColor7E7F7E),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: statusColors['bg'],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7.w,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: statusColors['dot'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        _statusLabel(status),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: statusColors['text'],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: onEditTap,
            child: SvgPicture.asset(
              'assets/icons/edit.svg',
              width: 18.w,
              height: 18.h,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor32A69A,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    if (pickedFile != null) {
      return Image.file(pickedFile!, fit: BoxFit.contain);
    }
    if (logoPath.startsWith('http')) {
      return Image.network(
        logoPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            Image.asset('assets/images/booth.png', fit: BoxFit.contain),
      );
    }
    if (logoPath.isNotEmpty) {
      return Image.file(File(logoPath), fit: BoxFit.contain);
    }
    return Image.asset('assets/images/booth.png', fit: BoxFit.contain);
  }

  String _statusLabel(String s) {
    switch (s.toLowerCase()) {
      case 'approved': return 'Approved';
      case 'rejected': return 'Rejected';
      case 'pending': return 'Pending';
      default: return s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : 'Unknown';
    }
  }

  Map<String, Color> _statusColors(String s) {
    switch (s.toLowerCase()) {
      case 'approved':
        return {'bg': const Color(0xffE8F8F2), 'dot': const Color(0xff2DB87D), 'text': const Color(0xff2DB87D)};
      case 'rejected':
        return {'bg': const Color(0xffFDE8E8), 'dot': const Color(0xffC0392B), 'text': const Color(0xffC0392B)};
      case 'pending':
        return {'bg': const Color(0xffFFF3E0), 'dot': const Color(0xffE5A000), 'text': const Color(0xffE5A000)};
      default:
        return {'bg': const Color(0xffF0F0F0), 'dot': const Color(0xff7E7F7E), 'text': const Color(0xff7E7F7E)};
    }
  }
}
