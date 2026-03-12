import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/document_controller.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../document_filter_chips.dart';
import '../document_item_widget.dart';
import '../document_search_field_widget.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentsController controller = Get.put(DocumentsController());

    return Scaffold(
      body: Column(
        children: [
          // App Bar
          const CustomAppBarWidget(title: 'Documents'),

          // Search Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: SearchField(
              controller: controller.searchController,
              hintText: 'Search document, abstracts, booklet etc',
            ),
          ),

          // Filter Chips
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(() {
              return Row(
                children: [
                  FilterChipButton(
                    text: 'All Files',
                    isSelected: controller.selectedFilter.value == 0,
                    onTap: () => controller.changeFilter(0),
                  ),
                  SizedBox(width: 16.w),
                  FilterChipButton(
                    text: 'Abstracts',
                    isSelected: controller.selectedFilter.value == 1,
                    onTap: () => controller.changeFilter(1),
                  ),
                  SizedBox(width: 16.w),
                  FilterChipButton(
                    text: 'Booklet',
                    isSelected: controller.selectedFilter.value == 2,
                    onTap: () => controller.changeFilter(2),
                  ),
                  SizedBox(width: 16.w),
                  FilterChipButton(
                    text: 'Floor map',
                    isSelected: controller.selectedFilter.value == 3,
                    onTap: () => controller.changeFilter(3),
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 16.h),

          // Documents List
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: const Color(0xffFCFCFC),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Obx(() {
                final documents = controller.filteredDocuments;

                if (documents.isEmpty) {
                  return Center(
                    child: Text(
                      'No documents found',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xff757575),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: DocumentItem(
                        title: document.name,
                        subtitle: document.createdAt,
                        fileSize: 'N/A', // Or size calculation if available
                        iconPath: 'assets/images/pdf1.png',
                        showArrow: true,
                        onTap: () => controller.openDocument(document),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
