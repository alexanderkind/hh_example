import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/models/task_status/task_statuses.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_sliver_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/sliver/custom_sliver_animated_paint_extent.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/passenger_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Список клиентов наверху контента
class TransferContentClientOnTop extends HookWidget {
  final LocalTaskStatus status;
  final List<Transfer> transfers;
  final Transfer activeTransfer;
  final ValueChanged<Transfer> onCallPassenger;
  final ValueChanged<Transfer> onChatPassenger;
  final bool actionRestrictions;

  const TransferContentClientOnTop({
    super.key,
    required this.status,
    required this.transfers,
    required this.activeTransfer,
    required this.onCallPassenger,
    required this.onChatPassenger,
    required this.actionRestrictions,
  });

  @override
  Widget build(BuildContext context) {
    final show = [
      LocalTaskStatus.notStarted,
      LocalTaskStatus.onRoute,
      LocalTaskStatus.arrived,
      LocalTaskStatus.customerOnBoard,
    ].contains(status);
    final showDropOffNumber = transfers.length > 1 && status == LocalTaskStatus.customerOnBoard;
    final showActions = status != LocalTaskStatus.customerOnBoard && !actionRestrictions;

    final transfersForDropOff = showDropOffNumber ? [activeTransfer] : transfers;

    return CustomSliverAnimatedPaintExtent(
      child: CustomSliverAnimatedSwitcher(
        sliver: show
            ? SliverPadding(
                key: ValueKey(transfersForDropOff.hashCode),
                padding: EdgeInsets.only(bottom: 20.h),
                sliver: SliverList.builder(
                  itemBuilder: (context, index) {
                    final t = transfersForDropOff[index];
                    final number = index + 1;

                    return PassengerItem(
                      transfer: t,
                      number: number,
                      showDropOffNumber: showDropOffNumber,
                      showActions: showActions,
                      onCallPassenger: () => onCallPassenger.call(t),
                      onChatPassenger: () => onChatPassenger.call(t),
                    );
                  },
                  itemCount: transfersForDropOff.length,
                ),
              )
            : const SliverToBoxAdapter(),
      ),
    );
  }
}
