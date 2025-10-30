import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import 'interceptors/logging_interceptor.dart';

class DioClientLegacy {
  DioClientLegacy(this.config) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.apiLegacyBaseUrl,
        responseType: ResponseType.json,
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.addAll([
      LoggingInterceptor(),
    ]);
  }

  final AppConfig config;
  late final Dio _dio;

  Dio get dio => _dio;
}
