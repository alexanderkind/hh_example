import 'package:hh_example/common/hooks/use_theme_extension.dart';
import 'package:hh_example/common/utils/extensions/date_extensions.dart';
import 'package:hh_example/common/widgets/animated_switcher/custom_animated_switcher.dart';
import 'package:hh_example/common/widgets/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Список дат для выбора
class DatesTabBar extends HookWidget implements PreferredSizeWidget {
  final DateTime? selectedDate;
  final List<DateTime> dates;
  final ValueChanged<DateTime> onChanged;

  const DatesTabBar({
    super.key,
    required this.selectedDate,
    required this.dates,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: preferredSize.height,
      child: Row(
        children: List.generate(
          dates.length,
          (index) {
            final date = dates[index];
            final isSelected = selectedDate == date;

            return Expanded(
              child: DateTabBarItem(
                dateTime: date,
                isSelected: isSelected,
                onTap: () => onChanged.call(date),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(46);
}

class DateTabBarItem extends HookWidget {
  final DateTime dateTime;
  final bool isSelected;
  final VoidCallback? onTap;

  const DateTabBarItem({
    super.key,
    required this.dateTime,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = useThemeExtension<ColorsScheme>();
    final textTheme = useThemeExtension<TextThemes>();
    final borders = useThemeExtension<BorderRadiusScheme>();

    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        borderRadius: borders.itemLTop,
        onTap: onTap,
        child: AnimatedContainer(
          duration: CustomAnimatedSwitcher.defaultDurationFast,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isSelected ? colors.backgroundAccent : colors.backgroundTertiary,
              ),
            ),
          ),
          padding: const EdgeInsets.all(2),
          alignment: Alignment.bottomCenter,
          child: AnimatedDefaultTextStyle(
            duration: CustomAnimatedSwitcher.defaultDurationFast,
            style: textTheme.titleMM.copyWith(
              color: isSelected ? colors.black : colors.textTertiary,
            ),
            child: Text(dateTime.toDmmmFormat()),
          ),
        ),
      ),
    );
  }
}
