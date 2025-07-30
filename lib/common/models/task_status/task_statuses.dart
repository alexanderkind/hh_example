import 'package:hh_example/common/models/task/history_tasks.dart';
import 'package:hh_example/common/models/task/tasks.dart';
import 'package:hh_example/common/utils/default_serializer.dart';

/// Локальные статусы задачи
/// Для облегчения работы в МП
///
/// [notStarted] - Не начата
/// [onRoute] - Водитель в пути
/// [arrived] - Водитель ожидает
/// [customerOnBoard] - Клиент в машине
/// [completed] - Завершена
///
enum LocalTaskStatus {
  notStarted(2),
  onRoute(4),
  arrived(5),
  customerOnBoard(3),
  completed(1),
  unknown(0);

  static LocalTaskStatus valueByHistoryTask(HistoryTask task) {
    final taskStatus = task.status;

    return switch (taskStatus) {
      TaskStatus.newStatus => notStarted,
      TaskStatus.started => customerOnBoard,
      TaskStatus.finished => completed,
      _ => unknown
    };
  }

  static LocalTaskStatus valueByTask(Task task) {
    final taskStatus = task.status;

    final statuses = task.data.map((e) => valueByTransfer(e, taskStatus: taskStatus)).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));

    return statuses.last;
  }

  static LocalTaskStatus valueByTransfer(Transfer transfer, {TaskStatus? taskStatus}) {
    taskStatus ??= transfer.status;

    if (transfer.status == TaskStatus.finished) {
      return LocalTaskStatus.completed;
    }

    if (transfer.clientOnBoard) {
      return customerOnBoard;
    } else if (transfer.driverWaiting) {
      return arrived;
    } else if (transfer.driverToPickUp) {
      return onRoute;
    }

    return switch (taskStatus) {
      TaskStatus.newStatus || TaskStatus.opened => notStarted,
      _ => unknown
    };
  }

  /// Приоритет при определении статуса задания
  final int priority;

  const LocalTaskStatus(this.priority);
}

/// Статусы задач (трансферов)
/// [newStatus] - Новая задача (по умолчанию)
/// [opened] - Имеет несколько значений
/// * Водитель просмотрел задание
/// * Водитель едет к точке pick-up
/// * Водитель ждёт пассажира на точке pick-up
/// [started] - Водитель посадил пассажина в машину
/// [finished] - Пассажир доставлен в точку drop-off
/// [penalized] - Нельзя использовать
enum TaskStatus {
  newStatus(0),
  opened(1),
  started(2),
  finished(3),
  penalized(-1);

  static int toJson(TaskStatus val) => val.id;

  static TaskStatus fromJson(dynamic data) =>
      TaskStatus.values.firstWhere((e) => e.index == DefaultSerializer.intFromJson(data));

  final int id;

  const TaskStatus(this.id);
}
