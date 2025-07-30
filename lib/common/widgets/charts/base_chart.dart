import 'package:hh_example/common/widgets/charts/base_chart_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef HighlightEntryPredicate<E extends BaseChartEntry> = bool Function(
    Set<E> highlightEntries, E entry);

/// Базовый класс графиков
abstract class BaseChart<E extends BaseChartEntry> extends HookWidget {
  static bool defaultHighlightEntryPredicate(Set<dynamic> highlightEntries, dynamic entry) {
    return highlightEntries.map((e) => e).contains(entry);
  }

  final List<E> data;
  final double? height;
  final Set<E> highlightEntries;
  final HighlightEntryPredicate<E> highlightEntryPredicate;

  const BaseChart({
    super.key,
    required this.data,
    this.height,
    this.highlightEntries = const {},
    this.highlightEntryPredicate = defaultHighlightEntryPredicate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: createChart(context),
    );
  }

  /// Настройка графика
  Widget createChart(BuildContext context);

  /// Определение подсветки элемента [data]
  bool checkHighlightEntry(E entry) {
    if (highlightEntries.isEmpty) {
      return false;
    }

    return highlightEntryPredicate.call(highlightEntries, entry);
  }
}
