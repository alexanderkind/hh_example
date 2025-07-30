part of '../routes.dart';

class TasksBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorTasksKey;
}

class TasksRoute extends GoRouteData {
  const TasksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TasksPage();
  }
}

class TransferDetailsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = globalNavKey;

  static const transferIdKey = 'tid';
  static const colonTransferIdKey = ':$transferIdKey';

  final int tid;

  const TransferDetailsRoute(this.tid);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransferDetailsPage(
      id: tid,
    );
  }
}

@TypedGoRoute<DriverOrderFormRoute>(path: '/driver-order-form')
class DriverOrderFormRoute extends GoRouteData {
  const DriverOrderFormRoute(this.taskIds);

  final List<int>? taskIds;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DriverOrderFormPage(taskIds: taskIds ?? []);
  }
}

@TypedGoRoute<ShareTripInfoRoute>(path: '/share-trip-info')
class ShareTripInfoRoute extends GoRouteData {
  final ShareTripInfoType type;

  const ShareTripInfoRoute({
    this.type = ShareTripInfoType.twoPickTwoDrop,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ShareTripInfoPage(
      type: type,
    );
  }
}

@TypedGoRoute<TransferSignRoute>(path: '/transfer-sign')
class TransferSignRoute extends GoRouteData {
  final List<String>? signs;

  const TransferSignRoute({
    required this.signs,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransferSignPage(
      signs: signs ?? [],
    );
  }
}
