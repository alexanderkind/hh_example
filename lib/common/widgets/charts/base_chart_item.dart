import 'package:flutter_hooks/flutter_hooks.dart';

abstract class BaseChartItem extends HookWidget {
  final bool isHighlight;

  const BaseChartItem({
    super.key,
    required this.isHighlight,
  });
}
