import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/job_service.dart';
import 'package:confaero_app/core/helpers/toast_message_helper.dart';

// Job Model
class Job {
  final String id;
  final String companyName;
  final String position;
  final String jobType;
  final String location;
  final String lastDate;
  final int applicants;
  final String salary;
  final String? imageUrl;

  Job({
    required this.id,
    required this.companyName,
    required this.position,
    required this.jobType,
    required this.location,
    required this.lastDate,
    required this.applicants,
    required this.salary,
    this.imageUrl,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      companyName:
          json['companyName']?.toString() ?? json['company']?.toString() ?? '',
      position: json['position']?.toString() ?? json['title']?.toString() ?? '',
      jobType: json['jobType']?.toString() ?? 'Full Time',
      location: json['location']?.toString() ?? '',
      lastDate:
          json['lastDate']?.toString() ?? json['deadline']?.toString() ?? '',
      applicants: json['applicants'] as int? ?? 0,
      salary: json['salary']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['logo']?.toString(),
    );
  }
}

class JobOpeningsController extends GetxController {
  final JobService _jobService = Get.find<JobService>();

  // Search controller
  final searchController = TextEditingController();

  // Selected filter
  final selectedFilter = 'All'.obs;

  // Job list
  final jobs = <Job>[].obs;
  final allJobs = <Job>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Filter options
  final filterOptions = ['All', 'Full-time', 'internship', 'Remote', 'On-site'];

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load jobs from API
  Future<void> loadJobs() async {
    isLoading.value = true;
    try {
      final data = await _jobService.getJobs();
      final parsed = data.map((j) => Job.fromJson(j)).toList();
      allJobs.assignAll(parsed);
      jobs.assignAll(parsed);
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load jobs', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  // Select filter
  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Search jobs
  void searchJobs(String query) {
    if (query.isEmpty) {
      jobs.assignAll(allJobs);
    } else {
      jobs.assignAll(
        allJobs
            .where(
              (j) =>
                  j.position.toLowerCase().contains(query.toLowerCase()) ||
                  j.companyName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  // Refresh jobs
  Future<void> refreshJobs() async {
    await loadJobs();
  }

  // Get filtered jobs
  List<Job> get filteredJobs {
    if (selectedFilter.value == 'All') {
      return jobs;
    }
    return jobs
        .where(
          (job) =>
              job.jobType.toLowerCase() == selectedFilter.value.toLowerCase(),
        )
        .toList();
  }

  // ======================== Organizer/Exhibitor Job Management ========================

  final myJobPosts = <Map<String, dynamic>>[].obs;
  final jobsForReview = <Map<String, dynamic>>[].obs;
  final isSaving = false.obs;

  Future<void> createJob(Map<String, dynamic> data) async {
    try {
      isSaving.value = true;
      await _jobService.createJob(data);
      ToastMessageHelper.showToastMessage('Job created', title: 'Success');
      loadJobs();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to create job', title: 'Error');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> loadMyJobPosts() async {
    try {
      isLoading.value = true;
      final response = await _jobService.getMyJobPosts();
      if (response['data'] is List) {
        myJobPosts.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load my jobs', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadJobReview() async {
    try {
      isLoading.value = true;
      final response = await _jobService.getJobReview();
      if (response['data'] is List) {
        jobsForReview.value =
            (response['data'] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to load jobs for review', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateJobStatus(String jobId, Map<String, dynamic> data) async {
    try {
      await _jobService.updateJobStatus(jobId, data);
      ToastMessageHelper.showToastMessage('Job status updated', title: 'Success');
      loadJobs();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to update job status', title: 'Error');
    }
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    try {
      await _jobService.updateJob(jobId, data);
      ToastMessageHelper.showToastMessage('Job updated', title: 'Success');
      loadJobs();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to update job', title: 'Error');
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await _jobService.deleteJob(jobId);
      ToastMessageHelper.showToastMessage('Job deleted', title: 'Success');
      loadJobs();
    } catch (e) {
      ToastMessageHelper.showToastMessage('Failed to delete job', title: 'Error');
    }
  }
}
