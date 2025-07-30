import 'package:alps2alps_cool_driver/common/hooks/use_theme_extension.dart';
import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_icon_buttons.dart';
import 'package:alps2alps_cool_driver/common/widgets/images/plug_avatar.dart';
import 'package:alps2alps_cool_driver/common/widgets/theme_extensions.dart';
import 'package:alps2alps_cool_driver/features/chats/components/chats_unseen_badge.dart';
import 'package:alps2alps_cool_driver/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Элемент списка пассажиров
class PassengerItem extends HookConsumerWidget {
  final Transfer transfer;
  final int? number;
  final bool showCountPassengers;
  final bool showDropOffNumber;
  final bool showActions;
  final VoidCallback onCallPassenger;
  final VoidCallback onChatPassenger;

  const PassengerItem({
    super.key,
    required this.transfer,
    this.number,
    this.showCountPassengers = true,
    this.showDropOffNumber = false,
    this.showActions = false,
    required this.onCallPassenger,
    required this.onChatPassenger,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = useThemeExtension<TextThemes>();
    final loc = context.loc;

    final passengersCount = transfer.passengerCount;

    late final String subtitle;
    if (showDropOffNumber && number != null) {
      subtitle = loc.transferDetailsClientDropOffNumber(loc.ordinalPostfix(number!));
    } else if (showCountPassengers) {
      subtitle = passengersCount > 1
          ? loc.commonCountPassengers(passengersCount)
          : loc.commonYourPassenger;
    } else {
      subtitle = loc.commonYourPassenger;
    }

    final showCall = transfer.contactNumber.isNotEmpty;
    final showChat = transfer.loyaltyUserId != null;
    final showActions = this.showActions && (showCall || showChat);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          // TODO(alexanderkind): Заменить на аватарку, как будет приходить
          const PlugAvatar(),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transfer.leadPassenger,
                  style: textTheme.titleMS,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: textTheme.bodyMR,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          CustomAnimatedSwitcher(
            child: showActions
                ? Row(
                    children: [
                      if (showCall) ...[
                        SizedBox(width: 10.w),
                        Skeleton.leaf(
                          child: AppIconButtons.secondary(
                            assetIcon: Assets.icons.phone,
                            onPressed: onCallPassenger,
                          ),
                        )
                      ],
                      SizedBox(width: 10.w),
                      if (showChat)
                        Skeleton.leaf(
                          child: ChatsUnseenBadge.topRightInside(
                            customerId: transfer.loyaltyUserId,
                            child: AppIconButtons.secondary(
                              assetIcon: Assets.icons.chatFilled,
                              onPressed: onChatPassenger,
                            ),
                          ),
                        ),
                    ],
                  )
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
