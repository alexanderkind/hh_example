import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FlightDelayedWarning extends HookWidget {
  final int minutes;

  const FlightDelayedWarning({
    super.key,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Skeleton.leaf(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // TODO(alexanderkind): Вынести новый цвет
          color: const Color(0xFFFFE9CB),
          borderRadius: borders.itemL,
        ),
        child: Row(
          children: [
            Assets.icons.info.svg(
              colorFilter: ColorFilter.mode(
                colors.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: loc.tasksFlightDelayedWarningPart1,
                  children: [
                    TextSpan(
                      text: loc.tasksFlightDelayedWarningPart2(minutes),
                      style: textTheme.titleMS,
                    ),
                  ],
                ),
                style: textTheme.titleMR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
