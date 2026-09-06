import 'dart:convert';

import 'package:dartchess/dartchess.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/notifications/notifications.dart';
import 'package:mocktail/mocktail.dart';

/// Broadcast notifications carry their title and body from the server, so they never read from
/// [AppLocalizations].
class MockAppLocalizations extends Mock implements AppLocalizations {}

/// Builds a broadcast FCM message as lila sends it.
///
/// See `modules/relay/src/main/RelayNotifier.scala`: the URL is the relative round path
/// `/broadcast/<tourSlug>/<roundSlug>/<roundId>`, with the chapter id appended and a `pov` query
/// parameter added when a followed player starts a game.
RemoteMessage broadcastMessage(String? url) => RemoteMessage(
  data: {'lichess.type': 'broadcast', if (url != null) 'lichess.url': url},
  notification: const RemoteNotification(title: 'Tata Steel Masters', body: 'Round 3 has begun'),
);

void main() {
  group('Broadcast FCM message parsing:', () {
    test('a round path is parsed as a round message', () {
      final message = FcmMessage.fromRemoteMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L'),
      );

      expect(
        message,
        isA<BroadcastRoundFcmMessage>().having(
          (m) => m.roundId,
          'roundId',
          const BroadcastRoundId('RAIoMC7L'),
        ),
      );
    });

    test('a round path with a dash as round slug is parsed as a round message', () {
      // lila substitutes '-' for the round slug when it is the same as the tournament slug.
      final message = FcmMessage.fromRemoteMessage(
        broadcastMessage('/broadcast/tata-steel-masters/-/RAIoMC7L'),
      );

      expect(
        message,
        isA<BroadcastRoundFcmMessage>().having(
          (m) => m.roundId,
          'roundId',
          const BroadcastRoundId('RAIoMC7L'),
        ),
      );
    });

    test('an absolute round URL is parsed as a round message', () {
      final message = FcmMessage.fromRemoteMessage(
        broadcastMessage('https://lichess.org/broadcast/tata-steel-masters/round-3/RAIoMC7L'),
      );

      expect(
        message,
        isA<BroadcastRoundFcmMessage>().having(
          (m) => m.roundId,
          'roundId',
          const BroadcastRoundId('RAIoMC7L'),
        ),
      );
    });

    test('a game path with a pov is parsed as a player follow message', () {
      for (final pov in Side.values) {
        final message = FcmMessage.fromRemoteMessage(
          broadcastMessage(
            '/broadcast/tata-steel-masters/round-3/RAIoMC7L/G2LUflKg?pov=${pov.name}',
          ),
        );

        expect(
          message,
          isA<BroadcastPlayerFollowFcmMessage>()
              .having((m) => m.roundId, 'roundId', const BroadcastRoundId('RAIoMC7L'))
              .having((m) => m.gameId, 'gameId', const BroadcastGameId('G2LUflKg'))
              .having((m) => m.pov, 'pov', pov),
        );
      }
    });

    test('a game path without a pov is malformed', () {
      final message = FcmMessage.fromRemoteMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L/G2LUflKg'),
      );

      expect(message, isA<MalformedFcmMessage>());
    });

    test('a game path with an unknown pov is malformed', () {
      final message = FcmMessage.fromRemoteMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L/G2LUflKg?pov=green'),
      );

      expect(message, isA<MalformedFcmMessage>());
    });

    test('a path with too few segments is malformed', () {
      final message = FcmMessage.fromRemoteMessage(
        broadcastMessage('/broadcast/tata-steel-masters'),
      );

      expect(message, isA<MalformedFcmMessage>());
    });

    test('a message without a URL is malformed', () {
      expect(FcmMessage.fromRemoteMessage(broadcastMessage(null)), isA<MalformedFcmMessage>());
    });

    test('a title and body are taken from the notification', () {
      final message = FcmMessage.fromRemoteMessage(
        broadcastMessage('/broadcast/tata-steel-masters/round-3/RAIoMC7L'),
      );

      final notification = BroadcastRoundNotification.fromFcmMessage(
        message as BroadcastRoundFcmMessage,
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
}
