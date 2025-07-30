import 'package:hh_example/common/models/task/history_tasks.dart';
import 'package:hh_example/common/utils/default_serializer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_tasks_response.freezed.dart';
part 'history_tasks_response.g.dart';

@freezed
class HistoryTasksResponse with _$HistoryTasksResponse {
  const factory HistoryTasksResponse({
    required List<GroupHistoryTasksByDate> tasks,
    required HistoryTasksPagination pagination,
  }) = _HistoryTasksResponse;

  factory HistoryTasksResponse.fromJson(Map<String, Object?> json) =>
      _$HistoryTasksResponseFromJson(json);
}

@freezed
class HistoryTasksPagination with _$HistoryTasksPagination {
  const factory HistoryTasksPagination({
    @JsonKey(fromJson: DefaultSerializer.intFromJson) required int totalCount,
    required int pageCount,
    @JsonKey(fromJson: DefaultSerializer.intFromJson) required int currentPage,
    @JsonKey(fromJson: DefaultSerializer.intFromJson) required int pageSize,
    @JsonKey(name: 'next_page') required String? nextPage,
  }) = _HistoryTasksPagination;

  factory HistoryTasksPagination.fromJson(Map<String, Object?> json) =>
      _$HistoryTasksPaginationFromJson(json);
}
