import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
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

  Completer<void>? _analysisCompleter;

  final _analysisProgress = ValueNotifier<(GameAnyId, ServerEvalEvent)?>(null);

  /// The current game being analyzed.
  ValueListenable<GameId?> get currentAnalysis => _currentAnalysis;

  /// The last analysis progress event received from the server.
  ValueListenable<(GameAnyId, ServerEvalEvent)?> get lastAnalysisEvent => _analysisProgress;

  SocketClient? _socketClient;

  /// Request server analysis for a game.
  ///
  /// This will return a future that completes when the server analysis is
  /// launched (but not when it is finished).
  Future<void> requestAnalysis(GameId id, [Side? side]) async {
    _cancelAnalysis();

    final uri = Uri(path: '/watch/$id/${side?.name ?? Side.white}/v6');
    _socketClient = SocketClient(
      uri,
      channelFactory: ref.read(webSocketChannelFactoryProvider),
      getSession: () => ref.read(authSessionProvider),
      packageInfo: ref.read(preloadedDataProvider).requireValue.packageInfo,
      deviceInfo: ref.read(preloadedDataProvider).requireValue.deviceInfo,
      sri: ref.read(preloadedDataProvider).requireValue.sri,
    );
    _socketClient!.connect();
    _analysisCompleter = Completer<void>();
    _socketSubscription = (
      id,
      _socketClient!.stream.listen(
        (event) {
          if (event.topic == 'analysisProgress') {
            final data = ServerEvalEvent.fromJson(event.data as Map<String, dynamic>);

            _analysisProgress.value = (id, data);

            if (data.isAnalysisComplete) {
              _cancelAnalysis();
              if (_analysisCompleter != null && !_analysisCompleter!.isCompleted) {
                _analysisCompleter?.complete();
              }
            }
          }
        },
        onDone: () {
          _cancelAnalysis();
        },
        cancelOnError: true,
      ),
    );

    try {
      await ref.read(gameRepositoryProvider).requestServerAnalysis(id.gameId);
      _currentAnalysis.value = id.gameId;
      await _analysisCompleter?.future.timeout(const Duration(minutes: 1));
    } on ServerException catch (e) {
      // 400 means analysis already requested (most likely) so we'll still try to listen to the socket
      // for updates.
      if (e.statusCode == 400) {
        debugPrint('Analysis already requested for game $id');
      } else {
        debugPrint('ServerException requesting server analysis: $e');
        _cancelAnalysis();
        rethrow;
      }
    } catch (e) {
      debugPrint('Error requesting server analysis: $e');
      _cancelAnalysis();
      rethrow;
    } finally {
      _analysisCompleter = null;
    }
  }

  /// Cancel the ongoing server analysis, if any.
  void _cancelAnalysis() {
    _socketSubscription?.$2.cancel();
    _socketSubscription = null;
    _currentAnalysis.value = null;
    if (_socketClient?.isDisposed != true) {
      _socketClient?.dispose();
      _socketClient = null;
    }
  }

  /// Merge the ongoing analysis from the server into the given node tree.
  static void mergeOngoingAnalysis(Node n1, Map<String, dynamic> n2) {
    final eval = n2['eval'] as Map<String, dynamic>?;
    final cp = eval?['cp'] as int?;
    final mate = eval?['mate'] as int?;
    final pgnEval = cp != null
        ? PgnEvaluation.pawns(pawns: cpToPawns(cp))
        : mate != null
        ? PgnEvaluation.mate(mate: mate)
        : null;
    final glyphs = n2['glyphs'] as List<dynamic>?;
    final glyph = glyphs?.first as Map<String, dynamic>?;
    final comments = n2['comments'] as List<dynamic>?;
    final comment = (comments?.first as Map<String, dynamic>?)?['text'] as String?;
    final children = n2['children'] as List<dynamic>? ?? [];
    final pgnComment = pgnEval != null ? PgnComment(eval: pgnEval, text: comment) : null;
    if (n1 is Branch) {
      if (pgnComment != null) {
        if (n1.lichessAnalysisComments == null) {
          n1.lichessAnalysisComments = [pgnComment];
        } else {
          n1.lichessAnalysisComments!.removeWhere((c) => c.eval != null);
          n1.lichessAnalysisComments!.add(pgnComment);
        }
      }
      if (glyph != null) {
        n1.nags ??= [glyph['id'] as int];
      }
    }
    for (final c in children) {
      final n2child = c as Map<String, dynamic>;
      final id = n2child['id'] as String;
      final n1child = n1.childById(UciCharPair.fromStringId(id));
      if (n1child != null) {
        mergeOngoingAnalysis(n1child, n2child);
      } else {
        final uci = n2child['uci'] as String;
        final san = n2child['san'] as String;
        final move = Move.parse(uci)!;
        n1.addChild(
          Branch(
            position: n1.position.playUnchecked(move),
            sanMove: SanMove(san, move),
            isCollapsed: children.length > 1,
          ),
        );
      }
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
    final gameId = ref.read(serverAnalysisServiceProvider).currentAnalysis.value;
    if (state != gameId) {
      state = gameId;
    }
  }
}
