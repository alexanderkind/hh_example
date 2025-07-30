import 'package:alps2alps_cool_driver/common/models/task_status/task_statuses.dart';
import 'package:alps2alps_cool_driver/common/router/routes.dart';
import 'package:alps2alps_cool_driver/common/services/analytics/analytics_event.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/analytics/widget_ref_analytics.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_button_styles.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_buttons.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/state/transfer_details_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Кнопки изменения статусов
class TransferBottomButtons extends HookConsumerWidget {
  const TransferBottomButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(transferDetailsNotifierProvider.notifier);
    final loc = context.loc;

    final state = ref.watch(transferDetailsNotifierProvider);

    final button = state.whenOrNull(
          main: (data) {
            final status = data.loading ? null : data.requiredTask.localStatus;
            final dropOffPlaces = data.task?.dropOffCorrectPlaces ?? [];
            final signs = data.task?.signs;
            final actionRestrictions = data.actionRestrictions;

            if (status == LocalTaskStatus.arrived && actionRestrictions) {
              return AppButtons.primary(
                key: ValueKey('${status}_$actionRestrictions'),
                text: loc.transferDetailsClientOnBoard,
                size: AppButtonSize.l,

                /// Пассажир(ы) на борту
                onPressed: () {
                  bloc.clientOnBoard(loc: loc);
                },
              );
            }

            return switch (status) {
              LocalTaskStatus.notStarted => AppButtons.primary(
                  key: ValueKey(status),
                  text: loc.transferDetailsStartATrip,
                  size: AppButtonSize.l,

                  /// Начать поездку
                  onPressed: () {
                    bloc.startTrip(loc: loc);
                  },
                ),
              LocalTaskStatus.onRoute => AppButtons.primary(
                  key: ValueKey(status),
                  text: loc.transferDetailsIVeArrived,
                  size: AppButtonSize.l,

                  /// Водитель на месте
                  onPressed: () {
                    bloc.driverArrived(loc: loc);
                  },
                ),
              LocalTaskStatus.arrived => Row(
                  key: ValueKey(status),
                  children: [
                    Expanded(
                      child: AppButtons.primary(
                        text: loc.transferDetailsClientOnBoard,
                        expandHorizontal: false,
                        size: AppButtonSize.l,

                        /// Пассажир(ы) на борту
                        onPressed: () {
                          bloc.clientOnBoard(loc: loc);
                        },
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: AppButtons.secondary(
                        text: loc.transferDetailsShowTheSign,
                        expandHorizontal: false,
                        size: AppButtonSize.l,
                        onPressed: () {
                          if (signs == null || !bloc.checkDateTime()) {
                            return;
                          }

                          /// Переход к просмотру карточки
                          TransferSignRoute(signs: signs.toList()).push(context);

                          /// Отправка события в аналитику
                          final ids = data.requiredTask.transferIds;
                          ref.analytics.logEvent(AnalyticsEvent.showTheSign(
                            datetime: data.requiredTask.datetime,
                            transferIds: ids,
                          ));
                        },
                      ),
                    )
                  ],
                ),
              LocalTaskStatus.customerOnBoard => Builder(
                  builder: (context) {
                    final number = data.requiredTask.activeIndexTransfer + 1;
                    final text = dropOffPlaces.length > 1
                        ? loc.transferDetailsCompleteNumberTransfer(loc.ordinalPostfix(number))
                        : loc.transferDetailsCompleteTheTrip;

                    return AppButtons.primary(
                      key: ValueKey(status),
                      text: text,
                      size: AppButtonSize.l,

                      /// Завершить поездку(и)
                      onPressed: () {
                        bloc.completeTransfer(loc: loc);
                      },
                    );
                  },
                ),
              _ => const SizedBox(),
            };
          },
        ) ??
        const SizedBox();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomAnimatedSwitcher(child: button),
      ),
    );
  }
}
