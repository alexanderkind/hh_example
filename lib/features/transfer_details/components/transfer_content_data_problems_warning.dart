import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/models/task_status/task_statuses.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_sliver_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/items/task_item/data_problems_warning.dart';
import 'package:alps2alps_cool_driver/common/widgets/sliver/custom_sliver_animated_paint_extent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferContentDataProblemsWarning extends HookWidget {
  final Task task;

  const TransferContentDataProblemsWarning({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final status = task.localStatus;
    final show = task.hasProblems && status != LocalTaskStatus.completed;

    return CustomSliverAnimatedPaintExtent(
      child: CustomSliverAnimatedSwitcher(
        sliver: show
            ? SliverToBoxAdapter(
                key: const Key('warning'),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
                  child: const DataProblemsWarning(),
                ),
              )
            : const SliverToBoxAdapter(),
      ),
    );
  }
}
