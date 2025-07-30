import 'package:intl/intl.dart';

final _numberFormat = NumberFormat('00');

extension DurationExtension on Duration {
  String get formatMS {
    final minutes = inMinutes;
    final seconds = inSeconds - inMinutes * Duration.secondsPerMinute;
    return '$minutes:${_numberFormat.format(seconds)}';
  }
}
