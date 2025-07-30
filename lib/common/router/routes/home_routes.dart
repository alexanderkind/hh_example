part of '../routes.dart';

@TypedStatefulShellRoute<HomeRoute>(
  branches: [
    TypedStatefulShellBranch<TasksBranch>(
      routes: [
        TypedGoRoute<TasksRoute>(
          path: '/',
          routes: [
            TypedGoRoute<TransferDetailsRoute>(
              path: 'transfer-details/${TransferDetailsRoute.colonTransferIdKey}',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ChatsBranch>(
      routes: [
        TypedGoRoute<ChatsRoute>(
          path: '/chats',
          routes: [
            TypedGoRoute<NewChatRoute>(path: 'new-chat'),
            TypedGoRoute<ChatRoute>(path: 'chat/${ChatRoute.colonChatUuidKey}'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: '/profile',
          routes: [
            TypedGoRoute<ProfileEditRoute>(
              path: 'profile-edit',
              routes: [
                TypedGoRoute<SelectPhoneRoute>(path: 'select-phone'),
              ],
            ),
            TypedGoRoute<TransferHistoryRoute>(path: 'transfer-history'),
            TypedGoRoute<SelectNavigatorRoute>(path: 'select-navigator'),
            TypedGoRoute<ProfileTermsRoute>(path: 'terms'),
            TypedGoRoute<ProfilePolicyRoute>(path: 'policy'),
            TypedGoRoute<ProfileContactsRoute>(path: 'contacts'),
          ],
        ),
      ],
    ),
  ],
)
class HomeRoute extends StatefulShellRouteData {
  const HomeRoute();

  static const String $restorationScopeId = 'homeRestorationScopeId';

  @override
  Widget builder(context, state, navigationShell) => navigationShell;

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return HomePage(
      navigationShell: navigationShell,
      children: children,
    );
  }
}
