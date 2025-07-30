import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/utils/default_serializer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_tasks.freezed.dart';
part 'history_tasks.g.dart';

@freezed
class GroupHistoryTasksByDate with _$GroupHistoryTasksByDate {
  const GroupHistoryTasksByDate._();

  const factory GroupHistoryTasksByDate({
    required DateTime date,
    required List<HistoryTask> entries,
  }) = _GroupHistoryTasksByDate;

  factory GroupHistoryTasksByDate.fromJson(Map<String, Object?> json) =>
      _$GroupHistoryTasksByDateFromJson(json);
}

@freezed
class HistoryTask with _$HistoryTask {
  const HistoryTask._();

  const factory HistoryTask({
    required DateTime datetime,
    @Default(TaskStatus.newStatus)
    @JsonKey(fromJson: TaskStatus.fromJson, toJson: TaskStatus.toJson)
    TaskStatus status,
    required String pickupLocation,
    @JsonKey(name: 'dropoffLocation') required String dropOffLocation,
    @JsonKey(fromJson: DefaultSerializer.doubleFromJson) required double driverSalary,
    required int passengerCount,
    required int childSeatCount,
    required int boosterSeatCount,
    required bool hasSkis,
    @JsonKey(fromJson: DefaultSerializer.doubleFromJsonNullable) double? tipEuroAmount,
  }) = _HistoryTask;

  factory HistoryTask.fromJson(Map<String, Object?> json) => _$HistoryTaskFromJson(json);

  LocalTaskStatus get localStatus => LocalTaskStatus.valueByHistoryTask(this);
}
