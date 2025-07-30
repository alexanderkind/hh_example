import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/models/chat/chats.dart';
import 'package:hh_example/common/models/files/file_model.dart';
import 'package:hh_example/common/utils/extensions/date_extensions.dart';
import 'package:hh_example/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:hh_example/common/widgets/badge/custom_badge.dart';
import 'package:hh_example/common/widgets/images/custom_circle_avatar.dart';
import 'package:hh_example/common/widgets/images/plug_avatar.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatItem extends HookWidget {
  final FileModel? avatar;
  final String title;
  final String? message;
  final DateTime? time;
  final int messagesNotViewed;
  final VoidCallback? onTap;
  final bool showTopDivider;
  final SvgGenImage? svgNoAvatar;
  final Color? colorNoAvatarSvg;

  const ChatItem({
    super.key,
    this.avatar,
    required this.title,
    this.message,
    this.time,
    this.messagesNotViewed = 0,
    this.onTap,
    this.svgNoAvatar,
    this.colorNoAvatarSvg,
    this.showTopDivider = false,
  });

  factory ChatItem.fromChatModel({
    Key? key,
    required ChatModel chat,
    required bool showTopDivider,
    VoidCallback? onTap,
  }) =>
      ChatItem(
        key: key,
        avatar: chat.customer.avatar,
        title: chat.customer.fullName,
        message: chat.last?.bodyByType,
        time: chat.last?.createdAt,
        messagesNotViewed: chat.unseen,
        onTap: onTap,
        svgNoAvatar: Assets.icons.profileFilled,
        showTopDivider: showTopDivider,
      );

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();

    final avatarSize = 40.r;

    final showTime = time != null;
    final showBadge = messagesNotViewed > 0;

    return IntrinsicHeight(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: CustomAnimatedSwitcher.defaultDuration,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(
              width: 0.5,
              color: showTopDivider ? colors.statesHoverField : Colors.transparent,
            ),
          )),
          child: Row(
            children: [
              CustomAnimatedSwitcher(
                child: avatar != null
                    ? CustomCircleAvatar.fileModel(
                        key: ValueKey(avatar.hashCode),
                        size: avatarSize,
                        file: avatar,
                      )
                    : PlugAvatar(
                        size: avatarSize,
                        svg: svgNoAvatar,
                        colorForeground: colorNoAvatarSvg,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key: ValueKey(title),
                      title,
                      style: textTheme.titleMS,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      key: ValueKey(message),
                      message ?? '-',
                      style: textTheme.bodyMR,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomAnimatedSwitcher.sizeFadePreset(
                    child: showTime
                        ? Text(
                            key: ValueKey(showTime),
                            time!.toHhmmFormat(),
                            style: textTheme.labelMR.copyWith(color: colors.textSubhead),
                          )
                        : const SizedBox(),
                  ),
                  const Spacer(),
                  CustomAnimatedSwitcher.scaleFadePreset(
                    child: showBadge
                        ? Padding(
                            key: ValueKey(messagesNotViewed),
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Skeleton.leaf(
                              child: CustomBadge(value: messagesNotViewed.toString()),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
