import 'package:async_task/async_task_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
@optionalTypeArgs
class MaterialModalPopupPage<T extends Object> extends Page<T> {
  final Color? barrierColor;
  final bool barrierDismissible;
  final bool expanded;
  final String barrierLabel;
  final WidgetBuilder builder;
  final bool enableDrag;
  final bool bounce;

  const MaterialModalPopupPage({
    super.key,
    required this.builder,
    this.barrierColor = kCupertinoModalBarrierColor,
    this.barrierDismissible = true,
    this.expanded = false,
    this.enableDrag = true,
    this.bounce = true,
    this.barrierLabel = 'Dismiss',
  });

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
        builder: builder,
        barrierLabel: barrierLabel,
        modalBarrierColor: barrierColor,
        isDismissible: barrierDismissible,
        settings: this,
        enableDrag: enableDrag,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: false,
      )..asFuture.whenComplete(() {
          if (context.mounted) {
            FocusScope.of(context).unfocus();
          }
        });
}
