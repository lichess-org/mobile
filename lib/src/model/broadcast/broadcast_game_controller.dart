import 'dart:async';

import 'package:deep_pick/deep_pick.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_game_controller.g.dart';

@riverpod
class BroadcastGameController extends _$BroadcastGameController {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  StreamSubscription<SocketEvent>? _subscription;

  late SocketClient _socketClient;

  @override
  Future<String> build(BroadcastRoundId roundId, BroadcastGameId gameId) async {
    _socketClient = ref
        .watch(socketPoolProvider)
        .open(BroadcastGameController.broadcastSocketUri(roundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final pgn = await ref.withClient(
      (client) => BroadcastRepository(client).getGame(roundId, gameId),
    );
    return pgn;
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) return;

    switch (event.topic) {
      // Sent when a node is recevied from the broadcast
      case 'addNode':
        _handleAddNodeEvent(event);
      // Sent when a pgn tag changes
      case 'setTags':
        _handleSetTagsEvent(event);
    }
  }

  void _handleAddNodeEvent(SocketEvent event) {
    final broadcastGameId =
        pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();

    // We check if the event is for this game
    if (broadcastGameId != gameId) return;

    // The path of the last and current move of the broadcasted game
    // Its value is "!" if the path is identical to one of the node that was received
    final currentPath = pick(event.data, 'relayPath').asUciPathOrThrow();

    // We check that the event we received is for the last move of the game
    if (currentPath.value != '!') return;

    // The path for the node that was received
    final path = pick(event.data, 'p', 'path').asUciPathOrThrow();
    final uciMove = pick(event.data, 'n', 'uci').asUciMoveOrThrow();
    final clock =
        pick(event.data, 'n', 'clock').asDurationFromCentiSecondsOrNull();

    final ctrlProviderNotifier = ref.read(
      analysisControllerProvider(
        state.requireValue,
        AnalysisState.broadcastOptions,
      ).notifier,
    );

    ctrlProviderNotifier.onBroadcastMove(path, uciMove, clock);
  }

  void _handleSetTagsEvent(SocketEvent event) {
    final broadcastGameId =
        pick(event.data, 'chapterId').asBroadcastGameIdOrThrow();

    // We check if the event is for this game
    if (broadcastGameId != gameId) return;

    final ctrlProviderNotifier = ref.read(
      analysisControllerProvider(
        state.requireValue,
        AnalysisState.broadcastOptions,
      ).notifier,
    );

    final headers = Map.fromEntries(
      pick(event.data, 'tags').asListOrThrow(
        (header) => MapEntry(
          header(0).asStringOrThrow(),
          header(1).asStringOrThrow(),
        ),
      ),
    );

    for (final entry in headers.entries) {
      ctrlProviderNotifier.updatePgnHeader(entry.key, entry.value);
    }
  }
}
