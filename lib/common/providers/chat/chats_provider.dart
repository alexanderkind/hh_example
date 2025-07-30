import 'dart:async';

import 'package:hh_example/common/config/endpoints.dart';
import 'package:hh_example/common/models/chat/chats.dart';
import 'package:hh_example/common/models/chat/create_chat_request.dart';
import 'package:hh_example/common/network/api_client.dart';
import 'package:hh_example/common/providers/chat/chats_abstraction.dart';
import 'package:hh_example/common/providers/file_uploader/file_uploader.dart';
import 'package:hh_example/common/services/json_decode_service.dart';
import 'package:hh_example/common/sockets/driver/listen/new_message.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'chats_provider.g.dart';

@riverpod
IChats chats(ChatsRef ref) {
  final api = ref.watch(apiClientProvider);
  final endpoints = ref.watch(endpointsProvider);
  final jsonDecode = ref.watch(jsonDecodeServiceProvider);

  final chats = ChatsProvider(api: api, endpoints: endpoints, jsonDecode: jsonDecode);

  /// Обновление последних сообщений в чатах
  ref.listen(newMessageListenProvider, (p, n) {
    if (n != null) {
      chats.updateLastMessage(n.message);
    }
  });
  ref.onDispose(chats.dispose);

  return chats;
}

class ChatsProvider implements IChats {
  final ApiClient _api;
  final Endpoints _endpoints;
  final JsonDecodeService _jsonDecode;

  final _prevChats = <ChatModel>[];
  final _chats = <ChatModel>[];
  final _chatsStreamController = StreamController<List<ChatModel>>.broadcast();

  ChatsProvider({
    required ApiClient api,
    required Endpoints endpoints,
    required JsonDecodeService jsonDecode,
  })  : _api = api,
        _endpoints = endpoints,
        _jsonDecode = jsonDecode;

  @override
  Stream<List<ChatModel>> get chatsStream => _chatsStreamController.stream;

  @override
  Stream<ChatModel> chatStream(String uuid) => chatsStream.skipWhile((c) {
        final pc = _prevChats.where((c) => c.uuid == uuid).firstOrNull;
        final nc = c.where((c) => c.uuid == uuid).firstOrNull;

        return nc == null || nc.uuid != uuid || pc == nc;
      }).map((event) {
        return event.where((c) => c.uuid == uuid).first;
      });

  @override
  Stream<ChatModelMessage> chatLastMessageStream(String uuid) => chatStream(uuid).skipWhile((c) {
        final pm = _prevChats.where((c) => c.uuid == uuid).firstOrNull?.last;
        final nm = c.last;

        return nm == null || pm == nm;
      }).map((event) {
        return event.last!;
      });

  @override
  Future<List<ChatModel>> getChats() async {
    final response = await _api.client.get(_endpoints.chats.getChats);

    final result = await _jsonDecode.run<List<ChatModel>>(
      jsonDecoder: (data) {
        return (data as List<dynamic>).map((e) => ChatModel.fromJson(e)).toList();
      },
      data: response.data,
    );

    _updateChats(result);

    return _chats;
  }

  @override
  Future<ChatModel?> getChat(String uuid) {
    return Future.value(_chats.where((e) => e.uuid == uuid).firstOrNull);
  }

  @override
  Future<ChatModel> createChat(CreateChatRequest data) async {
    final response = await _api.client.post(_endpoints.chats.createChat, data: data.toJson());

    final result = await _jsonDecode.run<ChatModel>(
      jsonDecoder: (data) => ChatModel.fromJson(data),
      data: response.data,
    );

    final newChats = _chats.toList()
      ..removeWhere((c) => c.uuid == result.uuid)
      ..add(result);

    _updateChats(newChats);

    return result;
  }

  @override
  Future<List<ChatModelMessage>> getMessages(String uuid, {String? cursor, int? limit}) async {
    final queryParameters = <String, dynamic>{
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
    final response = await _api.client.get(
      _endpoints.chats.getMessagesByChat(uuid),
      queryParameters: queryParameters,
    );

    final result = _jsonDecode.run<List<ChatModelMessage>>(
      jsonDecoder: (data) {
        return (data as List<dynamic>).map((e) => ChatModelMessage.fromJson(e)).toList();
      },
      data: response.data,
    );

    return result;
  }

  @override
  Future<ChatModelMessage> sendMessage({
    required String uuid,
    String? body,
    AssetEntity? image,
  }) async {
    if (body?.isNotEmpty == false && image == null) {
      throw 'Data is empty';
    }

    final data = {
      'uuid': uuid,
      if (body != null) 'body': body,
    };

    late Response response;
    if (image != null) {
      /// Запрос с изображением
      final mp = await FileUploader.buildAssetMultipart(image);
      final formData = FormData.fromMap({...data, 'file': mp});

      response = await _api.client.post(_endpoints.chats.uploadFile, data: formData);
    } else {
      /// Запрос с текстом
      response = await _api.client.post(_endpoints.chats.sendMessage, data: data);
    }

    final result = await _jsonDecode.run<ChatModelMessage>(
      jsonDecoder: (data) => ChatModelMessage.fromJson(data),
      data: response.data,
    );

    await updateLastMessage(result);

    return result;
  }

  @override
  Future<void> markMessagesSeen(String uuid) async {
    await _api.client.post(_endpoints.chats.chatSeen(uuid));

    final chat = await getChat(uuid);
    if (chat != null) {
      final newChats = _chats.toList();
      newChats.remove(chat);
      newChats.add(chat.copyWith(unseen: 0));

      _updateChats(newChats);
    }
  }

  /// Изменение последнего сообщения в чате
  Future<void> updateLastMessage(ChatModelMessage newMessage) async {
    var currentChat = await getChat(newMessage.room);

    /// Если чат есть, то обновляем локально последнее сообщение чата
    if (currentChat != null) {
      final newChats = _chats.toList();
      final unseen = currentChat.unseen + (newMessage.sender != currentChat.driver.uuid ? 1 : 0);
      final newChat = currentChat.copyWith(last: newMessage, unseen: unseen);
      newChats
        ..remove(currentChat)
        ..add(newChat);
      _updateChats(newChats);
    } else {
      /// Если нет, то запрашиваем из сети
      await getChats();
    }
  }

  void _updateChats(List<ChatModel> chats) {
    /// Обновление чата с сортировкой по последнему сообщению
    chats.sort((a, b) => (b.last?.createdAt.microsecondsSinceEpoch ?? 0)
        .compareTo((a.last?.createdAt.microsecondsSinceEpoch ?? 0)));

    _prevChats.clear();
    _prevChats.addAll(_chats.toList());
    _chats.clear();
    _chats.addAll(chats.toSet());

    _chatsStreamController.add(_chats);
  }

  Future<void> dispose() => _chatsStreamController.close();
}
