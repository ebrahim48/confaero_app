import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}

class JobOpeningsController extends GetxController {
  // Search controller
  final searchController = TextEditingController();

  // Selected filter
  final selectedFilter = 'All'.obs;

  // Job list
  final jobs = <Job>[].obs;

  // Loading state
  final isLoading = false.obs;

  // Filter options
  final filterOptions = [
    'All',
    'Full-time',
    'internship',
    'Remote',
    'On-site',
  ];

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

  // Load jobs (static data - pore API theke anba)
  void loadJobs() {
    isLoading.value = true;

    // Static data - 6 ta job
    jobs.value = [
      Job(
        id: '1',
        companyName: 'Betopia Group',
        position: 'UX/UI Designer',
        jobType: 'Full Time',
        location: 'Job Address, Dhaka , bangladesh',
        lastDate: '12 Feb, 2026',
        applicants: 5,
        salary: '\$20k/Month',
      ),
      Job(
        id: '2',
        companyName: 'Betopia Group',
        position: 'UX/UI Designer',
        jobType: 'Full Time',
        location: 'Job Address, Dhaka , bangladesh',
        lastDate: '12 Feb, 2026',
        applicants: 5,
        salary: '\$20k/Month',
      ),
      Job(
        id: '3',
        companyName: 'Betopia Group',
        position: 'UX/UI Designer',
        jobType: 'Full Time',
        location: 'Job Address, Dhaka , bangladesh',
        lastDate: '12 Feb, 2026',
        applicants: 5,
        salary: '\$20k/Month',
      ),
      Job(
        id: '4',
        companyName: 'Betopia Group',
        position: 'UX/UI Designer',
        jobType: 'Full Time',
        location: 'Job Address, Dhaka , bangladesh',
        lastDate: '12 Feb, 2026',
        applicants: 5,
        salary: '\$20k/Month',
      ),
      Job(
        id: '5',
        companyName: 'Betopia Group',
        position: 'UX/UI Designer',
        jobType: 'Full Time',
        location: 'Job Address, Dhaka , bangladesh',
        lastDate: '12 Feb, 2026',
        applicants: 5,
        salary: '\$20k/Month',
      ),
      Job(
        id: '6',
        companyName: 'Betopia Group',
        position: 'UX/UI Designer',
        jobType: 'Full Time',
        location: 'Job Address, Dhaka , bangladesh',
        lastDate: '12 Feb, 2026',
        applicants: 5,
        salary: '\$20k/Month',
      ),
    ];

    isLoading.value = false;
  }

  // Select filter
  void selectFilter(String filter) {
    selectedFilter.value = filter;
    // TODO: Filter jobs based on selected filter
  }

  // Search jobs
  void searchJobs(String query) {
    // TODO: Implement search functionality
    print('Searching for: $query');
  }

  // Refresh jobs
  Future<void> refreshJobs() async {
    await Future.delayed(const Duration(seconds: 1));
    loadJobs();
  }

  // Get filtered jobs
  List<Job> get filteredJobs {
    if (selectedFilter.value == 'All') {
      return jobs;
    }
    return jobs
        .where((job) => job.jobType.toLowerCase() ==
        selectedFilter.value.toLowerCase())
        .toList();
  }
}