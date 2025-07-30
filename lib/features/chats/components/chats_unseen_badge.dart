import 'package:hh_example/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:hh_example/common/widgets/badge/custom_badge.dart';
import 'package:hh_example/features/chats/state/chats_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef ChatsUnseenBadgePositionedBuilder = Widget Function(BuildContext context, Widget badge);

/// Показывает кол-во непрочитанных сообщений
class ChatsUnseenBadge extends HookConsumerWidget {
  static Widget _defaultPositionedBuilder(BuildContext context, Widget badge) {
    return Positioned(
      top: 0,
      right: 0,
      child: badge,
    );
  }

  static Widget _topRightInsidePositionedBuilder(BuildContext context, Widget badge) {
    return Positioned(
      top: 4.h,
      right: 4.w,
      child: badge,
    );
  }

  static Widget _topRightOutsidePositionedBuilder(BuildContext context, Widget badge) {
    return Positioned(
      top: -4.h,
      right: -4.w,
      child: badge,
    );
  }

  final Widget child;
  final String? chatUuid;
  final int? customerId;
  final ChatsUnseenBadgePositionedBuilder positionedBuilder;

  const ChatsUnseenBadge({
    super.key,
    required this.child,
    this.chatUuid,
    this.customerId,
    this.positionedBuilder = _defaultPositionedBuilder,
  });

  const ChatsUnseenBadge.topRightInside({
    super.key,
    required this.child,
    this.chatUuid,
    this.customerId,
    this.positionedBuilder = _topRightInsidePositionedBuilder,
  });

  const ChatsUnseenBadge.topRightOutside({
    super.key,
    required this.child,
    this.chatUuid,
    this.customerId,
    this.positionedBuilder = _topRightOutsidePositionedBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(chatsNotifierProvider
        .select((value) => value.getUnseenCount(chatUuid: chatUuid, customerId: customerId)));

    final badge = CustomAnimatedSwitcher.scaleFadePreset(
      child: count > 0
          ? CustomBadge(
              key: ValueKey(count),
              value: count.toString(),
              size: CustomBadgeSize.xs,
            )
          : const SizedBox(),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        positionedBuilder.call(context, badge),
      ],
    );
  }
}
