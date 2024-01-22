import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_socket_events.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_analysis_service.g.dart';

@Riverpod(keepAlive: true)
ServerAnalysisService serverAnalysisService(ServerAnalysisServiceRef ref) {
  return ServerAnalysisService(ref);
}

class ServerAnalysisService {
  ServerAnalysisService(this.ref);

  StreamSubscription<SocketEvent>? _socketSubscription;

  final ServerAnalysisServiceRef ref;

  final _analysisProgress = ValueNotifier<(GameId, ServerEvalEvent)?>(null);

  /// The last analysis progress event received from the server.
  ValueListenable<(GameId, ServerEvalEvent)?> get lastAnalysisEvent =>
      _analysisProgress;

  /// Request server analysis for a game.
  ///
  /// This will return a future that completes when the server analysis is
  /// launched (but not when it is finished).
  Future<void> requestAnalysis(GameFullId id) async {
    if (_socketSubscription != null) {
      throw Exception('You can only request analysis for one game at a time');
    }

    _analysisProgress.value = null;

    final socket = ref.read(socketClientProvider);
    final (stream, _) = socket.connect(Uri(path: '/play/$id/v6'));
    final repo = ref.read(gameRepositoryProvider);
    final completer = Completer<void>();
    final gameId = id.gameId;

    _socketSubscription = stream.listen((event) {
      // complete on first analysisProgress event
      if (event.topic == 'analysisProgress') {
        if (!completer.isCompleted) {
          completer.complete();
        }
        final data =
            ServerEvalEvent.fromJson(event.data as Map<String, dynamic>);

        _analysisProgress.value = (gameId, data);

        if (data.isAnalysisIncomplete == false) {
          _socketSubscription?.cancel();
          _socketSubscription = null;
        }
      }
    });

    final result = await repo.requestServerAnalysis(gameId);

    if (result.isError) {
      _socketSubscription?.cancel();
      _socketSubscription = null;
      completer.completeError(result.asError!.error);
    }

    return completer.future;
  }
}
