import 'package:hh_example/common/hooks/use_init_state.dart';
import 'package:hh_example/common/models/navigator_type/navigator_types.dart';
import 'package:hh_example/common/router/routes.dart';
import 'package:hh_example/common/utils/extensions/localization_extension.dart';
import 'package:hh_example/features/systems/custom_error_dialog.dart';
import 'package:hh_example/features/systems/error_dialog.dart';
import 'package:hh_example/features/transfer_details/components/transfer_app_bar.dart';
import 'package:hh_example/features/transfer_details/components/transfer_bottom_buttons.dart';
import 'package:hh_example/features/transfer_details/components/transfer_buttons_above_content.dart';
import 'package:hh_example/features/transfer_details/components/transfer_content_sheet.dart';
import 'package:hh_example/features/transfer_details/components/transfer_map.dart';
import 'package:hh_example/features/transfer_details/state/transfer_details_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Страница с детальной ифнормацией о трансфере
class TransferDetailsPage extends HookConsumerWidget {
  static const _minContentSize = .3;
  static const _hiddenContentSize = .7;

  final int id;

  const TransferDetailsPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(transferDetailsNotifierProvider.notifier);
    final loc = context.loc;

    final mapController = useRef<GoogleMapController?>(null);
    final draggableScrollableController = useMemoized(DraggableScrollableController.new);

    useInitState(
      initState: () {
        return draggableScrollableController.dispose;
      },
    );

    ref.listen(
      transferDetailsNotifierProvider,
      (p, n) {
        n.whenOrNull(
          /// Обновление позиции камеры
          cameraUpdate: (cameraUpdate) {
            mapController.value?.animateCamera(cameraUpdate);
          },

          /// Выход со страницы, например, если была ошибка
          exit: () {
            context.pop();
          },

          /// Переход для выбора навигатора
          selectNavigator: () {
            const SelectNavigatorConfirmationRoute().push<NavigatorType>(context).then(
              (value) {
                if (value != null) {
                  bloc.goToNavigator(navigator: value);
                }
              },
            );
          },

          /// Ошибка по дальности расстояния от точки посадки
          warningFarFromPickUp: () {
            WarningDialogRoute(
              title: loc.transferDetailsFarFromPickUpDialogTitle,
              description: loc.transferDetailsFarFromPickUpDialogDesc,
              blueButton: loc.commonOk,
            ).push(context);
          },

          /// Ошибка по дальности расстояния от точки высадки
          warningFarFromDropOff: () {
            WarningDialogRoute(
              title: loc.transferDetailsFarFromDropOffDialogTitle,
              description: loc.transferDetailsFarFromDropOffDialogDesc,
              blueButton: loc.commonOk,
            ).push(context);
          },

          /// Ошибка определения местоположения
          warningLocation: () {
            ErrorDialogRoute(
              title: loc.errorsUnableLocationTitle,
              description: loc.errorsUnableLocationDesc,
              iconType: ErrorDialogIconType.location,
              blueButton: loc.errorsGoToSettings,
            ).push<CustomDialogResponse>(context).then((value) {
              if (value == CustomDialogResponse.blue) {
                bloc.requestGpsPermission();
              }
            });
          },

          /// Успешное завершение задания
          /// Выход со страницы через 3 секунды после
          successfully: () {
            Future.delayed(const Duration(seconds: 3)).then((value) {
              if (context.mounted) {
                const TasksRoute().go(context);
              }
            });
            SuccessDialogRoute(
              title: loc.transferDetailsSuccessDialogTitle,
              description: loc.transferDetailsSuccessDialogDesc,
            ).push(context).then((value) {
              if (context.mounted) {
                const TasksRoute().go(context);
              }
            });
          },
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          /// Карта
          TransferMap(
            onMapCreated: (controller) {
              mapController.value = controller;

              bloc.init(id, loc: loc);
            },
            minContentSize: _minContentSize,
          ),

          /// Кнопка назад
          TransferAppBar(
            maxContentSize: _hiddenContentSize,
            draggableScrollableController: draggableScrollableController,
          ),

          /// Кнопки над информацией
          TransferButtonsAboveContent(
            maxContentSize: _hiddenContentSize,
            draggableScrollableController: draggableScrollableController,
          ),

          /// Информация по трансферу
          TransferContentSheet(
            minContentSize: _minContentSize,
            draggableScrollableController: draggableScrollableController,
          ),

          /// Кнопки по статусам
          const TransferBottomButtons(),
        ],
      ),
    );
  }
}
