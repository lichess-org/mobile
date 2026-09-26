import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_controller.dart';
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
import 'package:logging/logging.dart';

part 'server_analysis_service.freezed.dart';

final _logger = Logger('ServerAnalysisService');

@freezed
sealed class const ServerAnalysisSource._() with _$ServerAnalysisSource {
  const factory game({required GameId gameId}) = _GameServerAnalysisSource;

  const factory studyChapter({required StudyId studyId, required StudyChapterId chapterId}) =
      _StudyChapterServerAnalysisSource;
}

const Duration kMaxWaitForServerAnalysis = Duration(minutes: 1);

/// Why the server refused to start a new analysis.
///
/// [Analyse.requestAnalysis] answers 400 with the analyser's error string as a plain-text body,
/// so the status alone cannot tell a harmless refusal from a real one.
///
/// [isBenign] says whether the analysis is nonetheless already under way, so the request may be
/// treated as a success. Only [alreadyRequested] qualifies: every other value means the request was
/// refused outright, so listening would stall until [kMaxWaitForServerAnalysis] and then time out
/// with no evals.
enum ServerAnalysisRequestError({final bool isBenign = false}) {
  /// The game is already analysed, or the user already has an analysis requested. Evals are
  /// already coming, so listening for them is the right thing to do.
  alreadyRequested(isBenign: true),

  /// The user has run out of analyses this week.
  weeklyLimitReached,

  /// The user has run out of analyses today.
  dailyLimitReached,

  /// The user's IP has run out of analyses today.
  dailyIpLimitReached,

  /// The game cannot be analysed at all.
  notAnalysable,

  /// A 400 this list does not cover. Treated as a failure, so the app never waits on a socket
  /// for an analysis the server is not going to send.
  unknown;
}

/// The exact error strings [lila.fishnet.Analyser.Result] sends, keyed by the resulting error.
const _kServerAnalysisRequestErrors = {
  'This game is already analysed': ServerAnalysisRequestError.alreadyRequested,
  'You already have an ongoing requested analysis': ServerAnalysisRequestError.alreadyRequested,
  'You have reached the weekly analysis limit': ServerAnalysisRequestError.weeklyLimitReached,
  'You have reached the daily analysis limit': ServerAnalysisRequestError.dailyLimitReached,
  'You have reached the daily analysis limit on this IP':
      ServerAnalysisRequestError.dailyIpLimitReached,
  'This game is not analysable': ServerAnalysisRequestError.notAnalysable,
  'Game not found': ServerAnalysisRequestError.notAnalysable,
};

/// A provider for [ServerAnalysisService].
final serverAnalysisServiceProvider = Provider<ServerAnalysisService>((Ref ref) {
  return ServerAnalysisService(ref);
}, name: 'ServerAnalysisServiceProvider');

class ServerAnalysisService(final Ref ref) {
  StreamSubscription<SocketEvent>? _socketSubscription;

  final _currentAnalysis = ValueNotifier<ServerAnalysisSource?>(null);

  Completer<void>? _analysisCompleter;

  final _analysisProgress = ValueNotifier<(ServerAnalysisSource, ServerEvalEvent)?>(null);

  /// The current game being analyzed.
  ValueListenable<ServerAnalysisSource?> get currentAnalysis => _currentAnalysis;

  /// The last analysis progress event received from the server.
  ValueListenable<(ServerAnalysisSource, ServerEvalEvent)?> get lastAnalysisEvent =>
      _analysisProgress;

  SocketClient? _socketClient;

