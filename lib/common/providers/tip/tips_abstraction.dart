import 'dart:async';

import 'package:hh_example/common/models/tip/tip_response.dart';

abstract interface class ITips {
  Future<TipResponse> getTipAmount();

  /// Принять чаевые
  Future<void> acceptTip();
}
