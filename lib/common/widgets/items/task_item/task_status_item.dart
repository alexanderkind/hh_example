import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskStatusItem extends HookWidget {
  final LocalTaskStatus status;

  const TaskStatusItem({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();

    final title = loc.commonLocalTaskStatus(status.name);
    final color = switch (status) {
      // TODO(alexanderkind): Вынести цвета
      LocalTaskStatus.onRoute => const Color(0xFF7141A0),
      LocalTaskStatus.arrived => const Color(0xFFC45E00),
      LocalTaskStatus.customerOnBoard => const Color(0xFF469649),
      LocalTaskStatus.completed => const Color(0xFF2962D3),
      _ => colors.textTertiary,
    };
    const duration = CustomAnimatedSwitcher.defaultDuration;

    return Skeleton.leaf(
      child: AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          borderRadius: borders.itemL,
          color: color.withOpacity(0.2),
        ),
        child: CustomAnimatedSwitcher.sizeFadePresetHorizontal(
          duration: duration,
          child: Padding(
            key: ValueKey(title),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              title,
              style: textTheme.titleMS.copyWith(
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
