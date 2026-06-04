# Requirements Document

## Introduction

This feature implements a "Post a Job" screen for exhibitors and sponsors in the Confaero mobile app. The screen allows authorized users to create job postings with various fields including job details, requirements, benefits, and application links. Successfully posted jobs appear in the Job Openings list.

## Glossary

- **Post_Job_Screen**: The UI screen displaying the job posting form
- **Form_Validator**: Component that validates all form fields before submission
- **Job_API_Client**: Component that sends job creation requests to the backend API
- **Job_Openings_Screen**: The screen displaying a list of all job postings
- **Navigation_Controller**: Component that handles screen navigation
- **Date_Formatter**: Component that formats dates for display and API transmission
- **Benefits_Manager**: Component that manages the list of benefit/facility chips
- **Field_Character_Limiter**: Component that enforces character limits on text fields
- **URL_Validator**: Component that validates URL format for the application link
- **Banner_Image_Picker**: Component that handles image selection from gallery or camera

## Requirements

### Requirement 1: Form Navigation

**User Story:** As an exhibitor or sponsor, I want to access the job posting form from the Job Openings screen, so that I can create a new job posting.

#### Acceptance Criteria

1. THE Job_Openings_Screen SHALL display a circular floating action button with teal background color #5BB8AE
2. WHEN the user taps the floating action button, THE Navigation_Controller SHALL navigate to the Post_Job_Screen
3. THE floating action button SHALL display a "+" icon with color #F6F6F6

### Requirement 2: Banner Image Upload

**User Story:** As a job poster, I want to upload a banner image for my job posting, so that the listing is visually appealing.

#### Acceptance Criteria

1. THE Post_Job_Screen SHALL display a banner upload area with dashed border and camera icon
2. WHEN the user taps the banner upload area, THE Banner_Image_Picker SHALL open the device gallery
3. WHEN the user selects an image, THE Post_Job_Screen SHALL display the selected image as a preview
4. THE banner upload area SHALL display "Upload" text when no image is selected

### Requirement 3: Text Field Character Limits

**User Story:** As a job poster, I want character limits on text fields, so that job postings remain concise and readable.

#### Acceptance Criteria

1. FOR ALL text input on company field, THE Field_Character_Limiter SHALL enforce a maximum of 60 characters
2. FOR ALL text input on job title field, THE Field_Character_Limiter SHALL enforce a maximum of 60 characters
3. FOR ALL text input on job description field, THE Field_Character_Limiter SHALL enforce a maximum of 200 characters
4. FOR ALL text input on requirements field, THE Field_Character_Limiter SHALL enforce a maximum of 200 characters
5. FOR ALL text input on position field, THE Field_Character_Limiter SHALL enforce a maximum of 60 characters
6. FOR ALL text input on qualification field, THE Field_Character_Limiter SHALL enforce a maximum of 60 characters
7. FOR ALL text input on experience field, THE Field_Character_Limiter SHALL enforce a maximum of 60 characters
8. FOR ALL text input on job type field, THE Field_Character_Limiter SHALL enforce a maximum of 60 characters
9. FOR ALL text input on salary field, THE Field_Character_Limiter SHALL enforce a maximum of 60 characters

### Requirement 4: Required Field Validation

**User Story:** As a job poster, I want to be prevented from submitting incomplete job postings, so that all postings contain essential information.

#### Acceptance Criteria

1. WHEN the user taps the "Post" button, THE Form_Validator SHALL verify that the company field is non-empty
2. WHEN the user taps the "Post" button, THE Form_Validator SHALL verify that the job title field is non-empty
3. WHEN the user taps the "Post" button, THE Form_Validator SHALL verify that the description field is non-empty
4. WHEN the user taps the "Post" button, THE Form_Validator SHALL verify that the requirements field is non-empty
5. WHEN the user taps the "Post" button, THE Form_Validator SHALL verify that the location field is non-empty
6. WHEN the user taps the "Post" button, THE Form_Validator SHALL verify that the Google form link field is non-empty
7. WHEN the user taps the "Post" button, THE Form_Validator SHALL verify that a job expire date has been selected
8. IF any required field is empty, THEN THE Form_Validator SHALL prevent form submission and display appropriate error messages

### Requirement 5: Job Type Selection

**User Story:** As a job poster, I want to select a job type from predefined options, so that candidates understand the employment arrangement.

#### Acceptance Criteria

1. THE Post_Job_Screen SHALL display a job type dropdown with the following options: "full time", "part time", "contract", "internship", "remote"
2. WHEN the user selects a job type, THE Post_Job_Screen SHALL store the selected value
3. THE job type dropdown SHALL display "eg. full time" as placeholder text when no selection is made

### Requirement 6: Job Expiration Date Selection

**User Story:** As a job poster, I want to set an expiration date for my job posting, so that it closes automatically after a specified date.

#### Acceptance Criteria

1. THE Post_Job_Screen SHALL display a date picker field with placeholder format "DD/MM/YYYY"
2. WHEN the user taps the date picker field, THE Post_Job_Screen SHALL display a calendar date picker
3. WHEN the user selects a date, THE Date_Formatter SHALL format the date as "DD/MM/YYYY" for display
4. WHEN the user submits the form, THE Date_Formatter SHALL convert the date to ISO 8601 format for API transmission
5. FOR ALL valid date selections, parsing the ISO 8601 string then formatting to display format SHALL preserve the original date (round-trip property)

