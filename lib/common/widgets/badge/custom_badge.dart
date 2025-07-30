import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CustomBadgeSize {
  xs,
  s,
  m;
}

class CustomBadge extends HookWidget {
  static Size getMinSizeWidgetBySize(CustomBadgeSize size) {
    return switch (size) {
      CustomBadgeSize.xs => Size.square(14.dm),
      CustomBadgeSize.m => Size.square(26.dm),
      _ => Size.square(18.dm),
    };
  }

  static double getTextSizeBySize(CustomBadgeSize size) {
    return switch (size) {
      CustomBadgeSize.xs => 9.sp,
      CustomBadgeSize.m => 16.sp,
      _ => 13.sp,
    };
  }

  final String value;
  final CustomBadgeSize size;

  const CustomBadge({
    super.key,
    required this.value,
    this.size = CustomBadgeSize.s,
  });

  const CustomBadge.m({
    super.key,
    required this.value,
    this.size = CustomBadgeSize.m,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();

    final minSize = getMinSizeWidgetBySize(size);
    final textSize = getTextSizeBySize(size);

    return Container(
      decoration: BoxDecoration(
        color: colors.iconNegative,
        shape: BoxShape.circle,
      ),
      height: minSize.height,
      constraints: BoxConstraints(minWidth: minSize.width),
      child: Center(
        child: Text(
          value,
          style: textTheme.titleMS.copyWith(
            color: colors.white,
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}
