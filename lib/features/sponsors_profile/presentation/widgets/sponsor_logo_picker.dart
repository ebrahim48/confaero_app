import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class SponsorLogoPicker extends StatelessWidget {
  final String logoPath;
  final File? pickedFile;
  final VoidCallback onTap;

  const SponsorLogoPicker({
    super.key,
    required this.logoPath,
    required this.onTap,
    this.pickedFile,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pickedFile != null || logoPath.isNotEmpty;
    if (!hasImage) {
      return GestureDetector(onTap: onTap, child: _logoEmpty());
    }
    return _logoFilled(context);
  }

  Widget _logoEmpty() {
    return Container(
      width: double.infinity,
      height: 139.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderColorD2D2D2,
          style: BorderStyle.solid,
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined,
              size: 30.sp, color: AppColors.textColor7E7F7E),
          SizedBox(height: 8.h),
          Text(
            'Upload your logo',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor424242,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Recommended Size 1200×600px (16:9)',
            style: TextStyle(fontSize: 10.sp, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }

  Widget _logoFilled(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _showFullScreen(context),
          child: Container(
            width: double.infinity,
            height: 139.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderColorD2D2D2, width: 0.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: _buildImage(),
            ),
          ),
        ),
        // Change overlay
        Positioned(
          right: 10.w,
          bottom: 10.h,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 13.sp, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text('Change',
                      style: TextStyle(fontSize: 11.sp, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFullScreen(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: _buildImage(),
              ),
            ),
            Positioned(
              top: 40.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 22.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    Widget fallback() => Icon(Icons.broken_image_outlined, size: 40.sp, color: AppColors.iconColorAEAEAE);

    if (pickedFile != null && pickedFile!.existsSync()) {
      return Image.file(pickedFile!, fit: BoxFit.cover, width: double.infinity,
          errorBuilder: (_, __, ___) => fallback());
    }
    if (logoPath.startsWith('http')) {
      return Image.network(
        logoPath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }
    if (logoPath.isNotEmpty && File(logoPath).existsSync()) {
      return Image.file(File(logoPath), fit: BoxFit.cover, width: double.infinity,
          errorBuilder: (_, __, ___) => fallback());
    }
    return fallback();
  }
}
