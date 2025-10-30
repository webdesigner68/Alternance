import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';

class ContentTypeGuardInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final contentType = response.headers.value('content-type');
    
    // If content-type is not JSON and data is a String
    if (contentType != null && 
        !contentType.contains('application/json') &&
        response.data is String) {
      
      final dataString = response.data as String;
      
      // Try to parse if it starts with { or [
      if (dataString.trim().startsWith('{') || 
          dataString.trim().startsWith('[')) {
        try {
          final parsed = jsonDecode(dataString);
          response.data = parsed;
          return handler.next(response);
        } catch (e) {
          // Failed to parse, reject
          final sample = dataString.length > 300 
              ? '${dataString.substring(0, 300)}...' 
              : dataString;
          
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: Failure.invalidResponse(
                message: 'Expected JSON but got $contentType',
                contentType: contentType,
                bodySample: sample,
              ),
              type: DioExceptionType.badResponse,
            ),
          );
        }
      }
      
      // Not JSON-like, reject
      final sample = dataString.length > 300 
          ? '${dataString.substring(0, 300)}...' 
          : dataString;
      
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: Failure.invalidResponse(
            message: 'Expected JSON but got $contentType',
            contentType: contentType,
            bodySample: sample,
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    }
    
    super.onResponse(response, handler);
  }
}
