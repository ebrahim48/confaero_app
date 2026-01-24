import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;
  final int starCount;
  final Color activeColor;
  final Color inactiveColor;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starCount = 5,
    this.activeColor = const Color(0xffFFC107),
    this.inactiveColor = const Color(0xffE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: EdgeInsets.only(right: index < starCount - 1 ? 11.w : 0),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              size: 32.sp,
              color: index < rating ? activeColor : inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}