import 'dart:math';

import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/utils/extensions/date_extensions.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks_state.freezed.dart';

@freezed
class TasksState with _$TasksState {
  const TasksState._();

  const factory TasksState.main(TasksData data) = TasksDataMain;
}

@freezed
class TasksData with _$TasksData {
  const TasksData._();

  const factory TasksData({
    @Default(null) DateTime? selectedDate,
    @Default([]) List<DateTime> dates,
    @Default([]) List<GroupTasksByDate> groups,
    @Default(false) bool loading,
  }) = _TasksData;

  /// Изменение данных в зависимости от списка групп
  TasksData changeGroups(List<GroupTasksByDate> groups) {
    late DateTime first;

    if (groups.isNotEmpty) {
      first = groups.first.date;
    } else {
      final now = DateTime.now();
      first = DateTime(now.year, now.month, now.day);
    }
    final dates = List.generate(max(3, groups.length), (index) => first.add(Duration(days: index)));

    DateTime? newSelectedDate;
    if (selectedDate == null || !dates.contains(selectedDate)) {
      newSelectedDate = first;
    } else {
      newSelectedDate = selectedDate;
    }

    return copyWith(
      selectedDate: newSelectedDate,
      dates: dates,
      groups: groups,
    );
  }

  /// Выбранная группа
  GroupTasksByDate? get selectedGroup => groups
      .firstWhereOrNull((e) => e.date.toDefaultDateFormat() == selectedDate?.toDefaultDateFormat());

  /// Выбранные задачи
  List<Task> get selectedTasks => selectedGroup?.tasks ?? [];

  bool get isSelectedTasksNotEmpty => selectedTasks.isNotEmpty;

  /// Кол-во задач выбранной группы
  int get selectedTasksCount => selectedTasks.length;

  int get selectedBoosterSeatCount => selectedGroup?.maxBoosterSeatCount ?? 0;

  int get selectedChildSeatCount => selectedGroup?.maxChildSeatCount ?? 0;
}
