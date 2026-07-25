import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import '../../../../presentations/widgets/custom_text.dart';

class MapLocationCard extends StatelessWidget {
  final String locationName;
  final VoidCallback onTap;
  final double? latitude;
  final double? longitude;

  const MapLocationCard({
    super.key,
    required this.locationName,
    required this.onTap,
    this.latitude,
    this.longitude,
  });

  bool get _hasCoordinates => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 349.w,
          height: 98.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _hasCoordinates ? _buildMap() : _buildPlaceholder(),

              // Bottom gradient + location label
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x99000000)],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on,
                        color: const Color(0xffF6F6F6), size: 18.sp),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: CustomText(
                        text: locationName,
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffF6F6F6),
                        textAlign: TextAlign.start,
                        textDecoration: TextDecoration.underline,
                        maxline: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    final point = LatLng(latitude!, longitude!);
    return FlutterMap(
      options: MapOptions(
        initialCenter: point,
        initialZoom: 14,
        // Static preview — tapping the card opens the external map instead.
        interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.confaero.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: point,
              width: 40.w,
              height: 40.w,
              alignment: Alignment.topCenter,
              child: Icon(Icons.location_on,
                  color: Colors.red.shade600, size: 36.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(color: Colors.grey[300]);
  }
}
