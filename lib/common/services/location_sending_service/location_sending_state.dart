import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'location_sending_state.freezed.dart';

@freezed
class LocationSendingState with _$LocationSendingState {
  const LocationSendingState._();

  const factory LocationSendingState({
    @Default(false) enabled,
    Position? currentPosition,
  }) = _LocationSendingState;
}
