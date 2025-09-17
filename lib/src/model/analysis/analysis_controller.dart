import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/account/account_service.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/common_analysis_state.dart';
import 'package:lichess_mobile/src/model/analysis/forecast.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/tv/tv_socket_events.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_controller.freezed.dart';
part 'analysis_controller.g.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

@freezed
sealed class AnalysisOptions with _$AnalysisOptions {
  const AnalysisOptions._();

  const factory AnalysisOptions.standalone({
    required Side orientation,
    int? initialMoveCursor,
    required String pgn,
    required Variant variant,
    required bool isComputerAnalysisAllowed,
  }) = Standalone;

  const factory AnalysisOptions.archivedGame({
    required Side orientation,
    int? initialMoveCursor,
    required GameId gameId,
  }) = ArchivedGame;

  const factory AnalysisOptions.activeCorrespondenceGame({
    required Side orientation,
    int? initialMoveCursor,
    required GameFullId gameFullId,
  }) = ActiveCorrespondenceGame;

  bool get isLichessGameAnalysis => this is ArchivedGame;

  GameId? get gameId => switch (this) {
    ArchivedGame(:final gameId) => gameId,
    Standalone() => null,
    ActiveCorrespondenceGame(:final gameFullId) => gameFullId.gameId,
  };
}

class UnsupportedVariantException implements Exception {
  final Variant variant;
  final GameId gameId;

  const UnsupportedVariantException(this.variant, this.gameId);
}

enum AnalysisGameResult {
  whiteWins,
  blackWins,
  draw,
  other;

  static AnalysisGameResult resultFromPgnResult(String? result) {
    return switch (result) {
      '1-0' => AnalysisGameResult.whiteWins,
      '0-1' => AnalysisGameResult.blackWins,
      '½-½' => AnalysisGameResult.draw,
      _ => AnalysisGameResult.other,
    };
  }

  String? resultToString(Side side) => switch (this) {
    whiteWins => side == Side.white ? '1' : '0',
    blackWins => side == Side.white ? '0' : '1',
    draw => '½',
    other => null,
  };
}

