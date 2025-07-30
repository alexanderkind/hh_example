import 'package:alps2alps_cool_driver/common/hooks/use_theme_extension.dart';
import 'package:alps2alps_cool_driver/common/models/task/tasks.dart';
import 'package:alps2alps_cool_driver/common/services/url_launcher_service.dart';
import 'package:alps2alps_cool_driver/common/utils/extensions/localization_extension.dart';
import 'package:alps2alps_cool_driver/common/widgets/buttons/app_icon_buttons.dart';
import 'package:alps2alps_cool_driver/common/widgets/images/plug_avatar.dart';
import 'package:alps2alps_cool_driver/common/widgets/theme_extensions.dart';
import 'package:alps2alps_cool_driver/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Элемент списка водителей
class DriverItem extends HookConsumerWidget {
  final TransferDriver driver;

  const DriverItem({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = useThemeExtension<TextThemes>();
    final loc = context.loc;

    final phone = driver.phoneNumber;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          // TODO(alexanderkind): Заменить на аватарку, как будет приходить
          const PlugAvatar(),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.fullName,
                  style: textTheme.titleMS,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  loc.commonDriver,
                  style: textTheme.bodyMR,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (phone.isNotEmpty) ...[
            SizedBox(width: 10.w),
            AppIconButtons.secondary(
              assetIcon: Assets.icons.phone,
              onPressed: () {
                /// Переход в звонилку
                ref.read(urlLauncherServiceProvider.notifier).callTo(phone);
              },
            ),
          ],
        ],
      ),
    );
  }
}
