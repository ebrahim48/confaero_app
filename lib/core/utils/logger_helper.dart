import 'package:logger/logger.dart';

class CustomLogger {
  final Logger _logger;
  final String _className;

  CustomLogger(this._className)
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 80,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );

  void d(dynamic message) {
    _logger.d('[$_className] $message');
  }

  void i(dynamic message) {
    _logger.i('[$_className] $message');
  }

  void w(dynamic message) {
    _logger.w('[$_className] $message');
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('[$_className] $message', error: error, stackTrace: stackTrace);
  }
}
