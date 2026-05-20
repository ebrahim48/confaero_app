import 'package:confaero_app/features/abstractreviewer/presentation/widgets/abstract_doc_card.dart';
import 'package:confaero_app/features/abstractreviewer/presentation/widgets/content_tab_switch.dart';
import 'package:confaero_app/features/abstractreviewer/presentation/widgets/poster_doc_card.dart';
import 'package:confaero_app/features/abstractreviewer/presentation/widgets/reviewer_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/config/approutes/app_routes.dart';
import '../data/reviewer_models.dart';
import 'cotroller/review_documents_controller.dart';

class ReviewDocumentsScreen extends StatelessWidget {
  final AuthorModel author;
  const ReviewDocumentsScreen({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ReviewDocumentsController(authorId: author.authorId, author: author),
      tag: author.authorId,
    );

    return Obx(() {
      final isPoster = controller.selectedTab.value == 'Posters';
      return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xffF5F5F5),
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back,
                color: AppColors.textColor252525, size: 22.sp),
          ),
          title: Text(
            isPoster ? 'Review Posters' : 'Review Documents',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor252525),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ReviewerInfoCard(author: author),
            ),
            SizedBox(height: 14.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ContentTabSwitch(
                selectedTab: controller.selectedTab.value,
                onSelect: controller.setTab,
              ),
            ),
            SizedBox(height: 14.h),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _shimmerList();
                }
                final docs = isPoster
                    ? controller.posterDocs
                    : controller.abstractDocs;
                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      isPoster ? 'No posters yet' : 'No abstracts yet',
                      style: TextStyle(
                          fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) {
                    final doc = docs[i];
                    if (isPoster) {
                      return PosterDocCard(
                        doc: doc,
                        onView: () => context.pushNamed(
                          AppRoutes.posterDetailScreen,
                          extra: doc,
                        ),
                        onReject: () {
                          controller.prepareReview(doc.attachmentId, 'Reject');
                          _showReviewSheet(context, controller);
                        },
                        onReview: () => context.pushNamed(
                          AppRoutes.posterDetailScreen,
                          extra: doc,
                        ),
                      );
                    }
                    return AbstractDocCard(
                      doc: doc,
                      onView: () => context.pushNamed(
                        AppRoutes.abstractDetailScreen,
                        extra: doc,
                      ),
                      onReject: () {
                        controller.prepareReview(doc.attachmentId, 'Reject');
                        _showReviewSheet(context, controller);
                      },
                      onRevise: () {
                        controller.prepareReview(doc.attachmentId, 'Revise');
                        _showReviewSheet(context, controller);
                      },
                      onApprove: () {
                        controller.prepareReview(doc.attachmentId, 'Approve');
                        _showReviewSheet(context, controller);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  void _showReviewSheet(BuildContext context, ReviewDocumentsController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _ReviewReportSheet(controller: controller),
    );
  }

  Widget _shimmerList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 4,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xffE0E0E0),
        highlightColor: const Color(0xffF5F5F5),
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

class _ReviewReportSheet extends StatelessWidget {
  final ReviewDocumentsController controller;
  const _ReviewReportSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Review report',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor252525)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close,
                      size: 20.sp, color: AppColors.textColor7E7F7E),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            Text('Review Type *',
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor252525)),
            SizedBox(height: 8.h),

            Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderColorD2D2D2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.reviewType.value,
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: AppColors.textColor424242),
                  items: controller.reviewTypes
                      .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(t,
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textColor424242))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.reviewType.value = val;
                  },
                ),
              ),
            )),
            SizedBox(height: 16.h),

            Text('Reason',
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor252525)),
            SizedBox(height: 8.h),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderColorD2D2D2),
              ),
              child: TextFormField(
                controller: controller.reasonController,
                maxLines: 4,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textColor424242),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 12.h),
                  hintText: 'Add a reason (optional for Approve)',
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => controller.submitReview(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor32A69A,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text('Submit',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
              ),
            )),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
