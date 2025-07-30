import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

/// Получение изображения из ресурсов
Future<Image> loadUiImage(String imageAssetPath) async {
  final bytes = (await rootBundle.load(imageAssetPath)).buffer.asUint8List();
  final Completer<Image> completer = Completer();
  decodeImageFromList(Uint8List.view(bytes.buffer), completer.complete);
  return completer.future;
}
