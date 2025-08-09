import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/message/message.dart';
import 'package:lichess_mobile/src/network/aggregator.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// A provider that gets the conversation data for the current user.
final contactsProvider = FutureProvider.autoDispose<Contacts>((ref) {
  // We call this each time the account drawer is opened, so let's cache it for a short while.
  return ref.withAggregatorCacheFor(
    (client, aggregator) => MessageRepository(client, aggregator).loadContacts(),
    const Duration(seconds: 10),
  );
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref.read(lichessClientProvider), ref.read(aggregatorProvider));
});

/// A provider that gets the unread messages count for the current user.
final unreadMessagesProvider = FutureProvider.autoDispose<UnreadMessages>((ref) {
  final aggregator = ref.watch(aggregatorProvider);
  return aggregator.readJson(
    Uri(path: '/inbox/unread-count'),
    atomicMapper: (Map<String, dynamic> json) {
      return (unread: json['unread'] as int, lichess: json['lichess'] as bool? ?? false);
    },
  );
});

class MessageRepository {
  const MessageRepository(this.client, this.aggregator);

  final LichessClient client;
  final Aggregator aggregator;

  Future<UnreadMessages> unreadMessages() {
    return aggregator.readJson(
      Uri(path: '/inbox/unread-count'),
      headers: {'Accept': 'application/json'},
      atomicMapper: (Map<String, dynamic> json) =>
          (unread: json['unread'] as int, lichess: json['lichess'] as bool? ?? false),
    );
  }

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
