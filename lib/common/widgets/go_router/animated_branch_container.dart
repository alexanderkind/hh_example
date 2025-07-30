import 'package:flutter/widgets.dart';

class AnimatedBranchContainer extends StatelessWidget {
  static const defaultDuration = Duration(milliseconds: 167);

  /// Индекс отображаемого вложенного навигатора [children]
  final int currentIndex;

  /// Список вложенных навигаторов
  final List<Widget> children;

  /// Длительность анимации
  final Duration duration;

  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
    this.duration = defaultDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children.map(
        (n) {
          final index = children.indexOf(n);
          return AnimatedOpacity(
            opacity: index == currentIndex ? 1 : 0,
            duration: duration,
            child: _branchNavigatorWrapper(index, n),
          );
        },
      ).toList(),
    );
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}
