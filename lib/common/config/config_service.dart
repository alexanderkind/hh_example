import 'dart:convert';

import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/models/helpers/config/config_state_model.dart';
import 'package:hh_example/common/providers/config/config_abstraction.dart';
import 'package:hh_example/common/providers/config/config_provider.dart';
import 'package:hh_example/common/services/crypto/crypto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_service.g.dart';

@Riverpod(keepAlive: true)
class ConfigService extends _$ConfigService with ChangeNotifier {
  IConfig get _configProvider => ref.read(configProvider);

  Logs get _logs => ref.read(loggerProvider);

  @override
  ConfigStateModel build() {
    return const ConfigStateModel();
  }

  String _configDecode(String res) => ref.read(cryptoServiceProvider).decrypt(res);

  Future<void> loadConfig() async {
    try {
      final res = await _configProvider.getConfig();

      if (res.config != null && res.config?.startsWith('{') != true) {
        final config = jsonDecode(_configDecode(res.config!));
        state = ConfigStateModel.fromJson(config);
      } else {
        final config = jsonDecode(res.config!);
        state = ConfigStateModel.fromJson(config);
      }

      if (state.baseUrl.isEmpty) {
        throw 'Not contains required config baseUrl or type is not `String`. Founded ${state.baseUrl}';
      }

      notifyListeners();
    } catch (e, s) {
      _logs.e(e, e, s);
      rethrow;
    }
  }

  void setBaseUrl(String baseUrl) {
    state = state.copyWith(
      editUrl: baseUrl,
    );
    notifyListeners();
  }

  String get url {
    if (state.editUrl != null && state.editUrl?.isNotEmpty == true) {
      return state.editUrl!;
    }
    return state.baseUrl;
  }
}
