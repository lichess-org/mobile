import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'message.freezed.dart';

typedef UnreadMessages = ({int unread, bool lichess});

@freezed
sealed class const Contacts._() with _$Contacts {
  const factory({required IList<Contact> contacts, required LightUser me, required bool isBot}) =
      _Contacts;

  factory fromServerJson(Map<String, dynamic> json) {
    return Contacts.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return Contacts(
      contacts: pick('contacts').asListOrEmpty((it) => Contact.fromPick(it)).toIList(),
      me: pick('me').asLightUserOrThrow(),
      isBot: pick('bot').asBoolOrFalse(),
    );
  }

  int get unreadCount {
    return contacts
        .where((contact) => !contact.lastMessage.read && contact.lastMessage.userId != me.id)
        .length;
  }
}

@freezed
sealed class ConversationData with _$ConversationData {
  const factory({required LightUser me, required bool isBot, required Convo convo}) =
      _ConversationData;

  factory fromServerJson(Map<String, dynamic> json) {
    return ConversationData.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return ConversationData(
      me: pick('me').asLightUserOrThrow(),
      isBot: pick('bot').asBoolOrFalse(),
      convo: pick('convo').letOrThrow((it) => Convo.fromPick(it.required())),
    );
  }
}

@freezed
sealed class Message with _$Message {
  const factory({required UserId userId, required String text, required DateTime date}) = _Message;

  factory fromServerJson(Map<String, dynamic> json) {
    return Message.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return Message(
      userId: pick('user').asUserIdOrThrow(),
      text: pick('text').asStringOrThrow(),
      date: pick('date').asDateTimeFromMillisecondsOrThrow(),
    );
  }
}

@freezed
sealed class LastMessage with _$LastMessage {
  const factory({
    required UserId userId,
    required String text,
    required DateTime date,
    required bool read,
  }) = _LastMessage;
}

@freezed
sealed class Contact with _$Contact {
  const factory({required LightUser user, required LastMessage lastMessage}) = _Contact;

  factory fromServerJson(Map<String, dynamic> json) {
    return Contact.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return Contact(
      user: pick('user').asLightUserOrThrow(),
      lastMessage: LastMessage(
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
  const factory({
    required LightUser user,
    required IList<Message> messages,
    required Relations relations,
    required bool postable,
    ModDetails? modDetails,
  }) = _Convo;

  factory fromServerJson(Map<String, dynamic> json) {
    return Convo.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return Convo(
      user: pick('user').asLightUserOrThrow(),
      messages: pick('msgs').asListOrThrow((it) => Message.fromPick(it)).toIList(),
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
  const factory({
    required IList<Contact> contacts,
    required IList<LightUser> friends,
    required IList<LightUser> users,
  }) = _SearchResult;

  factory fromJson(Map<String, dynamic> json) {
    return SearchResult.fromPick(pick(json).required());
  }

  factory fromPick(RequiredPick pick) {
    return SearchResult(
      contacts: pick('contacts').asListOrEmpty((it) => Contact.fromPick(it)).toIList(),
      friends: pick('friends').asListOrEmpty((it) => it.asLightUserOrThrow()).toIList(),
      users: pick('users').asListOrEmpty((it) => it.asLightUserOrThrow()).toIList(),
    );
  }
}
