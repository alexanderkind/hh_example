import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Преднастроенный контейнер для графиков
class CustomChartBuilder extends HookWidget {
  final WidgetBuilder builder;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? titleBuilder;
  final BoxDecoration? decoration;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;

  const CustomChartBuilder({
    super.key,
    required this.builder,
    this.headerBuilder,
    this.titleBuilder,
    this.decoration,
    this.margin,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();

    final decoration = this.decoration ??
        BoxDecoration(
          color: colors.backgroundSecondary,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        );
    final margin = this.margin ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h);
    final padding = this.padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);

    final headerWidget = createHeader(context);

    final titleWidget = createTitle(context);

    return Container(
      decoration: decoration,
      margin: margin,
      padding: padding,
      clipBehavior: Clip.hardEdge,
      height: height,
      child: Column(
        children: [
          if (headerWidget != null) ...[
            headerWidget,
            SizedBox(height: 8.h),
          ],
          if (titleWidget != null) ...[
            titleWidget,
            SizedBox(height: 8.h),
          ],
          Expanded(child: builder.call(context)),
        ],
      ),
    );
  }

  /// Заголовок графика
  Widget? createHeader(BuildContext context) => headerBuilder?.call(context);

  /// Заголовок графика
  Widget? createTitle(BuildContext context) => titleBuilder?.call(context);
}
