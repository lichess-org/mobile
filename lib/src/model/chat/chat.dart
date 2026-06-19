import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/tv/tv_game_controller.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'chat.freezed.dart';

typedef ChatData = ({IList<ChatMessage> lines, bool writeable});

ChatData chatDataFromPick(RequiredPick pick) {
  return (
    lines: pick('lines').asListOrThrow((it) => ChatMessage.fromPick(it)).toIList(),
    writeable: pick('writeable').asBoolOrTrue(),
  );
}

@immutable
sealed class ChatOptions {
  const ChatOptions();

  StringId get id;
  LightUser? get opponent;
  bool get isPublic;
  bool get writeable;

  @override
  String toString() =>
      'ChatOptions(id: $id, opponent: $opponent, isPublic: $isPublic, writeable: $writeable)';
}

@freezed
abstract class GameChatOptions extends ChatOptions with _$GameChatOptions {
  const GameChatOptions._();
  const factory GameChatOptions({required GameFullId id, required LightUser? opponent}) =
      _GameChatOptions;

  @override
  bool get isPublic => false;

  @override
  bool get writeable => true;
}

@freezed
abstract class TvChatOptions extends ChatOptions with _$TvChatOptions {
  const TvChatOptions._();
  const factory TvChatOptions(TvGameControllerParams params, {required bool writeable}) =
      _TvChatOptions;

  @override
  GameId get id => params.gameId;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;
}

@freezed
abstract class TournamentChatOptions extends ChatOptions with _$TournamentChatOptions {
  const TournamentChatOptions._();
  const factory TournamentChatOptions({required TournamentId id, required bool writeable}) =
      _TournamentChatOptions;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;
}

@freezed
abstract class StudyChatOptions extends ChatOptions with _$StudyChatOptions {
  const StudyChatOptions._();
  const factory StudyChatOptions({required StudyOptions options, required bool writeable}) =
      _StudyChatOptions;

  @override
  LightUser? get opponent => null;

  @override
  bool get isPublic => true;

  @override
  StringId get id => options.id;
}

@freezed
sealed class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    required String message,
    required String? username,
    required bool troll,
    required bool deleted,
    int? patronColor,
    String? flair,
    String? title,
  }) = _ChatMessage;

  LightUser? get user => username != null
      ? LightUser(
          id: UserId.fromUserName(username!),
          name: username!,
          title: title,
          flair: flair,
          patronColor: patronColor,
        )
      : null;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      ChatMessage.fromPick(pick(json).required());

  factory ChatMessage.fromPick(RequiredPick pick) {
    return ChatMessage(
      message: pick('t').asStringOrThrow(),
      username: pick('u').asStringOrNull(),
      troll: pick('r').asBoolOrNull() ?? false,
      deleted: pick('d').asBoolOrNull() ?? false,
      patronColor: pick('pc').asIntOrNull(),
      flair: pick('f').asStringOrNull(),
      title: pick('title').asStringOrNull(),
    );
  }

  bool get isSpam => spamRegex.hasMatch(message) || followMeRegex.hasMatch(message);
}

final RegExp spamRegex = RegExp(
  [
    'xcamweb.com',
    '(^|[^i])chess-bot',
    'chess-cheat',
    'coolteenbitch',
    'letcafa.webcam',
    'tinyurl.com/',
    'wooga.info/',
    'bit.ly/',
    'wbt.link/',
    'eb.by/',
    '001.rs/',
    'shr.name/',
    'u.to/',
    '.3-a.net',
    '.ssl443.org',
    '.ns02.us',
    '.myftp.info',
    '.flinkup.com',
    '.serveusers.com',
    'badoogirls.com',
    'hide.su',
    'wyon.de',
    'sexdatingcz.club',
    'qps.ru',
    'tiny.cc/',
    'trasderk.blogspot.com',
    't.ly/',
    'shorturl.at/',
  ].map((url) => url.replaceAll('.', '\\.').replaceAll('/', '\\/')).join('|'),
);

final followMeRegex = RegExp('follow me|join my team', caseSensitive: false);
