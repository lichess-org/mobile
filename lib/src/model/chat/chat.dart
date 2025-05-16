import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'chat.freezed.dart';

typedef ChatData = ({IList<ChatMessage> lines, bool writeable});

ChatData chatDataFromPick(RequiredPick pick) {
  return (
    lines: pick('lines').asListOrThrow((it) => ChatMessage.fromPick(it)).toIList(),
    writeable: pick('writeable').asBoolOrTrue(),
  );
}

@freezed
sealed class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    required String message,
    required String? username,
    required bool troll,
    required bool deleted,
    required bool patron,
    String? flair,
    String? title,
  }) = _ChatMessage;

  LightUser? get user =>
      username != null
          ? LightUser(
            id: UserId.fromUserName(username!),
            name: username!,
            title: title,
            flair: flair,
            isPatron: patron,
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
      patron: pick('p').asBoolOrNull() ?? false,
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
