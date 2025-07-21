import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'message.freezed.dart';

@freezed
sealed class MsgData with _$MsgData {
  const factory MsgData({
    required LightUser me,
    required bool isBot,
    required IList<Contact> contacts,
    Convo? convo,
  }) = _MsgData;

  factory MsgData.fromServerJson(Map<String, dynamic> json) {
    return MsgData.fromPick(pick(json).required());
  }

  factory MsgData.fromPick(RequiredPick pick) {
    return MsgData(
      me: pick('me').asLightUserOrThrow(),
      isBot: pick('bot').asBoolOrFalse(),
      contacts: pick('contacts').asListOrEmpty((it) => Contact.fromPick(it)).toIList(),
      convo: pick('convo').letOrNull((it) => Convo.fromPick(it.required())),
    );
  }
}

@freezed
sealed class Msg with _$Msg {
  const factory Msg({required UserId userId, required String text, required DateTime date}) = _Msg;

  factory Msg.fromServerJson(Map<String, dynamic> json) {
    return Msg.fromPick(pick(json).required());
  }

  factory Msg.fromPick(RequiredPick pick) {
    return Msg(
      userId: pick('user').asUserIdOrThrow(),
      text: pick('text').asStringOrThrow(),
      date: pick('date').asDateTimeFromMillisecondsOrThrow(),
    );
  }
}

@freezed
sealed class LastMsg with _$LastMsg {
  const factory LastMsg({
    required UserId userId,
    required String text,
    required DateTime date,
    required bool read,
  }) = _LastMsg;
}

@freezed
sealed class Contact with _$Contact {
  const factory Contact({required LightUser user, required LastMsg lastMsg}) = _Contact;

  factory Contact.fromServerJson(Map<String, dynamic> json) {
    return Contact.fromPick(pick(json).required());
  }

  factory Contact.fromPick(RequiredPick pick) {
    return Contact(
      user: pick('user').asLightUserOrThrow(),
      lastMsg: LastMsg(
        userId: pick('lastMsg', 'user').asUserIdOrThrow(),
        text: pick('lastMsg', 'text').asStringOrThrow(),
        date: pick('lastMsg', 'date').asDateTimeFromMillisecondsOrThrow(),
        read: pick('lastMsg', 'read').asBoolOrThrow(),
      ),
    );
  }
}

typedef Relations = ({bool? inward, bool? outward});

@freezed
sealed class Convo with _$Convo {
  const factory Convo({
    required LightUser user,
    required IList<Msg> messages,
    required Relations relations,
    required bool postable,
    ModDetails? modDetails,
  }) = _Convo;

  factory Convo.fromServerJson(Map<String, dynamic> json) {
    return Convo.fromPick(pick(json).required());
  }

  factory Convo.fromPick(RequiredPick pick) {
    return Convo(
      user: pick('user').asLightUserOrThrow(),
      messages: pick('msgs').asListOrThrow((it) => Msg.fromPick(it)).toIList(),
      relations: (inward: pick('in').asBoolOrNull(), outward: pick('out').asBoolOrNull()),
      postable: pick('postable').asBoolOrThrow(),
      modDetails: pick('modDetails').letOrNull(
        (it) => (kid: it('kid').asBoolOrThrow(), openInbox: it('openInbox').asBoolOrThrow()),
      ),
    );
  }
}

typedef ModDetails = ({bool kid, bool openInbox});

@freezed
sealed class SearchResult with _$SearchResult {
  const factory SearchResult({
    required IList<Contact> contacts,
    required IList<User> friends,
    required IList<User> users,
  }) = _SearchResult;
}

@freezed
sealed class Search with _$Search {
  const factory Search({required String input, SearchResult? result}) = _Search;
}
