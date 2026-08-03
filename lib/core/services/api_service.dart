import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/approutes/app_routes.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../helpers/prefs_helper.dart';
import '../helpers/toast_message_helper.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  bool _isRefreshing = false;
  Future<String?>? _refreshTokenFuture;

  factory ApiService() {
    return _instance;
  }
  //*------------------ Singleton Implementation ------------------*//
  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefsHelper.getString(AppConstants.bearerToken);

          // Never attach the (likely expired) access token to the refresh call.
          // The backend validates the Authorization header before reading the
          // refreshToken body, so a stale header makes refresh fail with
          // "You are not authorized!" even when the refresh token is valid.
          final isRefreshCall = options.path == ApiConstants.refreshTokenApi;

          if (token.isNotEmpty && !isRefreshCall) {
            options.headers['Authorization'] = 'Bearer $token';
          } else if (isRefreshCall) {
            options.headers.remove('Authorization');
          }

          if (kDebugMode) {
            print('┌─────────────────────────────────────────');
            print('│ REQUEST[${options.method}] => ${options.baseUrl}${options.path}');
            print('│ Auth: ${options.headers['Authorization'] != null ? 'Bearer ***' : 'NONE'}');
            if (options.data != null) {
              print('│ Body: ${options.data}');
            }
            if (options.queryParameters.isNotEmpty) {
              print('│ Query: ${options.queryParameters}');
            }
            print('└─────────────────────────────────────────');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('┌─────────────────────────────────────────');
            print(
              '│ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
            );
            print('│ Body: ${response.data}');
            print('└─────────────────────────────────────────');
          }

          handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print('┌─────────────────────────────────────────');
            print(
              '│ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}',
            );
            print('│ Message: ${error.message}');
            print('│ Response: ${error.response?.data}');
            print('└─────────────────────────────────────────');
          }

          // Show user-friendly error toast for common errors
          _showErrorToast(error);

          final statusCode = error.response?.statusCode;
          final requestOptions = error.requestOptions;

          final isRefreshCall =
              requestOptions.path == ApiConstants.refreshTokenApi;

          // Backend incorrectly returns 500 for expired JWT instead of 401.
          // Detect jwt expired by checking the response message.
          final responseData = error.response?.data;
          final serverMessage =
              (responseData is Map ? responseData['message'] : null)
                  ?.toString()
                  .toLowerCase() ??
              '';
          final isJwtExpired = serverMessage.contains('jwt expired') ||
              serverMessage.contains('token expired');

          // Backend returns 404 "Route not found" on protected routes when the
          // token is missing or expired (auth middleware hides the route instead
          // of returning 401). Treat this as an auth error so we retry with a
          // refreshed token. Skip on retried requests to prevent infinite loops.
          // Exclude /resouce/ paths (backend's actual, misspelled route
          // prefix — see ApiConstants.getEventSurvey etc.) — they may
          // genuinely return 404 when the event has no data yet, and should
          // NOT trigger an auth retry loop.
          final isRetry = requestOptions.extra['isRetry'] == true;
          final isResourcePath = requestOptions.path.contains('/resouce/');
          final isHidden404 = !isRetry &&
              !isResourcePath &&
              statusCode == 404 &&
              serverMessage.contains('route is not found');

          // A 401 does not always mean "expired session" — the backend also
          // returns it when the current role lacks access to a route (e.g. a
          // SPEAKER hitting an /attendee/ endpoint). Refreshing cannot fix that,
          // and treating it as an expiry destroyed a perfectly valid session and
          // bounced the user to login. Only chase a refresh when the access
          // token has actually expired.
          final accessTokenExpired = await _isStoredAccessTokenExpired();

          final isAuthError = (statusCode == 401 && accessTokenExpired) ||
              (statusCode == 500 && isJwtExpired) ||
              isHidden404;

          if (isAuthError && !isRefreshCall) {
            try {
              final newAccessToken = await _handleTokenRefresh();

              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                final retryOptions = Options(
                  method: requestOptions.method,
                  headers: Map<String, dynamic>.from(requestOptions.headers)
                    ..['Authorization'] = 'Bearer $newAccessToken',
                  responseType: requestOptions.responseType,
                  contentType: requestOptions.contentType,
                  sendTimeout: requestOptions.sendTimeout,
                  receiveTimeout: requestOptions.receiveTimeout,
                  extra: Map<String, dynamic>.from(
                    requestOptions.extra,
                  )..['isRetry'] = true,
                  followRedirects: requestOptions.followRedirects,
                  listFormat: requestOptions.listFormat,
                  maxRedirects: requestOptions.maxRedirects,
                  receiveDataWhenStatusError:
                      requestOptions.receiveDataWhenStatusError,
                  requestEncoder: requestOptions.requestEncoder,
                  responseDecoder: requestOptions.responseDecoder,
                  validateStatus: requestOptions.validateStatus,
                );

                final clonedResponse = await _dio.request(
                  requestOptions.path,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                  options: retryOptions,
                );

                return handler.resolve(clonedResponse);
              } else {
                await _clearSession();
              }
            } catch (_) {
              await _clearSession();
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Show user-friendly error toast based on error type
  void _showErrorToast(DioException error) {
    // Don't show toast for 401 or hidden-auth 404 (handled by token refresh)
    if (error.response?.statusCode == 401) return;
    final errData = error.response?.data;
    final errMsg = (errData is Map ? errData['message'] : null)
            ?.toString()
            .toLowerCase() ??
        '';
    if (error.response?.statusCode == 404 &&
        errMsg.contains('route is not found')) return;

    // Suppress toasts for endpoints that handle errors in their own UI
    final path = error.requestOptions.path;
    final suppressedPaths = [
      '/eventAttendee/events/',
      '/connection/request/',
      '/booth/me',
      '/booth/analytics',
      '/exhibitor/performance',
      '/resouce/',
    ];

    if (suppressedPaths.any((suppressed) => path.contains(suppressed))) {
      return;
    }

    String errorMessage = 'Something went wrong';
    String title = 'Error';

    // Check if it's a network/connectivity error
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Please check your internet connection and try again';
      title = 'No Internet';
    } else if (error.response != null) {
      // Try to get error message from backend response
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'] as String?;
        if (message != null && message.isNotEmpty) {
          errorMessage = message;
        }
      }

      // Status code specific messages
      switch (error.response?.statusCode) {
        case 400:
          title = 'Bad Request';
          break;
        case 403:
          errorMessage = 'You don\'t have permission to perform this action';
          title = 'Access Denied';
          break;
        case 404:
          errorMessage = 'The requested resource was not found';
          title = 'Not Found';
          break;
        case 500:
          errorMessage = 'Server error. Please try again later';
          title = 'Server Error';
          break;
        case 502:
        case 503:
          errorMessage = 'Service temporarily unavailable';
          title = 'Service Unavailable';
          break;
      }
    }

    // Show toast in debug mode only to avoid spamming users during development
    if (kDebugMode) {
    }
  }

  //*---------------- Access Token Expiry Check ----------------*//

  /// Reads the stored access token and reports whether its `exp` claim has
  /// passed. Returns true when there is no token, or when the token cannot be
  /// parsed — in both cases a refresh attempt is the right fallback.
  Future<bool> _isStoredAccessTokenExpired() async {
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    if (token.isEmpty) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // base64Url payloads are unpadded; normalize before decoding.
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final exp = (payload as Map<String, dynamic>)['exp'];
      if (exp is! int) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      // 10s skew so a token expiring mid-flight still counts as expired.
      return DateTime.now().isAfter(
        expiry.subtract(const Duration(seconds: 10)),
      );
    } catch (_) {
      return true;
    }
  }

  //*---------------- Handle Refresh Token ----------------*//
  Future<String?> _handleTokenRefresh() async {
    if (_isRefreshing && _refreshTokenFuture != null) {
      return _refreshTokenFuture;
    }

    _isRefreshing = true;
    _refreshTokenFuture = _refreshAccessToken();

    try {
      return await _refreshTokenFuture;
    } finally {
      _isRefreshing = false;
      _refreshTokenFuture = null;
    }
  }
  //*------------ Access Token Refresh Logic ------------*//
  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken = await PrefsHelper.getString(
        AppConstants.refreshToken,
      );

      if (refreshToken.isEmpty) {
        return null;
      }

      // Backend expects refreshToken in HTTP-only cookie, but we also send it
      // in body as fallback since Flutter can't manage cookies like a browser.
      final response = await _dio.post(
        ApiConstants.refreshTokenApi,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          // Send cookies with request (for when cookie-based auth is available)
          extra: {'withCredentials': true},
        ),
      );

      final responseData = response.data as Map<String, dynamic>?;
      final success = responseData?['success'] as bool? ?? false;
      final data = responseData?['data'] as Map<String, dynamic>?;

      if (!success || data == null) {
        return null;
      }

      final newAccessToken = data['accessToken'] as String? ?? '';

      if (newAccessToken.isEmpty) {
        return null;
      }

      await PrefsHelper.setString(AppConstants.bearerToken, newAccessToken);

      // Update refresh token if backend rotated it
      final newRefreshToken = data['refreshToken'] as String? ?? refreshToken;
      await PrefsHelper.setString(AppConstants.refreshToken, newRefreshToken);

      return newAccessToken;
    } catch (_) {
      return null;
    }
  }
  //*---------Clear Session and Redirect to Login --------*//
  Future<void> _clearSession() async {
    await PrefsHelper.remove(AppConstants.bearerToken);
    await PrefsHelper.remove(AppConstants.refreshToken);
    await PrefsHelper.remove(AppConstants.userRole);
    await PrefsHelper.remove(AppConstants.email);
    await PrefsHelper.setBool(AppConstants.isLogged, false);

    // Redirect to login. Use the router singleton rather than Get.context —
    // context is frequently null/unmounted here, which silently dropped the
    // redirect and left the user on a protected screen with no token, so every
    // later request went out unauthenticated and 401'd.
    await Future.delayed(const Duration(milliseconds: 300));
    AppRoutes.goRouter.go(AppRoutes.signInScreen);
  }
  //------------------ API Methods ------------------*//
  //__________________________________________________//
  //*_________________GET___________________*//
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
  //*_________________POST___________________*//
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool validateStatus = true,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options:
            options ??
            (validateStatus ? null : Options(validateStatus: (status) => true)),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
  //*_________________PUT___________________*//
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
  //*_________________PATCH___________________*//
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
  //*_________________DELETE___________________*//
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
  //*------------------ Error Handling ------------------*//
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(error.message);

      case DioExceptionType.connectionError:
        return NoInternetException(error.message);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        String message = 'Server error';
        try {
          if (responseData is Map<String, dynamic>) {
            message =
                responseData['message'] as String? ??
                error.response?.statusMessage ??
                'Server error';
          } else {
            message = error.response?.statusMessage ?? 'Server error';
          }
        } catch (_) {
          message = error.response?.statusMessage ?? 'Server error';
        }

        return ServerException(
          message,
          statusCode,
          error.message,
          responseData,
          error.stackTrace,
        );

      case DioExceptionType.cancel:
        return UnknownException('Request cancelled');

      case DioExceptionType.badCertificate:
        return ServerException('Bad certificate', null, error.message);

      case DioExceptionType.unknown:
        return UnknownException(error.message ?? 'Unknown error occurred');
    }
  }
}
