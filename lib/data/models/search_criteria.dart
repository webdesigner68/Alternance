import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_criteria.freezed.dart';
part 'search_criteria.g.dart';

@freezed
class SearchCriteria with _$SearchCriteria {
  const factory SearchCriteria({
    double? latitude,
    double? longitude,
    @Default(30) int radius,
    List<String>? romes,
    String? rncp,
    @JsonKey(name: 'target_diploma_level') String? targetDiplomaLevel,
    String? opco,
    List<String>? departements,
    @JsonKey(name: 'partners_to_exclude') List<String>? partnersToExclude,
  }) = _SearchCriteria;

  factory SearchCriteria.fromJson(Map<String, dynamic> json) =>
      _$SearchCriteriaFromJson(json);
}
