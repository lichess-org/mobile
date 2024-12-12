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
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_game_controller.freezed.dart';
part 'broadcast_game_controller.g.dart';

@riverpod
class BroadcastGameController extends _$BroadcastGameController
    implements PgnTreeNotifier {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  AppLifecycleListener? _appLifecycleListener;
  StreamSubscription<SocketEvent>? _subscription;
  StreamSubscription<void>? _socketOpenSubscription;

  late SocketClient _socketClient;
  late Root _root;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 150));
  final _syncDebouncer = Debouncer(const Duration(milliseconds: 150));

  Timer? _startEngineEvalTimer;

  Object? _key = Object();

  @override
  Future<BroadcastGameState> build(
    BroadcastRoundId roundId,
    BroadcastGameId gameId,
  ) async {
    _socketClient = ref
        .watch(socketPoolProvider)
        .open(BroadcastGameController.broadcastSocketUri(roundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    await _socketClient.firstConnection;

    _socketOpenSubscription = _socketClient.connectedStream.listen((_) {
      if (state.valueOrNull?.isOngoing == true) {
        _syncDebouncer(() {
          _reloadPgn();
        });
      }
    });

    final evaluationService = ref.watch(evaluationServiceProvider);

    _appLifecycleListener = AppLifecycleListener(
      onResume: () {
        if (state.valueOrNull?.isOngoing == true) {
          _syncDebouncer(() {
            _reloadPgn();
          });
        }
      },
    );

    ref.onDispose(() {
      _key = null;
      _subscription?.cancel();
      _socketOpenSubscription?.cancel();
      _startEngineEvalTimer?.cancel();
      _engineEvalDebounce.dispose();
      evaluationService.disposeEngine();
      _appLifecycleListener?.dispose();
      _syncDebouncer.dispose();
    });

    final pgn = await ref.withClient(
      (client) => BroadcastRepository(client).getGamePgn(roundId, gameId),
    );

    final game = PgnGame.parsePgn(pgn);
    final pgnHeaders = IMap(game.headers);
    final rootComments = IList(game.comments.map((c) => PgnComment.fromPgn(c)));

    _root = Root.fromPgnGame(game);
    final currentPath = _root.mainlinePath;
    final currentNode = _root.nodeAt(currentPath);
    final lastMove = _root.branchAt(_root.mainlinePath)?.sanMove.move;

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);
    final broadcastState = BroadcastGameState(
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
      isLocalEvaluationEnabled: prefs.enableLocalEvaluation,
      clocks: _getClocks(currentPath),
    );

    if (broadcastState.isLocalEvaluationEnabled) {
      evaluationService
          .initEngine(
        _evaluationContext,
        options: EvaluationOptions(
          multiPv: prefs.numEvalLines,
          cores: prefs.numEngineCores,
          searchTime: ref.read(analysisPreferencesProvider).engineSearchTime,
        ),
      )
          .then((_) {
        _startEngineEvalTimer = Timer(const Duration(milliseconds: 250), () {
          _startEngineEval();
        });
      });
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
      final game = PgnGame.parsePgn(pgn);
      final pgnHeaders = IMap(game.headers);
      final rootComments =
          IList(game.comments.map((c) => PgnComment.fromPgn(c)));

      final newRoot = Root.fromPgnGame(game);

      final broadcastPath = newRoot.mainlinePath;
      final lastMove = newRoot.branchAt(newRoot.mainlinePath)?.sanMove.move;

      newRoot.merge(_root);

      _root = newRoot;

      state = AsyncData(
        state.requireValue.copyWith(
          pgnHeaders: pgnHeaders,
          pgnRootComments: rootComments,
          broadcastPath: broadcastPath,
          root: _root.view,
          lastMove: lastMove,
          clocks: _getClocks(state.requireValue.currentPath),
        ),
      );
    }
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

    final (newPath, isNewNode) = _root.addMoveAt(path, uciMove, clock: clock);

    if (newPath != null && isNewNode == false) {
      _root.updateAt(newPath, (node) {
        if (node is Branch) {
          node.comments = [
            ...node.comments ?? [],
            PgnComment(clock: clock),
          ];
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
    final broadcastGameId =
        pick(event.data, 'chapterId').asBroadcastGameIdOrThrow();

    // We check if the event is for this game
    if (broadcastGameId != gameId) return;

    final pgnHeadersEntries = pick(event.data, 'tags').asListOrThrow(
      (header) => MapEntry(
        header(0).asStringOrThrow(),
        header(1).asStringOrThrow(),
      ),
    );

    final pgnHeaders =
        state.requireValue.pgnHeaders.addEntries(pgnHeadersEntries);
    state = AsyncData(
      state.requireValue.copyWith(pgnHeaders: pgnHeaders),
    );
  }

  EvaluationContext get _evaluationContext => EvaluationContext(
        variant: Variant.standard,
        initialPosition: _root.position,
      );

  void onUserMove(NormalMove move) {
    if (!state.hasValue) return;

    if (!state.requireValue.position.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.position, move)) {
      state = AsyncData(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    final (newPath, isNewNode) = _root.addMoveAt(
      state.requireValue.currentPath,
      move,
    );
    if (newPath != null) {
      _setPath(
        newPath,
        shouldRecomputeRootView: isNewNode,
        shouldForceShowVariation: true,
      );
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

  void userNext() {
    if (!state.hasValue) return;

    if (!state.requireValue.currentNode.hasChild) return;
    _setPath(
      state.requireValue.currentPath +
          _root.nodeAt(state.requireValue.currentPath).children.first.id,
      replaying: true,
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

    state = AsyncData(
      state.requireValue.copyWith(pov: state.requireValue.pov.opposite),
    );
  }

  void userPrevious() {
    _setPath(state.requireValue.currentPath.penultimate, replaying: true);
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

  Future<void> toggleLocalEvaluation() async {
    if (!state.hasValue) return;

    ref
        .read(analysisPreferencesProvider.notifier)
        .toggleEnableLocalEvaluation();

    state = AsyncData(
      state.requireValue.copyWith(
        isLocalEvaluationEnabled: !state.requireValue.isLocalEvaluationEnabled,
      ),
    );

    if (state.requireValue.isLocalEvaluationEnabled) {
      final prefs = ref.read(analysisPreferencesProvider);
      await ref.read(evaluationServiceProvider).initEngine(
            _evaluationContext,
            options: EvaluationOptions(
              multiPv: prefs.numEvalLines,
              cores: prefs.numEngineCores,
              searchTime:
                  ref.read(analysisPreferencesProvider).engineSearchTime,
            ),
          );
      _startEngineEval();
    } else {
      _stopEngineEval();
      ref.read(evaluationServiceProvider).disposeEngine();
    }
  }

  void setNumEvalLines(int numEvalLines) {
    if (!state.hasValue) return;

    ref
        .read(analysisPreferencesProvider.notifier)
        .setNumEvalLines(numEvalLines);

    ref.read(evaluationServiceProvider).setOptions(
          EvaluationOptions(
            multiPv: numEvalLines,
            cores: ref.read(analysisPreferencesProvider).numEngineCores,
            searchTime: ref.read(analysisPreferencesProvider).engineSearchTime,
          ),
        );

    _root.updateAll((node) => node.eval = null);

    state = AsyncData(
      state.requireValue.copyWith(
        currentNode: AnalysisCurrentNode.fromNode(
          _root.nodeAt(state.requireValue.currentPath),
        ),
      ),
    );

    _startEngineEval();
  }

  void setEngineCores(int numEngineCores) {
    ref
        .read(analysisPreferencesProvider.notifier)
        .setEngineCores(numEngineCores);

    ref.read(evaluationServiceProvider).setOptions(
          EvaluationOptions(
            multiPv: ref.read(analysisPreferencesProvider).numEvalLines,
            cores: numEngineCores,
            searchTime: ref.read(analysisPreferencesProvider).engineSearchTime,
          ),
        );

    _startEngineEval();
  }

  void setEngineSearchTime(Duration searchTime) {
    ref
        .read(analysisPreferencesProvider.notifier)
        .setEngineSearchTime(searchTime);

    ref.read(evaluationServiceProvider).setOptions(
          EvaluationOptions(
            multiPv: ref.read(analysisPreferencesProvider).numEvalLines,
            cores: ref.read(analysisPreferencesProvider).numEngineCores,
            searchTime: searchTime,
          ),
        );

    _startEngineEval();
  }

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,
    bool replaying = false,
    UciPath? broadcastPath,
  }) {
    if (!state.hasValue) return;

    final pathChange = state.requireValue.currentPath != path;
    final currentNode = _root.nodeAt(path);

    // always show variation if the user plays a move
    if (shouldForceShowVariation &&
        currentNode is Branch &&
        currentNode.isCollapsed) {
      _root.updateAt(path, (node) {
        if (node is Branch) node.isCollapsed = false;
      });
    }

    // root view is only used to display move list, so we need to
    // recompute the root view only when the nodelist length changes
    // or a variation is hidden/shown
    final rootView = shouldForceShowVariation || shouldRecomputeRootView
        ? _root.view
        : state.requireValue.root;

    final isForward = path.size > state.requireValue.currentPath.size;
    if (currentNode is Branch) {
      if (!replaying) {
        if (isForward) {
          final isCheck = currentNode.sanMove.isCheck;
          if (currentNode.sanMove.isCapture) {
            ref
                .read(moveFeedbackServiceProvider)
                .captureFeedback(check: isCheck);
          } else {
            ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
          }
        }
      } else if (isForward) {
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

    if (pathChange && state.requireValue.isLocalEvaluationEnabled) {
      _debouncedStartEngineEval();
    }
  }

  void _startEngineEval() {
    if (!state.hasValue) return;

    if (!state.requireValue.isLocalEvaluationEnabled) return;
    ref
        .read(evaluationServiceProvider)
        .start(
          state.requireValue.currentPath,
          _root.branchesOn(state.requireValue.currentPath).map(Step.fromNode),
          initialPositionEval: _root.eval,
          shouldEmit: (work) => work.path == state.valueOrNull?.currentPath,
        )
        ?.forEach(
          (t) => _root.updateAt(t.$1.path, (node) => node.eval = t.$2),
        );
  }

  void _debouncedStartEngineEval() {
    _engineEvalDebounce(() {
      _startEngineEval();
    });
  }

  void _stopEngineEval() {
    if (!state.hasValue) return;

    ref.read(evaluationServiceProvider).stop();
    // update the current node with last cached eval
    state = AsyncData(
      state.requireValue.copyWith(
        currentNode: AnalysisCurrentNode.fromNode(
          _root.nodeAt(state.requireValue.currentPath),
        ),
      ),
    );
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
class BroadcastGameState with _$BroadcastGameState {
  const BroadcastGameState._();

  const factory BroadcastGameState({
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

    /// Whether the user has enabled local evaluation.
    required bool isLocalEvaluationEnabled,

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

  IMap<Square, ISet<Square>> get validMoves =>
      makeLegalMoves(currentNode.position);

  Position get position => currentNode.position;
  bool get canGoNext => currentNode.hasChild;
  bool get canGoBack => currentPath.size > UciPath.empty.size;

  /// Whether the game is still ongoing
  bool get isOngoing => pgnHeaders['Result'] == '*';

  /// The path to the current broadcast live move
  UciPath? get broadcastLivePath => isOngoing ? broadcastPath : null;

  EngineGaugeParams get engineGaugeParams => (
        orientation: pov,
        isLocalEngineAvailable: isLocalEvaluationEnabled,
        position: position,
        savedEval: currentNode.eval ?? currentNode.serverEval,
      );
}
