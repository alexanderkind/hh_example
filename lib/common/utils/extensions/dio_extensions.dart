import 'package:dio/dio.dart';

extension FormDataExtensions on FormData {
  void removeNullValue() {
    fields.removeWhere((element) {
      return element.value.isNotEmpty != true;
    });
  }
}

extension DataExtensions on Map {
  void removeNullValue() {
    removeWhere((key, value) {
      if (key == 'runtimeType') {
        return true;
      }
      if (value is Map) {
        value.removeNullValue();
      }
      return value == null ||
          value == '' ||
          (value is Iterable && value.isEmpty) ||
          (value is Map && value.isEmpty);
    });
  }

  void removeOnlyNullValue() {
    removeWhere((key, value) {
      return value == null || (value is Iterable && value.isEmpty);
    });
  }
}

extension ListExtensions on List {
  void removeNullValue() {
    removeWhere((value) {
      return value == null || value == '' || (value is Iterable && value.isEmpty);
    });
  }
}
