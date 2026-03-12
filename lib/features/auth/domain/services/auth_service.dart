// Auth service placeholder — business logic is handled directly in AuthRepository.

/// Service layer that handles business logic for the auth feature.
///
/// This class implements the **Service Layer Pattern**, separating business logic
/// from data access logic. It coordinates authentication operations and handles
/// cross-cutting concerns like connectivity checking.
///
/// **Responsibilities:**
/// - Coordinate authentication repository operations
/// - Check connectivity before network operations
/// - Implement authentication business rules and workflows
/// - Handle authentication error scenarios
///
/// **Architecture:**
/// ```
/// Controller -> AuthService -> AuthRepository -> ApiService
///                            -> ConnectivityService
/// ```
///
/// **Usage:**
/// ```dart
/// final authService = Get.find<AuthService>();
/// try {
///   final response = await authService.register(
///     email: 'user@example.com',
///     fullName: 'John Doe',
///     password: 'password123',
///   );
/// } on NoInternetException {
///   // Show offline UI
/// } on ServerException {
///   // Handle server error
/// }
/// ```
// class AuthService {
//   final AuthRepository _repository;
//   final ConnectivityService _connectivityService;
//
//   /// Creates a [AuthService] with required dependencies.
//   ///
//   /// Dependencies are typically injected via [DependencyInjection.init()].
//   AuthService({
//     required AuthRepository repository,
//     required ConnectivityService connectivityService,
//   })  : _repository = repository,
//         _connectivityService = connectivityService;
//
//   /// Registers a new user with email, fullName, password and confirmPassword
//   ///
//   /// **Parameters:**
//   /// - [email]: User's email address
//   /// - [fullName]: User's full name
//   /// - [password]: User's password (min 6 characters)
//   /// - [confirmPassword]: Confirmed password
//   ///
//   /// **Throws:**
//   /// - [NoInternetException]: If the device is offline
//   /// - [ServerException]: If the server returns an error
//   /// - [AppException]: If any other error occurs
//   ///
//   /// **Returns:**
//   /// A [Map<String, dynamic>] containing the server response
//   ///
//   /// **Example:**
//   /// ```dart
//   /// try {
//   ///   final response = await authService.register(
//   ///     email: 'user@example.com',
//   ///     fullName: 'John Doe',
//   ///     password: 'password123',
//   ///     confirmPassword: 'password123',
//   ///   );
//   ///
//   ///   // Handle successful registration
//   ///   print('Registration response: $response');
//   /// } on NoInternetException {
//   ///   // Handle offline scenario
//   /// }
//   /// ```
//   Future<Map<String, dynamic>> register({
//     required String email,
//     required String firstName,
//     required String lastName,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     try {
//       // Validate inputs
//       if (email.isEmpty || firstName.isEmpty || lastName.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//         throw ServerException('Email,  firstName, lastName, password, and confirmPassword are required', 400, 'Validation error');
//       }
//
//       if (password.length < 6) {
//         throw ServerException('Password must be at least 6 characters', 400, 'Validation error');
//       }
//
//       if (password != confirmPassword) {
//         throw ServerException('Passwords do not match', 400, 'Validation error');
//       }
//
//       // Check connectivity
//       await _connectivityService.checkConnectivity();
//
//       // Call repository method
//       return await _repository.register(
//         email: email,
//         firstName: firstName,
//         lastName: lastName,
//         password: password,
//         confirmPassword: confirmPassword,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// Login user with email and password
//   Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       if (email.isEmpty || password.isEmpty) {
//         throw ServerException('Email and password are required', 400, 'Validation error');
//       }
//
//       await _connectivityService.checkConnectivity();
//
//       return await _repository.login(
//         email: email,
//         password: password,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// Forgot password - send reset email
//   Future<Map<String, dynamic>> forgotPassword({
//     required String email,
//   }) async {
//     try {
//       if (email.isEmpty) {
//         throw ServerException('Email is required', 400, 'Validation error');
//       }
//
//       await _connectivityService.checkConnectivity();
//
//       return await _repository.forgotPassword(email: email);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// Verifies email with OTP code
//   Future<Map<String, dynamic>> verifyEmail({
//     required String otp,
//     required String email,
//     required String token,
//   }) async {
//     try {
//       if (otp.isEmpty || email.isEmpty || token.isEmpty) {
//         throw ServerException('OTP, email, and token are required', 400, 'Validation error');
//       }
//
//       await _connectivityService.checkConnectivity();
//
//       return await _repository.verifyEmail(
//         otp: otp,
//         email: email,
//         token: token,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// Reset password
//   Future<Map<String, dynamic>> resetPassword({
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     try {
//       if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//         throw ServerException('All fields are required', 400, 'Validation error');
//       }
//
//       if (password.length < 6) {
//         throw ServerException('Password must be at least 6 characters', 400, 'Validation error');
//       }
//
//       if (password != confirmPassword) {
//         throw ServerException('Passwords do not match', 400, 'Validation error');
//       }
//
//       await _connectivityService.checkConnectivity();
//
//       return await _repository.resetPassword(
//         email: email,
//         password: password,
//         confirmPassword: confirmPassword,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   /// Resend OTP
//   Future<Map<String, dynamic>> resendOtp({
//     required String email,
//   }) async {
//     try {
//       if (email.isEmpty) {
//         throw ServerException('Email is required', 400, 'Validation error');
//       }
//
//       await _connectivityService.checkConnectivity();
//
//       return await _repository.resendOtp(email: email);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
