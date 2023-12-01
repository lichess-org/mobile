import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/settings/analysis_preferences.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_controller.freezed.dart';
part 'analysis_controller.g.dart';

@freezed
class AnalysisOptions with _$AnalysisOptions {
  const factory AnalysisOptions({
    required ID id,
    required bool isLocalEvaluationAllowed,
    required Side orientation,
    required Variant variant,

    /// The PGN of the game to analyze.
    /// The move list can be empty.
    /// It can contain a FEN header for initial position.
    /// If it contains a Variant header, it will be ignored.
    required String pgn,
    int? initialMoveCursor,
    LightOpening? opening,

    /// Optional server analysis to display player stats.
    ({PlayerAnalysis white, PlayerAnalysis black})? serverAnalysis,
  }) = _AnalysisOptions;
}

@riverpod
class AnalysisController extends _$AnalysisController {
  late final Root _root;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 150));

  Timer? _startEngineEvalTimer;

  @override
  AnalysisState build(AnalysisOptions options) {
    final evaluationService = ref.read(evaluationServiceProvider);

    ref.onDispose(() {
      _startEngineEvalTimer?.cancel();
      _engineEvalDebounce.dispose();
      evaluationService.closeEngine();
    });

    UciPath path = UciPath.empty;
    Move? lastMove;

    final game = PgnGame.parsePgn(
      options.pgn,
      initHeaders: () => options.id is GameId
          ? {}
          : {
              'Event': '?',
              'Site': '?',
              'Date': '????.??.??',
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

    _root = Root.fromPgnGame(game, (root, branch, isMainline) {
      if (isMainline &&
          options.initialMoveCursor != null &&
          branch.position.ply <= options.initialMoveCursor!) {
        path = path + branch.id;
        lastMove = branch.sanMove.move;
      }
      if (isMainline && options.opening == null && branch.position.ply <= 2) {
        _fetchOpening(root, path);
      }
    });

    final currentPath =
        options.initialMoveCursor == null ? _root.mainlinePath : path;
    final currentNode = _root.nodeAt(currentPath);

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    // We know ACPL chart data is available in the PGN if the server analysis is
    // available.
    // Works only for lichess games.
    // TODO use another way to detect if the PGN contains ACPL data
    final acplChartData = options.serverAnalysis != null
        ? _root.mainline
            .map(
              (node) =>
                  node.comments?.firstWhereOrNull((c) => c.eval != null)?.eval,
            )
            .whereNotNull()
            .map(
              (eval) => ExternalEval(
                eval: eval.pawns,
                mate: eval.mate,
                depth: eval.depth,
              ),
            )
            .toList(growable: false)
        : null;

    final analysisState = AnalysisState(
      variant: options.variant,
      id: options.id,
      currentPath: currentPath,
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
      acplChartData: acplChartData?.lock,
    );

    if (analysisState.isEngineAvailable) {
      ref.read(evaluationServiceProvider).initEngine(
            _evaluationContext,
            EvaluationOptions(
              multiPv: prefs.numEvalLines,
              cores: prefs.numEngineCores,
            ),
          );
      _startEngineEvalTimer = Timer(const Duration(milliseconds: 150), () {
        _startEngineEval();
      });
    }

    return analysisState;
  }

  EvaluationContext get _evaluationContext => EvaluationContext(
        variant: options.variant,
        initialPosition: _root.position,
      );

  void onUserMove(Move move) {
    if (!state.position.isLegal(move)) return;
    final (newPath, isNewNode) = _root.addMoveAt(state.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, isNewNode: isNewNode);
    }
  }

  void userNext() {
    if (!state.currentNode.hasChild) return;
    _setPath(
      state.currentPath + _root.nodeAt(state.currentPath).children.first.id,
      replaying: true,
    );
  }

  void toggleBoard() {
    state = state.copyWith(pov: state.pov.opposite);
  }

  void userPrevious() {
    _setPath(state.currentPath.penultimate, replaying: true);
  }

  void userJump(UciPath path) {
    _setPath(path);
  }

  void toggleLocalEvaluation() {
    ref
        .read(analysisPreferencesProvider.notifier)
        .toggleEnableLocalEvaluation();

    state = state.copyWith(
      isLocalEvaluationEnabled: !state.isLocalEvaluationEnabled,
    );

    if (state.isEngineAvailable) {
      final prefs = ref.read(analysisPreferencesProvider);
      ref.read(evaluationServiceProvider).initEngine(
            _evaluationContext,
            EvaluationOptions(
              multiPv: prefs.numEvalLines,
              cores: prefs.numEngineCores,
            ),
          );
      _startEngineEval();
    } else {
      _stopEngineEval();
      ref.read(evaluationServiceProvider).closeEngine();
    }
  }

  void setNumEvalLines(int numEvalLines) {
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

    state = state.copyWith(
      currentNode:
          AnalysisCurrentNode.fromNode(_root.nodeAt(state.currentPath)),
    );

    _startEngineEvalTimer?.cancel();
    _startEngineEvalTimer = Timer(const Duration(milliseconds: 100), () {
      _startEngineEval();
    });
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

    _startEngineEvalTimer?.cancel();
    _startEngineEvalTimer = Timer(const Duration(milliseconds: 100), () {
      _startEngineEval();
    });
  }

  void updatePgnHeader(String key, String value) {
    final headers = state.pgnHeaders.add(key, value);
    state = state.copyWith(pgnHeaders: headers);
  }

  void toggleDisplayMode() {
    state = state.copyWith(
      displayMode: state.displayMode == DisplayMode.moves
          ? DisplayMode.summary
          : DisplayMode.moves,
    );
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

  String makeGamePgn() {
    return _root.makePgn(state.pgnHeaders, state.pgnRootComments);
  }

  void _setPath(
    UciPath path, {
    bool isNewNode = false,
    bool replaying = false,
  }) {
    final pathChange = state.currentPath != path;
    final (currentNode, opening) = _nodeOpeningAt(_root, path);

    if (currentNode is Branch) {
      if (!replaying) {
        final isForward = path.size > state.currentPath.size;
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
      } else {
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

      state = state.copyWith(
        currentPath: path,
        isOnMainline: _root.isOnMainline(path),
        currentNode: AnalysisCurrentNode.fromNode(currentNode),
        lastMove: currentNode.sanMove.move,
        currentBranchOpening: opening,
        // root view is only used to display move list, so we need to
        // recompute the root view only when a new node is added
        root: isNewNode ? _root.view : state.root,
      );
    } else {
      state = state.copyWith(
        currentPath: path,
        isOnMainline: _root.isOnMainline(path),
        currentNode: AnalysisCurrentNode.fromNode(currentNode),
        currentBranchOpening: opening,
        lastMove: null,
      );
    }

    if (pathChange) {
      _debouncedStartEngineEval();
    }
  }

  Future<void> _fetchOpening(Node fromNode, UciPath path) async {
    if (!kOpeningAllowedVariants.contains(options.variant)) return;

    final moves = fromNode.nodesOn(path).map((node) => node.sanMove.move);
    if (moves.isEmpty) return;
    if (moves.length > 40) return;

    final opening =
        await ref.read(openingServiceProvider).fetchFromMoves(moves);

    if (opening != null) {
      fromNode.updateAt(path, (node) => node.opening = opening);

      if (state.currentPath == path) {
        state = state.copyWith(
          currentNode: AnalysisCurrentNode.fromNode(fromNode.nodeAt(path)),
        );
      }
    }
  }

  void _startEngineEval() {
    if (!state.isEngineAvailable) return;
    ref
        .read(evaluationServiceProvider)
        .start(
          state.currentPath,
          _root.nodesOn(state.currentPath).map(Step.fromNode),
          initialPositionEval: _root.eval,
          shouldEmit: (work) => work.path == state.currentPath,
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
    ref.read(evaluationServiceProvider).stop();
    // update the current node with last cached eval
    state = state.copyWith(
      currentNode:
          AnalysisCurrentNode.fromNode(_root.nodeAt(state.currentPath)),
    );
  }
}

enum DisplayMode {
  moves,
  summary,
}

@freezed
class AnalysisState with _$AnalysisState {
  const AnalysisState._();

  const factory AnalysisState({
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

    /// Analysis ID, useful for the evaluation context.
    required ID id,

    /// The side to display the board from.
    required Side pov,

    /// Whether local evaluation is allowed for this analysis.
    required bool isLocalEvaluationAllowed,

    /// Whether the user has enabled local evaluation.
    required bool isLocalEvaluationEnabled,

    /// Whether to show the ACPL chart instead of tree view.
    required DisplayMode displayMode,

    /// The last move played.
    Move? lastMove,

    /// Opening of the analysis context (from lichess archived games).
    Opening? contextOpening,

    /// The opening of the current branch.
    Opening? currentBranchOpening,

    /// Optional ACPL chart data of the game, coming from lichess server analysis.
    IList<Eval>? acplChartData,

    /// The PGN headers of the game.
    required IMap<String, String> pgnHeaders,

    /// The PGN comments of the game.
    ///
    /// This field is only used with user submitted PGNS.
    IList<PgnComment>? pgnRootComments,
  }) = _AnalysisState;

  IMap<String, ISet<String>> get validMoves =>
      algebraicLegalMoves(currentNode.position);

  bool get hasServerAnalysis => acplChartData != null;

  /// Whether an evaluation can be available
  bool get hasAvailableEval => isEngineAvailable || acplChartData != null;

  /// Whether the engine is available for evaluation
  bool get isEngineAvailable =>
      isLocalEvaluationAllowed &&
      engineSupportedVariants.contains(variant) &&
      isLocalEvaluationEnabled;

  Position get position => currentNode.position;
  bool get canGoNext => currentNode.hasChild;
  bool get canGoBack => currentPath.size > UciPath.empty.size;
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

  PgnEvaluation? get pgnEval =>
      comments?.firstWhereOrNull((c) => c.eval != null)?.eval;
}
