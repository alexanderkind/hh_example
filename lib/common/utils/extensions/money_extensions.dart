import 'package:intl/intl.dart';

extension MoneyExtenstions on num? {
  String formatMoney() {
    final formatCurrency = NumberFormat?.simpleCurrency(
      decimalDigits: 2,
      name: 'EUR',
    );

    return formatCurrency.format(this ?? 0);
  }
}
