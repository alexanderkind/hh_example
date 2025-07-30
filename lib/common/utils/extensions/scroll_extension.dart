import 'package:flutter/material.dart';

extension ScrollControllerExtensions on ScrollController {
  bool loadMoreByHScreenInvert([double? extent]) {
    return position.pixels >= position.minScrollExtent + (extent ?? 50) && hasClients;
  }
}

extension ScrollNotificationExtensions on ScrollNotification {
  bool loadMoreByHScreen() {
    return metrics.pixels >= (metrics.maxScrollExtent * 0.8) &&
        metrics.axisDirection == AxisDirection.down &&
        metrics.axis == Axis.vertical &&
        !metrics.outOfRange;
  }

  /// [delta] - Разница между [metrics.maxScrollExtent] и [metrics.pixels]
  /// до которой должно срабатывать обновление
  bool loadMoreByDelta([double delta = 200]) {
    return (metrics.maxScrollExtent - metrics.pixels) <= delta &&
        metrics.axisDirection == AxisDirection.down &&
        metrics.axis == Axis.vertical &&
        !metrics.outOfRange;
  }
}
