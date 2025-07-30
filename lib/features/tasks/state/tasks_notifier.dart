import 'dart:async';

import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/providers/task/tasks_abstraction.dart';
import 'package:hh_example/common/providers/task/tasks_provider.dart';
import 'package:hh_example/common/services/analytics/analytics_event.dart';
import 'package:hh_example/common/utils/extensions/analytics/ref_analytics.dart';
import 'package:hh_example/common/utils/extensions/date_extensions.dart';
import 'package:hh_example/common/utils/extensions/ref_keep_providers_extension.dart';
import 'package:hh_example/features/tasks/state/tasks_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_notifier.g.dart';

@riverpod
class TasksNotifier extends _$TasksNotifier {
  ITasks get _tasksProvider => ref.read(tasksProvider);

  Logs get _logs => ref.read(loggerProvider);

  late final StreamSubscription<List<GroupTasksByDate>> _taskSubs;
  var _data = const TasksData(loading: true);
  final fakeDates = [DateTime.now(), DateTime.now(), DateTime.now()];
  final fakeTasks = [Task.fake(), Task.fake(), Task.fake()];

  @override
  TasksState build() {
    ref.keepProvider(tasksProvider);

    /// Подписка на обновление задач
    _taskSubs = _tasksProvider.tasksStream.listen(_updateGroups);

    ref.onDispose(() {
      _taskSubs.cancel();
    });

    return TasksState.main(_data);
  }

  /// Получение первоначальных данных
  Future<void> init() async {
    _data = _data.copyWith(loading: true);
    _setMainState();

    try {
      final groups = await _getGroups();

      _data = _data.changeGroups(groups);
      _logAnalyticEvent();
    } catch (e, s) {
      _logs.e(e, e, s);
    }

    _data = _data.copyWith(loading: false);
    _setMainState();
  }

  /// Выбор даты
  void selectDate(DateTime dateTime) {
    _data = _data.copyWith(selectedDate: dateTime);
    _logAnalyticEvent();
    _setMainState();
  }

  /// Отправка события в аналитику
  void _logAnalyticEvent() {
    if (_data.selectedDate?.isToday == true) {
      ref.analytics.logEvent(AnalyticsEvent.orderListViewToday(_data.selectedTasksCount));
    } else if (_data.selectedDate?.isTomorrow == true) {
      ref.analytics.logEvent(AnalyticsEvent.orderListViewTomorrow(_data.selectedTasksCount));
    }
  }

  /// Получение групп
  Future<List<GroupTasksByDate>> _getGroups() => _tasksProvider.getGroupsTasksByDate();

  void _updateGroups(List<GroupTasksByDate> groups) {
    _data = _data.changeGroups(groups);
    _setMainState();
  }

  void _setMainState() => state = TasksState.main(_data);
}
