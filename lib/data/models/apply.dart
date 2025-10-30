import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply.freezed.dart';
part 'apply.g.dart';

@freezed
class Apply with _$Apply {
  const factory Apply({
    String? url,
    @JsonKey(name: 'recipient_id') String? recipientId,
  }) = _Apply;

  factory Apply.fromJson(Map<String, dynamic> json) => _$ApplyFromJson(json);
}
