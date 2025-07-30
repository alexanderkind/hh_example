import 'package:alps2alps_cool_driver/common/hooks/use_theme_extension.dart';
import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/models/task_status/task_statuses.dart';
import 'package:alps2alps_cool_driver/common/router/routes.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/bottom_sheet/drag_handle.dart';
import 'package:alps2alps_cool_driver/common/widgets/items/task_item/task_content.dart';
import 'package:alps2alps_cool_driver/common/widgets/theme_extensions.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_content_actions.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_content_client_info.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_content_clients_on_top.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_content_data_problems_warning.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_content_flight_delay_warning.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_content_other_drivers.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_content_service_info.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/transfer_tips_content.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/state/transfer_details_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// [BottomSheet] Вся информация по трансферу
class TransferContentSheet extends HookConsumerWidget {
  final double minContentSize;
  final DraggableScrollableController draggableScrollableController;

  const TransferContentSheet({
    super.key,
    required this.minContentSize,
    required this.draggableScrollableController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(transferDetailsNotifierProvider.notifier);
    final colors = useThemeExtension<ColorsScheme>();
    final borders = useThemeExtension<BorderRadiusScheme>();

    final state = ref.watch(transferDetailsNotifierProvider);

    /// Позвонить пассажиру
    final onCallPassenger = useCallback(bloc.callPassenger);

    /// Переход в чат с пассажиром
    final onChatPassenger = useCallback((Transfer transfer) {
      final loyaltyUserId = transfer.loyaltyUserId;

      if (loyaltyUserId == null) {
        return;
      }

      NewChatRoute(loyaltyUserId).push(context);
    });

    return state.whenOrNull(
          main: (data) {
            final loading = data.loading;
            final task = loading ? bloc.fakeTask : data.requiredTask;
            final transfers = task.data;
            final status = task.localStatus;
            final activeTransfer = task.activeTransfer;
            final otherDrivers = task.otherDrivers.toList();
            final actionRestrictions = data.actionRestrictions;
            final tipAmount = data.task?.tipAmount;

            return DraggableScrollableSheet(
              controller: draggableScrollableController,
              initialChildSize: minContentSize,
              minChildSize: minContentSize,
              builder: (context, scrollController) {
                return Skeletonizer(
                  enabled: loading,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.backgroundPrimary,
                      borderRadius: borders.bottomSheet,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 5.h))
                      ],
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        const SliverToBoxAdapter(child: DragHandle()),

                        /// Предупреждение о наличии ошибок
                        TransferContentDataProblemsWarning(task: task),

                        /// Предупрежджение о задержке рейса
                        TransferContentFlightDelayWarning(
                          status: status,
                          activeTransfer: activeTransfer,
                        ),

                        /// Список пассажиров
                        TransferContentClientOnTop(
                          status: status,
                          transfers: transfers,
                          activeTransfer: activeTransfer,
                          onCallPassenger: onCallPassenger,
                          onChatPassenger: onChatPassenger,
                          actionRestrictions: actionRestrictions,
                        ),

                        /// Чаевые
                        TransferTipsContent(
                          tips: tipAmount,
                        ),

                        /// Информация о трансфере
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                          sliver: SliverToBoxAdapter(
                            child: TaskContent.fromTask(
                              task: task,
                              copyAddress: true,
                            ),
                          ),
                        ),

                        /// Информация об услуге
                        TransferContentServiceInfo(task: task),

                        /// Действия
                        TransferContentActions(
                          actionRestrictions: actionRestrictions,
                          task: task,
                        ),

                        /// Подробная информация о клиентах
                        TransferContentClientInfo(
                          transfers: transfers,
                          onCallPassenger: onCallPassenger,
                          onChatPassenger: onChatPassenger,
                          actionRestrictions: actionRestrictions,
                        ),

                        // TODO(alexanderkind): Отложено. Восстановить, если будем делать в дальнейшем
                        /// Информация о доп точках
                        // const TransferContentAdditionalStop(),

                        /// Список других водителей в заказе
                        TransferContentOtherDrivers(drivers: otherDrivers),

                        /// Отступ для кнопок
                        SliverToBoxAdapter(
                          child: AnimatedSize(
                            duration: CustomAnimatedSwitcher.defaultDuration,
                            child: SizedBox(
                              height: status == LocalTaskStatus.completed ? 24.h : 80.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ) ??
        const SizedBox();
  }
}
