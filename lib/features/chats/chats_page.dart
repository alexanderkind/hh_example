import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/router/routes.dart';
import 'package:hh_example/common/services/fresh_chat_service/fresh_chat_service.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/common/widgets/animated_list/sliver_animated_list.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/features/chats/components/chat_item.dart';
import 'package:hh_example/features/chats/state/chats_notifier.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatsPage extends HookConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = context.loc;
    final colors = useThemeExtension<ColorsScheme>();
    final bloc = ref.watch(chatsNotifierProvider.notifier);
    final freshChatBloc = ref.watch(freshChatServiceProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: bloc.update,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(loc.commonYourChats),
              floating: true,
            ),

            /// Тех. поддержка
            Consumer(
              builder: (context, ref, child) {
                final count =
                    ref.watch(freshChatServiceProvider.select((value) => value.messagesNotViewed));

                return SliverPadding(
                  padding: EdgeInsets.only(top: 20.h),
                  sliver: SliverToBoxAdapter(
                    child: ChatItem(
                      title: loc.supportTitle,
                      message: '',
                      messagesNotViewed: count,
                      showTopDivider: false,
                      svgNoAvatar: Assets.icons.supportFilled,
                      colorNoAvatarSvg: colors.iconAccent,

                      /// Переход в поддержку
                      onTap: freshChatBloc.openChat,
                    ),
                  ),
                );
              },
            ),

            /// Список чатов
            Consumer(builder: (context, ref, _) {
              final state = ref.watch(chatsNotifierProvider);
              final showSkeleton = state.showSkeleton;
              final chats = !showSkeleton ? state.chats : bloc.fakeChats;

              return SliverSkeletonizer(
                enabled: showSkeleton,
                child: SliverPadding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  sliver: CustomSliverAnimatedList(
                    animatedItemBuilder: (context, item) {
                      return ChatItem.fromChatModel(
                        key: ValueKey(item.uuid),
                        chat: item,
                        showTopDivider: true,
                        onTap: () {
                          /// Переход в чат
                          ChatRoute(item.uuid).push(context);
                        },
                      );
                    },
                    items: chats,
                    areItemsTheSame: (oldItem, newItem) => oldItem.uuid == newItem.uuid,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
