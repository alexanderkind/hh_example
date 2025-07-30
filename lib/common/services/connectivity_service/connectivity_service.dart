import 'dart:async';

import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

@Riverpod(keepAlive: true)
class ConnectivityService extends _$ConnectivityService {
  Logs get _logs => ref.read(loggerProvider);

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _connectivity = Connectivity();

  @override
  List<ConnectivityResult> build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });

    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> r) {
      _logs.d('onConnectivityChanged: $r');
      state = r;
    });

    return [];
  }

  bool get hasNetworkConnection => !state.contains(ConnectivityResult.none);
}
