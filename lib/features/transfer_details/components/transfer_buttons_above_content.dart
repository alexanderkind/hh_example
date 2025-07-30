import 'package:alps2alps_cool_driver/common/hooks/use_init_state.dart';
import 'package:alps2alps_cool_driver/common/hooks/use_theme_extension.dart';
import 'package:alps2alps_cool_driver/common/services/fresh_chat_service/fresh_chat_service.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_buttons.dart';
import 'package:alps2alps_cool_driver/common/widgets/theme_extensions.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/state/transfer_details_notifier.dart';
import 'package:alps2alps_cool_driver/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Кнопки над контентом
class TransferButtonsAboveContent extends HookConsumerWidget {
  final double maxContentSize;
  final DraggableScrollableController draggableScrollableController;

  const TransferButtonsAboveContent({
    super.key,
    required this.maxContentSize,
    required this.draggableScrollableController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(transferDetailsNotifierProvider.notifier);
    final freshChatBloc = ref.watch(freshChatServiceProvider.notifier);

    final loc = context.loc;
    final colors = useThemeExtension<ColorsScheme>();

    final state = ref.watch(transferDetailsNotifierProvider);
    final disabled = state.whenOrNull(main: (data) => data.loading) ?? true;
    final actionRestrictions = state.whenOrNull(main: (data) => data.actionRestrictions) ?? true;

    final openContentPixels = useState(0.0);
    final openContentSize = useState(0.0);
    final updateValues = useCallback(() {
      openContentSize.value = draggableScrollableController.size;
      openContentPixels.value = draggableScrollableController.pixels;
    });
    final onScroll = useCallback(updateValues.call);

    useInitState(
      onBuild: updateValues,
      initState: () {
        draggableScrollableController.addListener(onScroll);

        return () {
          draggableScrollableController.removeListener(onScroll);
        };
      },
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: openContentPixels.value),
        child: CustomAnimatedSwitcher(
          duration: CustomAnimatedSwitcher.defaultDurationFast,
          child: openContentSize.value > maxContentSize
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAnimatedSwitcher(
                        child: actionRestrictions
                            ? const SizedBox()
                            : AppButtons.tertiary(
                                expandHorizontal: false,
                                text: loc.commonSupport,
                                icon: Assets.icons.chatFilled.svg(
                                  colorFilter: ColorFilter.mode(
                                    colors.iconAccent,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                elevation: 10,
                                onPressed: () {
                                  if (!bloc.checkDateTime()) {
                                    return;
                                  }

                                  /// Переход в поддержку
                                  freshChatBloc.openChat();
                                },
                              ),
                      ),
                      const Spacer(),
                      AppButtons.tertiary(
                        expandHorizontal: false,
                        text: loc.commonNavigator,
                        icon: Assets.icons.navigatorFilled.svg(
                          colorFilter: ColorFilter.mode(
                            colors.iconAccent,
                            BlendMode.srcIn,
                          ),
                        ),
                        elevation: 10,
                        onPressed: () async {
                          if (disabled) return;

                          /// Переход в навигатор
                          bloc.goToNavigator();
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
