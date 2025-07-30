import 'dart:ui';

import 'package:hh_example/common/themes/text_themes.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferPlaceMarkerWidget extends StatelessWidget {
  static Size getDefaultSize() => Size(140.w, 140.h);

  static EdgeInsets getDefaultPadding() => EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h);

  static Offset getDefaultAnchor() {
    final size = getDefaultSize();
    final padding = getDefaultPadding();

    return Offset(0.5, 1 - (padding.bottom / size.height));
  }

  final String title;
  final SvgGenImage svg;
  final bool active;

  const TransferPlaceMarkerWidget({
    super.key,
    required this.title,
    required this.svg,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final size = getDefaultSize();
    final padding = getDefaultPadding();
    final imageSize = Size(52.w, 52.h);

    final shadowColor = Colors.black.withOpacity(0.32);
    final shadowOffset = Offset(0, 4.h);
    final shadowSigma = 8.r;

    final image = svg.svg(width: imageSize.width, height: imageSize.height);

    return Container(
      width: size.width,
      height: size.height,
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: active ? Colors.white : const Color(0xFFECEFF6),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: shadowOffset,
                  blurRadius: shadowSigma,
                ),
              ],
            ),
            child: Text(
              title,
              style: active
                  ? textThemes.labelLS
                  : textThemes.labelMM.copyWith(color: const Color(0xFF90929C)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (active) ...[
            SizedBox(height: 8.h),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: -shadowOffset.dy,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      tileMode: TileMode.decal,
                      sigmaX: shadowSigma,
                      sigmaY: shadowSigma,
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(shadowColor, BlendMode.srcIn),
                      child: image,
                    ),
                  ),
                ),
                image,
              ],
            ),
          ],
        ],
      ),
    );
  }
}
