import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';
import '../helpers/prefs_helper.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String token = await PrefsHelper.getString(AppConstants.bearerToken);
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

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('┌─────────────────────────────────────────');
            print('│ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
            print('│ Body: ${response.data}');
            print('└─────────────────────────────────────────');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('┌─────────────────────────────────────────');
            print('│ ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
            print('│ Message: ${error.message}');
            print('│ Response: ${error.response?.data}');
            print('└─────────────────────────────────────────');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

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
        options: options ??
            (validateStatus
                ? null
                : Options(validateStatus: (status) => true)),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

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
            message = responseData['message'] as String? ??
                error.response?.statusMessage ??
                'Server error';
          } else {
            message = error.response?.statusMessage ?? 'Server error';
          }
        } catch (_) {
          message = error.response?.statusMessage ?? 'Server error';
        }

        return ServerException(
            message, statusCode, error.message, responseData, error.stackTrace);

      case DioExceptionType.cancel:
        return UnknownException('Request cancelled');

      case DioExceptionType.badCertificate:
        return ServerException('Bad certificate', null, error.message);

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NoInternetException(error.message);
        }
        return UnknownException(error.message);
    }
  }

  void dispose() {
    _dio.close();
  }
}