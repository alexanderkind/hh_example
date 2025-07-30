import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/router/routes.dart';
import 'package:hh_example/common/services/tips_service/tips_service.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/animated_switcher/custom_sliver_animated_switcher.dart';
import 'package:hh_example/common/widgets/buttons/app_button_styles.dart';
import 'package:hh_example/common/widgets/buttons/app_buttons.dart';
import 'package:hh_example/common/widgets/sliver/custom_sliver_animated_paint_extent.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Информация о наличии чаевых
class TasksTipsInfo extends HookConsumerWidget {
  const TasksTipsInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasNewTips = ref.watch(tipsServiceProvider.select((value) => value.maybeWhen(
          main: (data) => data.hasNewTips,
          orElse: () => false,
        )));

    return CustomSliverAnimatedPaintExtent(
      child: CustomSliverAnimatedSwitcher(
        sliver: SliverToBoxAdapter(
          child: hasNewTips ? const _Info() : const SizedBox(),
        ),
      ),
    );
  }
}

class _Info extends HookWidget {
  const _Info({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundPositive,
        borderRadius: borders.itemL,
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      alignment: Alignment.center,
      child: Row(
        children: [
          Assets.icons.check.svg(
            height: 24.h,
            colorFilter: ColorFilter.mode(colors.white, BlendMode.srcIn),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.w),
              child: Text(
                loc.tasksTipsMessage,
                style: textTheme.titleMM.copyWith(
                  color: colors.white,
                ),
              ),
            ),
          ),
          AppButtons.tertiary(
            text: loc.tasksTipsButton,
            size: AppButtonSize.s,
            expandHorizontal: false,
            onPressed: () {
              const TransferHistoryRoute().go(context);
            },
          ),
        ],
      ),
    );
  }
}
