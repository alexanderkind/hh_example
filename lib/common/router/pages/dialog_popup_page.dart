import 'package:async_task/async_task_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class DialogPopupPage<T> extends Page<T> {
  final Color? barrierColor;
  final bool barrierDismissible;
  final String barrierLabel;
  final WidgetBuilder builder;
  final Offset? anchorOffset;

  const DialogPopupPage({
    super.key,
    required this.builder,
    this.barrierColor = kCupertinoModalBarrierColor,
    this.barrierDismissible = true,
    this.barrierLabel = 'Dismiss',
    this.anchorOffset,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
        context: context,
        builder: builder,
        barrierLabel: barrierLabel,
        settings: this,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        anchorPoint: anchorOffset,
        useSafeArea: true,
      )..asFuture.whenComplete(() {
          if (context.mounted) {
            FocusScope.of(context).unfocus();
          }
        });
}
