import 'package:alps2alps_cool_driver/common/hooks/use_theme_extension.dart';
import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferContentServiceInfo extends HookWidget {
  final Task task;

  const TransferContentServiceInfo({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();

    final serviceInfoSequence = task.clientInfoSequence;

    return SliverToBoxAdapter(
      child: serviceInfoSequence.isNotEmpty
          ? Container(
              margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                // TODO(alexanderkind): Вынести цвет
                color: const Color(0xFFF5F6FB),
                borderRadius: borders.itemS,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.transferDetailsServiceInfo,
                    style: textTheme.titleMS,
                  ),
                  Text(
                    serviceInfoSequence,
                    style: textTheme.titleMR,
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
