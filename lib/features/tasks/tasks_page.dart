import 'package:hh_example/common/hooks/use_init_state.dart';
import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/router/routes.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/animated_switcher/custom_sliver_animated_switcher.dart';
import 'package:hh_example/common/widgets/items/task_item/task_item.dart';
import 'package:hh_example/common/widgets/sliver/custom_sliver_animated_paint_extent.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/features/tasks/components/dates_tab_bar.dart';
import 'package:hh_example/features/tasks/components/notification_center_status.dart';
import 'package:hh_example/features/tasks/components/tasks_info.dart';
import 'package:hh_example/features/tasks/components/tips_info.dart';
import 'package:hh_example/features/tasks/state/tasks_notifier.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Страница списка задач водителя
class TasksPage extends HookConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(tasksNotifierProvider.notifier);

    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final loc = context.loc;

    useInitState(
      onBuild: () {
        bloc.init();
      },
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: bloc.init,
        child: CustomScrollView(
          slivers: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(tasksNotifierProvider);
                final data = state.data;
                final selectedDate = data.selectedDate;
                final loading = data.loading;
                final dates = loading ? bloc.fakeDates : data.dates;

                return SliverSkeletonizer(
                  enabled: loading,
                  child: SliverAppBar(
                    title: Skeleton.keep(child: Text(loc.commonYourTasks)),
                    floating: true,
                    pinned: true,
                    bottom: DatesTabBar(
                      selectedDate: selectedDate,
                      dates: dates,

                      /// Выбор другой даты
                      onChanged: bloc.selectDate,
                    ),
                  ),
                );
              },
            ),

            /// Чаевые
            const TasksTipsInfo(),

            /// Показатели по выбранной дате
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(tasksNotifierProvider);
                final data = state.data;
                final tasks = data.selectedTasks;
                final show = data.isSelectedTasksNotEmpty && !data.loading;

                return CustomSliverAnimatedPaintExtent(
                  child: CustomSliverAnimatedSwitcher(
                    sliver: SliverToBoxAdapter(
                      key: ValueKey(tasks),
                      child: show
                          ? TasksInfo(
                              ridesCount: data.selectedTasksCount,
                              boostersCount: data.selectedBoosterSeatCount,
                              childSeatsCount: data.selectedChildSeatCount,
                            )
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),

            /// Центр уведомлений
            const NotificationCenterStatus(),

            /// Список задач
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(tasksNotifierProvider);
                final data = state.data;
                final loading = data.loading;
                final tasks = loading ? bloc.fakeTasks : data.selectedTasks;

                late final Widget child;

                if (tasks.isNotEmpty) {
                  child = SliverSkeletonizer(
                    key: ValueKey(tasks),
                    enabled: loading,
                    child: SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return TaskItem.fromTask(
                            task: task,
                            onTap: () {
                              TransferDetailsRoute(task.firstTransferId).push(context);
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                        itemCount: tasks.length,
                      ),
                    ),
                  );
                } else {
                  child = SliverFillRemaining(
                    key: const Key('empty'),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Assets.icons.ccalendar.svg(
                            colorFilter: ColorFilter.mode(
                              colors.textSubhead,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            loc.tasksNoScheduledTrips,
                            style: textTheme.titleLB.copyWith(
                              color: colors.textSubhead,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }

                return CustomSliverAnimatedPaintExtent(
                  child: CustomSliverAnimatedSwitcher(
                    sliver: child,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
