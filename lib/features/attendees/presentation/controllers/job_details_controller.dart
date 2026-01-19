import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}

class JobDetailsController extends GetxController {
  // Job details data
  final jobDetails = Rx<JobDetails?>(null);

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadJobDetails();
  }

  // Load job details (static data)
  void loadJobDetails() {
    isLoading.value = true;

    // Static job details
    jobDetails.value = JobDetails(
      id: '1',
      companyName: 'Betopia Group',
      position: 'UX/UI Designer',
      jobType: 'Full Time',
      location: 'Job Address, Dhaka , bangladesh',
      lastDate: '12 Feb, 2026',
      salary: '\$20k/Month',
      description:
      'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
          'accusantium doloremque laudantium, totam rem aperiam, '
          'eaque ipsa quae ab illo inventore veritatis et quasi architecto '
          'beatae vitae dicta sunt explicabo. Nemo enim ipsam volatem '
          'doloremque laudantium...',
      requirements: [
        'Sed ut perspiciatis unde omnis iste natus error sit.',
        'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur & adipisci velit.',
        'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.',
        'Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur',
      ],
      locationAddress: 'Overlook Avenue, Belleville, NJ, USA',
      mapImage: 'assets/images/demomap.png',
      positionInfo: 'Senior Designer',
      qualification: 'Bachelor\'s Degree',
      experience: '3 Years',
      jobTypeInfo: 'Full-Time',
      specialization: 'Design',
      facilities: [
        'Medical',
        'Dental',
        'Technical Certification',
        'Meal Allowance',
      ],
    );

    isLoading.value = false;
  }

  // Apply for job
  void applyForJob() {
    Get.snackbar(
      'Success',
      'Your application has been submitted',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xff32A69A),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );

    // TODO: Backend e application pathano
    // await api.applyJob(jobId);
  }
}