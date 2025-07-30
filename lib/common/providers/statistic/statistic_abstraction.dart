import 'package:hh_example/common/models/statistic/distance_day.dart';
import 'package:hh_example/common/models/statistic/distance_statistic_entry.dart';
import 'package:hh_example/common/models/statistic/salary_day.dart';
import 'package:hh_example/common/models/statistic/salary_statistic_entry.dart';
import 'package:hh_example/common/models/statistic/statistic_grouped_type.dart';
import 'package:hh_example/common/models/statistic/statistic_period_type.dart';

abstract class IStatistic {
  /// Статистика заработка водителя в днях по периоду статистики
  Future<List<SalaryDay>?> getSalaryByPeriod(StatisticPeriodType type);

  /// Статистика задаботка в днях недели на неделю
  /// Ключ - дата дня недели
  /// Значение - заработок
  Future<List<SalaryStatisticEntry>?> getSalaryGroupedByWeekDayPerWeek();

  /// Статистика задаботка в неделях на месяц
  /// Ключ - первая дата в неделе
  /// Значение - заработок
  Future<List<SalaryStatisticEntry>?> getSalaryGroupedByWeekPerMonth();

  /// Статистика задаботка в днях недели на неделю
  /// Ключ - Первая дата в месяце
  /// Значение - заработок
  Future<List<SalaryStatisticEntry>?> getSalaryGroupedByMonthPerYear();

  /// Получение статистики по типу группировки
  Future<List<SalaryStatisticEntry>?> getSalaryByGroupedType(StatisticGroupedType type) =>
      switch (type) {
        StatisticGroupedType.day => getSalaryGroupedByWeekDayPerWeek(),
        StatisticGroupedType.week => getSalaryGroupedByWeekPerMonth(),
        StatisticGroupedType.month => getSalaryGroupedByMonthPerYear(),
      };

  /// Статистика пройденного расстояния в днях по периоду статистики
  Future<List<DistanceDay>?> getDistanceByPeriod(StatisticPeriodType type);

  /// Статистика пройденного расстояния в днях недели на неделю
  /// Ключ - дата дня недели
  /// Значение - заработок
  Future<List<DistanceStatisticEntry>?> getDistanceGroupedByWeekDayPerWeek();

  /// Статистика пройденного расстояния в неделях на месяц
  /// Ключ - первая дата в неделе
  /// Значение - заработок
  Future<List<DistanceStatisticEntry>?> getDistanceGroupedByWeekPerMonth();

  /// Статистика пройденного расстояния в днях недели на неделю
  /// Ключ - Первая дата в месяце
  /// Значение - заработок
  Future<List<DistanceStatisticEntry>?> getDistanceGroupedByMonthPerYear();

  /// Получение статистики по типу группировки
  Future<List<DistanceStatisticEntry>?> getDistanceByGroupedType(StatisticGroupedType type) =>
      switch (type) {
        StatisticGroupedType.day => getDistanceGroupedByWeekDayPerWeek(),
        StatisticGroupedType.week => getDistanceGroupedByWeekPerMonth(),
        StatisticGroupedType.month => getDistanceGroupedByMonthPerYear(),
      };
}