@riverpod
class AnalysisController extends _$AnalysisController
    with EngineEvaluationMixin
    implements PgnTreeNotifier {
  static final Uri socketUri = Uri(path: '/analysis/socket/v5');

  StreamSubscription<SocketEvent>? _socketSubscription;

  late Root _root;
  late Variant _variant;

  @override
  @protected
  EngineEvaluationPrefState get evaluationPrefs => ref.read(engineEvaluationPreferencesProvider);

  @override
  @protected
  EngineEvaluationPreferences get evaluationPreferencesNotifier =>
      ref.read(engineEvaluationPreferencesProvider.notifier);

  @override
  @protected
  EvaluationService evaluationServiceFactory() => ref.read(evaluationServiceProvider);

  @override
  @protected
  AnalysisState get evaluationState => state.requireValue;

  @override
  @protected
  late SocketClient socketClient;

  @override
  @protected
  Root get positionTree => _root;

  GameRepository get _gameRepository => ref.read(gameRepositoryProvider);

  @override
  Future<AnalysisState> build(AnalysisOptions options) async {
    final serverAnalysisService = ref.watch(serverAnalysisServiceProvider);

    ref.onDispose(() {
      _socketSubscription?.cancel();
      disposeEngineEvaluation();
      serverAnalysisService.lastAnalysisEvent.removeListener(_listenToServerAnalysisEvents);
    });

    socketClient = ref.watch(socketPoolProvider).open(AnalysisController.socketUri);
    _socketSubscription?.cancel();
    _socketSubscription = socketClient.stream.listen(_handleSocketEvent);

    isOnline(ref.read(defaultClientProvider)).then((online) {
      if (!online) {
        socketClient.close();
      }
    });

    late final String pgn;
    late final LightOpening? opening;
    late final ({PlayerAnalysis white, PlayerAnalysis black})? serverAnalysis;
    late final Division? division;
    late final PlayableGame? activeCorrespondenceGame;

    ExportedGame? archivedGame;

    switch (options) {
      case ArchivedGame(:final gameId):
        {
          archivedGame = await ref.watch(archivedGameProvider(id: gameId).future);
          _variant = archivedGame!.meta.variant;
          if (!_variant.isReadSupported) {
            throw UnsupportedVariantException(_variant, gameId);
          }
          pgn = archivedGame.makePgn();
          opening = archivedGame.data.opening;
          serverAnalysis = archivedGame.serverAnalysis;
          division = archivedGame.meta.division;
          activeCorrespondenceGame = null;
        }
      case Standalone(:final variant, pgn: final gamePgn):
        {
          _variant = variant;
          pgn = gamePgn;
          opening = null;
          serverAnalysis = null;
          division = null;
          activeCorrespondenceGame = null;
        }
      case ActiveCorrespondenceGame(:final gameFullId):
        {
          final game = await _gameRepository.getActiveCorrespondenceGame(gameFullId);
          _variant = game.meta.variant;
          pgn = game.makePgn();
          opening = game.meta.opening;
          serverAnalysis = null;
          division = null;
          activeCorrespondenceGame = game;
        }
    }

    UciPath path = UciPath.empty;
    Move? lastMove;

    final game = PgnGame.parsePgn(
      pgn,
      initHeaders: () => options.isLichessGameAnalysis
          ? {}
          : {
              'Event': '?',
              'Site': '?',
              'Date': _dateFormat.format(DateTime.now()),
              'Round': '?',
              'White': '?',
              'Black': '?',
              'Result': '*',
              'WhiteElo': '?',
              'BlackElo': '?',
            },
    );

    final pgnHeaders = IMap(game.headers);
    final rootComments = IList(game.comments.map((c) => PgnComment.fromPgn(c)));

    final isGameFinished = pgnHeaders['Result'] != '*';

    final isComputerAnalysisAllowed = switch (options) {
      Standalone(:final isComputerAnalysisAllowed) => isComputerAnalysisAllowed,
      ArchivedGame() => isGameFinished,
      ActiveCorrespondenceGame() => false,
    };

    final List<Future<(UciPath, FullOpening)?>> openingFutures = [];

    _root = Root.fromPgnGame(
      game,
      isLichessAnalysis: options.isLichessGameAnalysis,
      onVisitNode: (root, branch, isMainline) {
        if (isMainline &&
            options.initialMoveCursor != null &&
            branch.position.ply <= root.position.ply + options.initialMoveCursor!) {
          path = path + branch.id;
          lastMove = branch.sanMove.move;
        }
        if (isMainline && opening == null && branch.position.ply <= 10) {
          openingFutures.add(_fetchOpening(branch.position.fen, path));
        }
      },
    );

    // wait for the opening to be fetched to recompute the branch opening
    Future.wait(openingFutures)
        .then((list) {
          bool hasOpening = false;
          for (final updated in list) {
            if (updated != null) {
              hasOpening = true;
              final (path, opening) = updated;
              _root.updateAt(path, (node) => node.opening = opening);
            }
          }
          return hasOpening;
        })
        .then((hasOpening) {
          if (hasOpening) {
            scheduleMicrotask(() {
              _setPath(state.requireValue.currentPath);
            });
          }
        });

    final currentPath = options.initialMoveCursor == null ? _root.mainlinePath : path;
    final currentNode = _root.nodeAt(currentPath);

    late final Forecast? forecast;

    if (activeCorrespondenceGame != null) {
      // Premove paths are saved on the server, so if the user has already added some premoves on web,
      // we need to add them to our tree here as well.
      final lastMainlineNode = _root.mainline.lastOrNull ?? _root;
      // Adding nodes in the loop below changes _root.mainline, so save the current mainline path here
      final gameMainlinePath = _root.mainlinePath;

      final paths = <UciPath>[];
      for (final line
          in (activeCorrespondenceGame.correspondenceForecast ??
              const IList<IList<SanMove>>.empty())) {
        var position = lastMainlineNode.position;
        final nodes = <Branch>[];
        for (final sanMove in line) {
          position = position.playUnchecked(sanMove.move);
          nodes.add(Branch(position: position, sanMove: sanMove));
        }
        _root.addNodesAt(gameMainlinePath, nodes);

        paths.add(UciPath.fromUciMoves(line.map((sanMove) => sanMove.move.uci)));
      }

      forecast = Forecast(onMyTurn: activeCorrespondenceGame.isMyTurn, lines: paths.lock);
    } else {
      forecast = null;
    }

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    final isEngineAllowed = isComputerAnalysisAllowed && engineSupportedVariants.contains(_variant);
    if (isEngineAllowed) {
      initEngineEvaluation();
    }

    serverAnalysisService.lastAnalysisEvent.addListener(_listenToServerAnalysisEvents);

    final analysisState = AnalysisState(
      variant: _variant,
      gameId: options.gameId,
      archivedGame: archivedGame,
      currentPath: currentPath,
      pathToLiveMove: isGameFinished ? null : currentPath,
      forecast: forecast,
      isOnMainline: _root.isOnMainline(currentPath),
      root: _root.view,
      currentNode: AnalysisCurrentNode.fromNode(currentNode),
      pgnHeaders: pgnHeaders,
      pgnRootComments: rootComments,
      lastMove: lastMove,
      pov: options.orientation,
      contextOpening: opening,
      isComputerAnalysisAllowed: isComputerAnalysisAllowed,
      isServerAnalysisEnabled: prefs.enableServerAnalysis,
      evaluationContext: EvaluationContext(variant: _variant, initialPosition: _root.position),
      playersAnalysis: serverAnalysis,
      acplChartData: serverAnalysis != null ? _makeAcplChartData() : null,
      division: division,
    );

    // We need to define the state value in the build method because `requestEval` require the state
    // to have a value.
    state = AsyncData(analysisState);

    socketClient.firstConnection
        .timeout(const Duration(seconds: 3))
        .onError((_, _) {})
        .whenComplete(() {
          if (state.requireValue.isEngineAvailable(evaluationPrefs)) {
            requestEval();
          } else if (options case ActiveCorrespondenceGame(:final gameFullId)) {
            socketClient.send('startWatching', gameFullId.gameId.value);
          }
        });

    return analysisState;
  }

  Future<void> onFocusRegained() async {
    if (options case ActiveCorrespondenceGame(:final gameFullId)) {
      final updatedGame = await _gameRepository.getActiveCorrespondenceGame(gameFullId);
      _addNewLiveMoves(
        updatedGame.steps
            // Skip one more step, since the first one is the initial position
            .skip(1 + state.requireValue.pathToLiveMove!.size)
            .map((step) => step.sanMove!.move),
      );
    }
  }

  void _addNewLiveMoves(Iterable<Move> moves) {
    final newLiveMovePath = _root.addMovesAt(state.requireValue.pathToLiveMove!, moves);

    _root.promoteAt(newLiveMovePath!, toMainline: true);
    _setPath(
      // If the move cursor was on the live move, follow the game and move to the new live move.
      // Otherwise, stay on the current path.
      state.requireValue.pathToLiveMove == state.requireValue.currentPath
          ? newLiveMovePath
          : state.requireValue.currentPath,
      shouldRecomputeRootView: true,
      shouldForceShowVariation: true,
    );

    state = AsyncData(
      state.requireValue.copyWith(
        forecast: moves.fold(
          state.requireValue.forecast,
          (forecast, move) => forecast!.playMove(move),
        ),
        pathToLiveMove: newLiveMovePath,
      ),
    );
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) {
      return;
    }

    switch (event.topic) {
      case 'fen':
        _handleFenEvent(FenSocketEvent.fromJson(event.data as Map<String, dynamic>));
    }
  }

  void _handleFenEvent(FenSocketEvent fenEvent) {
    final isNewMove =
        fenEvent.id == options.gameId &&
        state.requireValue.liveMoveNode != null &&
        // The server sends an initial FEN event on connection, ignore that here
        !state.requireValue.liveMoveNode!.position.fen.startsWith(fenEvent.fen);

    if (!isNewMove) {
      return;
    }

    _addNewLiveMoves([fenEvent.lastMove]);
  }

  @override
  void onCurrentPathEvalChanged(bool isSameEvalString) {
    _refreshCurrentNode(recomputeRootView: !isSameEvalString);
  }

  void _refreshCurrentNode({bool recomputeRootView = false}) {
    state = AsyncData(
      state.requireValue.copyWith(
        root: recomputeRootView ? _root.view : state.requireValue.root,
        currentNode: AnalysisCurrentNode.fromNode(_root.nodeAt(state.requireValue.currentPath)),
      ),
    );
  }

  void onUserMove(NormalMove move, {bool shouldReplace = false}) {
    if (!state.requireValue.currentPosition.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.currentPosition, move)) {
      state = AsyncValue.data(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    final (newPath, isNewNode) = _root.addMoveAt(
      state.requireValue.currentPath,
      move,
      replace: shouldReplace,
    );
    if (newPath != null) {
      _setPath(newPath, shouldRecomputeRootView: isNewNode, shouldForceShowVariation: true);
    }
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      state = AsyncData(state.requireValue.copyWith(promotionMove: null));
      return;
    }
    final promotionMove = state.requireValue.promotionMove;
    if (promotionMove != null) {
      final promotion = promotionMove.withPromotion(role);
      onUserMove(promotion);
    }
  }

  void userPrevious() {
    _setPath(state.requireValue.currentPath.penultimate, isNavigating: true);
  }

  void userNext() {
    final curState = state.requireValue;
    if (!curState.currentNode.hasChild) return;
    _setPath(
      curState.currentPath + _root.nodeAt(curState.currentPath).children.first.id,
      isNavigating: true,
    );
  }

  void jumpToNthNodeOnMainline(int n) {
    UciPath path = _root.mainlinePath;
    while (!path.penultimate.isEmpty) {
      path = path.penultimate;
    }
    Node? node = _root.nodeAt(path);
    int count = 0;

    while (node != null && count < n) {
      if (node.children.isNotEmpty) {
        path = path + node.children.first.id;
        node = _root.nodeAt(path);
        count++;
      } else {
        break;
      }
    }

    if (node != null) {
      userJump(path);
    }
  }

  void toggleBoard() {
    final curState = state.requireValue;
    state = AsyncData(curState.copyWith(pov: curState.pov.opposite));
  }

  @override
  void userJump(UciPath path) {
    _setPath(path);
  }

  @override
  void expandVariations(UciPath path) {
    final node = _root.nodeAt(path);

    final childrenToShow = _root.isOnMainline(path) ? node.children.skip(1) : node.children;

    for (final child in childrenToShow) {
      child.isCollapsed = false;
      for (final grandChild in child.children) {
        grandChild.isCollapsed = false;
      }
    }
    state = AsyncData(state.requireValue.copyWith(root: _root.view));
  }

  @override
  void collapseVariations(UciPath path) {
    final node = _root.nodeAt(path);

    for (final child in node.children) {
      child.isCollapsed = true;
    }

    state = AsyncData(state.requireValue.copyWith(root: _root.view));
  }

  @override
  void promoteVariation(UciPath path, bool toMainline) {
    _root.promoteAt(path, toMainline: toMainline);
    final curState = state.requireValue;
    state = AsyncData(
      curState.copyWith(isOnMainline: _root.isOnMainline(curState.currentPath), root: _root.view),
    );
  }

  @override
  void deleteFromHere(UciPath path) {
    _root.deleteAt(path);
    _setPath(path.penultimate, shouldRecomputeRootView: true);
  }

  void addCurrentPathAsPremove() {
    state = AsyncData(
      state.requireValue.copyWith(
        forecast: state.requireValue.forecast!.add(
          state.requireValue.currentPath.stripPrefix(state.requireValue.pathToLiveMove!),
        ),
      ),
    );

    if (!state.requireValue.forecast!.onMyTurn) {
      _syncForecast();
    }
  }

  void playPendingMoveAndSaveForecast() {
    if (!state.hasValue || state.requireValue.pendingMove == null) return;

    final moveToPlay = state.requireValue.pendingMove!.move;

    final newForecast = state.requireValue.forecast!.playMove(moveToPlay);

    final newLiveMovePath = UciPath.join(
      state.requireValue.pathToLiveMove!,
      UciPath.fromId(UciCharPair.fromUci(moveToPlay.uci)),
    );

    _gameRepository.saveForecast(
      gameId: (options as ActiveCorrespondenceGame).gameFullId,
      forecast: newForecast.toApiForecast(_root.branchAt(newLiveMovePath)!.view),
      moveToPlay: moveToPlay,
    );

    state = AsyncData(
      state.requireValue.copyWith(
        forecast: state.requireValue.forecast!.playMove(moveToPlay),
        pathToLiveMove: newLiveMovePath,
      ),
    );
  }

  void removePremovePath(UciPath path) {
    state = AsyncData(
      state.requireValue.copyWith(forecast: state.requireValue.forecast!.remove(path)),
    );

    _syncForecast();
  }

  void _syncForecast() {
    final pathToLiveMove = state.requireValue.pathToLiveMove!;

    _gameRepository.saveForecast(
      gameId: (options as ActiveCorrespondenceGame).gameFullId,
      forecast: state.requireValue.forecast!.toApiForecast(
        pathToLiveMove.isEmpty ? _root.view : _root.branchAt(pathToLiveMove)!.view,
      ),
    );
  }

  void updatePgnHeader(String key, String value) {
    final headers = state.requireValue.pgnHeaders.add(key, value);
    state = AsyncData(state.requireValue.copyWith(pgnHeaders: headers));
  }

  Future<void> requestServerAnalysis() {
    if (state.requireValue.canRequestServerAnalysis) {
      final service = ref.read(serverAnalysisServiceProvider);
      return service.requestAnalysis(options.gameId!, options.orientation);
    }
    return Future.error('Cannot request server analysis');
  }

  /// Gets the node and maybe the associated branch opening at the given path.
  (Node, Opening?) _nodeOpeningAt(Node node, UciPath path, [Opening? opening]) {
    if (path.isEmpty) return (node, opening);
    final child = node.childById(path.head!);
    if (child != null) {
      return _nodeOpeningAt(child, path.tail, child.opening ?? opening);
    } else {
      return (node, opening);
    }
  }

  /// Makes a full PGN string (including headers and comments) of the current game state.
  String makeExportPgn() {
    final curState = state.requireValue;
    return _root.makePgn(curState.pgnHeaders, curState.pgnRootComments);
  }

  /// Makes a PGN string up to the current node only.
  String makeCurrentNodePgn() {
    final nodes = _root.branchesOn(state.requireValue.currentPath);
    return nodes.map((node) => node.sanMove.san).join(' ');
  }

  Future<void> toggleBookmark() async {
    if (state.hasValue) {
      final game = state.requireValue.archivedGame;
      if (game == null) return;
      final toggledBookmark = !(game.data.bookmarked ?? false);
      await ref.read(accountServiceProvider).setGameBookmark(game.id, bookmark: toggledBookmark);
      state = AsyncValue.data(
        state.requireValue.copyWith(
          archivedGame: state.requireValue.archivedGame?.copyWith(
            data: game.data.copyWith(bookmarked: toggledBookmark),
          ),
        ),
      );
    }
  }

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,

    /// Whether the user is navigating through the moves (as opposed to playing a move).
    bool isNavigating = false,
  }) {
    final curState = state.requireValue;
    final pathChange = curState.currentPath != path;
    final (currentNode, opening) = _nodeOpeningAt(_root, path);

    // always show variation if the user plays a move
    if (shouldForceShowVariation && currentNode is Branch && currentNode.isCollapsed) {
      _root.updateAt(path, (node) {
        if (node is Branch) node.isCollapsed = false;
      });
    }

    // root view is only used to display move list, so we need to
    // recompute the root view only when the nodelist length changes
    // or a variation is hidden/shown
    final rootView = shouldForceShowVariation || shouldRecomputeRootView
        ? _root.view
        : curState.root;

    final isForward = path.size > curState.currentPath.size;
    if (currentNode is Branch) {
      // normal move feedback
      if (!isNavigating && isForward) {
        final isCheck = currentNode.sanMove.isCheck;
        if (currentNode.sanMove.isCapture) {
          ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
        } else {
          ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
        }
      }
      // if navigating, only sound feedback
      else {
        final soundService = ref.read(soundServiceProvider);
        if (currentNode.sanMove.isCapture) {
          soundService.play(Sound.capture);
        } else {
          soundService.play(Sound.move);
        }
      }

      if (currentNode.opening == null && currentNode.position.ply <= 30) {
        _fetchOpening(currentNode.position.fen, path).then((value) {
          if (value != null) {
            final (path, opening) = value;
            _updateOpening(path, opening);
          }
        });
      }

      state = AsyncData(
        curState.copyWith(
          currentPath: path,
          isOnMainline: _root.isOnMainline(path),
          currentNode: AnalysisCurrentNode.fromNode(currentNode),
          currentBranchOpening: opening,
          lastMove: currentNode.sanMove.move,
          promotionMove: null,
          root: rootView,
        ),
      );
    } else {
      state = AsyncData(
        curState.copyWith(
          currentPath: path,
          isOnMainline: _root.isOnMainline(path),
          currentNode: AnalysisCurrentNode.fromNode(currentNode),
          currentBranchOpening: opening,
          lastMove: null,
          promotionMove: null,
          root: rootView,
        ),
      );
    }

    if (pathChange) requestEval();
  }

  Future<(UciPath, FullOpening)?> _fetchOpening(String fen, UciPath path) async {
    if (!kOpeningAllowedVariants.contains(_variant)) return null;

    final opening = await ref.read(openingServiceProvider).fetchFromFen(fen);
    if (opening != null) {
      return (path, opening);
    }
    return null;
  }

  void _updateOpening(UciPath path, FullOpening opening) {
    _root.updateAt(path, (node) => node.opening = opening);

    final curState = state.requireValue;
    if (curState.currentPath == path) {
      _refreshCurrentNode();
    }
  }

  void _listenToServerAnalysisEvents() {
    final event = ref.read(serverAnalysisServiceProvider).lastAnalysisEvent.value;
    if (event != null && event.$1 == state.requireValue.gameId) {
      _mergeOngoingAnalysis(_root, event.$2.tree);
      state = AsyncData(
        state.requireValue.copyWith(
          acplChartData: _makeAcplChartData(),
          playersAnalysis: event.$2.analysis != null
              ? (white: event.$2.analysis!.white, black: event.$2.analysis!.black)
              : null,
          root: _root.view,
        ),
      );
    }
  }

  void _mergeOngoingAnalysis(Node n1, Map<String, dynamic> n2) {
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
        _mergeOngoingAnalysis(n1child, n2child);
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

  IList<ExternalEval>? _makeAcplChartData() {
    if (!_root.mainline.any((node) => node.lichessAnalysisComments != null)) {
      return null;
    }
    final list = _root.mainline
        .map(
          (node) => (
            node.position.isCheckmate,
            node.position.turn,
            node.lichessAnalysisComments?.firstWhereOrNull((c) => c.eval != null)?.eval,
          ),
        )
        .map((el) {
          final (isCheckmate, side, eval) = el;
          return eval != null
              ? ExternalEval(
                  cp: eval.pawns != null ? cpFromPawns(eval.pawns!) : null,
                  mate: eval.mate,
                  depth: eval.depth,
                )
              : ExternalEval(
                  cp: null,
                  // hack to display checkmate as the max eval
                  mate: isCheckmate
                      ? side == Side.white
                            ? -1
                            : 1
                      : null,
                );
        })
        .toList(growable: false);
    return list.isEmpty ? null : IList(list);
  }
}