  /// Request server analysis for a game.
  ///
  /// This will return a future that completes when the server analysis is
  /// launched (but not when it is finished).
  Future<void> requestAnalysis(ServerAnalysisSource source, [Side? side]) async {
    // If we are already listening for analysis updates of this exact game/study,
    // don't tear everything down and reconnect.
    if (_currentAnalysis.value == source &&
        _socketSubscription != null &&
        _analysisCompleter != null) {
      return;
    }

    _cancelAnalysis();

    final uri = Uri(
      path: switch (source) {
        _GameServerAnalysisSource(:final gameId) => '/watch/$gameId/${side?.name ?? Side.white}/v6',
        _StudyChapterServerAnalysisSource(:final studyId) => '/study/$studyId/socket/v6',
      },
    );

    _socketClient = SocketClient(
      uri,
      channelFactory: ref.read(webSocketChannelFactoryProvider),
      getSession: () => ref.read(authControllerProvider),
      packageInfo: ref.read(preloadedDataProvider).requireValue.packageInfo,
      deviceInfo: ref.read(preloadedDataProvider).requireValue.deviceInfo,
      sri: ref.read(preloadedDataProvider).requireValue.sri,
    );
    _socketClient!.connect();
    _analysisCompleter = Completer<void>();
    _socketSubscription = _socketClient!.stream.listen(
      (event) {
        if (event.topic == 'analysisProgress') {
          final data = ServerEvalEvent.fromJson(event.data as Map<String, dynamic>);

          _analysisProgress.value = (source, data);

          if (data.isAnalysisComplete) {
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
    );

    switch (source) {
      case _GameServerAnalysisSource(:final gameId):
        try {
          await ref.read(gameRepositoryProvider).requestServerAnalysis(gameId);
          _currentAnalysis.value = source;
        } on ServerException catch (e, st) {
          // A 400 does not by itself mean the analysis is under way: several distinct refusals
          // share that status. Classify the body, and only keep listening for an analysis we
          // actually expect to arrive.
          final error = classifyRequestAnalysisError(e);
          if (error.isBenign) {
            // Already analysed or already queued: the evals are on their way, so keep listening.
            _logger.info('Server did not start a new analysis for game $gameId: $error');
            _currentAnalysis.value = source;
          } else {
            _logger.warning('Server refused to analyse game $gameId: $error', e, st);
            _cancelAnalysis();
            rethrow;
          }
        } catch (e, st) {
          _logger.severe('Error requesting server analysis', e, st);
          _cancelAnalysis();
          rethrow;
        }

      case _StudyChapterServerAnalysisSource(:final chapterId):
        _currentAnalysis.value = source;
        _socketClient!.firstConnection
            .timeout(const Duration(seconds: 3))
            .onError((e, st) {
              _logger.severe('Error connecting to analysis socket', e, st);
              _cancelAnalysis();
            })
            .whenComplete(() {
              _socketClient!.send('requestAnalysis', chapterId);
            });
    }

    _analysisCompleter?.future.timeout(kMaxWaitForServerAnalysis).whenComplete(() {
      _cancelAnalysis();
    });
  }

  /// Work out why the server refused to start an analysis, from the plain-text body it sends
  /// alongside the 400.
  static ServerAnalysisRequestError classifyRequestAnalysisError(ServerException e) {
    if (e.statusCode != 400) {
      return ServerAnalysisRequestError.unknown;
    }
    // The body is appended to the message by the http client, so match on the tail rather than
    // parsing it back out of the URL and status prefix.
    final body = e.jsonError?['error'] as String? ?? e.message;
    // Longest key first: the daily-limit key is a prefix of the daily-IP-limit key, so scanning in
    // declaration order would report every IP-limited request as a plain daily limit.
    final keys = _kServerAnalysisRequestErrors.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final key in keys) {
      if (body == key || body.endsWith(key)) {
        return _kServerAnalysisRequestErrors[key]!;
      }
    }
    return ServerAnalysisRequestError.unknown;
  }

  /// Cancel the ongoing server analysis, if any.
  void _cancelAnalysis() {
    _socketSubscription?.cancel();
    _socketSubscription = null;
    _currentAnalysis.value = null;
    _analysisCompleter = null;
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
      final uci = n2child['uci'] as String;
      final n1child = n1.childById(UciCharPair.fromUci(uci));
      if (n1child != null) {
        mergeOngoingAnalysis(n1child, n2child);
      } else {
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

/// A provider that exposes the current game being analyzed by the server.
final currentAnalysisProvider =
    NotifierProvider.autoDispose<CurrentAnalysis, ServerAnalysisSource?>(
      CurrentAnalysis.new,
      name: 'CurrentAnalysisProvider',
    );

class CurrentAnalysis() extends Notifier<ServerAnalysisSource?> {
  @override
  ServerAnalysisSource? build() {
    final listenable = ref.watch(serverAnalysisServiceProvider).currentAnalysis;

    listenable.addListener(_listener);

    ref.onDispose(() {
      listenable.removeListener(_listener);
    });

    return listenable.value;
  }

  void _listener() {
    final source = ref.read(serverAnalysisServiceProvider).currentAnalysis.value;
    if (state != source) {
      state = source;
    }
  }
}
