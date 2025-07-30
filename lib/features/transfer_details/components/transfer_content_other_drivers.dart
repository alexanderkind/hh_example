import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/chapter_title.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/driver_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// Список других водителей
/// Для СПЛИТ трансферов
class TransferContentOtherDrivers extends HookWidget {
  final List<TransferDriver> drivers;

  const TransferContentOtherDrivers({
    super.key,
    required this.drivers,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    if (drivers.isEmpty) {
      return const SliverToBoxAdapter();
    }

    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: ChapterTitle(
            title: loc.transferDetailsOtherDrivers,
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            final driver = drivers[index];

            return DriverItem(driver: driver);
          },
          itemCount: drivers.length,
        ),
      ],
    );
  }
}
