import 'package:logger/logger.dart';

/// Centralized logger helper for the app
/// 
/// Usage:
/// ```dart
/// final logger = LoggerHelper('TagName');
/// logger.i('Info message');
/// logger.d('Debug message');
/// logger.w('Warning message');
/// logger.e('Error message');
/// ```
class LoggerHelper {
  final Logger _logger;
  final String tag;

  LoggerHelper(this.tag) : _logger = Logger();

  /// Info log - for important runtime events
  void i(String message) {
    _logger.i('[$tag] $message');
  }

  /// Debug log - for debugging information
  void d(String message) {
    _logger.d('[$tag] $message');
  }

  /// Warning log - for potential issues
  void w(String message) {
    _logger.w('[$tag] $message');
  }

  /// Error log - for errors and exceptions
  void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e('[$tag] $message', error: error, stackTrace: stackTrace);
  }

  /// Log request details
  void request(String endpoint, Map<String, dynamic> data) {
    _logger.i('[$tag] REQUEST => Endpoint: $endpoint');
    _logger.d('[$tag] REQUEST DATA => $data');
  }

  /// Log response details
  void response(String endpoint, int statusCode, dynamic data) {
    _logger.i('[$tag] RESPONSE [$statusCode] => Endpoint: $endpoint');
    _logger.d('[$tag] RESPONSE DATA => $data');
  }

  /// Log error response
  void errorResponse(String endpoint, int? statusCode, String message) {
    _logger.e('[$tag] ERROR [$statusCode] => Endpoint: $endpoint, Message: $message');
  }

  /// Log exception
  void exception(String operation, dynamic error, {StackTrace? stackTrace}) {
    _logger.e('[$tag] EXCEPTION => $operation: $error', error: error, stackTrace: stackTrace);
  }
}
