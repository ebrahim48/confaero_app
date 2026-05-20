import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../data/reviewer_models.dart';
import 'cotroller/review_documents_controller.dart';

class AbstractDetailScreen extends StatelessWidget {
  final SubmissionModel doc;
  const AbstractDetailScreen({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewDocumentsController>(tag: doc.authorId.isNotEmpty ? doc.authorId : null);

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
          doc.title.isNotEmpty ? doc.title : 'Abstract Detail',
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor252525),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: _authorCard(),
            ),

            // PDF Preview placeholder
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              width: double.infinity,
              constraints: BoxConstraints(minHeight: 400.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF0F0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf,
                            color: Colors.red, size: 20.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            doc.title,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor252525),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('Author', doc.authorName),
                        _infoRow('Role', doc.authorRole),
                        _infoRow('Uploaded', _formatDate(doc.uploadedAt)),
                        if (doc.dueDate.isNotEmpty)
                          _infoRow('Due', _formatDate(doc.dueDate)),
                        _infoRow('Status', doc.reviewStatus),
                        if (doc.sizeLabel.isNotEmpty)
                          _infoRow('Size', doc.sizeLabel),
                        SizedBox(height: 16.h),
                        if (doc.fileUrl.isNotEmpty) ...[
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // Open URL in browser
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xffEAF4FF),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.open_in_new,
                                        size: 16.sp,
                                        color: const Color(0xff1A73E8)),
                                    SizedBox(width: 6.w),
                                    Text('Open PDF',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: const Color(0xff1A73E8),
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      label: 'Reject',
                      icon: Icons.close,
                      color: Colors.red,
                      borderColor: Colors.red.withOpacity(0.3),
                      bgColor: Colors.red.withOpacity(0.05),
                      onTap: () {
                        controller.prepareReview(doc.attachmentId, 'Reject');
                        _showReviewReport(context, controller);
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _actionBtn(
                      label: 'Revise',
                      icon: Icons.refresh,
                      color: AppColors.primaryColor32A69A,
                      borderColor: AppColors.primaryColor32A69A.withOpacity(0.3),
                      bgColor: AppColors.primaryColor32A69A.withOpacity(0.05),
                      onTap: () {
                        controller.prepareReview(doc.attachmentId, 'Revise');
                        _showReviewReport(context, controller);
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _actionBtn(
                      label: 'Approve',
                      icon: Icons.check,
                      color: AppColors.primaryColor32A69A,
                      borderColor: AppColors.primaryColor32A69A,
                      bgColor: AppColors.primaryColor32A69A,
                      textColor: Colors.white,
                      onTap: () {
                        controller.prepareReview(doc.attachmentId, 'Approve');
                        _showReviewReport(context, controller);
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            Center(
              child: GestureDetector(
                onTap: () => _showFlagDialog(context, controller),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_outlined,
                        size: 16.sp, color: Colors.red),
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

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _authorCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppColors.borderColorD2D2D2.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: AppColors.borderColorD2D2D2,
            backgroundImage: doc.authorAvatar.isNotEmpty
                ? CachedNetworkImageProvider(doc.authorAvatar)
                : null,
            child: doc.authorAvatar.isEmpty
                ? Icon(Icons.person, size: 22.sp, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.authorName,
                    style: TextStyle(
                        fontSize: 14.sp,
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
    );
  }

  Widget _infoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textColor7E7F7E,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textColor252525)),
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

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required Color borderColor,
    required Color bgColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.sp, color: textColor ?? color),
            SizedBox(width: 4.w),
            Text(label,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? color)),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return iso.length > 10 ? iso.substring(0, 10) : iso;
    }
  }

  void _showReviewReport(
      BuildContext context, ReviewDocumentsController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReviewReportSheet(controller: controller),
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

class _ReviewReportSheet extends StatelessWidget {
  final ReviewDocumentsController controller;
  const _ReviewReportSheet({required this.controller});

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
                  height: 50.h,
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
