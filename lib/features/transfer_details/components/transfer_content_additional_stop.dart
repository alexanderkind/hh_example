import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/items/info_item/info_item.dart';
import 'package:alps2alps_cool_driver/features/transfer_details/components/chapter_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Информация по добавленных точкам маршрута
class TransferContentAdditionalStop extends HookWidget {
  const TransferContentAdditionalStop({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChapterTitle(
            title: loc.commonAdditionalStop,
          ),
          InfoItem(
            title: loc.commonName,
            value: 'Collect skis',
          ),
          InfoItem(
            title: loc.commonCoordinates,
            value: '46. 102657, 6. 103562',
            copyValue: true,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
