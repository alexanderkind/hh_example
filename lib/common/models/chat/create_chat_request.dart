import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_request.freezed.dart';
part 'create_chat_request.g.dart';

@freezed
class CreateChatRequest with _$CreateChatRequest {
  const CreateChatRequest._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CreateChatRequest({
    required int receiverId,
    @Default(false) bool isPartner,
  }) = _CreateChatRequest;

  factory CreateChatRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRequestFromJson(json);
}
