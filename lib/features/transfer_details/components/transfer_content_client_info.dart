import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/date_extensions.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/items/info_item/info_item.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/chapter_title.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/passenger_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Информация о клиенте
class TransferContentClientInfo extends HookWidget {
  final List<Transfer> transfers;
  final ValueChanged<Transfer> onCallPassenger;
  final ValueChanged<Transfer> onChatPassenger;
  final bool actionRestrictions;

  const TransferContentClientInfo({
    super.key,
    required this.transfers,
    required this.onCallPassenger,
    required this.onChatPassenger,
    required this.actionRestrictions,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return SliverPadding(
      padding: EdgeInsets.only(bottom: 10.h),
      sliver: SliverList.builder(
        itemBuilder: (context, index) {
          final t = transfers[index];
          final showTitleWithNumber = transfers.length > 1;
          final number = index + 1;
          final title = showTitleWithNumber
              ? loc.transferDetailsNumberClientInfoText(loc.ordinalPostfix(number))
              : loc.transferDetailsClientInfo;

          return _FullItem(
            title: title,
            transfer: t,
            showClientItem: true,
            onCallPassenger: () => onCallPassenger.call(t),
            onChatPassenger: () => onChatPassenger.call(t),
            showActions: !actionRestrictions,
          );
        },
        itemCount: transfers.length,
      ),
    );
  }
}

class _FullItem extends HookWidget {
  final String title;
  final Transfer transfer;
  final bool showClientItem;
  final VoidCallback onCallPassenger;
  final VoidCallback onChatPassenger;
  final bool showActions;

  const _FullItem({
    super.key,
    required this.title,
    required this.transfer,
    this.showClientItem = false,
    required this.onCallPassenger,
    required this.onChatPassenger,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ClientInfoItem(
          title: title,
          transfer: transfer,
          showClientItem: showClientItem,
          onCallPassenger: onCallPassenger,
          onChatPassenger: onChatPassenger,
          showActions: showActions,
        ),
        _DetailTripItem(
          transfer: transfer,
        )
      ],
    );
  }
}

class _ClientInfoItem extends HookWidget {
  final String title;
  final Transfer transfer;
  final bool showClientItem;
  final VoidCallback onCallPassenger;
  final VoidCallback onChatPassenger;
  final bool showActions;

  const _ClientInfoItem({
    super.key,
    required this.title,
    required this.transfer,
    this.showClientItem = false,
    required this.onCallPassenger,
    required this.onChatPassenger,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChapterTitle(title: title),
        if (showClientItem)
          PassengerItem(
            transfer: transfer,
            showCountPassengers: false,
            showActions: showActions,
            onCallPassenger: onCallPassenger,
            onChatPassenger: onChatPassenger,
          ),
        InfoItem(
          title: loc.transferDetailsSign,
          value: transfer.sign,
        ),
        InfoItem(
          title: loc.transferDetailsNumberOfPeople,
          value: loc.commonCountPassengers(transfer.passengerCount),
        ),
        InfoItem(
          title: loc.commonBoosters,
          value: transfer.boosterSeatCount.toString(),
        ),
        InfoItem(
          title: loc.commonChildSeats,
          value: transfer.childSeatCount.toString(),
        ),
        InfoItem(
          title: loc.transferDetailsTransportingSkis,
          value: transfer.travelingWithSkis ? loc.yes : loc.no,
        ),
      ],
    );
  }
}

/// Детали поездки
class _DetailTripItem extends HookWidget {
  final Transfer transfer;

  const _DetailTripItem({
    super.key,
    required this.transfer,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = transfer.datetime;
    final flightInfo = transfer.flight?.numberAndTime ?? '-';
    final accommodation = transfer.accommodation;

    final loc = context.loc;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChapterTitle(title: loc.transferDetailsDetailTrip),
        InfoItem(
          title: loc.transferDetailsPickUpData,
          value: dateTime.toDmmmyyyyFormat(),
        ),
        InfoItem(
          title: loc.transferDetailsPickUpTime,
          value: dateTime.toHhmmFormat(),
        ),
        InfoItem(
          title: loc.transferDetailsFlightInfo,
          value: flightInfo,
        ),
        InfoItem(
          title: loc.transferDetailsAccommodationName,
          value: accommodation?.name ?? '-',
        ),
        InfoItem(
          title: loc.transferDetailsAccommodationAddress,
          value: accommodation?.address ?? '-',
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