@freezed
sealed class AnalysisState
    with _$AnalysisState
    implements EvaluationMixinState, CommonAnalysisState {
  const AnalysisState._();

  const factory AnalysisState({
    /// The ID of the game if it's a lichess game.
    required GameId? gameId,

    /// The archived game if it's a finished lichess game.
    ExportedGame? archivedGame,

    /// The variant of the analysis.
    required Variant variant,

    /// Immutable view of the whole tree
    required ViewRoot root,

    /// The current node in the analysis view.
    ///
    /// This is an immutable copy of the actual [Node] at the `currentPath`.
    /// We don't want to use [Node.view] here because it'd copy the whole tree
    /// under the current node and it's expensive.
    required AnalysisCurrentNode currentNode,

    /// The path to the current node in the analysis view.
    required UciPath currentPath,

    /// If this is a correspondence game, the path to the last move that has been played.
    required UciPath? pathToLiveMove,

    /// If this is a correspondence game, stores the current set of conditional premoves.
    required Forecast? forecast,

    /// Whether the current path is on the mainline.
    required bool isOnMainline,

    /// The side to display the board from.
    required Side pov,

    /// Whether computer evaluation is allowed for this analysis.
    ///
    /// Acts on both local and server analysis.
    required bool isComputerAnalysisAllowed,

    /// Whether the user has enabled server analysis.
    required bool isServerAnalysisEnabled,

    /// The context that the local engine is initialized with.
    required EvaluationContext evaluationContext,

    /// The last move played.
    Move? lastMove,

    /// Possible promotion move to be played.
    NormalMove? promotionMove,

    /// Opening of the analysis context (from lichess archived games).
    Opening? contextOpening,

    /// The opening of the current branch.
    Opening? currentBranchOpening,

    /// Optional server analysis to display player stats.
    ({PlayerAnalysis white, PlayerAnalysis black})? playersAnalysis,

    /// Optional game division data, given by server analysis.
    Division? division,

    /// Optional ACPL chart data of the game, coming from lichess server analysis.
    IList<Eval>? acplChartData,

    /// The PGN headers of the game.
    required IMap<String, String> pgnHeaders,

    /// The PGN comments of the game.
    ///
    /// This field is only used with user submitted PGNS.
    IList<PgnComment>? pgnRootComments,
  }) = _AnalysisState;

  @override
  bool get alwaysRequestCloudEval => false;

  /// Whether the analysis is for a lichess game.
  bool get isLichessGameAnalysis => gameId != null;

  /// Whether the user can request server analysis.
  ///
  /// It must be a lichess game, which is finished and not already analyzed.
  bool get canRequestServerAnalysis =>
      gameId != null && !hasServerAnalysis && pgnHeaders['Result'] != '*';

  /// Whether the server analysis is available.
  bool get hasServerAnalysis => playersAnalysis != null;

  bool get canShowGameSummary => hasServerAnalysis || canRequestServerAnalysis;

  /// Whether an evaluation can be available
  bool hasAvailableEval(EngineEvaluationPrefState prefs) =>
      isEngineAvailable(prefs) ||
      (isComputerAnalysisAllowed && isServerAnalysisEnabled && currentNode.serverEval != null);

  /// Whether the engine is allowed for this analysis and variant.
  bool get isEngineAllowed =>
      isComputerAnalysisAllowed && engineSupportedVariants.contains(variant);

  ViewNode? get liveMoveNode => pathToLiveMove != null
      ? pathToLiveMove!.isEmpty
            ? root
            : root.branchesOn(pathToLiveMove!).last
      : null;

  bool get branchedOffFromLiveMove =>
      forecast != null &&
      pathToLiveMove != null &&
      currentPath != pathToLiveMove &&
      currentPath.contains(pathToLiveMove!);

  /// If the current node branches off from the live move and is not yet saved as a premove,
  /// the part of [AnalysisState.currentPath] that would be saved as a premove line. null otherwise.
  UciPath? get currentPremoveCandidate {
    if (!branchedOffFromLiveMove) {
      return null;
    }

    final candidate = currentPath.stripPrefix(pathToLiveMove!);
    return forecast!.isCandidate(candidate) ? candidate : null;
  }

  /// If it's our turn and we have branched off from the main line, this is the move we would play
  /// if we to save the entire current path as a premove line.
  SanMove? get pendingMove => forecast?.onMyTurn == true && branchedOffFromLiveMove
      ? liveMoveNode!.childById(currentPath.stripPrefix(pathToLiveMove!).head!)?.sanMove
      : null;

  IList<UciPath>? get linesForPendingMove =>
      pendingMove != null ? forecast?.linesStartingWith(pendingMove!.move) : null;

  @override
  bool isEngineAvailable(EngineEvaluationPrefState prefs) => isEngineAllowed && prefs.isEnabled;

  @override
  Position get currentPosition => currentNode.position;

  bool get canGoNext => currentNode.hasChild;
  bool get canGoBack => currentPath.size > UciPath.empty.size;

  EngineGaugeParams engineGaugeParams(EngineEvaluationPrefState prefs) => (
    isLocalEngineAvailable: isEngineAvailable(prefs),
    orientation: pov,
    position: currentPosition,
    savedEval: currentNode.eval,
    serverEval: currentNode.serverEval,
  );
}

