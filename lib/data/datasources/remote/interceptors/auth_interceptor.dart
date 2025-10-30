import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.config);

  final AppConfig config;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only add ONE auth header
    if (config.apiKey.isNotEmpty) {
      final headerName = config.authHeaderName;
      final headerValue = config.authHeaderValue;
      
      // Remove any existing auth headers to ensure only one is sent
      options.headers.remove('X-Api-Key');
      options.headers.remove('Authorization');
      
      // Add the configured auth header
      options.headers[headerName] = headerValue;
    }

    // Always add Accept header
    options.headers['Accept'] = 'application/json';

    super.onRequest(options, handler);
  }
}
