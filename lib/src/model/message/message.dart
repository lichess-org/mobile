import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/json.dart';

part 'message.freezed.dart';

@freezed
sealed class Contacts with _$Contacts {
  const Contacts._();

  const factory Contacts({
    required IList<Contact> contacts,
    required LightUser me,
    required bool isBot,
  }) = _Contacts;

  factory Contacts.fromServerJson(Map<String, dynamic> json) {
    return Contacts.fromPick(pick(json).required());
  }

  factory Contacts.fromPick(RequiredPick pick) {
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
  const factory ConversationData({
    required LightUser me,
    required bool isBot,
    required Convo convo,
  }) = _ConversationData;

  factory ConversationData.fromServerJson(Map<String, dynamic> json) {
    return ConversationData.fromPick(pick(json).required());
  }

  factory ConversationData.fromPick(RequiredPick pick) {
    return ConversationData(
      me: pick('me').asLightUserOrThrow(),
      isBot: pick('bot').asBoolOrFalse(),
      convo: pick('convo').letOrThrow((it) => Convo.fromPick(it.required())),
    );
  }
}

@freezed
sealed class Message with _$Message {
  const factory Message({required UserId userId, required String text, required DateTime date}) =
      _Message;

  factory Message.fromServerJson(Map<String, dynamic> json) {
    return Message.fromPick(pick(json).required());
  }

  factory Message.fromPick(RequiredPick pick) {
    return Message(
      userId: pick('user').asUserIdOrThrow(),
      text: pick('text').asStringOrThrow(),
      date: pick('date').asDateTimeFromMillisecondsOrThrow(),
    );
  }
}

@freezed
sealed class LastMessage with _$LastMessage {
  const factory LastMessage({
    required UserId userId,
    required String text,
    required DateTime date,
    required bool read,
  }) = _LastMessage;
}

@freezed
sealed class Contact with _$Contact {
  const factory Contact({required LightUser user, required LastMessage lastMessage}) = _Contact;

  factory Contact.fromServerJson(Map<String, dynamic> json) {
    return Contact.fromPick(pick(json).required());
  }

  factory Contact.fromPick(RequiredPick pick) {
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
  const factory Convo({
    required LightUser user,
    required IList<Message> messages,
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
