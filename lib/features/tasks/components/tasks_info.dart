import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Информация о задачах
class TasksInfo extends HookWidget {
  final int ridesCount;
  final int boostersCount;
  final int childSeatsCount;

  const TasksInfo({
    super.key,
    required this.ridesCount,
    required this.boostersCount,
    required this.childSeatsCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: borders.itemL,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 56,
      alignment: Alignment.center,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          TaskInfoItem(
            svg: Assets.icons.listFilled,
            title: loc.commonRides,
            value: ridesCount.toString(),
          ),
          const SizedBox(
            width: 15,
          ),
          TaskInfoItem(
            svg: Assets.icons.boosterFilled,
            title: loc.commonBoosters,
            value: boostersCount.toString(),
          ),
          const SizedBox(
            width: 15,
          ),
          TaskInfoItem(
            svg: Assets.icons.seatFilled,
            title: loc.commonChildSeats,
            value: childSeatsCount.toString(),
          ),
        ],
      ),
    );
  }
}

class TaskInfoItem extends HookWidget {
  final SvgGenImage svg;
  final String title;
  final String value;

  const TaskInfoItem({
    super.key,
    required this.svg,
    required this.title,
    required this.value,
  });

  const TaskInfoItem.onlyValue({
    super.key,
    required this.svg,
    required this.value,
  }) : title = '';

  const TaskInfoItem.withX({
    super.key,
    required this.svg,
    required String value,
  })  : title = '',
        value = 'x$value';

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Skeleton.shade(
          child: svg.svg(
            colorFilter: ColorFilter.mode(
              colors.iconTertiary,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${title.isNotEmpty ? '$title ' : ''}$value',
          style: textTheme.labelMS.copyWith(
            color: colors.textTertiary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
