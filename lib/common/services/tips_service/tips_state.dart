import 'package:freezed_annotation/freezed_annotation.dart';

part 'tips_state.freezed.dart';

@freezed
class TipsState with _$TipsState {
  const TipsState._();

  const factory TipsState.main(TipsData data) = TipsStateMain;

  const factory TipsState.acceptedSuccess() = TipsStateAcceptedSuccess;
}

@freezed
class TipsData with _$TipsData {
  const TipsData._();

  const factory TipsData({
    @Default(0.0) double tips,
    @Default(false) bool loading,
  }) = _TipsData;

  bool get hasNewTips => tips > 0;
}
