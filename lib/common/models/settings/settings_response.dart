import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_response.freezed.dart';
part 'settings_response.g.dart';

@freezed
class SettingsResponse with _$SettingsResponse {
  const factory SettingsResponse({
    @JsonKey(name: 'terms_and_conditions') String? termsAndConditions,
    @JsonKey(name: 'privacy_policy') String? privacyPolicy,
    @JsonKey(name: 'contact_fr') String? contactFr,
    @JsonKey(name: 'contact_uk') String? contactUk,
    @JsonKey(name: 'contact_au') String? contactAu,
    @JsonKey(name: 'contact_it') String? contactIt,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'transfer_detail') String? transferDetail,
  }) = _SettingsResponse;

  factory SettingsResponse.fromJson(Map<String, Object?> json) => _$SettingsResponseFromJson(json);
}
