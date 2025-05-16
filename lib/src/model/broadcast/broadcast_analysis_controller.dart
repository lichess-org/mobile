import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_mixin.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_analysis_controller.freezed.dart';
part 'broadcast_analysis_controller.g.dart';

@riverpod
class BroadcastAnalysisController extends _$BroadcastAnalysisController
    with EngineEvaluationMixin
    implements PgnTreeNotifier {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  AppLifecycleListener? _appLifecycleListener;
  StreamSubscription<SocketEvent>? _subscription;
  StreamSubscription<void>? _socketOpenSubscription;

  late SocketClient _socketClient;
  late Root _root;

  final _syncDebouncer = Debouncer(const Duration(milliseconds: 150));

  Timer? _startEngineEvalTimer;

  Object? _key = Object();

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
  BroadcastAnalysisState get evaluationState => state.requireValue;

  @override
  @protected
  SocketClient get socketClient => _socketClient;

  @override
  @protected
  Root get positionTree => _root;

  @override
  Future<BroadcastAnalysisState> build(BroadcastRoundId roundId, BroadcastGameId gameId) async {
    ref.onDispose(() {
      _key = null;
      _subscription?.cancel();
      _socketOpenSubscription?.cancel();
      _startEngineEvalTimer?.cancel();
      _appLifecycleListener?.dispose();
      _syncDebouncer.cancel();
      disposeEngineEvaluation();
    });

    _socketClient = ref
        .watch(socketPoolProvider)
        .open(BroadcastAnalysisController.broadcastSocketUri(roundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    await _socketClient.firstConnection;

    _socketOpenSubscription = _socketClient.connectedStream.listen((_) {
      if (state.valueOrNull?.isNewOrOngoing == true) {
        _syncDebouncer(() {
          _reloadPgn();
        });
      }
    });

    _appLifecycleListener = AppLifecycleListener(
      onResume: () {
        if (state.valueOrNull?.isNewOrOngoing == true) {
          _syncDebouncer(() {
            _reloadPgn();
          });
        }
      },
    );

    final pgn = await ref.withClient(
      (client) => BroadcastRepository(client).getGamePgn(roundId, gameId),
    );

    final game = PgnGame.parsePgn(pgn);
    final pgnHeaders = IMap(game.headers);
    final rootComments = IList(game.comments.map((c) => PgnComment.fromPgn(c)));

    _root = Root.fromPgnGame(game, isLichessAnalysis: true);
    final currentPath = _root.mainlinePath;
    final currentNode = _root.nodeAt(currentPath);
    final lastMove = _root.branchAt(_root.mainlinePath)?.sanMove.move;

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    final broadcastState = BroadcastAnalysisState(
      id: gameId,
      currentPath: currentPath,
      broadcastPath: currentPath,
      isOnMainline: _root.isOnMainline(currentPath),
      root: _root.view,
      currentNode: AnalysisCurrentNode.fromNode(currentNode),
      pgnHeaders: pgnHeaders,
      pgnRootComments: rootComments,
      lastMove: lastMove,
      pov: Side.white,
      evaluationContext: EvaluationContext(
        variant: Variant.standard,
        initialPosition: _root.position,
      ),
      isComputerAnalysisEnabled: prefs.enableComputerAnalysis,
      clocks: _getClocks(currentPath),
    );

    // We need to define the state value in the build method because `sendEvalGetEvent` and
    // `debouncedStartEngineEval` require the state to have a value.
    state = AsyncData(broadcastState);

    initEngineEvaluation();

    if (state.requireValue.isEngineAvailable(evaluationPrefs)) {
      requestEval();
    }

    return broadcastState;
  }

  Future<void> _reloadPgn() async {
    if (!state.hasValue) return;
    final key = _key;

    final pgn = await ref.withClient(
      (client) => BroadcastRepository(client).getGamePgn(roundId, gameId),
    );

    // check provider is still mounted
    if (key == _key) {
      final curState = state.requireValue;
      final wasOnLivePath = curState.broadcastLivePath == curState.currentPath;
      final game = PgnGame.parsePgn(pgn);
      final pgnHeaders = IMap(game.headers);
      final rootComments = IList(game.comments.map((c) => PgnComment.fromPgn(c)));

      final newRoot = Root.fromPgnGame(game, isLichessAnalysis: true);

      final broadcastPath = newRoot.mainlinePath;
      final lastMove =
          wasOnLivePath ? newRoot.branchAt(newRoot.mainlinePath)?.sanMove.move : curState.lastMove;

      newRoot.merge(_root);

      _root = newRoot;

      final newCurrentPath = wasOnLivePath ? broadcastPath : curState.currentPath;
      final newCurrentNode =
          wasOnLivePath
              ? AnalysisCurrentNode.fromNode(_root.nodeAt(newCurrentPath))
              : curState.currentNode;

      state = AsyncData(
        state.requireValue.copyWith(
          currentNode: newCurrentNode,
          currentPath: newCurrentPath,
          pgnHeaders: pgnHeaders,
          pgnRootComments: rootComments,
          broadcastPath: broadcastPath,
          root: _root.view,
          lastMove: lastMove,
          clocks: _getClocks(newCurrentPath),
        ),
      );
    }
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
    final broadcastGameId = pick(event.data, 'p', 'chapterId').asBroadcastGameIdOrThrow();

    // We check if the event is for this game
    if (broadcastGameId != gameId) return;

    // The path of the last and current move of the broadcasted game
    // Its value is "!" if the path is identical to one of the node that was received
    final currentPath = pick(event.data, 'relayPath').asUciPathOrNull();

    // We check that the event we received is for the last move of the game
    if (currentPath?.value != '!') return;

    // The path for the node that was received
    final path = pick(event.data, 'p', 'path').asUciPathOrThrow();
    final uciMove = pick(event.data, 'n', 'uci').asUciMoveOrThrow();
    final clock = pick(event.data, 'n', 'clock').asDurationFromCentiSecondsOrNull();

    final (newPath, isNewNode) = _root.addMoveAt(path, uciMove, clock: clock);

    if (newPath != null && isNewNode == false) {
      _root.updateAt(newPath, (node) {
        if (node is Branch) {
          node.comments = [...node.comments ?? [], PgnComment(clock: clock)];
        }
      });
    }

    if (newPath != null) {
      _root.promoteAt(newPath, toMainline: true);
      _setPath(
        (state.requireValue.broadcastPath == state.requireValue.currentPath)
            ? newPath
            : state.requireValue.currentPath,
        shouldRecomputeRootView: isNewNode,
        shouldForceShowVariation: true,
        broadcastPath: newPath,
      );
    }
  }

  void _handleSetTagsEvent(SocketEvent event) {
    final broadcastGameId = pick(event.data, 'chapterId').asBroadcastGameIdOrThrow();

    // We check if the event is for this game
    if (broadcastGameId != gameId) return;

    final pgnHeadersEntries = pick(
      event.data,
      'tags',
    ).asListOrThrow((header) => MapEntry(header(0).asStringOrThrow(), header(1).asStringOrThrow()));

    final pgnHeaders = state.requireValue.pgnHeaders.addEntries(pgnHeadersEntries);
    state = AsyncData(state.requireValue.copyWith(pgnHeaders: pgnHeaders));
  }

  void onUserMove(NormalMove move) {
    if (!state.hasValue) return;

    if (!state.requireValue.position.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.position, move)) {
      state = AsyncData(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    final (newPath, isNewNode) = _root.addMoveAt(state.requireValue.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, shouldRecomputeRootView: isNewNode, shouldForceShowVariation: true);
    }
  }

  void onPromotionSelection(Role? role) {
    if (!state.hasValue) return;

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
    if (!state.hasValue) return;

    if (!state.requireValue.currentNode.hasChild) return;
    _setPath(
      state.requireValue.currentPath +
          _root.nodeAt(state.requireValue.currentPath).children.first.id,
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
    if (!state.hasValue) return;

    state = AsyncData(state.requireValue.copyWith(pov: state.requireValue.pov.opposite));
  }

  @override
  void userJump(UciPath path) {
    _setPath(path);
  }

  @override
  void expandVariations(UciPath path) {
    if (!state.hasValue) return;

    final node = _root.nodeAt(path);
    for (final child in node.children) {
      child.isCollapsed = false;
      for (final grandChild in child.children) {
        grandChild.isCollapsed = false;
      }
    }
    state = AsyncData(state.requireValue.copyWith(root: _root.view));
  }

  @override
  void collapseVariations(UciPath path) {
    if (!state.hasValue) return;

    final node = _root.nodeAt(path);

    for (final child in node.children) {
      child.isCollapsed = true;
    }

    state = AsyncData(state.requireValue.copyWith(root: _root.view));
  }

  @override
  void promoteVariation(UciPath path, bool toMainline) {
    if (!state.hasValue) return;

    _root.promoteAt(path, toMainline: toMainline);
    state = AsyncData(
      state.requireValue.copyWith(
        isOnMainline: _root.isOnMainline(state.requireValue.currentPath),
        root: _root.view,
      ),
    );
  }

  @override
  void deleteFromHere(UciPath path) {
    _root.deleteAt(path);
    _setPath(path.penultimate, shouldRecomputeRootView: true);
  }

  /// Toggles the computer analysis on/off.
  ///
  /// Acts both on engine evaluation and server analysis.
  Future<void> toggleComputerAnalysis() async {
    await ref.read(analysisPreferencesProvider.notifier).toggleEnableComputerAnalysis();

    final curState = state.requireValue;
    final engineWasAvailable = curState.isEngineAvailable(evaluationPrefs);

    state = AsyncData(
      curState.copyWith(isComputerAnalysisEnabled: !curState.isComputerAnalysisEnabled),
    );

    final computerAllowed = state.requireValue.isComputerAnalysisEnabled;
    if (!computerAllowed && engineWasAvailable) {
      toggleEngine();
    }
  }

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,

    /// Whether the user is navigating through the moves (as opposed to playing a move).
    bool isNavigating = false,
    UciPath? broadcastPath,
  }) {
    if (!state.hasValue) return;

    final pathChange = state.requireValue.currentPath != path;
    final currentNode = _root.nodeAt(path);

    // always show variation if the user plays a move
    if (shouldForceShowVariation && currentNode is Branch && currentNode.isCollapsed) {
      _root.updateAt(path, (node) {
        if (node is Branch) node.isCollapsed = false;
      });
    }

    // root view is only used to display move list, so we need to
    // recompute the root view only when the nodelist length changes
    // or a variation is hidden/shown
    final rootView =
        shouldForceShowVariation || shouldRecomputeRootView ? _root.view : state.requireValue.root;

    final isForward = path.size > state.requireValue.currentPath.size;
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
      state = AsyncData(
        state.requireValue.copyWith(
          currentPath: path,
          broadcastPath: broadcastPath ?? state.requireValue.broadcastPath,
          isOnMainline: _root.isOnMainline(path),
          currentNode: AnalysisCurrentNode.fromNode(currentNode),
          lastMove: currentNode.sanMove.move,
          promotionMove: null,
          root: rootView,
          clocks: _getClocks(path),
        ),
      );
    } else {
      state = AsyncData(
        state.requireValue.copyWith(
          currentPath: path,
          broadcastPath: broadcastPath ?? state.requireValue.broadcastPath,
          isOnMainline: _root.isOnMainline(path),
          currentNode: AnalysisCurrentNode.fromNode(currentNode),
          lastMove: null,
          promotionMove: null,
          root: rootView,
          clocks: _getClocks(path),
        ),
      );
    }

    if (pathChange) requestEval();
  }

  ({Duration? parentClock, Duration? clock}) _getClocks(UciPath path) {
    final node = _root.nodeAt(path);
    final parent = _root.parentAt(path);

    return (
      parentClock: (parent is Branch) ? parent.clock : null,
      clock: (node is Branch) ? node.clock : null,
    );
  }
}

