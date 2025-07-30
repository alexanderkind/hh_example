import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';

typedef CustomAnimatedItemBuilder<T extends Object> = Widget Function(BuildContext context, T item);

typedef CustomAnimatedTransitionBuilder = Widget Function(
    Animation<double> animation, Widget child);

class CustomAnimatedList<T extends Object> extends ImplicitlyAnimatedList<T> {
  static const defaultDuration = Duration(milliseconds: 500);

  static Widget defaultCustomAnimatedTransitionBuilder(Animation<double> animation, Widget child) {
    return SizeFadeTransition(
      curve: Curves.easeInOut,
      animation: animation,
      child: child,
    );
  }

  static Widget defaultHorizontalCustomAnimatedTransitionBuilder(
      Animation<double> animation, Widget child) {
    return SizeFadeTransition(
      curve: Curves.easeInOut,
      animation: animation,
      axis: Axis.horizontal,
      child: child,
    );
  }

  static Widget defaultCustomAnimatedUpdateTransitionBuilder(
      Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static bool defaultItemDiffUtil(dynamic oldItem, dynamic newItem) {
    return oldItem == newItem;
  }

  /// Для построения элемента списка
  final CustomAnimatedItemBuilder<T> animatedItemBuilder;

  /// Для построения элемента списка при обновлении
  /// Если не указан, то используется [animatedItemBuilder]
  final CustomAnimatedItemBuilder<T>? updateAnimatedItemBuilder;

  /// Для построения элемента списка при удалении
  /// Если не указан, то используется [animatedItemBuilder]
  final CustomAnimatedItemBuilder<T>? removeAnimatedItemBuilder;

  /// Для построения перехода
  /// Если не указан, то используется [defaultCustomAnimatedTransitionBuilder]
  final CustomAnimatedTransitionBuilder? animatedTransitionBuilder;

  /// Для построения перехода
  /// Если не указан, то используется [defaultCustomAnimatedUpdateTransitionBuilder]
  final CustomAnimatedTransitionBuilder? updateTransitionBuilder;

  /// Для построения перехода
  /// Если не указан, то используется [defaultCustomAnimatedTransitionBuilder]
  final CustomAnimatedTransitionBuilder? removeTransitionBuilder;

  CustomAnimatedList({
    required this.animatedItemBuilder,
    this.updateAnimatedItemBuilder,
    this.removeAnimatedItemBuilder,
    this.animatedTransitionBuilder,
    this.updateTransitionBuilder,
    this.removeTransitionBuilder,
    super.key,
    required super.items,
    super.areItemsTheSame = defaultItemDiffUtil,
    super.separatorBuilder,
    super.insertDuration = defaultDuration,
    super.removeDuration = defaultDuration,
    super.updateDuration = defaultDuration,
    super.spawnIsolate,
    super.scrollDirection = Axis.vertical,
    super.reverse = false,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap = false,
    super.padding,
    super.clipBehavior,
  }) : super(
          itemBuilder: (context, animation, item, index) {
            final child = animatedItemBuilder.call(context, item);

            return animatedTransitionBuilder?.call(animation, child) ??
                defaultCustomAnimatedTransitionBuilder(animation, child);
          },
          updateItemBuilder: (context, animation, item) {
            final child = updateAnimatedItemBuilder?.call(context, item) ??
                animatedItemBuilder.call(context, item);

            return updateTransitionBuilder?.call(animation, child) ??
                animatedTransitionBuilder?.call(animation, child) ??
                defaultCustomAnimatedUpdateTransitionBuilder(animation, child);
          },
          removeItemBuilder: (context, animation, item) {
            final child = removeAnimatedItemBuilder?.call(context, item) ??
                animatedItemBuilder.call(context, item);

            return removeTransitionBuilder?.call(animation, child) ??
                animatedTransitionBuilder?.call(animation, child) ??
                defaultCustomAnimatedTransitionBuilder(animation, child);
          },
        );
}