@freezed
sealed class AnalysisCurrentNode
    with _$AnalysisCurrentNode
    implements AnalysisCurrentNodeInterface {
  const AnalysisCurrentNode._();

  const factory AnalysisCurrentNode({
    required Position position,
    required bool hasChild,
    required bool isRoot,
    SanMove? sanMove,
    Opening? opening,
    ClientEval? eval,
    IList<PgnComment>? lichessAnalysisComments,
    IList<PgnComment>? startingComments,
    IList<PgnComment>? comments,
    IList<int>? nags,
  }) = _AnalysisCurrentNode;

  factory AnalysisCurrentNode.fromNode(Node node) {
    if (node is Branch) {
      return AnalysisCurrentNode(
        sanMove: node.sanMove,
        position: node.position,
        isRoot: node is Root,
        hasChild: node.children.isNotEmpty,
        opening: node.opening,
        eval: node.eval,
        lichessAnalysisComments: IList(node.lichessAnalysisComments),
        startingComments: IList(node.startingComments),
        comments: IList(node.comments),
        nags: IList(node.nags),
      );
    } else {
      return AnalysisCurrentNode(
        position: node.position,
        hasChild: node.children.isNotEmpty,
        isRoot: node is Root,
        opening: node.opening,
        eval: node.eval,
      );
    }
  }

  /// The evaluation from the PGN comments.
  ///
  /// For now we only trust the eval coming from lichess analysis.
  ExternalEval? get serverEval {
    final pgnEval = lichessAnalysisComments?.firstWhereOrNull((c) => c.eval != null)?.eval;
    return pgnEval != null
        ? ExternalEval(
            cp: pgnEval.pawns != null ? cpFromPawns(pgnEval.pawns!) : null,
            mate: pgnEval.mate,
            depth: pgnEval.depth,
          )
        : null;
  }
}