@freezed
sealed class BroadcastAnalysisState with _$BroadcastAnalysisState implements EvaluationMixinState {
  const BroadcastAnalysisState._();

  const factory BroadcastAnalysisState({
    /// Broadcast game ID
    required StringId id,

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

    /// The path to the last broadcast move.
    required UciPath broadcastPath,

    /// Whether the current path is on the mainline.
    required bool isOnMainline,

    /// The side to display the board from.
    required Side pov,

    /// Whether the user has enabled computer analysis.
    ///
    /// This is a user preference and acts both on local and server analysis.
    required bool isComputerAnalysisEnabled,

    required EvaluationContext evaluationContext,

    /// Clocks if available.
    ({Duration? parentClock, Duration? clock})? clocks,

    /// The last move played.
    Move? lastMove,

    /// Possible promotion move to be played.
    NormalMove? promotionMove,

    /// The PGN headers of the game.
    required IMap<String, String> pgnHeaders,

    /// The PGN comments of the game.
    ///
    /// This field is only used with user submitted PGNS.
    IList<PgnComment>? pgnRootComments,
  }) = _BroadcastGameState;

  Position get position => currentNode.position;
  bool get canGoNext => currentNode.hasChild;
  bool get canGoBack => currentPath.size > UciPath.empty.size;

  /// Whether the game is new or ongoing
  bool get isNewOrOngoing => pgnHeaders['Result'] == '*';

  /// The path to the current broadcast live move.
  ///
  /// If the game is new the path will be empty.
  UciPath? get broadcastLivePath => isNewOrOngoing ? broadcastPath : null;

  /// In a broadcast analysis, the cloud evals are most likely available.
  @override
  bool get alwaysRequestCloudEval => true;

  /// Whether an evaluation can be available
  bool hasAvailableEval(EngineEvaluationPrefState prefs) =>
      isEngineAvailable(prefs) || (isComputerAnalysisEnabled && currentNode.serverEval != null);

  @override
  bool isEngineAvailable(EngineEvaluationPrefState prefs) =>
      isComputerAnalysisEnabled && prefs.isEnabled;

  @override
  Position get currentPosition => currentNode.position;

  EngineGaugeParams engineGaugeParams(EngineEvaluationPrefState prefs) => (
    isLocalEngineAvailable: isEngineAvailable(prefs),
    orientation: pov,
    position: position,
    savedEval: currentNode.eval,
    serverEval: currentNode.serverEval,
  );
}
