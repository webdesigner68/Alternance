import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/content_type_guard_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClientV2 {
  DioClientV2(this.config) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.apiV2BaseUrl,
        responseType: ResponseType.json,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(config),
      ContentTypeGuardInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  final AppConfig config;
  late final Dio _dio;

  Dio get dio => _dio;
}
