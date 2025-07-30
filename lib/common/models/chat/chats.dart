import 'package:hh_example/common/models/files/file_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats.freezed.dart';
part 'chats.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const ChatModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ChatModel({
    required String uuid,
    required int customerExternalId,
    required int driverExternalId,
    @Default(0) @JsonKey() int unseen,
    required ChatModelUser customer,
    required ChatModelUser driver,
    required ChatModelMessage? last,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

  factory ChatModel.fake() => ChatModel(
        uuid: '',
        customerExternalId: 0,
        driverExternalId: 0,
        unseen: 1,
        customer: ChatModelUser.fakeDriver(),
        driver: ChatModelUser.fakeCustomer(),
        last: ChatModelMessage.fakeDriver(),
      );
}

@freezed
class ChatModelUser with _$ChatModelUser {
  const ChatModelUser._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ChatModelUser({
    required String uuid,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String email,
    @Default('') String phone,
    FileModel? avatar,
  }) = _User;

  factory ChatModelUser.fromJson(Map<String, dynamic> json) => _$ChatModelUserFromJson(json);

  factory ChatModelUser.fakeDriver() => const ChatModelUser(
        uuid: '1',
        firstName: 'Hdjfh',
        lastName: 'Ghfjghfd',
      );

  factory ChatModelUser.fakeCustomer() => const ChatModelUser(
        uuid: '2',
        firstName: 'Jdjhdsjh',
        lastName: 'Flashgun',
      );

  String get fullName => '${firstName.trim()} ${lastName.trim()}'.trim();
}

@freezed
class ChatModelMessage with _$ChatModelMessage {
  const ChatModelMessage._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ChatModelMessage({
    required String room,
    required String uuid,
    required String sender,
    required String reverse,
    @Default('') String body,
    @Default(false) bool seen,
    FileModel? attachment,
    required DateTime createdAt,
  }) = _ChatModelMessage;

  factory ChatModelMessage.fromJson(Map<String, dynamic> json) => _$ChatModelMessageFromJson(json);

  factory ChatModelMessage.fakeDriver() => ChatModelMessage(
        room: '',
        uuid: '',
        sender: '1',
        reverse: '',
        body: '123123 123 127474 377373',
        createdAt: DateTime(2024),
      );

  factory ChatModelMessage.fakeCustomer() =>
      ChatModelMessage.fakeDriver().copyWith(sender: '2', body: '2374567 654737256 236');

  String get bodyByType => attachment != null ? 'Image' : body;
}
