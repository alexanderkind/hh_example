import 'package:freezed_annotation/freezed_annotation.dart';

part 'distance_statistic_entry.freezed.dart';

@freezed
class DistanceStatisticEntry with _$DistanceStatisticEntry {
  const DistanceStatisticEntry._();

  const factory DistanceStatisticEntry({
    required DateTime from,
    required DateTime to,
    required int value,
  }) = _DistanceStatisticEntry;
}
