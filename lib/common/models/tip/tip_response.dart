import 'package:hh_example/common/models/tip/tip_cents_mixin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tip_response.freezed.dart';
part 'tip_response.g.dart';

@freezed
class TipResponse with _$TipResponse, TipCentsMixin {
  const TipResponse._();

  const factory TipResponse({
    int? amount,
  }) = _TipResponse;

  @override
  int get tipInCents => amount ?? 0;

  factory TipResponse.fromJson(Map<String, dynamic> json) => _$TipResponseFromJson(json);
}
