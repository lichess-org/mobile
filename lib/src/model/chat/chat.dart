import 'package:deep_pick/deep_pick.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@Freezed(fromJson: true)
class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    @JsonKey(name: 'u') required String username,
    @JsonKey(name: 't') required String message,
    @JsonKey(name: 'f') required String? flair,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, Object?> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.fromPick(RequiredPick pick) =>
      ChatMessage.fromJson(pick.asMapOrThrow());
}
