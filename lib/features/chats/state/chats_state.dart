import 'package:hh_example/common/models/chat/chats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats_state.freezed.dart';

@freezed
class ChatsState with _$ChatsState {
  const ChatsState._();

  const factory ChatsState({
    @Default(false) bool loading,
    @Default([]) List<ChatModel> chats,
  }) = _ChatsState;

  bool get showSkeleton => loading && chats.isEmpty;

  /// Кол-во непросмотренных сообщений
  int getUnseenCount({String? chatUuid, int? customerId}) => chats
      .where((e) =>
          (chatUuid == null && customerId == null) ||
          chatUuid == e.uuid ||
          customerId == e.customerExternalId)
      .map((e) => e.unseen)
      .fold(0, (pv, v) => pv + v);
}
