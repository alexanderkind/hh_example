import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Предупреждение при наличии проблем с данными
class DataProblemsWarning extends HookWidget {
  const DataProblemsWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Skeleton.leaf(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          // TODO(alexanderkind): Вынести новый цвет
          color: const Color(0xFFFFDEDE),
          borderRadius: borders.itemL,
        ),
        child: Row(
          children: [
            Assets.icons.warningFilled.svg(
              colorFilter: ColorFilter.mode(
                colors.iconNegative,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                loc.commonThereAreProblems,
                style: textTheme.titleMR,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
