/// Application string constants for internationalization and maintainability.
///
/// This class centralizes all user-facing strings in the application, making it
/// easier to:
/// - Update text across the app from a single location
/// - Prepare for internationalization (i18n)
/// - Maintain consistent messaging
/// - Search and replace text efficiently
///
/// **Best Practices:**
/// - Use descriptive constant names that indicate context
/// - Group related strings together with comments
/// - Keep strings in alphabetical order within groups
/// - Use const for compile-time constants
///
/// **Usage:**
/// ```dart
/// Text(AppStrings.searchHint)  // Instead of: Text('Search food or restaurant here...')
/// ```
///
/// **Future i18n Support:**
/// When adding internationalization, this class can be replaced with:
/// ```dart
/// AppLocalizations.of(context).searchHint
/// ```
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // Search
  static const String searchHint = 'Search food or restaurant here...';


}
