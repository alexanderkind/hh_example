import 'package:hh_example/common/utils/extensions/date_extensions.dart';

/// Подсчёт кол-ва недель между двумя датами (с неполными неделями)
int countWeeksBetweenDates(DateTime first, DateTime second) {
  /// Кол-во дней в месяце с текущим
  var durationPeriodInDays = second.difference(first).abs().inDays + 1;

  /// Кол-во дней до след. понедельника
  final daysToNextMonday = first.daysToNextMonday;

  /// Если кол-во дней периода меньше или равно  кол-ву дней до понедельника след недели,
  /// то в этом периоде не может быть более одной недели
  /// Считать дальше не имеет смысла
  if (durationPeriodInDays <= daysToNextMonday) {
    return 1;
  }

  /// Вычитаем кол-во дней до понедельника следующей недели,
  /// чтобы начать считать кол-во недель от понедельника
  durationPeriodInDays -= daysToNextMonday;

  /// Прибавляем 1 к оставшемуся кол-ву за предыдущее действие
  return (durationPeriodInDays / DateTime.sunday).ceil() + 1;
}
