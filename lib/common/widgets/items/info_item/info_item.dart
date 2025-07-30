import 'package:hh_example/common/themes/text_themes.dart';
import 'package:hh_example/common/widgets/buttons/copy_clipboard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoItem extends StatelessWidget {
  final String title;
  final String value;
  final EdgeInsets? padding;
  final bool copyValue;

  const InfoItem({
    super.key,
    required this.title,
    required this.value,
    this.padding,
    this.copyValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h);

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textThemes.labelSR.copyWith(
              // TODO(alexanderkind): Цвет вынести
              color: const Color(0xFF90929C),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: textThemes.titleMR,
                ),
              ),
              if (copyValue)
                CopyClipboardButton(
                  value: value,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
