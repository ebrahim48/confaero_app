import 'package:confaero_app/presentations/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/new_event_proposal_controller.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../../widgets/form_field_widget.dart';
import '../customdropdown_widget.dart';
import '../message_input_widgtet.dart';
import '../phoneinput_widget.dart';

class NewEventProposalScreen extends StatelessWidget {
  const NewEventProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewEventProposalController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom App Bar
          CustomAppBarWidget(
            title: 'New Event proposal',
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  FormFieldWidget(
                    label: 'Your email: *',
                    hint: 'Enter your email',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15.h),

                  // Event Name Field
                  FormFieldWidget(
                    label: 'Name of the next event you are organizing: *',
                    hint: 'Enter your event name',
                    controller: controller.eventNameController,
                  ),
                  SizedBox(height: 15.h),

                  // Attendees Dropdown
                  Obx(() => CustomDropdownWidget(
                    label: 'How many attendees do you expect? *',
                    value: controller.selectedAttendees.value,
                    items: controller.attendeesOptions,
                    onChanged: controller.onAttendeesChanged,
                  )),
                  SizedBox(height: 15.h),

                  // Future Events Dropdown
                  Obx(() => CustomDropdownWidget(
                    label:
                    'How many events do you plan to organize in the future? *',
                    value: controller.selectedFutureEvents.value,
                    items: controller.futureEventsOptions,
                    onChanged: controller.onFutureEventsChanged,
                  )),
                  SizedBox(height: 15.h),

                  // Country/Area Field
                  FormFieldWidget(
                    label: 'Country/Area that you run your event *',
                    hint: 'Enter your Country/Area',
                    controller: controller.countryController,
                  ),
                  SizedBox(height: 15.h),

                  // Contact Number with Country Picker
                  Obx(() => PhoneInputWidget(
                    label: 'Contact number *',
                    countryFlag: controller.countryFlag,
                    countryCode: controller.countryCode,
                    onCountryTap: () => controller.selectCountry(context),
                    phoneController: controller.phoneController,
                  )),
                  SizedBox(height: 15.h),

                  // Message Field
                  Obx(() => MessageInputWidget(
                    label: 'Message: *',
                    controller: controller.messageController,
                    currentLength: controller.messageCharCount.value,
                    maxLength: controller.maxMessageChar,
                  )),
                  SizedBox(height: 24.h),

                  // Submit Button
                  CustomButton(
                    title: 'Submit',
                    onpress: () => controller.onSubmit(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}