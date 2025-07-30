import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/models/places/place_for_copy.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/utils/extensions/date_extensions.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/utils/symbolic_naming.dart';
import 'package:hh_example/common/widgets/items/task_item/place_info_item.dart';
import 'package:hh_example/common/widgets/items/task_item/task_counter_info.dart';
import 'package:hh_example/common/widgets/items/task_item/task_status_item.dart';
import 'package:hh_example/common/widgets/items/task_item/task_tips_item.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Основная инф. о задаче
class TaskContent extends HookWidget {
  static const _defaultCopyAddress = false;

  final String? transferReference;
  final DateTime dateTime;
  final int? passengerCount;
  final int? boosterSeatCount;
  final int? childSeatCount;
  final bool withSkis;
  final double? tips;
  final LocalTaskStatus status;
  final List<PlaceForCopy> pickUpPoints;
  final List<PlaceForCopy> dropOffPoints;

  /// Для отображения кнопки копирования адреса
  final bool copyAddress;

  const TaskContent({
    super.key,
    this.transferReference,
    required this.dateTime,
    this.passengerCount,
    this.boosterSeatCount,
    this.childSeatCount,
    this.withSkis = false,
    this.tips,
    required this.status,
    this.pickUpPoints = const [],
    this.dropOffPoints = const [],
    this.copyAddress = _defaultCopyAddress,
  });

  factory TaskContent.fromTask({
    Key? key,
    required Task task,
    bool copyAddress = _defaultCopyAddress,
  }) =>
      TaskContent(
        key: key,
        transferReference: task.firstReference,
        dateTime: task.datetime,
        passengerCount: task.passengerCount,
        boosterSeatCount: task.boosterSeatCount,
        childSeatCount: task.childSeatCount,
        withSkis: task.withSkis,
        status: task.localStatus,
        pickUpPoints: task.pickUpCorrectPlaces
            .map((e) => PlaceForCopy(
                  name: e.name,
                  copyValue: e.valueForCopy,
                ))
            .toList(),
        dropOffPoints: task.dropOffCorrectPlaces
            .map((e) => PlaceForCopy(
                  name: e.name,
                  copyValue: e.valueForCopy,
                ))
            .toList(),
        copyAddress: copyAddress,
      );

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final loc = context.loc;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (transferReference != null)
          Text(
            '${loc.commonTransferReference}: $transferReference',
            style: textTheme.labelLR.copyWith(
              color: colors.textTertiary,
            ),
          ),

        /// Дата время
        Text(
          dateTime.toDmmmyyyyhmFormat(),
          style: textTheme.hSS,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        SizedBox(height: 5.h),

        /// Информация о пассажирах, бустерах и т.д.
        TaskCounterInfo(
          passengersCount: passengerCount,
          boostersCount: boosterSeatCount,
          childSitsCount: childSeatCount,
          withSkis: withSkis,
        ),
        SizedBox(height: 16.h),

        /// Чаевые
        if ((tips ?? 0) > 0) ...[
          TaskTipsItem(tips: tips!),
          SizedBox(height: 16.h),
        ],

        /// Статус задачи
        TaskStatusItem(status: status),
        SizedBox(height: 16.h),

        /// Точки маршрута
        if (pickUpPoints.isNotEmpty)
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final p = pickUpPoints[index];

              final title = '${loc.commonPickUp}'
                  '${pickUpPoints.length > 1 ? ' ${createSymbolicNameByIndex(index)}' : ''}';

              return PlaceInfoItem(
                title: title,
                address: p.name,
                valueForCopy: p.copyValue,
                color: colors.iconNegative,
                copyAddress: copyAddress,
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemCount: pickUpPoints.length,
          ),
        if (pickUpPoints.isNotEmpty && dropOffPoints.isNotEmpty) SizedBox(height: 10.h),
        if (dropOffPoints.isNotEmpty)
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final p = dropOffPoints[index];

              final title = '${loc.commonDropOff}'
                  '${dropOffPoints.length > 1 ? ' ${createSymbolicNameByIndex(index)}' : ''}';

              return PlaceInfoItem(
                title: title,
                address: p.name,
                valueForCopy: p.copyValue,
                color: colors.iconAccent,
                copyAddress: copyAddress,
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemCount: dropOffPoints.length,
          ),
      ],
    );
  }
}
