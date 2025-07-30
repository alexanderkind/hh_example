import 'package:hh_example/common/config/endpoints.dart';
import 'package:hh_example/common/models/tip/tip_response.dart';
import 'package:hh_example/common/network/api_client.dart';
import 'package:hh_example/common/providers/tip/tips_abstraction.dart';
import 'package:async_task/async_task_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tips_provider.g.dart';

@riverpod
ITips tips(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final endpoints = ref.watch(endpointsProvider);

  return TipsProvider(
    api: api,
    endpoints: endpoints,
  );
}

class TipsProvider implements ITips {
  final ApiClient _api;
  final Endpoints _endpoints;

  TipsProvider({
    required ApiClient api,
    required Endpoints endpoints,
  })  : _api = api,
        _endpoints = endpoints;

  @override
  Future<TipResponse> getTipAmount() async {
    final response = await _api.client.get(_endpoints.tips.getTipAmount);
    return TipResponse.fromJson(response.data);
  }

  @override
  Future<void> acceptTip() => _api.client.post(_endpoints.tips.acceptTip);
}
