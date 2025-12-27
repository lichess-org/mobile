import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/socket.dart';

/// The [LobbyNumbers] provider is used to display the number of players and
/// games on lichess in real time.
final lobbyNumbersProvider =
    NotifierProvider.autoDispose<LobbyNumbers, ({int nbPlayers, int nbGames})?>(
      LobbyNumbers.new,
      name: 'LobbyNumbersProvider',
    );

class LobbyNumbers extends Notifier<({int nbPlayers, int nbGames})?> {
  StreamSubscription<SocketEvent>? _socketSubscription;

  @override
  ({int nbPlayers, int nbGames})? build() {
    ref.onDispose(() {
      _socketSubscription?.cancel();
    });

    _socketSubscription?.cancel();
    _socketSubscription = socketGlobalStream.listen((event) {
      if (event.topic == 'n') {
        final data = event.data as Map<String, int>;
        state = (nbPlayers: data['nbPlayers']!, nbGames: data['nbGames']!);
      }
    });

    return null;
  }
}
