import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/photo_model.dart';

/// Full-screen, pinch-to-zoom viewer for a single event photo.
class PhotoViewerScreen extends StatelessWidget {
  final PhotoModel photo;

  const PhotoViewerScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: photo.imageUrl.isEmpty
                      ? _placeholder()
                      : CachedNetworkImage(
                          imageUrl: photo.imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(
                                color: Colors.white54),
                          ),
                          errorWidget: (_, __, ___) => _placeholder(),
                        ),
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
                tooltip: 'Close',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Icon(
        Icons.broken_image_outlined,
        size: 64.sp,
        color: Colors.white38,
      );
}
