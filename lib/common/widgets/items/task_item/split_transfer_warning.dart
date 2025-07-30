import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/common/widgets/tooltip.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SplitTransferWarning extends HookWidget {
  const SplitTransferWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.backgroundTertiary,
        borderRadius: borders.itemL,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTooltip(
            title: loc.tasksSplitTransferTitle,
            description: loc.tasksSplitTransferDesc,
            child: Assets.icons.info.svg(
              colorFilter: ColorFilter.mode(
                colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: loc.tasksSplitTransferWarningPart1,
                children: [
                  TextSpan(
                    text: loc.tasksSplitTransferWarningPart2,
                    style: textTheme.titleMS,
                  ),
                ],
              ),
              style: textTheme.titleMR,
            ),
          ),
        ],
      ),
    );
  }
}
