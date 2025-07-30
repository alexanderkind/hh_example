import 'package:hh_example/common/models/task_status/task_statuses.dart';
import 'package:hh_example/common/utils/default_serializer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_update_request.freezed.dart';
part 'task_update_request.g.dart';

@freezed
class TaskUpdateRequest with _$TaskUpdateRequest {
  const TaskUpdateRequest._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TaskUpdateRequest({
    @JsonKey(name: 'identificator') required int transferId,
    @JsonKey(toJson: TaskStatus.toJson) required TaskStatus status,
    @Default(false) @JsonKey(toJson: DefaultSerializer.boolToInt) bool clientOnBoard,
    @Default(false) @JsonKey(toJson: DefaultSerializer.boolToInt) bool clientNoShow,
    @Default(false) @JsonKey(toJson: DefaultSerializer.boolToInt) bool driverToPickUp,
    @Default(false) @JsonKey(toJson: DefaultSerializer.boolToInt) bool driverWaiting,
    @JsonKey(toJson: DefaultSerializer.doubleToString) required double currentLat,
    @JsonKey(toJson: DefaultSerializer.doubleToString) required double currentLng,
    @Default('') String source,
  }) = _TaskUpdateRequest;

  factory TaskUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$TaskUpdateRequestFromJson(json);
}
