class ApiConstants {
  static const String baseUrl = 'https://reaz8080.syedbipul.me/api/v1';
  static const String imageUrl = "https://reaz8080.syedbipul.me";

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };


  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgetPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-reset-code';
  static const String resetPassword = '/auth/reset-password';



}





