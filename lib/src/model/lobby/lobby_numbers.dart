import 'dart:async';

import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lobby_numbers.g.dart';

/// The [LobbyNumbers] provider is used to display the number of players and
/// games on lichess in real time.
@riverpod
class LobbyNumbers extends _$LobbyNumbers {
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
