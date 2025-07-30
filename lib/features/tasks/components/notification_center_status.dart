import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/router/routes.dart';
import 'package:hh_example/common/services/notification_center_service/notification_center_service.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/animated_switcher/custom_sliver_animated_switcher.dart';
import 'package:hh_example/common/widgets/badge/custom_badge.dart';
import 'package:hh_example/common/widgets/buttons/app_button_styles.dart';
import 'package:hh_example/common/widgets/buttons/app_buttons.dart';
import 'package:hh_example/common/widgets/sliver/custom_sliver_animated_paint_extent.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/features/notification_center/notification_center_page.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationCenterStatus extends ConsumerWidget {
  const NotificationCenterStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.read(notificationCenterServiceProvider.notifier);

    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(notificationCenterServiceProvider);
        final warnings = state.activeWarningTypes;

        final child = SliverToBoxAdapter(
          key: ValueKey(warnings.length),
          child: switch (warnings.length) {
            0 => const SizedBox(),
            1 => StatusContainer(
                key: ValueKey(warnings.length),
                child: StatusOne(
                  title: NotificationCenterPage.getTitleByType(context, warnings.first),
                  actionTitle: NotificationCenterPage.getActionTitleByType(context, warnings.first),
                  onTap: () {
                    bloc.actionByType(warnings.first);
                  },
                ),
              ),
            _ => StatusContainer(
                key: ValueKey(warnings.length),
                child: StatusMore(
                  count: warnings.length,
                  onTap: () {
                    const NotificationCenterRoute().push(context);
                  },
                ),
              ),
          },
        );

        return CustomSliverAnimatedPaintExtent(
          child: CustomSliverAnimatedSwitcher(
            sliver: child,
          ),
        );
      },
    );
  }
}

/// Виджет для общих ограничений размера
class StatusContainer extends StatelessWidget {
  final Widget child;

  const StatusContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
      child: child,
    );
  }
}

/// Для одного предупреждения
class StatusOne extends HookWidget {
  final String title;
  final String actionTitle;
  final VoidCallback onTap;

  const StatusOne({
    super.key,
    required this.title,
    required this.actionTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundNegative,
        borderRadius: borders.itemL,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            Assets.icons.warningFilled.svg(
              colorFilter: ColorFilter.mode(
                colors.white,
                BlendMode.srcIn,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  title,
                  style: textTheme.titleMR.copyWith(
                    color: colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            AppButtons.secondary(
              size: AppButtonSize.s,
              expandHorizontal: false,
              text: actionTitle,
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// Для нескольких предупреждений
class StatusMore extends HookWidget {
  final int count;
  final VoidCallback? onTap;

  const StatusMore({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();
    final loc = context.loc;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundNegative.withOpacity(0.2),
        borderRadius: borders.itemL,
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Assets.icons.warningFilled.svg(
                  colorFilter: ColorFilter.mode(
                    colors.iconNegative,
                    BlendMode.srcIn,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text(
                      loc.commonThereAreProblems,
                      style: textTheme.titleMM,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                CustomBadge.m(value: count.toString()),
                SizedBox(width: 10.w),
                Assets.icons.arrowNext.svg(
                  colorFilter: ColorFilter.mode(
                    colors.textTertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
