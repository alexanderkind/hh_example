import 'dart:async';

import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/models/chat/chats.dart';
import 'package:hh_example/common/providers/chat/chats_abstraction.dart';
import 'package:hh_example/common/providers/chat/chats_provider.dart';
import 'package:hh_example/common/utils/extensions/ref_keep_providers_extension.dart';
import 'package:hh_example/features/chats/state/chats_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_notifier.g.dart';

@riverpod
class ChatsNotifier extends _$ChatsNotifier {
  Logs get _logs => ref.read(loggerProvider);

  IChats get _chats => ref.read(chatsProvider);

  late final StreamSubscription<List<ChatModel>> _chatsSubs;
  final fakeChats = [
    ChatModel.fake(),
    ChatModel.fake(),
    ChatModel.fake(),
    ChatModel.fake(),
    ChatModel.fake(),
    ChatModel.fake(),
    ChatModel.fake(),
    ChatModel.fake(),
  ];

  @override
  ChatsState build() {
    ref.keepProvider(chatsProvider);

    /// Отслеживание обновления чатов
    _chatsSubs = _chats.chatsStream.listen(_updateChats);

    ref.onDispose(() {
      _chatsSubs.cancel();
    });

    return const ChatsState(loading: true);
  }

  /// Получение первоначальных данных
  Future<void> init() async {
    state = state.copyWith(loading: true);
    try {
      final chats = await _getChats();

      state = state.copyWith(chats: chats, loading: false);
    } catch (e, s) {
      _logs.e(e, e, s);
      state = state.copyWith(loading: false);
    }
  }

  /// Обновление чатов без лоадера
  Future<void> update() async {
    try {
      final chats = await _getChats();

      _updateChats(chats);
    } catch (e, s) {
      _logs.e(e, e, s);
    }
  }

  /// Получение чатов
  Future<List<ChatModel>> _getChats() => _chats.getChats();

  void _updateChats(List<ChatModel> chats) {
    state = state.copyWith(chats: chats);
  }
}
