class AppConstants {
  static const String bearerToken = "bearerToken";
  static const String refreshToken = "refreshToken";
  static const String userRole = "userRole";
  static const String email = "email";
  static const String phone = "phone";
  static const String address = "address";
  static const String name = "name";
  static const String isEmailVerified = "isEmailVerified";
  static const String image = "image";
  static const String role = "role";
  static const String userId = "userId";
  static const String isLogged = "isLogged";
  static const String fcmToken = "fcmToken";
  static const String currentEventId = "currentEventId";
  static const String mechanicType = "mechanicType";
  static const String emailValidator = "emailValidator";

  /// Address shown on the About screen and used by its "write to us" link.
  static const String supportEmail = "support@confaero.com";

  // ========== DEMO MODE FOR INVESTOR PRESENTATION ==========
  // Set to true to auto-select default event after login
  static const bool DEMO_MODE = true;
  static const String DEMO_EVENT_ID = "697ecdf91d03df1518019a5b";
  static const String DEMO_EVENT_TITLE = "Confaero Conference 2026";
  // ==========================================================

  static RegExp emailValidate = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static bool validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$');
    return regex.hasMatch(value);
  }
}
