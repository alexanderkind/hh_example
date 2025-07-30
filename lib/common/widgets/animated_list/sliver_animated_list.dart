import 'package:animated_list_plus/animated_list_plus.dart';

import 'animated_list.dart';

class CustomSliverAnimatedList<T extends Object> extends SliverImplicitlyAnimatedList<T> {
  static const defaultDuration = Duration(milliseconds: 500);

  /// Для построения элемента списка
  final CustomAnimatedItemBuilder<T> animatedItemBuilder;

  /// Для построения элемента списка при обновлении
  /// Если не указан, то используется [animatedItemBuilder]
  final CustomAnimatedItemBuilder<T>? updateAnimatedItemBuilder;

  /// Для построения элемента списка при удалении
  /// Если не указан, то используется [animatedItemBuilder]
  final CustomAnimatedItemBuilder<T>? removeAnimatedItemBuilder;

  /// Для построения перехода
  /// Если не указан, то используется [CustomAnimatedList.defaultCustomAnimatedTransitionBuilder]
  final CustomAnimatedTransitionBuilder? animatedTransitionBuilder;

  /// Для построения перехода
  /// Если не указан, то используется [CustomAnimatedList.defaultCustomAnimatedUpdateTransitionBuilder]
  final CustomAnimatedTransitionBuilder? updateTransitionBuilder;

  /// Для построения перехода
  /// Если не указан, то используется [CustomAnimatedList.defaultCustomAnimatedTransitionBuilder]
  final CustomAnimatedTransitionBuilder? removeTransitionBuilder;

  CustomSliverAnimatedList({
    required this.animatedItemBuilder,
    this.updateAnimatedItemBuilder,
    this.removeAnimatedItemBuilder,
    this.animatedTransitionBuilder,
    this.updateTransitionBuilder,
    this.removeTransitionBuilder,
    super.key,
    required super.items,
    super.areItemsTheSame = CustomAnimatedList.defaultItemDiffUtil,
    super.insertDuration = defaultDuration,
    super.removeDuration = defaultDuration,
    super.updateDuration = defaultDuration,
    super.spawnIsolate,
  }) : super(
          itemBuilder: (context, animation, item, index) {
            final child = animatedItemBuilder.call(context, item);

            return animatedTransitionBuilder?.call(animation, child) ??
                CustomAnimatedList.defaultCustomAnimatedTransitionBuilder(animation, child);
          },
          updateItemBuilder: (context, animation, item) {
            final child = updateAnimatedItemBuilder?.call(context, item) ??
                animatedItemBuilder.call(context, item);

            return updateTransitionBuilder?.call(animation, child) ??
                animatedTransitionBuilder?.call(animation, child) ??
                CustomAnimatedList.defaultCustomAnimatedUpdateTransitionBuilder(animation, child);
          },
          removeItemBuilder: (context, animation, item) {
            final child = removeAnimatedItemBuilder?.call(context, item) ??
                animatedItemBuilder.call(context, item);

            return removeTransitionBuilder?.call(animation, child) ??
                animatedTransitionBuilder?.call(animation, child) ??
                CustomAnimatedList.defaultCustomAnimatedTransitionBuilder(animation, child);
          },
        );

  CustomSliverAnimatedList.separated({
    required this.animatedItemBuilder,
    required super.separatorBuilder,
    this.updateAnimatedItemBuilder,
    this.removeAnimatedItemBuilder,
    this.animatedTransitionBuilder,
    this.updateTransitionBuilder,
    this.removeTransitionBuilder,
    super.key,
    required super.items,
    super.areItemsTheSame = CustomAnimatedList.defaultItemDiffUtil,
    super.insertDuration = defaultDuration,
    super.removeDuration = defaultDuration,
    super.updateDuration = defaultDuration,
    super.spawnIsolate,
  }) : super.separated(
          itemBuilder: (context, animation, item, index) {
            final child = animatedItemBuilder.call(context, item);

            return animatedTransitionBuilder?.call(animation, child) ??
                CustomAnimatedList.defaultCustomAnimatedTransitionBuilder(animation, child);
          },
          updateItemBuilder: (context, animation, item) {
            final child = updateAnimatedItemBuilder?.call(context, item) ??
                animatedItemBuilder.call(context, item);

            return updateTransitionBuilder?.call(animation, child) ??
                animatedTransitionBuilder?.call(animation, child) ??
                CustomAnimatedList.defaultCustomAnimatedUpdateTransitionBuilder(animation, child);
          },
          removeItemBuilder: (context, animation, item) {
            final child = removeAnimatedItemBuilder?.call(context, item) ??
                animatedItemBuilder.call(context, item);

            return removeTransitionBuilder?.call(animation, child) ??
                animatedTransitionBuilder?.call(animation, child) ??
                CustomAnimatedList.defaultCustomAnimatedTransitionBuilder(animation, child);
          },
        );
}
