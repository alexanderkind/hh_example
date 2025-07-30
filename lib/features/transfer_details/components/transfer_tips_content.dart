import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/items/task_item/task_tips_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferTipsContent extends HookWidget {
  final double? tips;

  const TransferTipsContent({
    super.key,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    final tips = this.tips ?? 0;

    return SliverToBoxAdapter(
      child: CustomAnimatedSwitcher.sizeFadePreset(
        child: tips > 0
            ? Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 16.h),
                child: TaskTipsItem.secondary(tips: tips),
              )
            : const SizedBox(),
      ),
    );
  }
}
