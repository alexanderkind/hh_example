import 'package:hh_example/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CustomSliverAnimatedSwitcher extends AnimatedSwitcher {
  static const defaultDurationHalf = CustomAnimatedSwitcher.defaultDurationFast;
  static const defaultDuration = CustomAnimatedSwitcher.defaultDuration;

  static Widget defaultFadeTransition(Widget child, Animation<double> animation) {
    return SliverFadeTransition(key: child.key, opacity: animation, sliver: child);
  }

  const CustomSliverAnimatedSwitcher({
    super.key,
    required Widget sliver,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve,
    super.switchOutCurve,
    super.transitionBuilder = defaultFadeTransition,
    super.layoutBuilder = SliverAnimatedSwitcher.defaultLayoutBuilder,
  }) : super(child: sliver);
}
