import 'package:hh_example/common/widgets/charts/base_chart_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bar_chart_entry.freezed.dart';

@freezed
class BarChartEntry<T> extends BaseChartEntry<T> with _$BarChartEntry<T> {
  const BarChartEntry._();

  const factory BarChartEntry({
    required T key,
    required String title,
    required num value,
  }) = _BarChartEntry<T>;
}
