import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_repository.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/socket.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_game_controller.freezed.dart';
part 'broadcast_game_controller.g.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

@riverpod
class BroadcastGameController extends _$BroadcastGameController
    implements PgnTreeNotifier {
  static Uri broadcastSocketUri(BroadcastRoundId broadcastRoundId) =>
      Uri(path: 'study/$broadcastRoundId/socket/v6');

  static AnalysisOptions get options => const AnalysisOptions(
        id: standaloneBroadcastId,
        isLocalEvaluationAllowed: true,
        orientation: Side.white,
        variant: Variant.standard,
        isBroadcast: true,
      );

  StreamSubscription<SocketEvent>? _subscription;

  late SocketClient _socketClient;
  late Root _root;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 150));

  Timer? _startEngineEvalTimer;

  @override
  Future<BroadcastGameState> build(
    BroadcastRoundId roundId,
    BroadcastGameId gameId,
  ) async {
    _socketClient = ref
        .watch(socketPoolProvider)
        .open(BroadcastGameController.broadcastSocketUri(roundId));

    _subscription = _socketClient.stream.listen(_handleSocketEvent);

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final evaluationService = ref.watch(evaluationServiceProvider);
    final serverAnalysisService = ref.watch(serverAnalysisServiceProvider);

    final isEngineAllowed = options.isLocalEvaluationAllowed &&
        engineSupportedVariants.contains(options.variant);

    ref.onDispose(() {
      _startEngineEvalTimer?.cancel();
      _engineEvalDebounce.dispose();
      if (isEngineAllowed) {
        evaluationService.disposeEngine();
      }
      serverAnalysisService.lastAnalysisEvent
          .removeListener(_listenToServerAnalysisEvents);
    });

    serverAnalysisService.lastAnalysisEvent
        .addListener(_listenToServerAnalysisEvents);

    UciPath path = UciPath.empty;
    Move? lastMove;

    final pgn = await ref.withClient(
      (client) => BroadcastRepository(client).getGame(roundId, gameId),
    );

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

    Future<void>? openingFuture;

    _root = Root.fromPgnGame(
      game,
      isLichessAnalysis: options.isLichessGameAnalysis,
      hideVariations: options.isLichessGameAnalysis,
      onVisitNode: (root, branch, isMainline) {
        if (isMainline &&
            options.initialMoveCursor != null &&
            branch.position.ply <=
                root.position.ply + options.initialMoveCursor!) {
          path = path + branch.id;
          lastMove = branch.sanMove.move;
        }
        if (isMainline && options.opening == null && branch.position.ply <= 5) {
          openingFuture = _fetchOpening(root, path);
        }
      },
    );

    final currentPath =
        options.initialMoveCursor == null ? _root.mainlinePath : path;
    final currentNode = _root.nodeAt(currentPath);

    // wait for the opening to be fetched to recompute the branch opening
    openingFuture?.then((_) {
      _setPath(currentPath);
    });

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    final analysisState = BroadcastGameState(
      variant: options.variant,
      id: options.id,
      currentPath: currentPath,
      broadcastLivePath: options.isBroadcast && pgnHeaders['Result'] == '*'
          ? currentPath
          : null,
      isOnMainline: _root.isOnMainline(currentPath),
      root: _root.view,
      currentNode: AnalysisCurrentNode.fromNode(currentNode),
      pgnHeaders: pgnHeaders,
      pgnRootComments: rootComments,
      lastMove: lastMove,
      pov: options.orientation,
      contextOpening: options.opening,
      isLocalEvaluationAllowed: options.isLocalEvaluationAllowed,
      isLocalEvaluationEnabled: prefs.enableLocalEvaluation,
      displayMode: DisplayMode.moves,
      playersAnalysis: options.serverAnalysis,
      acplChartData:
          options.serverAnalysis != null ? _makeAcplChartData() : null,
      clocks: options.isBroadcast ? _makeClocks(currentPath) : null,
    );

    if (analysisState.isEngineAvailable) {
      evaluationService
          .initEngine(
        _evaluationContext,
        options: EvaluationOptions(
          multiPv: prefs.numEvalLines,
          cores: prefs.numEngineCores,
        ),
      )
          .then((_) {
        _startEngineEvalTimer = Timer(const Duration(milliseconds: 250), () {
          _startEngineEval();
        });
      });
    }

    return analysisState;
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

    if (newPath != null) {
      if (state.requireValue.broadcastLivePath ==
          state.requireValue.currentPath) {
        _setPath(
          newPath,
          shouldRecomputeRootView: isNewNode,
          shouldForceShowVariation: true,
          isBroadcastMove: true,
        );
      } else {
        _root.promoteAt(newPath, toMainline: true);
        state = AsyncData(
          state.requireValue
              .copyWith(broadcastLivePath: newPath, root: _root.view),
        );
      }
    }
  }

  void _handleSetTagsEvent(SocketEvent event) {
    final broadcastGameId =
        pick(event.data, 'chapterId').asBroadcastGameIdOrThrow();

    // We check if the event is for this game
    if (broadcastGameId != gameId) return;

    final headers = Map.fromEntries(
      pick(event.data, 'tags').asListOrThrow(
        (header) => MapEntry(
          header(0).asStringOrThrow(),
          header(1).asStringOrThrow(),
        ),
      ),
    );

    for (final entry in headers.entries) {
      final headers = state.requireValue.pgnHeaders.add(entry.key, entry.value);
      state = AsyncData(state.requireValue.copyWith(pgnHeaders: headers));
    }
  }

  EvaluationContext get _evaluationContext => EvaluationContext(
        variant: options.variant,
        initialPosition: _root.position,
      );

  void onUserMove(NormalMove move) {
    if (!state.hasValue) return;

    if (!state.requireValue.position.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.position, move)) {
      state = AsyncData(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    // For the opening explorer, last played move should always be the mainline
    final shouldReplace = options.id == standaloneOpeningExplorerId;

    final (newPath, isNewNode) = _root.addMoveAt(
      state.requireValue.currentPath,
      move,
      replace: shouldReplace,
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
      child.isHidden = false;
      for (final grandChild in child.children) {
        grandChild.isHidden = false;
      }
    }
    state = AsyncData(state.requireValue.copyWith(root: _root.view));
  }

  @override
  void collapseVariations(UciPath path) {
    if (!state.hasValue) return;

    final node = _root.nodeAt(path);

    for (final child in node.children) {
      child.isHidden = true;
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

    if (state.requireValue.isEngineAvailable) {
      final prefs = ref.read(analysisPreferencesProvider);
      await ref.read(evaluationServiceProvider).initEngine(
            _evaluationContext,
            options: EvaluationOptions(
              multiPv: prefs.numEvalLines,
              cores: prefs.numEngineCores,
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
          ),
        );

    _startEngineEval();
  }

  void setDisplayMode(DisplayMode mode) {
    if (!state.hasValue) return;

    state = AsyncData(state.requireValue.copyWith(displayMode: mode));
  }

  Future<void> requestServerAnalysis() async {
    if (!state.hasValue) return;

    if (state.requireValue.canRequestServerAnalysis) {
      final service = ref.read(serverAnalysisServiceProvider);
      return service.requestAnalysis(
        options.id as GameAnyId,
        options.orientation,
      );
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
    if (!state.hasValue) Exception('Cannot make a PGN');

    return _root.makePgn(
      state.requireValue.pgnHeaders,
      state.requireValue.pgnRootComments,
    );
  }

  /// Makes a PGN string up to the current node only.
  String makeCurrentNodePgn() {
    if (!state.hasValue) Exception('Cannot make a PGN up to the current node');

    final nodes = _root.branchesOn(state.requireValue.currentPath);
    return nodes.map((node) => node.sanMove.san).join(' ');
  }

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,
    bool replaying = false,
    bool isBroadcastMove = false,
  }) {
    if (!state.hasValue) return;

    final pathChange = state.requireValue.currentPath != path;
    final (currentNode, opening) = _nodeOpeningAt(_root, path);

    // always show variation if the user plays a move
    if (shouldForceShowVariation &&
        currentNode is Branch &&
        currentNode.isHidden) {
      _root.updateAt(path, (node) {
        if (node is Branch) node.isHidden = false;
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

      if (currentNode.opening == null && currentNode.position.ply <= 30) {
        _fetchOpening(_root, path);
      }

      state = AsyncData(
        state.requireValue.copyWith(
          currentPath: path,
          broadcastLivePath:
              isBroadcastMove ? path : state.requireValue.broadcastLivePath,
          isOnMainline: _root.isOnMainline(path),
          currentNode: AnalysisCurrentNode.fromNode(currentNode),
          currentBranchOpening: opening,
          lastMove: currentNode.sanMove.move,
          promotionMove: null,
          root: rootView,
          clocks: options.isBroadcast ? _makeClocks(path) : null,
        ),
      );
    } else {
      state = AsyncData(
        state.requireValue.copyWith(
          currentPath: path,
          broadcastLivePath:
              isBroadcastMove ? path : state.requireValue.broadcastLivePath,
          isOnMainline: _root.isOnMainline(path),
          currentNode: AnalysisCurrentNode.fromNode(currentNode),
          currentBranchOpening: opening,
          lastMove: null,
          promotionMove: null,
          root: rootView,
          clocks: options.isBroadcast ? _makeClocks(path) : null,
        ),
      );
    }

    if (pathChange && state.requireValue.isEngineAvailable) {
      _debouncedStartEngineEval();
    }
  }

  Future<void> _fetchOpening(Node fromNode, UciPath path) async {
    if (!state.hasValue) return;
    if (!kOpeningAllowedVariants.contains(options.variant)) return;

    final moves = fromNode.branchesOn(path).map((node) => node.sanMove.move);
    if (moves.isEmpty) return;
    if (moves.length > 40) return;

    final opening =
        await ref.read(openingServiceProvider).fetchFromMoves(moves);

    if (opening != null) {
      fromNode.updateAt(path, (node) => node.opening = opening);

      if (state.requireValue.currentPath == path) {
        state = AsyncData(
          state.requireValue.copyWith(
            currentNode: AnalysisCurrentNode.fromNode(fromNode.nodeAt(path)),
          ),
        );
      }
    }
  }

  void _startEngineEval() {
    if (!state.hasValue) return;

    if (!state.requireValue.isEngineAvailable) return;
    ref
        .read(evaluationServiceProvider)
        .start(
          state.requireValue.currentPath,
          _root.branchesOn(state.requireValue.currentPath).map(Step.fromNode),
          initialPositionEval: _root.eval,
          shouldEmit: (work) => work.path == state.requireValue.currentPath,
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
    if (!state.hasValue) Exception('Cannot export PGN');

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

  void _listenToServerAnalysisEvents() {
    if (!state.hasValue) Exception('Cannot export PGN');

    final event =
        ref.read(serverAnalysisServiceProvider).lastAnalysisEvent.value;
    if (event != null && event.$1 == state.requireValue.id) {
      _mergeOngoingAnalysis(_root, event.$2.tree);
      state = AsyncData(
        state.requireValue.copyWith(
          acplChartData: _makeAcplChartData(),
          playersAnalysis: event.$2.analysis != null
              ? (
                  white: event.$2.analysis!.white,
                  black: event.$2.analysis!.black
                )
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
    final comment =
        (comments?.first as Map<String, dynamic>?)?['text'] as String?;
    final children = n2['children'] as List<dynamic>? ?? [];
    final pgnComment =
        pgnEval != null ? PgnComment(eval: pgnEval, text: comment) : null;
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
            isHidden: children.length > 1,
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
        node.lichessAnalysisComments
            ?.firstWhereOrNull((c) => c.eval != null)
            ?.eval
      ),
    )
        .map(
      (el) {
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
      },
    ).toList(growable: false);
    return list.isEmpty ? null : IList(list);
  }

  ({Duration? parentClock, Duration? clock}) _makeClocks(UciPath path) {
    final nodeView = _root.nodeAt(path).view;
    final parentView = _root.parentAt(path).view;

    return (
      parentClock: (parentView is ViewBranch) ? parentView.clock : null,
      clock: (nodeView is ViewBranch) ? nodeView.clock : null,
    );
  }
}

enum DisplayMode {
  moves,
  summary,
}

@freezed
class BroadcastGameState with _$BroadcastGameState {
  const BroadcastGameState._();

  const factory BroadcastGameState({
    /// Analysis ID
    required StringId id,

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

    // The path to the current broadcast live move.
    required UciPath? broadcastLivePath,

    /// Whether the current path is on the mainline.
    required bool isOnMainline,

    /// The side to display the board from.
    required Side pov,

    /// Whether local evaluation is allowed for this analysis.
    required bool isLocalEvaluationAllowed,

    /// Whether the user has enabled local evaluation.
    required bool isLocalEvaluationEnabled,

    /// The display mode of the analysis.
    ///
    /// It can be either moves, summary or opening explorer.
    required DisplayMode displayMode,

    /// Clocks if avaible. Only used by the broadcast analysis screen.
    ({Duration? parentClock, Duration? clock})? clocks,

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

    /// Optional ACPL chart data of the game, coming from lichess server analysis.
    IList<Eval>? acplChartData,

    /// The PGN headers of the game.
    required IMap<String, String> pgnHeaders,

    /// The PGN comments of the game.
    ///
    /// This field is only used with user submitted PGNS.
    IList<PgnComment>? pgnRootComments,
  }) = _AnalysisState;

  IMap<Square, ISet<Square>> get validMoves => makeLegalMoves(
        currentNode.position,
        isChess960: variant == Variant.chess960,
      );

  /// Whether the user can request server analysis.
  ///
  /// It must be a lichess game, which is finished and not already analyzed.
  bool get canRequestServerAnalysis => false;

  bool get canShowGameSummary => hasServerAnalysis || canRequestServerAnalysis;

  bool get hasServerAnalysis => playersAnalysis != null;

  /// Whether an evaluation can be available
  bool get hasAvailableEval =>
      isEngineAvailable ||
      (isLocalEvaluationAllowed &&
          acplChartData != null &&
          acplChartData!.isNotEmpty);

  /// Whether the engine is allowed for this analysis and variant.
  bool get isEngineAllowed =>
      isLocalEvaluationAllowed && engineSupportedVariants.contains(variant);

  /// Whether the engine is available for evaluation
  bool get isEngineAvailable => isEngineAllowed && isLocalEvaluationEnabled;

  Position get position => currentNode.position;
  bool get canGoNext => currentNode.hasChild;
  bool get canGoBack => currentPath.size > UciPath.empty.size;

  EngineGaugeParams get engineGaugeParams => (
        orientation: pov,
        isLocalEngineAvailable: isEngineAvailable,
        position: position,
        savedEval: currentNode.eval ?? currentNode.serverEval,
      );

  AnalysisOptions get openingExplorerOptions => AnalysisOptions(
        id: standaloneOpeningExplorerId,
        isLocalEvaluationAllowed: false,
        orientation: pov,
        variant: variant,
        initialMoveCursor: currentPath.size,
      );
}

@freezed
class AnalysisCurrentNode with _$AnalysisCurrentNode {
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
    final pgnEval =
        lichessAnalysisComments?.firstWhereOrNull((c) => c.eval != null)?.eval;
    return pgnEval != null
        ? ExternalEval(
            cp: pgnEval.pawns != null ? cpFromPawns(pgnEval.pawns!) : null,
            mate: pgnEval.mate,
            depth: pgnEval.depth,
          )
        : null;
  }
}
