import 'package:hh_example/common/config/endpoints.dart';
import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/models/task/history_tasks_response.dart';
import 'package:hh_example/common/models/task/task_driver_order_response.dart';
import 'package:hh_example/common/models/task/task_update_request.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/models/task/tasks_response.dart';
import 'package:hh_example/common/network/api_client.dart';
import 'package:hh_example/common/providers/task/tasks_abstraction.dart';
import 'package:hh_example/common/services/json_decode_service.dart';
import 'package:hh_example/common/utils/extensions/package_info_extension.dart';
import 'package:async_task/async_task_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_provider.g.dart';

@riverpod
ITasks tasks(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final endpoints = ref.watch(endpointsProvider);
  final jsonDecode = ref.watch(jsonDecodeServiceProvider);
  final packageInfo = ref.watch(packageInfoProvider);

  final tasks = TasksProvider(
    api: api,
    endpoints: endpoints,
    jsonDecode: jsonDecode,
    packageInfo: packageInfo,
  );

  ref.onDispose(tasks.dispose);

  return tasks;
}

class TasksProvider implements ITasks {
  final ApiClient _api;
  final Endpoints _endpoints;
  final JsonDecodeService _jsonDecode;
  final PackageInfo _packageInfo;

  final _groups = <GroupTasksByDate>[];
  final _tasksStreamController = StreamController<List<GroupTasksByDate>>.broadcast();

  TasksProvider({
    required ApiClient api,
    required Endpoints endpoints,
    required JsonDecodeService jsonDecode,
    required PackageInfo packageInfo,
  })  : _api = api,
        _endpoints = endpoints,
        _jsonDecode = jsonDecode,
        _packageInfo = packageInfo;

  @override
  Stream<List<GroupTasksByDate>> get tasksStream => _tasksStreamController.stream;

  @override
  Future<List<GroupTasksByDate>> getGroupsTasksByDate() async {
    final response = await _api.client.get(_endpoints.tasks.getTasks);

    final result = await _jsonDecode.run<TasksResponse>(
      jsonDecoder: (data) {
        if (data is Iterable) return const TasksResponse(data: []);
        return TasksResponse.fromJson(data);
      },
      data: response.data,
    );

    _updateGroups(result.data);

    return _groups;
  }

  @override
  Future<Task?> getTaskByTransferId(int id) async {
    for (final g in _groups) {
      final task =
          g.tasks.where((task) => task.data.any((transfer) => transfer.id == id)).firstOrNull;

      if (task != null) {
        return task;
      }
    }

    return null;
  }

  @override
  Future<Task?> updateTask(TaskUpdateRequest data) async {
    data = data.copyWith(source: _packageInfo.appNameAndVersion);

    final response = await _api.client.post(
      _endpoints.tasks.taskUpdate,
      data: data.toJson(),
    );

    final result = await _jsonDecode.run<TasksResponse>(
      jsonDecoder: (data) {
        return TasksResponse.fromJson(data);
      },
      data: response.data,
    );

    _updateGroups(result.data);

    return getTaskByTransferId(data.transferId);
  }

  @override
  Future<HistoryTasksResponse> getGroupsHistoryTasksByDate({
    int? pageNumber,
  }) async {
    final queryParameters = <String, dynamic>{
      if (pageNumber != null) 'page': pageNumber,
      'sort': 'desc',
    };

    final response = await _api.client.get(
      _endpoints.tasks.getHistoryTasks,
      queryParameters: queryParameters,
    );

    final result = await _jsonDecode.run<HistoryTasksResponse>(
      jsonDecoder: (data) {
        return HistoryTasksResponse.fromJson(data);
      },
      data: response.data,
    );

    return result;
  }

  @override
  Future<TaskDriverOrderResponse> getBonDeCommande({
    int? taskId,
  }) async {
    final response = await _api.client.get(
      _endpoints.tasks.getBonDeCommande,
      queryParameters: {
        'task_id': taskId,
      },
    );

    final result = await _jsonDecode.run<TaskDriverOrderResponse>(
      jsonDecoder: (data) {
        if (data is Iterable) return const TaskDriverOrderResponse();
        return TaskDriverOrderResponse.fromJson(data);
      },
      data: response.data,
    );

    return result;
  }

  void _updateGroups(List<GroupTasksByDate> groups) {
    _groups.clear();
    _groups.addAll(groups);

    _tasksStreamController.add(_groups);
  }

  Future<void> dispose() => _tasksStreamController.close();
}
