import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'endpoints.g.dart';

@riverpod
class Endpoints extends _$Endpoints {
  @override
  Endpoints build() => this;

  final config = const _Config();
  final auth = const _Auth();
  final profile = const _Profile();
  final settings = const _Settings();
  final tasks = const _Tasks();
  final chats = const _Chats();
  final statistic = const _Statistic();
  final tips = const _Tips();
}

final class _Config {
  const _Config();

  final getConfigDev = 'https://example.ru/example_dev.json';
}

final class _Auth {
  const _Auth();

  final login = '/v1/auth/login';
  final logout = '/v1/auth/logout';
}

final class _Profile {
  const _Profile();

  final getProfile = '/v1/profile/show';
  final profileUpdate = '/v1/profile/update';
  final profileUpload = '/v1/profile/upload';
  final setToken = '/v1/firebase/set-token';
  final setLocation = '/v1/transfer/set-location';
}

class _Settings {
  const _Settings();

  final getSettings = '/v1/settings';
}

class _Tasks {
  const _Tasks();

  final getTasks = '/v1/tasks';
  final taskUpdate = '/v1/tasks/update';
  final getHistoryTasks = '/v1/tasks/history';
  final getBonDeCommande = '/v1/tasks/bon-de-commande';
}

class _Chats {
  const _Chats();

  final getChats = '/v1/chats/rooms';
  final createChat = '/v1/chats/rooms';

  String getMessagesByChat(String uuid) => '/v1/chats/room/$uuid/messages';
  final sendMessage = '/v1/chats/send-message';
  final uploadFile = '/v1/chats/upload';

  String chatSeen(String uuid) => '/v1/chats/seen/$uuid';
}

class _Statistic {
  const _Statistic();

  final salary = '/v2/salary';
  final kilometers = '/v1/profile/kilometers';
}

class _Tips {
  const _Tips();

  final getTipAmount = '/tips/v1/tips-amount';
  final acceptTip = '/tips/v1/tip-receive';
}
