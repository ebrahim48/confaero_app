import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../presentations/widgets/custom_network_image.dart';

class ExhibitorBannerWidget extends StatelessWidget {
  final String imagePath;

  const ExhibitorBannerWidget({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: const Color(0xFF707070), width: 1);
    final borderRadius = BorderRadius.circular(12.r);

    if (imagePath.startsWith('http')) {
      return CustomNetworkImage(
        imageUrl: imagePath,
        width: 346.w,
        height: 197.h,
        border: border,
        borderRadius: borderRadius,
      );
    }

    return Container(
      width: 346.w,
      height: 197.h,
      decoration: BoxDecoration(borderRadius: borderRadius, border: border),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}