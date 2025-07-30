import 'package:flutter/cupertino.dart';

class CustomAnimatedSwitcher extends AnimatedSwitcher {
  static const defaultDurationFast = Duration(milliseconds: 167);
  static const defaultDuration = Duration(milliseconds: 300);

  static Widget defaultFadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      key: child.key,
      opacity: animation,
      child: child,
    );
  }

  static Widget defaultLayoutBuilderBottom(Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  const CustomAnimatedSwitcher({
    super.key,
    super.child,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve,
    super.switchOutCurve,
    super.transitionBuilder = defaultFadeTransition,
    super.layoutBuilder,
  });

  CustomAnimatedSwitcher.sizeFadePreset({
    Axis axis = Axis.vertical,
    double axisAlignment = 0.0,
    super.key,
    super.child,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve = Curves.easeInOut,
    super.switchOutCurve = Curves.easeInOut,
    super.layoutBuilder,
  }) : super(
          transitionBuilder: (child, animation) {
            return SizeTransition(
              key: child.key,
              sizeFactor: animation,
              axis: axis,
              axisAlignment: axisAlignment,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  CustomAnimatedSwitcher.sizeFadePresetHorizontal({
    double axisAlignment = 0.0,
    super.key,
    super.child,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve = Curves.easeInOut,
    super.switchOutCurve = Curves.easeInOut,
    super.layoutBuilder,
  }) : super(
          transitionBuilder: (child, animation) {
            return SizeTransition(
              key: child.key,
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: axisAlignment,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  CustomAnimatedSwitcher.slideFadePreset({
    Offset begin = const Offset(0, 1),
    Offset end = const Offset(0, 0),
    super.key,
    super.child,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve = Curves.easeInOut,
    super.switchOutCurve = Curves.easeInOut,
    super.layoutBuilder,
  }) : super(
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(begin: begin, end: end).animate(animation),
              child: FadeTransition(
                key: child.key,
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  CustomAnimatedSwitcher.slideFadeVerticalHalfPreset({
    Offset begin = const Offset(0, 0.5),
    Offset end = const Offset(0, 0),
    super.key,
    super.child,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve = Curves.easeInOut,
    super.switchOutCurve = Curves.easeInOut,
    super.layoutBuilder,
  }) : super(
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(begin: begin, end: end).animate(animation),
              child: FadeTransition(
                key: child.key,
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  CustomAnimatedSwitcher.scaleFadePreset({
    super.key,
    super.child,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve = Curves.easeInOut,
    super.switchOutCurve = Curves.easeInOut,
    super.layoutBuilder,
  }) : super(
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                key: child.key,
                opacity: animation,
                child: child,
              ),
            );
          },
        );

  CustomAnimatedSwitcher.scaleFadePresetDownOneAndHalf({
    super.key,
    super.child,
    super.duration = defaultDuration,
    super.reverseDuration,
    super.switchInCurve = Curves.easeInOut,
    super.switchOutCurve = Curves.easeInOut,
    super.layoutBuilder,
  }) : super(
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: Tween<double>(begin: 1.5, end: 1).animate(animation),
              child: FadeTransition(
                key: child.key,
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}
