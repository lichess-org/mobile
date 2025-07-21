import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_repository.g.dart';

@Riverpod(keepAlive: true)
MessageRepository messageRepository(Ref ref) {
  return MessageRepository(ref.read(lichessClientProvider));
}

class MessageRepository {
  const MessageRepository(this.client);

  final LichessClient client;

  Future<IList<Contact>> loadContacts() {
    return client.readJson(
      Uri(path: '/inbox'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) =>
          pick(json).required()('contacts').asListOrEmpty((it) => Contact.fromPick(it)).toIList(),
    );
  }

  Future<ConversationData> loadConvo(UserId userId) {
    return client.readJson(
      Uri(path: '/inbox/$userId'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => ConversationData.fromServerJson(json),
    );
  }

  Future<ConversationData> getMore(UserId userId, DateTime before) {
    return client.readJson(
      Uri(path: '/inbox/$userId', queryParameters: {'before': before.millisecondsSinceEpoch}),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => ConversationData.fromServerJson(json),
    );
  }
}
