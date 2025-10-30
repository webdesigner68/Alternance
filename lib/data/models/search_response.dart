import 'package:freezed_annotation/freezed_annotation.dart';
import 'job.dart';

part 'search_response.freezed.dart';
part 'search_response.g.dart';

@freezed
class SearchResponse with _$SearchResponse {
  const factory SearchResponse({
    required List<Job> jobs,
    List<Map<String, dynamic>>? recruiters,
    List<String>? warnings,
  }) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}
