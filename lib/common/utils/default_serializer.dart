import 'package:hh_example/common/utils/extensions/bool_extensions.dart';

class DefaultSerializer {
  static String stringTrimmedFromJson(dynamic json) {
    return stringFromJson(json).trim();
  }

  static String stringFromJson(dynamic json) {
    return json.toString();
  }

  static int intFromJson(dynamic json) {
    return int.parse(json.toString());
  }

  static int? intFromJsonNullable(dynamic json) {
    if (json == null) {
      return null;
    }
    return intFromJson(json);
  }

  static double doubleFromJson(dynamic json) {
    return double.parse(json.toString());
  }

  static double? doubleFromJsonNullable(dynamic json) {
    if (json == null) {
      return null;
    }
    return doubleFromJson(json);
  }

  static bool boolFromJson(dynamic json) {
    if (json is int) {
      return json == 1;
    } else if (json is String && ['0', '1'].contains(json)) {
      return json == '1';
    }
    return bool.tryParse(json.toString().toLowerCase()) ?? false;
  }

  static bool? boolFromJsonNullable(dynamic json) {
    if (json == null) {
      return null;
    }
    return boolFromJson(json);
  }

  static String doubleToString(double value) {
    return value.toString();
  }

  static int boolToInt(bool value) {
    return value.toInt();
  }

  static int dateTimeToMilliseconds(DateTime value) {
    return value.millisecondsSinceEpoch;
  }

  static int? dateTimeToMillisecondsNullable(DateTime? value) {
    if (value == null) {
      return null;
    }
    return dateTimeToMilliseconds(value);
  }
}
