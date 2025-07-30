import 'package:hh_example/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:hh_example/generated/assets.gen.dart';
import 'package:flutter/material.dart';

typedef CustomBottomNavigationBarItemIconBuilder = Widget Function(
    BuildContext context, Widget icon);

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem.svgGenImage({
    super.key,
    required SvgGenImage svg,
    required Color selectedColor,
    required Color unselectedColor,
    super.label,
    super.backgroundColor,
    super.tooltip,
  }) : super(
          icon: svg.svg(
            colorFilter: ColorFilter.mode(
              unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: svg.svg(
            colorFilter: ColorFilter.mode(
              selectedColor,
              BlendMode.srcIn,
            ),
          ),
        );

  CustomBottomNavigationBarItem.fadeSvgGenImage({
    super.key,
    required SvgGenImage svg,
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    CustomBottomNavigationBarItemIconBuilder? iconBuilder,
    super.label,
    super.backgroundColor,
    super.tooltip,
  }) : super(
          icon: Builder(
            builder: (context) {
              final icon = CustomAnimatedSwitcher(
                child: svg.svg(
                  key: ValueKey(isSelected),
                  colorFilter: ColorFilter.mode(
                    isSelected ? selectedColor : unselectedColor,
                    BlendMode.srcIn,
                  ),
                ),
              );

              return iconBuilder?.call(context, icon) ?? icon;
            },
          ),
        );
}
