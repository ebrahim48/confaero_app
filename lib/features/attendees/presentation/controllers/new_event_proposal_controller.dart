import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewEventProposalController extends GetxController {
  // Text Editing Controllers
  final emailController = TextEditingController();
  final eventNameController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  // Dropdown Values
  final RxString selectedAttendees = 'Select'.obs;
  final RxString selectedFutureEvents = 'Select'.obs;

  // Country Selection
  final Rx<Country?> selectedCountry = Rx<Country?>(null);
  String get countryCode => selectedCountry.value?.phoneCode ?? '';
  String get countryFlag => selectedCountry.value?.flagEmoji ?? '🏳️';
  String get countryName => selectedCountry.value?.name ?? 'Select Country';

  // Character count for message
  final RxInt messageCharCount = 0.obs;
  final int maxMessageChar = 200;

  // Dropdown Options - Updated based on image
  final List<String> attendeesOptions = [
    'Select',
    'More than 60,000',
    'Between 30,000 and 60,000',
    'Between 10,000 and 30,000',
    'Between 5,000 and 10,000',
    'Between 3,000 and 5,000',
    'Between 1,500 and 3,000',
    'Between 500 and 1,500',
    'Fewer than 500',
  ];

  final List<String> futureEventsOptions = [
    'Select',
    '1-2',
    '3-5',
    '6-10',
    '10+',
  ];

  @override
  void onInit() {
    super.onInit();
    // Listen to message text changes
    messageController.addListener(() {
      messageCharCount.value = messageController.text.length;
    });
  }

  void onAttendeesChanged(String? value) {
    if (value != null) {
      selectedAttendees.value = value;
    }
  }

  void onFutureEventsChanged(String? value) {
    if (value != null) {
      selectedFutureEvents.value = value;
    }
  }

  void selectCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.black),
        bottomSheetHeight: 500,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFFE1E1E1),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        selectedCountry.value = country;
      },
    );
  }

  void onSubmit() {
    // Validation
    if (emailController.text.isEmpty) {
      return;
    }
    if (eventNameController.text.isEmpty) {
      return;
    }
    if (selectedAttendees.value == 'Select') {
      return;
    }
    if (selectedFutureEvents.value == 'Select') {
      return;
    }
    if (countryController.text.isEmpty) {
      return;
    }
    if (selectedCountry.value == null || phoneController.text.isEmpty) {
      return;
    }
    if (messageController.text.isEmpty) {
      return;
    }

    // Submit logic here
    final phoneNumber = '+${selectedCountry.value!.phoneCode}${phoneController.text}';

    print('Email: ${emailController.text}');
    print('Event Name: ${eventNameController.text}');
    print('Attendees: ${selectedAttendees.value}');
    print('Future Events: ${selectedFutureEvents.value}');
    print('Country: ${countryController.text}');
    print('Phone: $phoneNumber');
    print('Message: ${messageController.text}');

  }

  @override
  void onClose() {
    emailController.dispose();
    eventNameController.dispose();
    countryController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.onClose();
  }
}