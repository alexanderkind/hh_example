import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/utils/extensions/money_extensions.dart';
import 'package:hh_example/common/widgets/buttons/app_buttons.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Информация о наличии чаевых
class TipsInfo extends HookWidget {
  final String message;
  final num value;
  final String? button;
  final VoidCallback? onTap;
  final bool loading;

  const TipsInfo({
    super.key,
    required this.message,
    required this.value,
    this.button,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: borders.itemL,
      ),
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  loc.transferHistoryTipsMessage,
                  style: textTheme.titleLR,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                value.formatMoney(),
                style: textTheme.titleLS.copyWith(
                  color: colors.textPositive,
                ),
              )
            ],
          ),
          if (button != null && onTap != null) SizedBox(height: 16.h),
          AppButtons.primary(
            text: loc.commonCollectTips,
            loading: loading,
            onPressed: onTap!,
          ),
        ],
      ),
    );
  }
}
