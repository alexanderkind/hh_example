import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/widgets/charts/bar_chart/bar_chart_entry.dart';
import 'package:hh_example/common/widgets/charts/base_chart_item.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BarChartItem extends BaseChartItem {
  final BarChartEntry entry;
  final num maxValue;
  final double marginTitle;

  const BarChartItem({
    super.key,
    required this.entry,
    required this.maxValue,
    required this.marginTitle,
    required super.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();

    return LayoutBuilder(builder: (context, constraints) {
      final c = entry.value > 0 && maxValue > 0 ? entry.value / maxValue : 0;
      // TODO(alexanderkind): Заменить вычисление высоты, если нужен минимальный размер столбца графика
      //final h = value != 0 ? max(16.h, constraints.maxHeight * c) : 0.0;
      final heightBar = constraints.maxHeight * c;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.backgroundAccent,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                height: heightBar,
              ),
            ),
          ),
          SizedBox(height: marginTitle),
          BarChartItemTitle(
            title: entry.title,
            isHighlight: isHighlight,
          ),
        ],
      );
    });
  }
}

class BarChartItemTitle extends HookWidget {
  final String title;
  final bool isHighlight;

  const BarChartItemTitle({
    super.key,
    required this.title,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = useThemeExtension<TextThemes>();
    final colors = useThemeExtension<ColorsScheme>();

    return Container(
      decoration: BoxDecoration(
        color: isHighlight ? colors.iconTertiary : colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Text(
        title,
        style: textTheme.labelMM.copyWith(
          color: isHighlight ? colors.white : colors.textPrimary,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
      ),
    );
  }
}
