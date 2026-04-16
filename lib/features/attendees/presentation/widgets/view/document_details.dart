import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/document_controller.dart';
import '../custom_app_bar_widget.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final String documentId;

  const DocumentDetailsScreen({super.key, required this.documentId});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  late final DocumentsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DocumentsController>();
    controller.fetchDocumentDetails(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final details = controller.documentDetails.value;
        final isLoading = controller.isLoadingDetails.value;

        final title = details?.documentName.isNotEmpty == true
            ? details!.documentName
            : details?.documentType ?? 'Document';

        return Column(
          children: [
            CustomAppBarWidget(title: isLoading ? '...' : title),

            Expanded(
              child: isLoading
                  ? _DocumentDetailsShimmer()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFDFDFDF),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/viewpdf.png',
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 742.h,
                              color: const Color(0xFFE0E0E0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf,
                                      size: 80.sp,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'PDF not found',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

class _DocumentDetailsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PDF preview placeholder
            Container(
              width: double.infinity,
              height: 742.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: const Color(0xFFDFDFDF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
