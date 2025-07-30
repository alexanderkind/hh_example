import 'package:hh_example/common/models/chat/chats.dart';
import 'package:hh_example/common/models/chat/create_chat_request.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract interface class IChats {
  Stream<List<ChatModel>> get chatsStream;

  /// [uuid] - UUID комнаты (чата)
  Stream<ChatModel> chatStream(String uuid);

  /// [uuid] - UUID комнаты (чата)
  Stream<ChatModelMessage> chatLastMessageStream(String uuid);

  Future<List<ChatModel>> getChats();

  /// [uuid] - UUID комнаты (чата)
  Future<ChatModel?> getChat(String uuid);

  /// [receiverId] - ID пассажира
  Future<ChatModel> createChat(CreateChatRequest data);

  /// [uuid] - UUID комнаты (чата)
  /// [cursor] - UUID сообщения
  /// [limit] - Ограничение по кол-ву сообщений
  Future<List<ChatModelMessage>> getMessages(String uuid, {String? cursor, int? limit});

  /// [uuid] - UUID комнаты (чата)
  /// [body] - Текст сообщения
  /// [image] - Изображение
  Future<ChatModelMessage> sendMessage({
    required String uuid,
    String body,
    AssetEntity? image,
  });

  /// [uuid] - UUID комнаты (чата)
  Future<void> markMessagesSeen(String uuid);
}
