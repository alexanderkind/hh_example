import 'package:hh_example/common/models/statistic/statistic_day_mixin.dart';
import 'package:hh_example/common/utils/default_serializer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_day.freezed.dart';
part 'salary_day.g.dart';

@freezed
class SalaryDay with _$SalaryDay, StatisticDayMixin {
  const SalaryDay._();

  const factory SalaryDay({
    required DateTime date,
    required String day,
    @JsonKey(fromJson: DefaultSerializer.doubleFromJson) required double amount,
  }) = _SalaryDay;

  factory SalaryDay.fromJson(Map<String, dynamic> json) => _$SalaryDayFromJson(json);
}
