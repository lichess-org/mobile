import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_controller.freezed.dart';
part 'analysis_controller.g.dart';

final _dateFormat = DateFormat('yyyy.MM.dd');

typedef StandaloneAnalysis = ({String pgn, Variant variant, bool isComputerAnalysisAllowed});

@freezed
class AnalysisOptions with _$AnalysisOptions {
  const AnalysisOptions._();

  @Assert('standalone != null || gameId != null')
  const factory AnalysisOptions({
    required Side orientation,
    StandaloneAnalysis? standalone,
    GameId? gameId,
    int? initialMoveCursor,
  }) = _AnalysisOptions;

  bool get isLichessGameAnalysis => gameId != null;
}

@riverpod
class AnalysisController extends _$AnalysisController
    with EvaluationNotifier<AnalysisState>
    implements PgnTreeNotifier {
  late Root _root;
  late Variant _variant;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 800));

  Timer? _startEngineEvalTimer;

  @override
  void onEngineEmit((Work, ClientEval) tuple) {
    final (work, eval) = tuple;
    _root.updateAt(work.path, (node) => node.eval = eval);
    if (work.path == state.requireValue.currentPath && eval.searchTime >= work.searchTime) {
      _refreshCurrentNode();
    }
  }

  @override
  void refreshCurrentNode() {
    state = AsyncData(
      state.requireValue.copyWith(
        currentNode: AnalysisCurrentNode.fromNode(_root.nodeAt(state.requireValue.currentPath)),
      ),
    );
  }

  @override
  Future<AnalysisState> build(AnalysisOptions options) async {
    final evaluationService = ref.watch(evaluationServiceProvider);
    final serverAnalysisService = ref.watch(serverAnalysisServiceProvider);

    late final String pgn;
    late final LightOpening? opening;
    late final ({PlayerAnalysis white, PlayerAnalysis black})? serverAnalysis;
    late final Division? division;

    ArchivedGame? archivedGame;

    if (options.gameId != null) {
      archivedGame = await ref.watch(archivedGameProvider(id: options.gameId!).future);
      _variant = archivedGame!.meta.variant;
      pgn = archivedGame.makePgn();
      opening = archivedGame.data.opening;
      serverAnalysis = archivedGame.serverAnalysis;
      division = archivedGame.meta.division;
    } else {
      _variant = options.standalone!.variant;
      pgn = options.standalone!.pgn;
      opening = null;
      serverAnalysis = null;
      division = null;
    }

    UciPath path = UciPath.empty;
    Move? lastMove;

    final game = PgnGame.parsePgn(
      pgn,
      initHeaders:
          () =>
              options.isLichessGameAnalysis
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

    final isComputerAnalysisAllowed =
        options.isLichessGameAnalysis
            ? pgnHeaders['Result'] != '*'
            : options.standalone!.isComputerAnalysisAllowed;

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
          openingFutures.add(_fetchOpening(root, path));
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

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    ref.onDispose(() {
      _startEngineEvalTimer?.cancel();
      _engineEvalDebounce.dispose();
      if (engineSupportedVariants.contains(_variant)) {
        evaluationService.disposeEngine();
      }
      serverAnalysisService.lastAnalysisEvent.removeListener(_listenToServerAnalysisEvents);
    });

    serverAnalysisService.lastAnalysisEvent.addListener(_listenToServerAnalysisEvents);

    final analysisState = AnalysisState(
      variant: _variant,
      gameId: options.gameId,
      archivedGame: archivedGame,
      currentPath: currentPath,
      isOnMainline: _root.isOnMainline(currentPath),
      root: _root.view,
      currentNode: AnalysisCurrentNode.fromNode(currentNode),
      pgnHeaders: pgnHeaders,
      pgnRootComments: rootComments,
      lastMove: lastMove,
      pov: options.orientation,
      contextOpening: opening,
      isComputerAnalysisAllowed: isComputerAnalysisAllowed,
      isComputerAnalysisEnabled: prefs.enableComputerAnalysis,
      isLocalEvaluationEnabled: prefs.enableLocalEvaluation,
      evaluationContext: _evaluationContext,
      currentPathSteps: _root.branchesOn(currentPath).map(Step.fromNode),
      playersAnalysis: serverAnalysis,
      acplChartData: serverAnalysis != null ? _makeAcplChartData() : null,
      division: division,
    );

    if (analysisState.isEngineAvailable) {
      evaluationService.initEngine(_evaluationContext, options: _evaluationOptions).then((_) {
        _startEngineEvalTimer = Timer(const Duration(milliseconds: 250), () {
          _startEngineEval();
        });
      });
    }

    return analysisState;
  }

  EvaluationContext get _evaluationContext =>
      EvaluationContext(variant: _variant, initialPosition: _root.position);

  EvaluationOptions get _evaluationOptions =>
      ref.read(analysisPreferencesProvider).evaluationOptions;

  void onUserMove(NormalMove move, {bool shouldReplace = false}) {
    if (!state.requireValue.position.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.position, move)) {
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

  void userNext() {
    final curState = state.requireValue;
    if (!curState.currentNode.hasChild) return;
    _setPath(
      curState.currentPath + _root.nodeAt(curState.currentPath).children.first.id,
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
    final curState = state.requireValue;
    state = AsyncData(curState.copyWith(pov: curState.pov.opposite));
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

  /// Toggles the computer analysis on/off.
  ///
  /// Acts both on local evaluation and server analysis.
  Future<void> toggleComputerAnalysis() async {
    await ref.read(analysisPreferencesProvider.notifier).toggleEnableComputerAnalysis();

    final curState = state.requireValue;
    final engineWasAvailable = curState.isEngineAvailable;

    state = AsyncData(
      curState.copyWith(isComputerAnalysisEnabled: !curState.isComputerAnalysisEnabled),
    );

    final computerAllowed = state.requireValue.isComputerAnalysisEnabled;
    if (!computerAllowed && engineWasAvailable) {
      toggleLocalEvaluation();
    }
  }

  /// Toggles the local evaluation on/off.
  Future<void> toggleLocalEvaluation() async {
    await ref.read(analysisPreferencesProvider.notifier).toggleEnableLocalEvaluation();

    state = AsyncData(
      state.requireValue.copyWith(
        isLocalEvaluationEnabled: !state.requireValue.isLocalEvaluationEnabled,
      ),
    );

    if (state.requireValue.isEngineAvailable) {
      await ref
          .read(evaluationServiceProvider)
          .initEngine(_evaluationContext, options: _evaluationOptions);
      _startEngineEval();
    } else {
      _stopEngineEval();
      ref.read(evaluationServiceProvider).disposeEngine();
    }
  }

  void setNumEvalLines(int numEvalLines) {
    ref.read(analysisPreferencesProvider.notifier).setNumEvalLines(numEvalLines);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    _root.updateAll((node) => node.eval = null);

    final curState = state.requireValue;
    state = AsyncData(
      curState.copyWith(
        currentNode: AnalysisCurrentNode.fromNode(_root.nodeAt(curState.currentPath)),
      ),
    );

    _startEngineEval();
  }

  void setEngineCores(int numEngineCores) {
    ref.read(analysisPreferencesProvider.notifier).setEngineCores(numEngineCores);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    _startEngineEval();
  }

  void setEngineSearchTime(Duration searchTime) {
    ref.read(analysisPreferencesProvider.notifier).setEngineSearchTime(searchTime);

    ref.read(evaluationServiceProvider).setOptions(_evaluationOptions);

    _startEngineEval();
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

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,
    bool replaying = false,
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
    final rootView =
        shouldForceShowVariation || shouldRecomputeRootView ? _root.view : curState.root;

    final isForward = path.size > curState.currentPath.size;
    if (currentNode is Branch) {
      if (!replaying) {
        if (isForward) {
          final isCheck = currentNode.sanMove.isCheck;
          if (currentNode.sanMove.isCapture) {
            ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
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
        _fetchOpening(_root, path).then((value) {
          if (value != null) {
            final (path, opening) = value;
            _updateOpening(path, opening);
          }
        });
      }

      state = AsyncData(
        curState.copyWith(
          currentPath: path,
          currentPathSteps: _root.branchesOn(path).map(Step.fromNode),
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
          currentPathSteps: _root.branchesOn(path).map(Step.fromNode),
          isOnMainline: _root.isOnMainline(path),
          currentNode: AnalysisCurrentNode.fromNode(currentNode),
          currentBranchOpening: opening,
          lastMove: null,
          promotionMove: null,
          root: rootView,
        ),
      );
    }

    if (pathChange && curState.isEngineAvailable) {
      _debouncedStartEngineEval();
    }
  }

  void _refreshCurrentNode({bool shouldRecomputeRootView = false}) {
    state = AsyncData(
      state.requireValue.copyWith(
        root: shouldRecomputeRootView ? _root.view : state.requireValue.root,
        currentNode: AnalysisCurrentNode.fromNode(_root.nodeAt(state.requireValue.currentPath)),
      ),
    );
  }

  Future<(UciPath, FullOpening)?> _fetchOpening(Node fromNode, UciPath path) async {
    if (!kOpeningAllowedVariants.contains(_variant)) return null;

    final moves = fromNode.branchesOn(path).map((node) => node.sanMove.move);
    if (moves.isEmpty) return null;
    if (moves.length > 40) return null;

    final opening = await ref.read(openingServiceProvider).fetchFromMoves(moves);
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

  Future<void> _startEngineEval() async {
    final curState = state.requireValue;
    if (!curState.isEngineAvailable) return;
    await ref
        .read(evaluationServiceProvider)
        .ensureEngineInitialized(_evaluationContext, options: _evaluationOptions);
    ref
        .read(evaluationServiceProvider)
        .start(
          curState.currentPath,
          _root.branchesOn(curState.currentPath).map(Step.fromNode),
          initialPositionEval: _root.eval,
          shouldEmit: (work) => work.path == state.valueOrNull?.currentPath,
        )
        ?.forEach((t) {
          final (work, eval) = t;
          _root.updateAt(work.path, (node) => node.eval = eval);
          if (work.path == curState.currentPath) {
            _refreshCurrentNode(
              shouldRecomputeRootView:
                  eval.evalString != state.valueOrNull?.currentNode.eval?.evalString,
            );
          }
        });
  }

  void _debouncedStartEngineEval() {
    _engineEvalDebounce(() {
      _startEngineEval();
    });
  }

  void _stopEngineEval() {
    ref.read(evaluationServiceProvider).stop();
    // update the current node with last cached eval
    _refreshCurrentNode(shouldRecomputeRootView: true);
  }

  void _listenToServerAnalysisEvents() {
    final event = ref.read(serverAnalysisServiceProvider).lastAnalysisEvent.value;
    if (event != null && event.$1 == state.requireValue.gameId) {
      _mergeOngoingAnalysis(_root, event.$2.tree);
      state = AsyncData(
        state.requireValue.copyWith(
          acplChartData: _makeAcplChartData(),
          playersAnalysis:
              event.$2.analysis != null
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
    final pgnEval =
        cp != null
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
                mate:
                    isCheckmate
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
class AnalysisState with _$AnalysisState {
  const AnalysisState._();

  const factory AnalysisState({
    /// The ID of the game if it's a lichess game.
    required GameId? gameId,

    /// The archived game if it's a finished lichess game.
    ArchivedGame? archivedGame,

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

    /// Whether the current path is on the mainline.
    required bool isOnMainline,

    /// The side to display the board from.
    required Side pov,

    /// Whether computer evaluation is allowed for this analysis.
    ///
    /// Acts on both local and server analysis.
    required bool isComputerAnalysisAllowed,

    /// Whether the user has enabled computer analysis.
    ///
    /// This is a user preference and acts both on local and server analysis.
    required bool isComputerAnalysisEnabled,

    /// Whether the user has enabled local evaluation.
    ///
    /// This is a user preference and acts only on local analysis.
    required bool isLocalEvaluationEnabled,

    required EvaluationContext evaluationContext,

    required Iterable<Step> currentPathSteps,

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

  /// Whether the analysis is for a lichess game.
  bool get isLichessGameAnalysis => gameId != null;

  IMap<Square, ISet<Square>> get validMoves =>
      makeLegalMoves(currentNode.position, isChess960: variant == Variant.chess960);

  /// Whether the user can request server analysis.
  ///
  /// It must be a lichess game, which is finished and not already analyzed.
  bool get canRequestServerAnalysis =>
      gameId != null && !hasServerAnalysis && pgnHeaders['Result'] != '*';

  /// Whether the server analysis is available.
  bool get hasServerAnalysis => playersAnalysis != null;

  bool get canShowGameSummary => hasServerAnalysis || canRequestServerAnalysis;

  /// Whether an evaluation can be available
  bool get hasAvailableEval =>
      isEngineAvailable ||
      (isComputerAnalysisAllowedAndEnabled && acplChartData != null && acplChartData!.isNotEmpty);

  bool get isComputerAnalysisAllowedAndEnabled =>
      isComputerAnalysisAllowed && isComputerAnalysisEnabled;

  /// Whether the engine is allowed for this analysis and variant.
  bool get isEngineAllowed =>
      isComputerAnalysisAllowedAndEnabled && engineSupportedVariants.contains(variant);

  /// Whether the engine is available for evaluation
  bool get isEngineAvailable => isEngineAllowed && isLocalEvaluationEnabled;

  Position get position => currentNode.position;
  bool get canGoNext => currentNode.hasChild;
  bool get canGoBack => currentPath.size > UciPath.empty.size;

  EngineGaugeParams get engineGaugeParams => (
    isLocalEngineAvailable: isEngineAvailable,
    orientation: pov,
    position: position,
    savedEval: currentNode.eval,
    serverEval: currentNode.serverEval,
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
