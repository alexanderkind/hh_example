import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/features/tasks/components/tasks_info.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Информация о задаче
class TaskCounterInfo extends StatelessWidget {
  final int? passengersCount;
  final int? boostersCount;
  final int? childSitsCount;
  final bool withSkis;

  const TaskCounterInfo({
    super.key,
    required this.passengersCount,
    required this.boostersCount,
    required this.childSitsCount,
    required this.withSkis,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return SizedBox(
      height: 24,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          TaskInfoItem.withX(
            svg: Assets.icons.passengersFilled,
            value: (passengersCount ?? 0).toString(),
          ),
          SizedBox(width: 10.w),
          TaskInfoItem.withX(
            svg: Assets.icons.boosterFilled,
            value: (boostersCount ?? 0).toString(),
          ),
          SizedBox(width: 10.w),
          TaskInfoItem.withX(
            svg: Assets.icons.seatFilled,
            value: (childSitsCount ?? 0).toString(),
          ),
          if (withSkis) ...[
            SizedBox(width: 10.w),
            TaskInfoItem.onlyValue(
              svg: Assets.icons.ski,
              value: loc.commonWithSkis,
            ),
          ],
        ],
      ),
    );
  }
}