### Requirement 7: Benefits and Facilities Management

**User Story:** As a job poster, I want to add multiple benefits or facilities as chips, so that candidates can see job perks at a glance.

#### Acceptance Criteria

1. THE Post_Job_Screen SHALL display a "Facilities Title" text input field
2. THE Post_Job_Screen SHALL display an "+ Add Option" button
3. WHEN the user enters text and taps "+ Add Option", THE Benefits_Manager SHALL add a chip containing the entered text
4. THE Benefits_Manager SHALL display each benefit as a chip with an "×" remove icon
5. WHEN the user taps the "×" icon on a chip, THE Benefits_Manager SHALL remove that chip
6. FOR ALL sequences of add and remove operations, adding N benefits then removing M benefits SHALL result in (N - M) benefits remaining, where N ≥ M

### Requirement 8: Application Link Validation

**User Story:** As a job poster, I want to provide a valid application link, so that candidates can apply for the position.

#### Acceptance Criteria

1. THE Post_Job_Screen SHALL display a Google form link field with placeholder "http://"
2. WHEN the user taps the "Post" button, THE URL_Validator SHALL verify that the link starts with "http://" or "https://"
3. IF the link is empty or does not start with "http://" or "https://", THEN THE Form_Validator SHALL prevent form submission and display an error message

### Requirement 9: Job Creation Request

**User Story:** As a job poster, I want my job posting data to be sent to the backend, so that it can be reviewed and published.

#### Acceptance Criteria

1. WHEN all form validations pass, THE Job_API_Client SHALL send a POST request to the "/job" endpoint
2. THE Job_API_Client SHALL include the following fields in the request body: title, company, bannerImage, description, requirements, location, locationUrl, position, qualification, experience, jobExpire, type, salary, benefits, applyLink
3. THE Job_API_Client SHALL serialize the benefits field as a JSON array of strings
4. FOR ALL valid job creation requests, serializing to JSON then deserializing SHALL produce an equivalent request object (round-trip property)

### Requirement 10: Successful Job Creation Response

**User Story:** As a job poster, I want confirmation when my job is successfully posted, so that I know the operation completed.

#### Acceptance Criteria

1. WHEN the API responds with success: true, THE Navigation_Controller SHALL navigate back to the Job_Openings_Screen
2. WHEN the Navigation_Controller navigates back, THE Job_Openings_Screen SHALL refresh the job list to display the newly created job
3. THE Post_Job_Screen SHALL display the newly created job with status "PENDING" until reviewed by an organizer

### Requirement 11: Error Handling for Job Creation

**User Story:** As a job poster, I want to see clear error messages when job creation fails, so that I can understand and fix the problem.

#### Acceptance Criteria

1. IF the API responds with success: false, THEN THE Post_Job_Screen SHALL display the error message from the API response
2. IF the API request fails due to network error, THEN THE Post_Job_Screen SHALL display "Network error, please try again"
3. IF the API request times out, THEN THE Post_Job_Screen SHALL display "Request timed out, please try again"
4. WHEN an error occurs, THE Post_Job_Screen SHALL remain open and preserve the user's entered data

### Requirement 12: Loading State During Submission

**User Story:** As a job poster, I want to see a loading indicator during submission, so that I know the app is processing my request.

#### Acceptance Criteria

1. WHEN the user taps the "Post" button, THE Post_Job_Screen SHALL disable the button and display a loading indicator
2. WHILE the API request is in progress, THE Post_Job_Screen SHALL prevent additional form submissions
3. WHEN the API responds or an error occurs, THE Post_Job_Screen SHALL re-enable the button and hide the loading indicator

### Requirement 13: Screen Layout and Styling

**User Story:** As a job poster, I want a well-organized and visually consistent form, so that posting a job is intuitive and professional.

#### Acceptance Criteria

1. THE Post_Job_Screen SHALL display all fields in the following order: banner upload, company, job title, job description, requirements, location, information section (position, qualification, experience, job type, job expire, salary), facilities section, Google form link, and Post button
2. THE Post_Job_Screen SHALL use the primary color #32A69A for the "Post" button background
3. THE Post_Job_Screen SHALL use the font size, color, and spacing defined in the UI design specification
4. THE Post_Job_Screen SHALL display field labels above each input field

### Requirement 14: Form Data Serialization

**User Story:** As a system, I want to reliably serialize form data to JSON and deserialize it back, so that data integrity is maintained throughout the submission process.

#### Acceptance Criteria

1. THE Job_API_Client SHALL serialize all text fields as JSON strings
2. THE Job_API_Client SHALL serialize the jobExpire field as an ISO 8601 date string
3. THE Job_API_Client SHALL serialize the benefits field as a JSON array
4. FOR ALL valid form data objects, serializing to JSON then deserializing SHALL produce an object equal to the original (round-trip property)
5. FOR ALL valid ISO 8601 date strings in the jobExpire field, deserializing then serializing SHALL produce an equivalent date string (date round-trip property)
