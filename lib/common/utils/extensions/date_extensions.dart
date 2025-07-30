import 'package:hh_example/common/utils/date_time.dart';
import 'package:hh_example/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toPickUp({required String text}) {
    final date = DateFormat('dd.MM.yyyy, HH:mm').format(this);

    return '$text - $date';
  }

  String toRequest() {
    return DateFormat('yyyy-MM-dd HH:mm:00').format(this);
  }

  String toDefaultDateTimeFormatWithoutSec() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }

  String toDefaultDateFormat() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toDmmmFormat() {
    return DateFormat('d MMM').format(this);
  }

  String toDmmmmFormat() {
    return DateFormat('d MMMM').format(this);
  }

  String toDmmmyyyyFormat() {
    return DateFormat('d MMM yyyy').format(this);
  }

  String toDmmmmyyyyFormat() {
    return DateFormat('d MMMM yyyy').format(this);
  }

  String toDmmmyyyyhmFormat() {
    return DateFormat('d MMM yyyy HH:mm').format(this);
  }

  String toHhmmFormat() {
    return DateFormat('HH:mm').format(this);
  }

  bool get isToday => DateTime.now().toDefaultDateFormat() == toDefaultDateFormat();

  bool get isTomorrow =>
      DateTime.now().add(const Duration(days: 1)).toDefaultDateFormat() == toDefaultDateFormat();

  String toWeekdayFullFormat() => DateFormat('EEEE').format(this);

  String toWeekdayShortFormat() => toWeekdayFullFormat()[0];

  String toMonthFullFormat() => DateFormat('MMMM').format(this);

  String toMonthShortFormat() => toMonthFullFormat()[0];

  /// Кол-во неполных недель в месяце
  int get countWeeksInMonth {
    final startDate = copyWith(day: 1);
    final lastDate =
        startDate.copyWith(month: startDate.month + 1).subtract(const Duration(days: 1));

    return countWeeksBetweenDates(startDate, lastDate);
  }

  /// Текущий номер недели в месяце из неполных
  int get numberOfWeekInMonth => countWeeksBetweenDates(copyWith(day: 1), this);

  /// Кол-во дней до следующего понедельника (с текущим днём включительно)
  int get daysToNextMonday => DateTime.sunday - weekday + 1;

  /// Кол-во дней до следующего понедельника
  int get daysToNextMondayWithoutCurrent => DateTime.sunday - weekday;
}

extension StringDateExtensions on String {
  DateTime? toDate() {
    final date = split(' ');
    return DateTime.tryParse('${date[0]}T${date[1]}Z');
  }
}

extension DateStringExtensions on String {
  DateTime? get tryParseFromSlashed {
    final d = DateFormat('dd / MM / yyyy').tryParse(this, true);
    return d;
  }

  String? get parseForTransfer {
    if (toDate() == null) return null;

    return DateFormat('dd MMM yyyy HH:mm').format(toDate()!);
  }

  String? toMinutes(AppLocalizations loc) {
    List<int> times = List.filled(3, 0, growable: true);
    final timesSplit = split(':');

    for (final (index, value) in timesSplit.indexed) {
      times[index] = int.tryParse(value) ?? 0;
    }
    Duration time = Duration(
      hours: times.first,
      minutes: times[1],
      seconds: times[2],
    );

    return loc.bookingHistoryTime(
      time.inHours.remainder(Duration.hoursPerDay),
      time.inMinutes.remainder(Duration.minutesPerHour),
    );
  }
}
