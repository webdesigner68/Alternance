import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String title,
    String? description,
    @JsonKey(name: 'desired_skills') List<String>? desiredSkills,
    @JsonKey(name: 'to_be_acquired_skills') List<String>? toBeAcquiredSkills,
    @JsonKey(name: 'access_conditions') String? accessConditions,
    @JsonKey(name: 'opening_count') int? positions,
    List<String>? romes,
    @JsonKey(name: 'target_diploma_level') String? targetDiplomaLevel,
    String? status,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}
