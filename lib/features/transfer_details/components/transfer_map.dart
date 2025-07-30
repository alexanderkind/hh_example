import 'package:alps2alps_cool_driver/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:alps2alps_cool_driver/common/widgets/circular_loader.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/state/transfer_details_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransferMap extends HookConsumerWidget {
  static const _defaultCameraPosition = CameraPosition(
    target: LatLng(47.03487689898907, 9.498134292662144),
    zoom: 5,
  );

  final MapCreatedCallback? onMapCreated;
  final double minContentSize;

  const TransferMap({
    super.key,
    this.onMapCreated,
    required this.minContentSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transferDetailsNotifierProvider);

    final extraPadding = 30.r;

    return state.whenOrNull(
          main: (data) {
            final loading = data.loading;
            final markers = data.markers;
            final polylines = data.polylines;

            return Padding(
              padding: EdgeInsets.only(
                  bottom: ScreenUtil().screenHeight * minContentSize - extraPadding),
              child: Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    buildingsEnabled: true,
                    initialCameraPosition: _defaultCameraPosition,
                    polylines: polylines,
                    markers: markers,
                    onMapCreated: (controller) {
                      onMapCreated?.call(controller);
                    },
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top.h + 66.h,
                      bottom: extraPadding + 50.h,
                    ),
                  ),
                  CustomAnimatedSwitcher(
                    child: loading ? const CircularLoader() : const SizedBox(),
                  ),
                ],
              ),
            );
          },
        ) ??
        const SizedBox();
  }
}
