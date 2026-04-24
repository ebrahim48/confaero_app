import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controllers/booth_controllers.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  late final BoothController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<BoothController>()) {
      controller = Get.put(BoothController());
    } else {
      controller = Get.find<BoothController>();
    }
    controller.loadPerformance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmer();
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Total Scans Card ──────────────────────────────────
              Obx(() => _totalScansCard(controller.totalScans.value)),
              SizedBox(height: 14.h),

              // ── Traffic Over Time Card ────────────────────────────
              Obx(() {
                final values = controller.chartScanValues;
                final labels = controller.chartLabels;
                if (values.isEmpty) return const SizedBox.shrink();
                return _trafficCard(values, labels);
              }),

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

              Obx(() => controller.recentLeads.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          'No leads yet',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textColor7E7F7E),
                        ),
                      ),
                    )
                  : Column(
                      children: controller.recentLeads
                          .map((lead) => _leadTile(lead))
                          .toList(),
                    )),
            ],
          ),
        );
      }),
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

  double _yMax(List<double> values) {
    if (values.isEmpty) return 100;
    final max = values.reduce((a, b) => a > b ? a : b);
    if (max <= 20) return 20;
    if (max <= 40) return 40;
    if (max <= 60) return 60;
    if (max <= 80) return 80;
    if (max <= 100) return 100;
    return ((max / 20).ceil() * 20).toDouble();
  }

  Widget _trafficCard(List<double> values, List<String> labels) {
    final yMax = _yMax(values);
    const chartHeight = 180.0;

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
          // Title + Legend
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

          // Chart row: y-axis labels + chart area
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis labels
              SizedBox(
                height: chartHeight.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    final val = (yMax * (5 - i) / 5).round();
                    return Text(
                      val.toString(),
                      style: TextStyle(
                          fontSize: 9.sp, color: AppColors.textColor7E7F7E),
                    );
                  }),
                ),
              ),
              SizedBox(width: 6.w),

              // Chart + x-axis labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: chartHeight.h,
                      child: CustomPaint(
                        painter: _LineChartPainter(values, yMax: yMax),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: labels
                          .map((label) => Text(
                                label,
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    color: AppColors.textColor7E7F7E),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _leadTile(Map<String, dynamic> lead) {
    final avatarRaw = lead['avatar'];
    final avatarUrl = (avatarRaw != null && avatarRaw.toString().isNotEmpty)
        ? avatarRaw.toString()
        : '';
    final name = lead['name']?.toString() ?? '';
    final designation = lead['designation']?.toString() ?? '';
    final company = lead['company']?.toString() ?? '';
    final scannedAt = lead['scannedAt']?.toString() ?? '';
    final timeLabel = _formatTime(scannedAt);
    final roleLabel =
        [designation, company].where((s) => s.isNotEmpty).join(' @ ');

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
            backgroundImage: avatarUrl.startsWith('http')
                ? NetworkImage(avatarUrl) as ImageProvider
                : const AssetImage('assets/images/profile.png'),
            backgroundColor: AppColors.borderColorD2D2D2,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor252525,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  roleLabel,
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textColor7E7F7E),
                ),
              ],
            ),
          ),
          Text(
            timeLabel,
            style:
                TextStyle(fontSize: 11.sp, color: AppColors.textColor7E7F7E),
          ),
        ],
      ),
    );
  }

  String _formatTime(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final min = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '$hour:$min $period';
    } catch (_) {
      return '';
    }
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              height: 260.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 20.h),
            Container(width: 100.w, height: 14.h, color: Colors.white),
            SizedBox(height: 12.h),
            ...List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Container(
                  width: double.infinity,
                  height: 62.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final double yMax;

  const _LineChartPainter(this.data, {this.yMax = 100});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final w = size.width;
    final h = size.height;

    if (data.length == 1) {
      _drawDot(canvas, Offset(w / 2, h / 2), true);
      return;
    }

    final effectiveMax = yMax > 0 ? yMax : 1.0;

    // ── Grid lines (dashed) ───────────────────────────────────────
    final gridPaint = Paint()
      ..color = const Color(0xffDDDDDD)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Horizontal — 6 lines matching y-axis labels (0%, 20%, …, 100%)
    for (int i = 0; i <= 5; i++) {
      final dy = i * h / 5;
      _drawDashed(canvas, Offset(0, dy), Offset(w, dy), gridPaint);
    }

    // Vertical — one per data point
    for (int i = 0; i < data.length; i++) {
      final dx = i * w / (data.length - 1);
      _drawDashed(canvas, Offset(dx, 0), Offset(dx, h), gridPaint);
    }

    // ── Compute points ────────────────────────────────────────────
    final pts = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = i * w / (data.length - 1);
      final y = (h - (data[i] / effectiveMax) * h).clamp(0.0, h);
      pts.add(Offset(x, y));
    }

    // ── Smooth bezier line ────────────────────────────────────────
    final linePaint = Paint()
      ..color = const Color(0xff7B9FDE)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final midX = (pts[i].dx + pts[i + 1].dx) / 2;
      path.cubicTo(midX, pts[i].dy, midX, pts[i + 1].dy,
          pts[i + 1].dx, pts[i + 1].dy);
    }
    canvas.drawPath(path, linePaint);

    // ── Dots ──────────────────────────────────────────────────────
    for (int i = 0; i < pts.length; i++) {
      _drawDot(canvas, pts[i], i == pts.length - 1);
    }
  }

  void _drawDot(Canvas canvas, Offset c, bool highlighted) {
    if (highlighted) {
      // Outer translucent halo
      canvas.drawCircle(c, 14,
          Paint()
            ..color = const Color(0xff32A69A).withOpacity(0.15)
            ..style = PaintingStyle.fill);
      // Green ring
      canvas.drawCircle(c, 9,
          Paint()
            ..color = const Color(0xff32A69A)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
      // White fill
      canvas.drawCircle(c, 8,
          Paint()
            ..color = const Color(0xffffffff)
            ..style = PaintingStyle.fill);
      // Green center dot
      canvas.drawCircle(c, 4,
          Paint()
            ..color = const Color(0xff32A69A)
            ..style = PaintingStyle.fill);
    } else {
      // Translucent blue halo
      canvas.drawCircle(c, 10,
          Paint()
            ..color = const Color(0xff7B9FDE).withOpacity(0.2)
            ..style = PaintingStyle.fill);
      // Solid blue dot
      canvas.drawCircle(c, 5,
          Paint()
            ..color = const Color(0xff7B9FDE)
            ..style = PaintingStyle.fill);
    }
  }

  void _drawDashed(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 4.0;
    const gap = 4.0;
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final dist = Offset(dx, dy).distance;
    if (dist == 0) return;
    final ux = dx / dist;
    final uy = dy / dist;
    double pos = 0;
    bool draw = true;
    while (pos < dist) {
      final seg = draw ? dash : gap;
      final next = (pos + seg).clamp(0.0, dist);
      if (draw) {
        canvas.drawLine(
          Offset(start.dx + ux * pos, start.dy + uy * pos),
          Offset(start.dx + ux * next, start.dy + uy * next),
          paint,
        );
      }
      pos = next;
      draw = !draw;
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.data != data || old.yMax != yMax;
}
