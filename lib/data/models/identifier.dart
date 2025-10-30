import 'package:freezed_annotation/freezed_annotation.dart';

part 'identifier.freezed.dart';
part 'identifier.g.dart';

@freezed
class Identifier with _$Identifier {
  const factory Identifier({
    required String id,
    @JsonKey(name: 'partner_label') String? partnerLabel,
  }) = _Identifier;

  factory Identifier.fromJson(Map<String, dynamic> json) =>
      _$IdentifierFromJson(json);
}
