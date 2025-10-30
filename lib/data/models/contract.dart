import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract.freezed.dart';
part 'contract.g.dart';

@freezed
class Contract with _$Contract {
  const factory Contract({
    required String type,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'duration') int? durationMonths,
    @JsonKey(name: 'remote') String? workMode,
  }) = _Contract;

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);
}
