import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_analysis_service.g.dart';

@Riverpod(keepAlive: true)
ServerAnalysisService serverAnalysisService(Ref ref) {
  return ServerAnalysisService(ref);
}

class ServerAnalysisService {
  ServerAnalysisService(this.ref);

  (GameAnyId, StreamSubscription<SocketEvent>)? _socketSubscription;

  final Ref ref;

  final _currentAnalysis = ValueNotifier<GameId?>(null);

  final _analysisProgress = ValueNotifier<(GameAnyId, ServerEvalEvent)?>(null);

  /// The current game being analyzed.
  ValueListenable<GameId?> get currentAnalysis => _currentAnalysis;

  /// The last analysis progress event received from the server.
  ValueListenable<(GameAnyId, ServerEvalEvent)?> get lastAnalysisEvent =>
      _analysisProgress;

  /// Request server analysis for a game.
  ///
  /// This will return a future that completes when the server analysis is
  /// launched (but not when it is finished).
  Future<void> requestAnalysis(GameId id, [Side? side]) async {
    final socketPool = ref.read(socketPoolProvider);
    final uri = Uri(path: '/watch/$id/${side?.name ?? Side.white}/v6');
    final socketClient = socketPool.open(uri);

    _socketSubscription?.$2.cancel();
    _socketSubscription = (
      id,
      socketClient.stream.listen(
        (event) {
          if (event.topic == 'analysisProgress') {
            final data =
                ServerEvalEvent.fromJson(event.data as Map<String, dynamic>);

            _analysisProgress.value = (id, data);

            if (data.isAnalysisComplete) {
              _currentAnalysis.value = null;
              _socketSubscription?.$2.cancel();
              _socketSubscription = null;
            }
          }
        },
        onDone: () {
          _currentAnalysis.value = null;
          _socketSubscription?.$2.cancel();
          _socketSubscription = null;
        },
        cancelOnError: true,
      )
    );

    try {
      await ref.withClient(
        (client) => GameRepository(client).requestServerAnalysis(id.gameId),
      );
      _currentAnalysis.value = id.gameId;
    } catch (e) {
      _socketSubscription?.$2.cancel();
      _socketSubscription = null;
    }
  }
}

@riverpod
class CurrentAnalysis extends _$CurrentAnalysis {
  @override
  GameId? build() {
    final listenable = ref.watch(serverAnalysisServiceProvider).currentAnalysis;

    listenable.addListener(_listener);

    ref.onDispose(() {
      listenable.removeListener(_listener);
    });

    return listenable.value;
  }

  void _listener() {
    final gameId =
        ref.read(serverAnalysisServiceProvider).currentAnalysis.value;
    if (state != gameId) {
      state = gameId;
    }
  }
}
