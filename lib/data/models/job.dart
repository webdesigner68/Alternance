import 'package:freezed_annotation/freezed_annotation.dart';
import 'identifier.dart';
import 'workplace.dart';
import 'contract.dart';
import 'offer.dart';
import 'apply.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class Job with _$Job {
  const factory Job({
    required Identifier identifier,
    Workplace? workplace,
    Contract? contract,
    required Offer offer,
    Apply? apply,
    @JsonKey(name: 'is_delegated') @Default(false) bool isDelegated,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}
