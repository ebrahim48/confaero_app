## Qwen Added Memories
- Confaero App is a Flutter conference management application with the following key characteristics:

1. Project Structure:
   - Uses a feature-based architecture with core, features, global, and presentations directories
   - Core contains config (routes, themes), constants, di, exceptions, helpers, and services
   - Features contains auth and onboarding modules
   - Presentations contains controllers and widgets
   - Global contains custom assets

2. Key Features:
   - Onboarding flow with 4 screens explaining the app functionality
   - Authentication system with sign up and sign in (email/password and Google)
   - Network connectivity monitoring with offline UI
   - Theme management (light/dark mode)
   - Responsive design using flutter_screenutil

3. Navigation:
   - Uses GoRouter for navigation
   - Initial route is onboarding screen
   - Routes include onboarding, signup, and signin screens

4. Technologies Used:
   - Flutter framework with GetX for state management
   - GoRouter for navigation
   - Hive for local storage
   - Dio for HTTP requests
   - Socket.IO client for real-time communication
   - Various UI packages like flutter_svg, lottie, flutter_rating_bar, etc.

5. UI Components:
   - Custom widgets for buttons, text fields, text, loaders
   - Consistent color scheme defined in AppColors
   - Responsive design with ScreenUtil

6. Architecture:
   - MVC-like pattern with controllers managing business logic
   - Separation of concerns with feature modules
   - Centralized constants and configurations
