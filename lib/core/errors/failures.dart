import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.network({
    required String message,
    int? statusCode,
    String? responseBody,
  }) = NetworkFailure;

  const factory Failure.unauthorized({
    required String message,
  }) = UnauthorizedFailure;

  const factory Failure.invalidResponse({
    required String message,
    String? contentType,
    String? bodySample,
  }) = InvalidResponseFailure;

  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;

  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  const factory Failure.unknown({
    required String message,
    Object? error,
  }) = UnknownFailure;
}
