part of '../routes.dart';

class ChatsBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorChatKey;
}

class ChatsRoute extends GoRouteData {
  const ChatsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatsPage();
  }
}

class ChatRoute extends GoRouteData {
  static const chatUuidKey = 'cid';
  static const colonChatUuidKey = ':$chatUuidKey';

  static final GlobalKey<NavigatorState> $parentNavigatorKey = globalNavKey;

  final String cid;

  const ChatRoute(this.cid);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatPage(chatUuid: cid);
  }
}

class NewChatRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = globalNavKey;

  final int customerId;

  const NewChatRoute(this.customerId);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatPage(customerId: customerId);
  }
}
