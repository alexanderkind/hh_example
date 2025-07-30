import 'package:hh_example/common/config/endpoints.dart';
import 'package:hh_example/common/models/statistic/distance_day.dart';
import 'package:hh_example/common/models/statistic/distance_statistic_entry.dart';
import 'package:hh_example/common/models/statistic/salary_day.dart';
import 'package:hh_example/common/models/statistic/salary_statistic_entry.dart';
import 'package:hh_example/common/models/statistic/statistic_day_mixin.dart';
import 'package:hh_example/common/models/statistic/statistic_period_type.dart';
import 'package:hh_example/common/network/api_client.dart';
import 'package:hh_example/common/providers/statistic/statistic_abstraction.dart';
import 'package:hh_example/common/services/json_decode_service.dart';
import 'package:hh_example/common/utils/extensions/date_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistic_provider.g.dart';

@riverpod
IStatistic statistic(StatisticRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  final endpoints = ref.watch(endpointsProvider);
  final jsonDecode = ref.watch(jsonDecodeServiceProvider);
  return StatisticProvider(
    apiClient,
    endpoints,
    jsonDecode,
  );
}

class StatisticProvider extends IStatistic {
  final ApiClient _api;
  final Endpoints _endpoints;
  final JsonDecodeService _jsonDecode;

  StatisticProvider(this._api, this._endpoints, this._jsonDecode);

  @override
  Future<List<SalaryDay>?> getSalaryByPeriod(StatisticPeriodType type) async {
    final queryParameters = {'period': type.name};

    final response = await _api.client.get(
      _endpoints.statistic.salary,
      queryParameters: queryParameters,
    );

    return _jsonDecode.run<List<SalaryDay>?>(
      jsonDecoder: (data) {
        return (data as List<dynamic>?)?.map((e) => SalaryDay.fromJson(e)).toList();
      },
      data: response.data,
    );
  }

  @override
  Future<List<SalaryStatisticEntry>?> getSalaryGroupedByWeekDayPerWeek() async {
    final days = await getSalaryByPeriod(StatisticPeriodType.week);

    return _dayToGroupedByWeekDay(
      days: days,
      transform: (day) => SalaryStatisticEntry(from: day.date, to: day.date, value: day.amount),
    );
  }

  @override
  Future<List<SalaryStatisticEntry>?> getSalaryGroupedByWeekPerMonth() async {
    final days = await getSalaryByPeriod(StatisticPeriodType.month);

    return _dayToGroupedByWeek(
      days: days,
      transformValue: (day) => day.amount,
      transform: (start, end, values) => SalaryStatisticEntry(
        from: start,
        to: end,
        value: values.fold(0.0, (p, v) => p + v),
      ),
    );
  }

  @override
  Future<List<SalaryStatisticEntry>?> getSalaryGroupedByMonthPerYear() async {
    final days = await getSalaryByPeriod(StatisticPeriodType.year);

    return _dayToGroupedByMonth(
      days: days,
      transformValue: (day) => day.amount,
      transform: (start, end, values) => SalaryStatisticEntry(
        from: start,
        to: end,
        value: values.fold(0.0, (p, v) => p + v),
      ),
    );
  }

  @override
  Future<List<DistanceDay>?> getDistanceByPeriod(StatisticPeriodType type) async {
    final queryParameters = {'period': type.name};

    final response = await _api.client.get(
      _endpoints.statistic.kilometers,
      queryParameters: queryParameters,
    );

    return _jsonDecode.run<List<DistanceDay>?>(
      jsonDecoder: (data) {
        return (data as List<dynamic>?)?.map((e) => DistanceDay.fromJson(e)).toList();
      },
      data: response.data,
    );
  }

  @override
  Future<List<DistanceStatisticEntry>?> getDistanceGroupedByWeekDayPerWeek() async {
    final days = await getDistanceByPeriod(StatisticPeriodType.week);

    return _dayToGroupedByWeekDay(
      days: days,
      transform: (day) => DistanceStatisticEntry(from: day.date, to: day.date, value: day.distance),
    );
  }

  @override
  Future<List<DistanceStatisticEntry>?> getDistanceGroupedByWeekPerMonth() async {
    final days = await getDistanceByPeriod(StatisticPeriodType.month);

    return _dayToGroupedByWeek(
      days: days,
      transformValue: (day) => day.distance,
      transform: (start, end, values) => DistanceStatisticEntry(
        from: start,
        to: end,
        value: values.fold(0, (p, v) => p + v),
      ),
    );
  }

  @override
  Future<List<DistanceStatisticEntry>?> getDistanceGroupedByMonthPerYear() async {
    final days = await getDistanceByPeriod(StatisticPeriodType.year);

    return _dayToGroupedByMonth(
      days: days,
      transformValue: (day) => day.distance,
      transform: (start, end, values) => DistanceStatisticEntry(
        from: start,
        to: end,
        value: values.fold(0, (p, v) => p + v),
      ),
    );
  }

  List<DT>? _dayToGroupedByWeekDay<D extends StatisticDayMixin, DT>({
    List<D>? days,
    required DT Function(D day) transform,
  }) =>
      days?.map(transform).toList();

  List<DT>? _dayToGroupedByWeek<D extends StatisticDayMixin, DT, V>({
    List<D>? days,
    required V Function(D day) transformValue,
    required DT Function(DateTime start, DateTime end, Iterable<V> values) transform,
  }) {
    if (days == null) {
      return null;
    }

    if (days.isEmpty) {
      return [];
    }

    var startDate = days.first.date;
    final endDate = days.last.date;

    final entries = <DT>[];
    while (!startDate.isAfter(endDate)) {
      final endDateWeek = startDate.add(Duration(days: startDate.daysToNextMondayWithoutCurrent));
      final values = days
          .where((d) => !d.date.isBefore(startDate) && !d.date.isAfter(endDateWeek))
          .map((d) => transformValue(d));

      entries.add(transform(startDate, endDateWeek, values));

      /// Переход к понедельнику следующей недели
      startDate = endDateWeek.add(const Duration(days: 1));
    }

    return entries;
  }

  List<DT>? _dayToGroupedByMonth<D extends StatisticDayMixin, DT, V>({
    List<D>? days,
    required V Function(D day) transformValue,
    required DT Function(DateTime start, DateTime end, Iterable<V> values) transform,
  }) {
    if (days == null) {
      return null;
    }

    if (days.isEmpty) {
      return [];
    }

    var startDate = days.first.date;
    final endDate = days.last.date;

    final entries = <DT>[];
    while (!startDate.isAfter(endDate)) {
      final endDateMonth =
          startDate.copyWith(month: startDate.month + 1).subtract(const Duration(days: 1));
      final values = days
          .where((d) => !d.date.isBefore(startDate) && !d.date.isAfter(endDateMonth))
          .map((d) => transformValue(d));

      entries.add(transform(startDate, endDateMonth, values));

      /// Переход к 1-му числу следующего месяца
      startDate = startDate.copyWith(month: startDate.month + 1, day: 1);
    }

    return entries;
  }
}
