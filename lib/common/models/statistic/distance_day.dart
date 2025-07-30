import 'package:hh_example/common/models/statistic/statistic_day_mixin.dart';
import 'package:hh_example/common/utils/default_serializer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'distance_day.freezed.dart';
part 'distance_day.g.dart';

@freezed
class DistanceDay with _$DistanceDay, StatisticDayMixin {
  const DistanceDay._();

  const factory DistanceDay({
    required DateTime date,
    required String day,
    @JsonKey(fromJson: DefaultSerializer.intFromJson) required int distance,
  }) = _DistanceDay;

  factory DistanceDay.fromJson(Map<String, dynamic> json) => _$DistanceDayFromJson(json);
}
