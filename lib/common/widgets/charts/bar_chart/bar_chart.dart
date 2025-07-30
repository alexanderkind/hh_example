import 'package:hh_example/common/widgets/charts/bar_chart/bar_chart_entry.dart';
import 'package:hh_example/common/widgets/charts/bar_chart/bar_chart_item.dart';
import 'package:hh_example/common/widgets/charts/base_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BarChart<E extends BarChartEntry> extends BaseChart<E> {
  const BarChart({
    super.key,
    required super.data,
    super.height,
    super.highlightEntries,
    super.highlightEntryPredicate,
  });

  @override
  Widget createChart(BuildContext context) {
    final maxValue = data.map((e) => e.value).fold(0 as num, (p, v) => p > v ? p : v);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hMarginItemTitle = 4.h;
        final wPaddingBetweenItems = 12.w;

        final items = <Widget>[];
        for (int i = 0; i < data.length; i++) {
          final entry = data[i];

          items.add(Expanded(
            child: BarChartItem(
              entry: entry,
              maxValue: maxValue,
              marginTitle: hMarginItemTitle,
              isHighlight: checkHighlightEntry(entry),
            ),
          ));

          if (wPaddingBetweenItems > 0) {
            final isLast = i >= data.length - 1;
            if (!isLast) {
              items.add(SizedBox(width: wPaddingBetweenItems));
            }
          }
        }

        return Row(
          children: items,
        );
      },
    );
  }
}
