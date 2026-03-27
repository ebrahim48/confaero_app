import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:go_router/go_router.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../helpers/prefs_helper.dart';

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

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            print('┌─────────────────────────────────────────');
            print('│ REQUEST[${options.method}] => ${options.path}');
            print('│ Headers: ${options.headers}');
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

          final isAuthError =
              (statusCode == 401) || (statusCode == 500 && isJwtExpired);

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
                  extra: requestOptions.extra,
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

      final response = await _dio.post(
        ApiConstants.refreshTokenApi,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final responseData = response.data as Map<String, dynamic>?;
      final success = responseData?['success'] as bool? ?? false;
      final data = responseData?['data'] as Map<String, dynamic>?;

      if (!success || data == null) {
        return null;
      }

      final newAccessToken = data['accessToken'] as String? ?? '';
      final newRefreshToken = data['refreshToken'] as String? ?? refreshToken;

      if (newAccessToken.isEmpty) {
        return null;
      }

      await PrefsHelper.setString(AppConstants.bearerToken, newAccessToken);

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

    // Redirect to login — use a small delay so any in-flight UI settles first
    await Future.delayed(const Duration(milliseconds: 300));
    final context = Get.context;
    if (context != null && context.mounted) {
      context.go('/signInScreen');
    }
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
