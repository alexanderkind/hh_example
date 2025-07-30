import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/models/places/place_for_copy.dart';
import 'package:hh_example/common/models/task/history_tasks.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/utils/extensions/money_extensions.dart';
import 'package:hh_example/common/widgets/items/task_item/data_problems_warning.dart';
import 'package:hh_example/common/widgets/items/task_item/task_content.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'flight_delayed_warning.dart';
import 'split_transfer_warning.dart';

/// Элемент списка задач
class TaskItem extends HookWidget {
  final bool hasProblems;
  final int? flightDelay;
  final String? transferReference;
  final DateTime date;
  final LocalTaskStatus status;
  final int? passengerCount;
  final int? boosterSeatCount;
  final int? childSeatCount;
  final bool withSkis;
  final double? tips;
  final List<PlaceForCopy> pickUpPoints;
  final List<PlaceForCopy> dropOffPoints;
  final bool isSplit;
  final double? salary;
  final VoidCallback? onTap;

  const TaskItem({
    super.key,
    this.hasProblems = false,
    this.flightDelay,
    this.transferReference,
    required this.date,
    required this.status,
    this.passengerCount,
    this.boosterSeatCount,
    this.childSeatCount,
    this.withSkis = false,
    this.tips,
    this.pickUpPoints = const [],
    this.dropOffPoints = const [],
    this.isSplit = false,
    this.salary,
    this.onTap,
  });

  factory TaskItem.fromTask({
    Key? key,
    required Task task,
    VoidCallback? onTap,
  }) =>
      TaskItem(
        key: key,
        hasProblems: task.hasProblems,
        flightDelay: task.maxFlightDelay,
        transferReference: task.firstReference,
        date: task.datetime,
        status: task.localStatus,
        passengerCount: task.passengerCount,
        boosterSeatCount: task.boosterSeatCount,
        childSeatCount: task.childSeatCount,
        withSkis: task.withSkis,
        pickUpPoints: task.pickUpPlaces
            .map((e) => PlaceForCopy(
                  name: e.name,
                  copyValue: e.valueForCopy,
                ))
            .toList(),
        dropOffPoints: task.dropOffPlaces
            .map((e) => PlaceForCopy(
                  name: e.name,
                  copyValue: e.valueForCopy,
                ))
            .toList(),
        isSplit: task.isSplit,
        onTap: onTap,
      );

  factory TaskItem.fromHistoryTask({
    Key? key,
    required HistoryTask task,
    VoidCallback? onTap,
  }) =>
      TaskItem(
        key: key,
        date: task.datetime,
        status: task.localStatus,
        onTap: onTap,
        passengerCount: task.passengerCount,
        boosterSeatCount: task.boosterSeatCount,
        childSeatCount: task.childSeatCount,
        withSkis: task.hasSkis,
        tips: task.tipEuroAmount,
        pickUpPoints: [PlaceForCopy.fromName(task.pickupLocation)],
        dropOffPoints: [PlaceForCopy.fromName(task.dropOffLocation)],
        // TODO(alexanderkind): Заказчик попросил скрыть, вернуть по необходимости
        //salary: task.driverSalary,
      );

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: borders.itemL,
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasProblems)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: const DataProblemsWarning(),
                  ),

                /// Предупреждение о задержке рейса
                if ((flightDelay ?? 0) > 0)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: FlightDelayedWarning(
                      minutes: flightDelay!,
                    ),
                  ),

                TaskContent(
                  transferReference: transferReference,
                  dateTime: date,
                  passengerCount: passengerCount,
                  boosterSeatCount: boosterSeatCount,
                  childSeatCount: childSeatCount,
                  withSkis: withSkis,
                  tips: tips,
                  status: status,
                  pickUpPoints: pickUpPoints,
                  dropOffPoints: dropOffPoints,
                ),

                /// Предупреждение о раздельном трансфере
                if (isSplit)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: const SplitTransferWarning(),
                  ),

                /// Стоимость трансфера
                if (salary != null)
                  Container(
                    margin: EdgeInsets.only(top: 16.h),
                    padding: EdgeInsets.only(top: 18.h, bottom: 4.h),
                    decoration: BoxDecoration(
                      border:
                          Border(top: BorderSide(color: colors.separatorPrimaryAlpha, width: 1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            loc.commonTotal,
                            style: textTheme.bodyLR.copyWith(
                              color: colors.textTertiary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          salary!.formatMoney(),
                          style: textTheme.titleLM,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
