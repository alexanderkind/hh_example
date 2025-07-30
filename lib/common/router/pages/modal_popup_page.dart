import 'package:async_task/async_task_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

@immutable
@optionalTypeArgs
class ModalPopupPage<T extends Object> extends Page<T> {
  final Color? barrierColor;
  final bool barrierDismissible;
  final bool expanded;
  final String barrierLabel;
  final WidgetBuilder builder;
  final bool enableDrag;
  final bool bounce;

  const ModalPopupPage({
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
  Route<T> createRoute(BuildContext context) => CupertinoModalBottomSheetRoute<T>(
        builder: builder,
        barrierLabel: barrierLabel,
        modalBarrierColor: barrierColor,
        isDismissible: barrierDismissible,
        settings: this,
        enableDrag: enableDrag,
        expanded: expanded,
        bounce: bounce,
        animationCurve: Curves.fastEaseInToSlowEaseOut,
      )..asFuture.whenComplete(() {
          if (context.mounted) {
            FocusScope.of(context).unfocus();
          }
        });
}
