import 'package:freezed_annotation/freezed_annotation.dart';
import 'location.dart';

part 'workplace.freezed.dart';
part 'workplace.g.dart';

@freezed
class Workplace with _$Workplace {
  const factory Workplace({
    String? name,
    String? description,
    String? siret,
    String? website,
    Location? location,
    @JsonKey(name: 'size') String? headcount,
    String? sector,
  }) = _Workplace;

  factory Workplace.fromJson(Map<String, dynamic> json) =>
      _$WorkplaceFromJson(json);
}
