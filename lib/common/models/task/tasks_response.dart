import 'package:hh_example/common/models/task/tasks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasks_response.freezed.dart';

@freezed
class TasksResponse with _$TasksResponse {
  const TasksResponse._();

  const factory TasksResponse({
    required List<GroupTasksByDate> data,
  }) = _TasksResponse;

  factory TasksResponse.fromJson(Map<String, dynamic> json) {
    final entries = json.entries;

    return TasksResponse(
      data: entries.map(GroupTasksByDate.fromMapEntry).toList(),
    );
  }

  /// Список всех задач
  List<Task> get allTasks => data.map((e) => e.tasks).fold([], (p, v) => [...p, ...v]);
}
