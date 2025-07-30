import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/models/task_status/task_statuses.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_sliver_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/items/task_item/flight_delayed_warning.dart';
import 'package:alps2alps_cool_driver/common/widgets/sliver/custom_sliver_animated_paint_extent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferContentFlightDelayWarning extends HookWidget {
  final LocalTaskStatus status;
  final Transfer activeTransfer;

  const TransferContentFlightDelayWarning({
    super.key,
    required this.status,
    required this.activeTransfer,
  });

  @override
  Widget build(BuildContext context) {
    final flightDelay = activeTransfer.flight?.delay ?? 0;
    final show = [
          LocalTaskStatus.notStarted,
          LocalTaskStatus.onRoute,
          LocalTaskStatus.arrived,
        ].contains(status) &&
        flightDelay > 0;

    return CustomSliverAnimatedPaintExtent(
      child: CustomSliverAnimatedSwitcher(
        sliver: show
            ? SliverToBoxAdapter(
                key: const Key('warning'),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
                  child: FlightDelayedWarning(
                    minutes: flightDelay,
                  ),
                ),
              )
            : const SliverToBoxAdapter(),
      ),
    );
  }
}
