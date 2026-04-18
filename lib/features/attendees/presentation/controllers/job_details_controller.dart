import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/job_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

// Job Details Model
class JobDetails {
  final String id;
  final String companyName;
  final String position;
  final String jobType;
  final String location;
  final String lastDate;
  final String salary;
  final String description;
  final List<String> requirements;
  final String locationAddress;
  final String mapImage;

  // Informations
  final String positionInfo;
  final String qualification;
  final String experience;
  final String jobTypeInfo;
  final String specialization;

  // Facilities
  final List<String> facilities;

  JobDetails({
    required this.id,
    required this.companyName,
    required this.position,
    required this.jobType,
    required this.location,
    required this.lastDate,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.locationAddress,
    required this.mapImage,
    required this.positionInfo,
    required this.qualification,
    required this.experience,
    required this.jobTypeInfo,
    required this.specialization,
    required this.facilities,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      companyName:
          json['companyName']?.toString() ?? json['company']?.toString() ?? '',
      position: json['position']?.toString() ?? json['title']?.toString() ?? '',
      jobType: json['jobType']?.toString() ?? 'Full Time',
      location: json['location']?.toString() ?? '',
      lastDate:
          json['lastDate']?.toString() ?? json['deadline']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      requirements:
          (json['requirements'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      locationAddress:
          json['locationAddress']?.toString() ??
          json['address']?.toString() ??
          '',
      mapImage: json['mapImage']?.toString() ?? 'assets/images/demomap.png',
      positionInfo:
          json['positionInfo']?.toString() ??
          json['position']?.toString() ??
          '',
      qualification: json['qualification']?.toString() ?? '',
      experience: json['experience']?.toString() ?? '',
      jobTypeInfo:
          json['jobTypeInfo']?.toString() ?? json['jobType']?.toString() ?? '',
      specialization: json['specialization']?.toString() ?? '',
      facilities:
          (json['facilities'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}

class JobDetailsController extends GetxController {
  final JobService _jobService = Get.find<JobService>();

  // Job details data
  final jobDetails = Rx<JobDetails?>(null);

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Load job details from API
  Future<void> loadJobDetails(String jobId) async {
    isLoading.value = true;
    try {
      final data = await _jobService.getJobDetails(jobId);
      if (data != null) {
        jobDetails.value = JobDetails.fromJson(data);
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load job details', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  // Apply for job
  void applyForJob() {
    ToastMessageHelper.showToastMessage('Your application has been submitted', title: 'Success');
  }
}
