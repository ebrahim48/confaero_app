import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../data/reviewer_models.dart';
import 'cotroller/review_documents_controller.dart';

class PosterDetailScreen extends StatelessWidget {
  final SubmissionModel doc;
  const PosterDetailScreen({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewDocumentsController>(
        tag: doc.authorId.isNotEmpty ? doc.authorId : null);
    final RxBool showReviewPanel = false.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back,
              color: AppColors.textColor252525, size: 22.sp),
        ),
        title: Text(
          doc.title.isNotEmpty ? doc.title : 'Poster Detail',
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor252525),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Poster image preview
                Container(
                  margin: EdgeInsets.all(16.w),
                  width: double.infinity,
                  height: 460.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                        color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: doc.fileUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: doc.fileUrl,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primaryColor32A69A),
                            ),
                            errorWidget: (_, __, ___) => Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.broken_image_outlined,
                                      size: 40.sp,
                                      color: AppColors.textColor7E7F7E),
                                  SizedBox(height: 8.h),
                                  Text('Failed to load poster',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.textColor7E7F7E)),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image_outlined,
                                    size: 40.sp,
                                    color: AppColors.textColor7E7F7E),
                                SizedBox(height: 8.h),
                                Text('No image available',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.textColor7E7F7E)),
                              ],
                            ),
                          ),
                  ),
                ),

                // Author info
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: AppColors.borderColorD2D2D2,
                          backgroundImage: doc.authorAvatar.isNotEmpty
                              ? CachedNetworkImageProvider(doc.authorAvatar)
                              : null,
                          child: doc.authorAvatar.isEmpty
                              ? Icon(Icons.person,
                                  size: 18.sp, color: Colors.white)
                              : null,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.authorName,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor252525)),
                              Text(doc.authorRole,
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.textColor7E7F7E)),
                            ],
                          ),
                        ),
                        _statusBadge(doc.reviewStatus),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),

          // Bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showReviewPanel.value)
                      _PosterReviewPanel(
                        controller: controller,
                        attachmentId: doc.attachmentId,
                      ),

                    Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showReviewPanel.value = false;
                                _showRejectPosterSheet(context, controller, doc.attachmentId);
                              },
                              child: Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                      color: Colors.red.withOpacity(0.4)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.close,
                                        size: 16.sp, color: Colors.red),
                                    SizedBox(width: 4.w),
                                    Text('Reject',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => showReviewPanel.value =
                                  !showReviewPanel.value,
                              child: Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor32A69A,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: Text('Review',
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),

          // Flag for Admin
          Positioned(
            bottom: 86.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => _showFlagDialog(context, controller),
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, size: 16.sp, color: Colors.red),
                  SizedBox(width: 6.w),
                  Text('Flag for Admin',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color text;
    switch (status.toLowerCase()) {
      case 'approved':
        bg = const Color(0xffE8F8F5);
        text = AppColors.primaryColor32A69A;
        break;
      case 'rejected':
        bg = const Color(0xffFFEBEB);
        text = Colors.red;
        break;
      default:
        bg = const Color(0xffFFF8E6);
        text = const Color(0xffE5A000);
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: Text(status,
          style: TextStyle(
              fontSize: 10.sp, fontWeight: FontWeight.w500, color: text)),
    );
  }

  void _showRejectPosterSheet(
      BuildContext context, ReviewDocumentsController controller, String attachmentId) {
    final reasonCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reject Poster',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor252525)),
                  GestureDetector(
                    onTap: () => Navigator.of(sheetCtx).pop(),
                    child: Icon(Icons.close, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.borderColorD2D2D2),
                ),
                child: TextFormField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.w),
                    hintText: 'Reason for rejection (optional)',
                    hintStyle: TextStyle(
                        fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () => controller.rejectPoster(
                              sheetCtx, attachmentId, reasonCtrl.text.trim()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: controller.isSubmitting.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('Reject',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                    ),
                  )),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewSheet(
      BuildContext context, ReviewDocumentsController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReviewBottomSheet(controller: controller),
    );
  }

  void _showFlagDialog(
      BuildContext context, ReviewDocumentsController controller) {
    final reasonCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Flag for Admin',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor252525)),
                  GestureDetector(
                    onTap: () => Navigator.of(sheetCtx).pop(),
                    child: Icon(Icons.close, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.borderColorD2D2D2),
                ),
                child: TextFormField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.w),
                    hintText: 'Reason for flagging',
                    hintStyle: TextStyle(
                        fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetCtx).pop();
                    controller.flagToAdmin(
                        doc.attachmentId, reasonCtrl.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text('Flag',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PosterReviewPanel extends StatelessWidget {
  final ReviewDocumentsController controller;
  final String attachmentId;
  const _PosterReviewPanel({required this.controller, required this.attachmentId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, -4))
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xff2A2A2A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Poster review',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                Icon(Icons.keyboard_arrow_down,
                    color: Colors.white, size: 20.sp),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              children: [
                _radioRow('Originality / innovation', 'originality', controller),
                _radioRow('Scientific rigor:', 'scientific', controller),
                _radioRow('Clarity of message:', 'clarity', controller),
                _sliderRow('Visual design & layout:', 'visual', controller),
                _sliderRow('Impact / significance', 'impact', controller),
                _sliderRow('Presenter interaction', 'presenter', controller),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: Text('Overall impression',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor252525)),
                    ),
                    Text('(Award caliber)',
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textColor7E7F7E)),
                  ],
                ),
                SizedBox(height: 14.h),

                // Reason field — required by API
                Text('Review Reason *',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor252525)),
                SizedBox(height: 6.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.borderColorD2D2D2),
                  ),
                  child: TextField(
                    controller: controller.posterReasonController,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textColor252525),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      hintText: 'Enter review reason (required)',
                      hintStyle: TextStyle(
                          fontSize: 12.sp, color: AppColors.textColor7E7F7E),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : () => controller.submitPosterReview(
                                context, attachmentId),
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
                            : Text('Submit Review',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                      ),
                    )),
                SizedBox(height: 6.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioRow(
      String label, String key, ReviewDocumentsController ctrl) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textColor252525)),
          ),
          Obx(() => Text(
                '${ctrl.posterScores[key]?.toInt() ?? 0}/10',
                style:
                    TextStyle(fontSize: 12.sp, color: AppColors.textColor7E7F7E),
              )),
          SizedBox(width: 8.w),
          Obx(() => Radio<double>(
                value: 0,
                groupValue: ctrl.posterScores[key],
                onChanged: (v) => ctrl.updateScore(key, v ?? 0),
                activeColor: AppColors.primaryColor32A69A,
              )),
        ],
      ),
    );
  }

  Widget _sliderRow(
      String label, String key, ReviewDocumentsController ctrl) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textColor252525)),
              ),
              Obx(() => Text(
                    '${ctrl.posterScores[key]?.toInt() ?? 0}/10',
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textColor7E7F7E),
                  )),
            ],
          ),
          Obx(() => SliderTheme(
                data: SliderThemeData(
                  thumbColor: AppColors.primaryColor32A69A,
                  activeTrackColor: AppColors.primaryColor32A69A,
                  inactiveTrackColor: const Color(0xffE0E0E0),
                  trackHeight: 3,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 7),
                ),
                child: Slider(
                  value: ctrl.posterScores[key] ?? 0,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (v) => ctrl.updateScore(key, v),
                ),
              )),
        ],
      ),
    );
  }
}

class _ReviewBottomSheet extends StatelessWidget {
  final ReviewDocumentsController controller;
  const _ReviewBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      icon: const Icon(Icons.keyboard_arrow_down),
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
                  hintText: 'Add a reason',
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: AppColors.textColor7E7F7E),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border:
                            Border.all(color: Colors.red.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, size: 16.sp, color: Colors.red),
                          SizedBox(width: 4.w),
                          Text('No',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Obx(() => GestureDetector(
                        onTap: controller.isSubmitting.value
                            ? null
                            : () => controller.submitReview(context),
                        child: Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor32A69A,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: controller.isSubmitting.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check,
                                        size: 16.sp, color: Colors.white),
                                    SizedBox(width: 4.w),
                                    Text('Yes',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ],
                                ),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
