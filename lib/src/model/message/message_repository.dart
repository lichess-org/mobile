import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_repository.g.dart';

@riverpod
Future<Contacts> contacts(Ref ref) {
  // We call this each time the account drawer is opened, so let's cache it for a short while.
  return ref.withClientCacheFor(
    (client) => MessageRepository(client).loadContacts(),
    const Duration(minutes: 5),
  );
}

@Riverpod(keepAlive: true)
MessageRepository messageRepository(Ref ref) {
  return MessageRepository(ref.read(lichessClientProvider));
}

class MessageRepository {
  const MessageRepository(this.client);

  final LichessClient client;

  Future<Contacts> loadContacts() {
    return client.readJson(
      Uri(path: '/inbox'),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => Contacts.fromServerJson(json),
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
      Uri(
        path: '/inbox/$userId',
        queryParameters: {'before': before.millisecondsSinceEpoch.toString()},
      ),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => ConversationData.fromServerJson(json),
    );
  }

  Future<SearchResult> search(String query) {
    return client.readJson(
      Uri(path: '/inbox/search', queryParameters: {'q': query}),
      headers: {'Accept': 'application/json'},
      mapper: (Map<String, dynamic> json) => SearchResult.fromJson(json),
    );
  }
}
