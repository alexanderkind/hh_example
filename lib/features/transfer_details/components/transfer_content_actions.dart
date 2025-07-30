import 'package:alps2alps_cool_driver/common/hooks/use_theme_extension.dart';
import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/router/routes.dart';
import 'package:alps2alps_cool_driver/common/services/fresh_chat_service/fresh_chat_service.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/group_list/group_cell.dart';
import 'package:alps2alps_cool_driver/common/widgets/group_list/group_cell_data.dart';
import 'package:alps2alps_cool_driver/common/widgets/group_list/group_list.dart';
import 'package:alps2alps_cool_driver/common/widgets/theme_extensions.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/state/transfer_details_notifier.dart';
import 'package:alps2alps_cool_driver/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Кнопки действий в контенте
class TransferContentActions extends HookConsumerWidget {
  final bool actionRestrictions;
  final Task task;

  const TransferContentActions({
    super.key,
    required this.actionRestrictions,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(transferDetailsNotifierProvider.notifier);
    final freshChatBloc = ref.watch(freshChatServiceProvider.notifier);

    final loc = context.loc;
    final colors = useThemeExtension<ColorsScheme>();

    final arrowIcon = Skeleton.shade(
      child: Assets.icons.arrowNext.svg(
        colorFilter: ColorFilter.mode(
          colors.iconAccent,
          BlendMode.srcIn,
        ),
      ),
    );
    final cellPadding = EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h);
    const cellSize = GroupCellSize.l;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          GroupList(
            size: cellSize,
            cellPadding: cellPadding,
            commonRightIcon: arrowIcon,
            entries: [
              GroupCellData(
                itemId: 0,
                title: loc.transferDetailsBonDeCommandeChauffeur,
                leftIcon: Assets.icons.fileFilled.svg(
                  colorFilter: ColorFilter.mode(
                    colors.iconTertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
            onTap: (value) {
              switch (value) {
                case 0:
                  DriverOrderFormRoute(task.taskIds).push(context);
                  break;
              }
            },
          ),
          CustomAnimatedSwitcher.sizeFadePreset(
            child: actionRestrictions
                ? const SizedBox()
                : GroupCell(
                    title: loc.transferDetailsSupportChat,
                    rightIcon: arrowIcon,
                    padding: cellPadding,
                    leftIcon: Skeleton.shade(
                      child: Assets.icons.chatFilled.svg(
                        colorFilter: ColorFilter.mode(
                          colors.iconTertiary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    size: cellSize,

                    /// Переход в поддержку
                    onTap: () {
                      if (!bloc.checkDateTime()) {
                        return;
                      }

                      /// Переход в поддержку
                      freshChatBloc.openChat();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
