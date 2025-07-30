import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/widgets/buttons/copy_clipboard_button.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Элемент списка точек маршрута
class PlaceInfoItem extends HookWidget {
  final String title;
  final String address;
  final String valueForCopy;
  final Color color;
  final bool copyAddress;

  const PlaceInfoItem({
    super.key,
    required this.title,
    required this.address,
    required this.valueForCopy,
    required this.color,
    this.copyAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Skeleton.shade(
              child: Assets.icons.placeFilled.svg(
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                title,
                style: textTheme.titleMR.copyWith(
                  color: colors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                address,
                style: textTheme.titleLR,
              ),
            ),
            if (copyAddress) CopyClipboardButton(value: valueForCopy),
          ],
        ),
      ],
    );
  }
}
