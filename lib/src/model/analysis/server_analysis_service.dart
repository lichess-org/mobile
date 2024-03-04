import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_analysis_service.g.dart';

@Riverpod(keepAlive: true)
ServerAnalysisService serverAnalysisService(ServerAnalysisServiceRef ref) {
  return ServerAnalysisService(ref);
}

class ServerAnalysisService {
  ServerAnalysisService(this.ref);

  (GameFullId, StreamSubscription<SocketEvent>)? _socketSubscription;

  Completer<void>? _analysisCompleter;

  final ServerAnalysisServiceRef ref;

  final _analysisProgress = ValueNotifier<(GameFullId, ServerEvalEvent)?>(null);

  /// The last analysis progress event received from the server.
  ValueListenable<(GameFullId, ServerEvalEvent)?> get lastAnalysisEvent =>
      _analysisProgress;

  /// Request server analysis for a game.
  ///
  /// This will return a future that completes when the server analysis is
  /// launched (but not when it is finished).
  Future<void> requestAnalysis(GameFullId id) async {
    if (_socketSubscription != null) {
      final (subId, _) = _socketSubscription!;
      if (subId == id) {
        return _analysisCompleter?.future;
      } else {
        return Future.error(
          'You already have an ongoing requested analysis. Please wait for it to finish before starting a new one.',
        );
      }
    }

    final socketPool = ref.read(socketPoolProvider);
    final socketClient = socketPool.open(Uri(path: '/play/$id/v6'));

    final completer = Completer<void>();

    _socketSubscription?.$2.cancel();
    _socketSubscription = (
      id,
      socketClient.stream.listen((event) {
        // complete on first analysisProgress event
        if (event.topic == 'analysisProgress') {
          if (!completer.isCompleted) {
            completer.complete();
          }
          final data =
              ServerEvalEvent.fromJson(event.data as Map<String, dynamic>);

          _analysisProgress.value = (id, data);

          if (data.isAnalysisIncomplete == false) {
            _socketSubscription?.$2.cancel();
            _socketSubscription = null;
          }
        }
      })
    );

    try {
      await ref.withClient(
        (client) => GameRepository(client).requestServerAnalysis(id.gameId),
      );
    } catch (e) {
      _socketSubscription?.$2.cancel();
      _socketSubscription = null;
      completer.completeError(e);
    }

    _analysisCompleter = completer;

    return completer.future;
  }
}
