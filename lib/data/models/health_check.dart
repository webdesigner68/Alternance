import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_check.freezed.dart';
part 'health_check.g.dart';

@freezed
class HealthCheck with _$HealthCheck {
  const factory HealthCheck({
    String? name,
    String? version,
    String? env,
    bool? healthcheck,
  }) = _HealthCheck;

  factory HealthCheck.fromJson(Map<String, dynamic> json) =>
      _$HealthCheckFromJson(json);
}
