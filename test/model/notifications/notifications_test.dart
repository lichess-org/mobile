import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:mocktail/mocktail.dart';

/// Broadcast notifications carry their title and body from the server, so they never read from
/// [AppLocalizations].
class MockAppLocalizations() extends Mock implements AppLocalizations;

/// Builds a broadcast FCM message as lila sends it.
///
/// See `modules/relay/src/main/RelayNotifier.scala`: the URL is the relative round path
/// `/broadcast/<tourSlug>/<roundSlug>/<roundId>`, with the chapter id appended and a `pov` query
/// parameter added when a followed player starts a game.
PushMessage broadcastMessage(String? url) => PushMessage(
  data: {'lichess.type': 'broadcast', 'lichess.url': ?url},
  notification: const PushNotification(title: 'Tata Steel Masters', body: 'Round 3 has begun'),
);

void main() {
  group('Broadcast FCM message parsing:', () {
    test('a round path is parsed as a round message', () {
      final message = ParsedPushMessage.fromPushMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L'),
      );

      expect(
        message,
        isA<BroadcastRoundPushMessage>().having(
          (m) => m.roundId,
          'roundId',
          const BroadcastRoundId('RAIoMC7L'),
        ),
      );
    });

    test('a round path with a dash as round slug is parsed as a round message', () {
      // lila substitutes '-' for the round slug when it is the same as the tournament slug.
      final message = ParsedPushMessage.fromPushMessage(
        broadcastMessage('/broadcast/tata-steel-masters/-/RAIoMC7L'),
      );

      expect(
        message,
        isA<BroadcastRoundPushMessage>().having(
          (m) => m.roundId,
          'roundId',
          const BroadcastRoundId('RAIoMC7L'),
        ),
      );
    });

    test('an absolute round URL is parsed as a round message', () {
      final message = ParsedPushMessage.fromPushMessage(
        broadcastMessage('https://lichess.org/broadcast/tata-steel-masters/round-3/RAIoMC7L'),
      );

      expect(
        message,
        isA<BroadcastRoundPushMessage>().having(
          (m) => m.roundId,
          'roundId',
          const BroadcastRoundId('RAIoMC7L'),
        ),
      );
    });

    test('a game path with a pov is parsed as a player follow message', () {
      for (final pov in Side.values) {
        final message = ParsedPushMessage.fromPushMessage(
          broadcastMessage(
            '/broadcast/tata-steel-masters/round-3/RAIoMC7L/G2LUflKg?pov=${pov.name}',
          ),
        );

        expect(
          message,
          isA<BroadcastPlayerFollowPushMessage>()
              .having((m) => m.roundId, 'roundId', const BroadcastRoundId('RAIoMC7L'))
              .having((m) => m.gameId, 'gameId', const BroadcastGameId('G2LUflKg'))
              .having((m) => m.pov, 'pov', pov),
        );
      }
    });

    test('a game path without a pov is malformed', () {
      final message = ParsedPushMessage.fromPushMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L/G2LUflKg'),
      );

      expect(message, isA<MalformedPushMessage>());
    });

    test('a game path with an unknown pov is malformed', () {
      final message = ParsedPushMessage.fromPushMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L/G2LUflKg?pov=green'),
      );

      expect(message, isA<MalformedPushMessage>());
    });

    test('a path with too few segments is malformed', () {
      final message = ParsedPushMessage.fromPushMessage(
        broadcastMessage('/broadcast/tata-steel-masters'),
      );

      expect(message, isA<MalformedPushMessage>());
    });

    test('a message without a URL is malformed', () {
      expect(
        ParsedPushMessage.fromPushMessage(broadcastMessage(null)),
        isA<MalformedPushMessage>(),
      );
    });

    test('a title and body are taken from the notification', () {
      final message = ParsedPushMessage.fromPushMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L'),
      );

      final notification = BroadcastRoundNotification.fromPushMessage(
        message as BroadcastRoundPushMessage,
      );

      expect(notification.title(MockAppLocalizations()), 'Tata Steel Masters');
      expect(notification.body(MockAppLocalizations()), 'Round 3 has begun');
    });
  });

  group('Broadcast notification payload:', () {
    test('a round notification round trips through its payload', () {
      const notification = BroadcastRoundNotification(
        BroadcastRoundId('RAIoMC7L'),
        'Tata Steel Masters',
        'Round 3 has begun',
      );

      final decoded = LocalNotification.fromJson(
        jsonDecode(jsonEncode(notification.payload)) as Map<String, dynamic>,
      );

      expect(
        decoded,
        isA<BroadcastRoundNotification>()
            .having((n) => n.roundId, 'roundId', const BroadcastRoundId('RAIoMC7L'))
            .having((n) => n.id, 'id', notification.id),
      );
      expect(decoded.payload, notification.payload);
    });

    test('a player follow notification round trips through its payload', () {
      const notification = BroadcastPlayerFollowNotification(
        BroadcastRoundId('RAIoMC7L'),
        BroadcastGameId('G2LUflKg'),
        Side.black,
        'Tata Steel Masters',
        'Gukesh D is playing against Praggnanandhaa R in Round 3',
      );

      final decoded = LocalNotification.fromJson(
        jsonDecode(jsonEncode(notification.payload)) as Map<String, dynamic>,
      );

      expect(
        decoded,
        isA<BroadcastPlayerFollowNotification>()
            .having((n) => n.roundId, 'roundId', const BroadcastRoundId('RAIoMC7L'))
            .having((n) => n.gameId, 'gameId', const BroadcastGameId('G2LUflKg'))
            .having((n) => n.pov, 'pov', Side.black)
            .having((n) => n.id, 'id', notification.id),
      );
      expect(decoded.payload, notification.payload);
    });

    test('both broadcast notifications share the android channel', () {
      const round = BroadcastRoundNotification(BroadcastRoundId('RAIoMC7L'), 'title', 'body');
      const playerFollow = BroadcastPlayerFollowNotification(
        BroadcastRoundId('RAIoMC7L'),
        BroadcastGameId('G2LUflKg'),
        Side.white,
        'title',
        'body',
      );

      expect(round.channelId, playerFollow.channelId);
      // ...but are distinguished when reconstructed from their payload.
      expect(round.payloadType, isNot(playerFollow.payloadType));
    });
  });

  group('FCM message to local notification mapping:', () {
    final displayable = <(PushMessage, Type)>[
      (
        const PushMessage(data: {'lichess.type': 'newMessage', 'lichess.threadId': 'thethread'}),
        NewMessageNotification,
      ),
      (
        const PushMessage(data: {'lichess.type': 'gameMove', 'lichess.fullId': '9wlmxmibr9gh'}),
        CorresGameUpdateNotification,
      ),
      (
        const PushMessage(
          data: {'lichess.type': 'challengeCreate', 'lichess.challengeId': 'challenging'},
        ),
        ChallengeCreatedNotification,
      ),
      (
        const PushMessage(
          data: {
            'lichess.type': 'challengeAccept',
            'lichess.challengeId': 'challenging',
            'lichess.fullId': '9wlmxmibr9gh',
          },
        ),
        ChallengeAcceptedNotification,
      ),
      (
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L'),
        BroadcastRoundNotification,
      ),
      (
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L/G2LUflKg?pov=white'),
        BroadcastPlayerFollowNotification,
      ),
      (
        const PushMessage(data: {'lichess.type': 'recap', 'lichess.year': '2025'}),
        RecapNotification,
      ),
    ];

    test('each displayable message maps to its local notification', () {
      for (final (message, expectedType) in displayable) {
        expect(
          ParsedPushMessage.fromPushMessage(message).toLocalNotification().runtimeType,
          expectedType,
          reason: 'for $message',
        );
      }
    });

    test('unhandled and malformed messages have no local notification', () {
      final messages = <ParsedPushMessage>[
        ParsedPushMessage.fromPushMessage(const PushMessage(data: {'lichess.type': 'unknown'})),
        ParsedPushMessage.fromPushMessage(const PushMessage(data: {})),
        // a correspondence update without a game id cannot be parsed
        ParsedPushMessage.fromPushMessage(const PushMessage(data: {'lichess.type': 'gameMove'})),
      ];

      for (final message in messages) {
        expect(message.toLocalNotification(), isNull, reason: 'for $message');
      }
    });
  });
}
