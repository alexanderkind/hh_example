import 'package:hh_example/common/models/markers/marker_with_transfer_place.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/features/share_trip_info/share_trip_info_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'transfer_details_state.freezed.dart';

@freezed
class TransferDetailsState with _$TransferDetailsState {
  const TransferDetailsState._();

  const factory TransferDetailsState.main(TransferDetailsData data) = TransferDetailsStateMain;

  const factory TransferDetailsState.exit() = TransferDetailsStateExit;

  const factory TransferDetailsState.selectNavigator() = TransferDetailsStateSelectNavigator;

  const factory TransferDetailsState.cameraUpdate(CameraUpdate cameraUpdate) =
      TransferDetailsStateCameraUpdate;

  const factory TransferDetailsState.warningFarFromPickUp() =
      TransferDetailsStateWarningFarFromPickUp;

  const factory TransferDetailsState.warningFarFromDropOff() =
      TransferDetailsStateWarningFarFromDropOff;

  const factory TransferDetailsState.warningLocation() = TransferDetailsStateWarningLocation;

  const factory TransferDetailsState.successfully() = TransferDetailsStateSuccessfully;
}

@freezed
class TransferDetailsData with _$TransferDetailsData {
  const TransferDetailsData._();

  const factory TransferDetailsData({
    @Default(false) bool loading,
    @Default(true) bool actionRestrictions,
    @Default(null) Task? task,
    @Default({}) Set<MarkerWithTransferPlace> markers,
    @Default({}) Set<Polyline> polylines,
  }) = _TransferDetailsData;

  Task get requiredTask => task!;

  /// Проверка по дате начала
  bool checkActionRestrictions() {
    final now = DateTime.now();
    final dateTimeStart = requiredTask.datetime.subtract(const Duration(hours: 1));

    return now.isAfter(dateTimeStart);
  }

  /// Получение задержи по временным ограничениям
  Duration get durationLeftActionRestrictions {
    final now = DateTime.now();
    final dateTimeStart = requiredTask.datetime.subtract(const Duration(hours: 1));

    if (now.isAfter(dateTimeStart)) {
      return const Duration();
    }
    return dateTimeStart.difference(now);
  }

  /// Маркеры для отображения
  Set<Marker> get markersForShow {
    final currentStatus = task?.localStatus;

    if ([
      LocalTaskStatus.onRoute,
      LocalTaskStatus.arrived,
      LocalTaskStatus.customerOnBoard,
    ].contains(currentStatus)) {
      return markersNotCompleted;
    }

    return markers;
  }

  /// Маркеры не завершенные
  Set<MarkerWithTransferPlace> get markersNotCompleted {
    // TODO(alexanderkind): Вернуть, если необходимо менять видимую область в зависимости от этапа
    //final placesNotCompleted = task?.currentActivePlaces ?? [];
    final placesNotCompleted = task?.allCorrectPlaces ?? [];

    return markers.where((e) => placesNotCompleted.contains(e.place)).toSet();
  }

  ShareTripInfoType? get shareTripInfoType {
    final pickUpCount = task?.pickUpCorrectPlaces.length ?? 0;
    final dropOffCount = task?.dropOffCorrectPlaces.length ?? 0;

    return ShareTripInfoType.valueByCounts(
      pickUpCount: pickUpCount,
      dropOffCount: dropOffCount,
    );
  }
}
