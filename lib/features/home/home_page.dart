import 'package:hh_example/common/hooks/use_init_state.dart';
import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/router/routes.dart';
import 'package:hh_example/common/services/analytics/analytics_event.dart';
import 'package:hh_example/common/services/app_navigation_service/app_navigation_service.dart';
import 'package:hh_example/common/services/connectivity_service/connectivity_service.dart';
import 'package:hh_example/common/services/fresh_chat_service/fresh_chat_service.dart';
import 'package:hh_example/common/services/location_sending_service/location_sending_service.dart';
import 'package:hh_example/common/services/notification_center_service/notification_center_service.dart';
import 'package:hh_example/common/services/notification_service/notification_notifier.dart';
import 'package:hh_example/common/services/tips_service/tips_service.dart';
import 'package:hh_example/common/utils/extensions/analytics/widget_ref_analytics.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/app_update/update_wrapper_view.dart';
import 'package:hh_example/common/widgets/bottom_navigation_bar/custom_bottom_navigation_bar_item.dart';
import 'package:hh_example/common/widgets/go_router/animated_branch_container.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/features/chats/components/chats_unseen_badge.dart';
import 'package:hh_example/features/chats/state/chats_notifier.dart';
import 'package:hh_example/features/systems/system_error_dialog.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  final StatefulNavigationShell _navigationShell;
  final List<Widget> _children;

  const HomePage({
    super.key,
    required StatefulNavigationShell navigationShell,
    required List<Widget> children,
  })  : _navigationShell = navigationShell,
        _children = children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final loc = context.loc;

    final currentIndex = _navigationShell.currentIndex;

    final selectedColor = colors.iconAccent;
    final unselectedColor = colors.iconTertiary;
    final itemsData = <(SvgGenImage, String, bool)>[
      (Assets.icons.timeFilled, loc.commonTask, false),
      (Assets.icons.chatFilled, loc.commonChat, true),
      (Assets.icons.profileFilled, loc.commonProfile, false),
    ];

    /// Отображение ошибки отсутствия интернет соединения
    // TODO(alexanderkind): Можно вынести в логику
    final connectivityBloc = ref.read(connectivityServiceProvider.notifier);
    var isOpenNetworkDialog = useState(false);

    ref.listen(
      connectivityServiceProvider,
      (p, n) async {
        final hasNetworkConnection = connectivityBloc.hasNetworkConnection;
        if (!hasNetworkConnection && !isOpenNetworkDialog.value) {
          isOpenNetworkDialog.value = true;
          context.push(const SystemErrorRoute(SystemErrorType.internetError).location).then(
            (value) {
              isOpenNetworkDialog.value = false;
            },
          );
        }
      },
    );

    /// Отправка событий в аналитику при переходе на определённые страницы
    ref.listen(appNavigationServiceProvider, (p, n) {
      if (p != n) {
        final currentLocation = n.currentLocation;
        switch (currentLocation) {
          case '/profile':
            ref.analytics.logEvent(AnalyticsEvent.profileView());
            break;
          default:
            break;
        }
      }
    });

    ref.listen(tipsServiceProvider, (p, n) {
      n.whenOrNull(
        acceptedSuccess: () {
          SuccessDialogRoute(
            title: loc.messagesCollectedNewTipsTitle,
            description: loc.messagesCollectedNewTipsDesc,
            btnText: loc.commonOk,
          ).push(context);
        },
      );
    });

    /// Инициализация общих блоков
    final pushNotify = ref.watch(notificationNotifierProvider.notifier);
    final notificationCenterBloc = ref.watch(notificationCenterServiceProvider.notifier);
    final freshChatService = ref.watch(freshChatServiceProvider.notifier);
    final chatsBloc = ref.watch(chatsNotifierProvider.notifier);
    ref.watch(locationSendingServiceProvider.notifier);
    final tipsBloc = ref.watch(tipsServiceProvider.notifier);

    useInitState(
      onBuild: () {
        pushNotify.updateFCMToken();
        notificationCenterBloc.init();
        freshChatService.updateUnreadCount();
        chatsBloc.init();
        ref.analytics.setProfile();
        tipsBloc.updateTips(updateTasks: false);
      },
    );

    /// Обновление данных при возвращении в приложение
    useOnAppLifecycleStateChange((p, c) {
      if (p != c && c == AppLifecycleState.resumed) {
        /// Обновление данных по разрешениям
        notificationCenterBloc.updateState();
      }
    });

    return UpdateWrapperView(
      child: Scaffold(
        body: AnimatedBranchContainer(
          currentIndex: currentIndex,
          children: _children,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: colors.white,
          selectedLabelStyle: textTheme.labelSS,
          unselectedLabelStyle: textTheme.labelSM.copyWith(
            color: colors.textTertiary,
          ),
          onTap: _goBranch,
          currentIndex: currentIndex,
          items: List.generate(
            itemsData.length,
            (index) {
              final itemData = itemsData[index];

              return CustomBottomNavigationBarItem.fadeSvgGenImage(
                svg: itemData.$1,
                isSelected: currentIndex == index,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                label: itemData.$2,
                iconBuilder: itemData.$3
                    ? (context, icon) {
                        return ChatsUnseenBadge.topRightOutside(child: icon);
                      }
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) {
    _navigationShell.goBranch(
      index,
      initialLocation: index == _navigationShell.currentIndex,
    );
  }
}
