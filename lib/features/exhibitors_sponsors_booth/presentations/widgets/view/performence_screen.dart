import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../controllers/booth_controllers.dart';


class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BoothController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text(
          'Performance',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor252525,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Total Scans Card ──────────────────────────────────
            Obx(() => _totalScansCard(controller.totalScans.value)),
            SizedBox(height: 14.h),

            // ── Traffic Over Time Card ────────────────────────────
            Obx(() => _trafficCard(controller.weeklyScans)),

            SizedBox(height: 20.h),

            // ── Recent Leads ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Lead',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor252525,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor32A69A,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Obx(() => Column(
              children: controller.recentLeads
                  .map((lead) => _leadTile(lead))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _totalScansCard(int count) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: const Color(0xffE8F8F5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.qr_code,
                color: AppColors.textColor252525, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Scans',
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textColor7E7F7E),
              ),
              SizedBox(height: 2.h),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor252525,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trafficCard(RxList<double> weeklyScans) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Traffic Over Time',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor252525,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: Color(0xff7B9FDE),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Scans',
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textColor7E7F7E),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: CustomPaint(
              painter: _LineChartPainter(weeklyScans),
              child: const SizedBox.expand(),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
                  (i) => Text(
                'week ${i + 1}',
                style: TextStyle(
                    fontSize: 9.sp, color: AppColors.textColor7E7F7E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadTile(Map<String, dynamic> lead) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundImage: AssetImage(lead['image']),
            backgroundColor: AppColors.borderColorD2D2D2,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lead['name'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor252525,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  lead['role'],
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textColor7E7F7E),
                ),
              ],
            ),
          ),
          Text(
            lead['time'],
            style: TextStyle(
                fontSize: 11.sp, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double maxY = 100;
    const double minY = 0;
    final double chartWidth = size.width;
    final double chartHeight = size.height;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xffE8E8E8)
      ..strokeWidth = 1;

    final yLabels = [0.0, 20.0, 40.0, 60.0, 80.0, 100.0];
    for (final y in yLabels) {
      final dy = chartHeight - (y / maxY) * chartHeight;
      canvas.drawLine(Offset(0, dy), Offset(chartWidth, dy), gridPaint);
    }

    // Gradient fill under line
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = i * chartWidth / (data.length - 1);
      final y = chartHeight - ((data[i] - minY) / (maxY - minY)) * chartHeight;
      points.add(Offset(x, y));
    }

    final fillPath = Path()..moveTo(points.first.dx, chartHeight);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff7B9FDE).withOpacity(0.3),
          const Color(0xff7B9FDE).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, chartWidth, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = const Color(0xff7B9FDE)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Dots
    for (int i = 0; i < points.length; i++) {
      final isHighlighted = i == data.length - 2; // green highlight
      final dotPaint = Paint()
        ..color = isHighlighted
            ? const Color(0xff32A69A)
            : const Color(0xff7B9FDE)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(points[i], isHighlighted ? 6 : 4, dotPaint);

      final outerPaint = Paint()
        ..color = isHighlighted
            ? const Color(0xff32A69A).withOpacity(0.2)
            : const Color(0xff7B9FDE).withOpacity(0.2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i], isHighlighted ? 10 : 7, outerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}