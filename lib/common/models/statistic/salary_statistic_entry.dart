import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_statistic_entry.freezed.dart';

@freezed
class SalaryStatisticEntry with _$SalaryStatisticEntry {
  const SalaryStatisticEntry._();

  const factory SalaryStatisticEntry({
    required DateTime from,
    required DateTime to,
    required double value,
  }) = _SalaryStatisticEntry;
}
