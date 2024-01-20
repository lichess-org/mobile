import 'dart:async';

import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
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

  /// Request server analysis for a game.
  ///
  /// This will return a future that completes when the server analysis is
  /// launched (but not when it is finished).
  Future<void> requestAnalysis(GameFullId id) async {
    if (_socketSubscription != null) {
      throw Exception('You can only request analysis for one game at a time');
    }

    final socket = ref.read(socketClientProvider);
    final (stream, _) = socket.connect(Uri(path: '/play/$id/v6'));
    final repo = ref.read(gameRepositoryProvider);
    final completer = Completer<void>();

    _socketSubscription = stream.listen((event) {
      // complete on first analysisProgress event
      if (event.topic == 'analysisProgress') {
        completer.complete();
        _socketSubscription?.cancel();
        _socketSubscription = null;
      }
    });

    final result = await repo.requestServerAnalysis(id.gameId);

    if (result.isError) {
      _socketSubscription?.cancel();
      _socketSubscription = null;
      completer.completeError(result.asError!.error);
    }

    return completer.future;
  }
}
