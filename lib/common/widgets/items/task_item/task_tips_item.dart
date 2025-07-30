import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/utils/extensions/money_extensions.dart';
import 'package:hh_example/common/utils/typedefs/color_builder_from_scheme.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskTipsItem extends HookWidget {
  static Color defaultBackgroundColorBuilder(ColorsScheme colors) => colors.backgroundPrimary;

  static Color secondaryBackgroundColorBuilder(ColorsScheme colors) => colors.backgroundSecondary;

  final double tips;
  final ColorBuilderFromScheme backgroundColorBuilder;

  const TaskTipsItem({
    super.key,
    required this.tips,
    this.backgroundColorBuilder = defaultBackgroundColorBuilder,
  });

  const TaskTipsItem.secondary({
    super.key,
    required this.tips,
    this.backgroundColorBuilder = secondaryBackgroundColorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColorBuilder(colors),
        borderRadius: borders.itemL,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              loc.commonTipForTheTransfer,
              style: textTheme.titleMS,
            ),
          ),
          Text(
            tips.formatMoney(),
            style: textTheme.titleMS.copyWith(color: colors.textPositive),
          )
        ],
      ),
    );
  }
}
