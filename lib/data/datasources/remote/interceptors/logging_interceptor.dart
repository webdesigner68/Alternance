import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('🌐 REQUEST: ${options.method} ${options.uri}');
      print('Headers: ${_maskSensitiveHeaders(options.headers)}');
      if (options.data != null) {
        print('Body: ${_maskSensitiveData(options.data)}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      print('Content-Type: ${response.headers.value('content-type')}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ ERROR: ${err.message} ${err.requestOptions.uri}');
      if (err.response != null) {
        print('Status: ${err.response?.statusCode}');
      }
    }
    super.onError(err, handler);
  }

  Map<String, dynamic> _maskSensitiveHeaders(Map<String, dynamic> headers) {
    final masked = Map<String, dynamic>.from(headers);
    if (masked.containsKey('Authorization')) {
      masked['Authorization'] = '***MASKED***';
    }
    if (masked.containsKey('X-Api-Key')) {
      masked['X-Api-Key'] = '***MASKED***';
    }
    return masked;
  }

  dynamic _maskSensitiveData(dynamic data) {
    if (data is Map) {
      final masked = Map<String, dynamic>.from(data as Map<String, dynamic>);
      if (masked.containsKey('applicant_attachment_content')) {
        masked['applicant_attachment_content'] = '***BASE64_MASKED***';
      }
      return masked;
    }
    return data;
  }
}
