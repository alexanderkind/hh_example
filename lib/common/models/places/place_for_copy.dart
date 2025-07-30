import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_for_copy.freezed.dart';

@freezed
class PlaceForCopy with _$PlaceForCopy {
  const PlaceForCopy._();

  const factory PlaceForCopy({
    required String name,
    required String copyValue,
  }) = _PlaceForCopy;

  factory PlaceForCopy.fromName(String name) => PlaceForCopy(
        name: name,
        copyValue: name,
      );
}
