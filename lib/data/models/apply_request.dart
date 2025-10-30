import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_request.freezed.dart';
part 'apply_request.g.dart';

@freezed
class ApplyRequest with _$ApplyRequest {
  const factory ApplyRequest({
    @JsonKey(name: 'applicant_first_name') required String applicantFirstName,
    @JsonKey(name: 'applicant_last_name') required String applicantLastName,
    @JsonKey(name: 'applicant_email') required String applicantEmail,
    @JsonKey(name: 'applicant_phone') required String applicantPhone,
    @JsonKey(name: 'applicant_attachment_name')
    required String applicantAttachmentName,
    @JsonKey(name: 'applicant_attachment_content')
    required String applicantAttachmentContent,
    @JsonKey(name: 'recipient_id') required String recipientId,
    @JsonKey(name: 'applicant_message') String? applicantMessage,
  }) = _ApplyRequest;

  factory ApplyRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyRequestFromJson(json);
}
