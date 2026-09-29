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

/// Raised when the server refused to start an analysis, carrying the reason.
///
/// Distinct from a load failure: the view shows the reason instead of a retry screen.
class ServerAnalysisRequestException(
  /// The reason the server refused, as classified by
  /// [ServerAnalysisService.classifyRequestAnalysisError].
  final ServerAnalysisRequestError error,

  /// The raw failure, as reported by the server.
  final String message,
) {
  @override
  String toString() => 'ServerAnalysisRequestException: $error ($message)';
}

/// Why the server refused to start an analysis for a game.
///
/// [Analyse.requestAnalysis] answers 400 with the analyser's error string as a plain-text body, so
/// the status alone cannot tell a refusal we can live with from one that leaves nothing running.
///
/// [isBenign] marks the single case where evals for *this* game are still expected on the socket.
/// Every other value means the server queued nothing for this game, so listening would burn
/// [kMaxWaitForServerAnalysis] and then time out having reported nothing.
enum ServerAnalysisRequestError({final bool isBenign = false, required final String message}) {
  alreadyAnalysed(isBenign: true, message: 'This game has already been analysed'),
  concurrentAnalysis(message: 'Another analysis is already in progress'),
  weeklyLimitReached(message: 'Weekly analysis limit reached'),
  dailyLimitReached(message: 'Daily analysis limit reached'),
  dailyIpLimitReached(message: 'Daily analysis limit reached for this IP address'),
  notAnalysable(message: 'This game cannot be analysed'),
  unknown(message: 'The analysis could not be started'),
}

/// The exact error strings [lila.fishnet.Analyser.Result] sends, keyed by the resulting error.
const _kServerAnalysisRequestErrors = {
  'This game is already analysed': ServerAnalysisRequestError.alreadyAnalysed,
  'You already have an ongoing requested analysis': ServerAnalysisRequestError.concurrentAnalysis,
  'You have reached the weekly analysis limit': ServerAnalysisRequestError.weeklyLimitReached,
  'You have reached the daily analysis limit': ServerAnalysisRequestError.dailyLimitReached,
  'You have reached the daily analysis limit on this IP':
      ServerAnalysisRequestError.dailyIpLimitReached,
  'This game is not analysable': ServerAnalysisRequestError.notAnalysable,
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
          // share that status. Classify the body, and only keep listening when evals for *this*
          // game are still expected.
          final error = classifyRequestAnalysisError(e);
          if (error.isBenign) {
            // Already analysed: the evals exist, so keep reading them off the socket.
            _logger.info('Game $gameId is already analysed, reading it from the socket');
            _currentAnalysis.value = source;
          } else if (e.statusCode == 400) {
            // A refusal the server explained: the user hit a limit, or their queue is busy.
            // Wrap it so the view can report the reason instead of a bare failure.
            _logger.warning('Server refused to analyse game $gameId: $error', e, st);
            _cancelAnalysis();
            throw ServerAnalysisRequestException(error, e.message);
          } else {
            _logger.severe('ServerException requesting server analysis', e, st);
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
    // The body is appended to the message by the http client, so match on the tail. That is what
    // keeps the two daily limits apart: the account one is a prefix of the IP one, so `contains`
    // would report every IP-limited request as a plain daily limit.
    for (final MapEntry(key: body, value: error) in _kServerAnalysisRequestErrors.entries) {
      if (e.message.endsWith(body)) {
        return error;
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
