import 'package:hh_example/common/di/infra_module.dart';
import 'package:hh_example/common/logs/logs.dart';
import 'package:hh_example/common/providers/task/tasks_abstraction.dart';
import 'package:hh_example/common/providers/task/tasks_provider.dart';
import 'package:hh_example/common/providers/tip/tips_abstraction.dart';
import 'package:hh_example/common/providers/tip/tips_provider.dart';
import 'package:hh_example/common/services/notification_service/notification_notifier.dart';
import 'package:hh_example/common/services/tips_service/tips_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tips_service.g.dart';

@riverpod
class TipsService extends _$TipsService {
  ITips get _tips => ref.read(tipsProvider);

  ITasks get _tasks => ref.watch(tasksProvider);

  Logs get _logs => ref.read(loggerProvider);

  var _data = const TipsData();

  @override
  TipsState build() {
    /// Ожидание уведомления по чаевым
    ref.listen(notificationNotifierProvider.select((value) => value.data), (p, n) {
      if (p != n) {
        n?.whenOrNull(
          tipTransfer: updateTips,
        );
      }
    });

    return TipsState.main(_data);
  }

  /// Обновить чаевые
  Future<void> updateTips({bool updateTasks = true}) async {
    double? tips;
    try {
      tips = (await _tips.getTipAmount()).tip;
      if (updateTasks) {
        await _tasks.getGroupsTasksByDate();
      }
    } catch (e, s) {
      _logs.e(e, e, s);
    }

    _data = _data.copyWith(tips: tips ?? 0.0);
    _setMainState();
  }

  /// Принять чаевые
  Future<void> acceptTips() async {
    _data = _data.copyWith(loading: true);
    _setMainState();
    try {
      await _tips.acceptTip();

      updateTips();
      _setAcceptedSuccessState();
    } catch (e, s) {
      _logs.e(e, e, s);
    }
    _data = _data.copyWith(loading: false);
    _setMainState();
  }

  void _setMainState() => state = TipsState.main(_data);

  void _setAcceptedSuccessState() => state = const TipsState.acceptedSuccess();
}
