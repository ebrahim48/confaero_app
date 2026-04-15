import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExhibitorBannerWidget extends StatelessWidget {
  final String imagePath;

  const ExhibitorBannerWidget({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 346.w,
      height: 197.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF707070),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: imagePath.startsWith('http')
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF5F5F5),
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
              )
            : Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}