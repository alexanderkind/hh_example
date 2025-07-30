import 'package:alps2alps_cool_driver/common/hooks/use_init_state.dart';
import 'package:alps2alps_cool_driver/common/hooks/use_theme_extension.dart';
import 'package:alps2alps_cool_driver/common/router/routes.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_button_styles.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_buttons.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_icon_buttons.dart';
import 'package:alps2alps_cool_driver/common/widgets/theme_extensions.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/state/transfer_details_notifier.dart';
import 'package:alps2alps_cool_driver/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// "Апп бар" страницы деталей трансфера
class TransferAppBar extends HookConsumerWidget {
  final double maxContentSize;
  final DraggableScrollableController draggableScrollableController;

  const TransferAppBar({
    super.key,
    required this.maxContentSize,
    required this.draggableScrollableController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = useThemeExtension<ColorsScheme>();
    final loc = context.loc;

    final state = ref.watch(transferDetailsNotifierProvider);

    final openContentSize = useState(0.0);
    final updateValues = useCallback(() {
      openContentSize.value = draggableScrollableController.size;
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
    final elevation = openContentSize.value > maxContentSize ? 5.0 : 10.0;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 16.h,
          ),
          child: Row(
            children: [
              CustomAnimatedSwitcher(
                child: state.whenOrNull(
                      main: (data) {
                        final type = data.shareTripInfoType;

                        if (type == null) {
                          return const SizedBox();
                        }

                        return AppButtons.tertiary(
                          expandHorizontal: false,
                          icon: Assets.icons.info.svg(
                            colorFilter: ColorFilter.mode(
                              colors.iconAccent,
                              BlendMode.srcIn,
                            ),
                          ),
                          elevation: elevation,
                          text: loc.transferDetailsWhatIsAShareTrip,
                          onPressed: () {
                            /// Переход к странице объяснения раздельного трансфера
                            ShareTripInfoRoute(type: type).push(context);
                          },
                        );
                      },
                    ) ??
                    const SizedBox(),
              ),
              const Spacer(),
              AppIconButtons.tertiary(
                assetIcon: Assets.icons.closeModal,
                expandHorizontal: false,
                size: AppButtonSize.m,
                elevation: elevation,
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
