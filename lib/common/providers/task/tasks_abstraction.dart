import 'dart:async';

import 'package:hh_example/common/models/task/history_tasks_response.dart';
import 'package:hh_example/common/models/task/task_driver_order_response.dart';
import 'package:hh_example/common/models/task/task_update_request.dart';
import 'package:hh_example/common/models/task/tasks.dart';

abstract interface class ITasks {
  Stream<List<GroupTasksByDate>> get tasksStream;

  Future<List<GroupTasksByDate>> getGroupsTasksByDate();

  Future<Task?> getTaskByTransferId(int id);

  Future<Task?> updateTask(TaskUpdateRequest data);

  Future<HistoryTasksResponse> getGroupsHistoryTasksByDate({
    int? pageNumber,
  });

  Future<TaskDriverOrderResponse> getBonDeCommande({
    int? taskId,
  });
}
