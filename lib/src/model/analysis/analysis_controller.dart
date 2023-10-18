import 'dart:async';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/engine_evaluation.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/settings/analysis_preferences.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/model/analysis/opening_service.dart';

part 'analysis_controller.g.dart';
part 'analysis_controller.freezed.dart';

@freezed
class AnalysisOptions with _$AnalysisOptions {
  const factory AnalysisOptions({
    required ID id,
    required bool isLocalEvaluationAllowed,
    required Variant variant,
    required Side orientation,
    required String initialFen,
    required int initialPly,
    String? pgn,
    int? initialMoveCursor,
    LightOpening? opening,
  }) = _AnalysisOptions;
}

@riverpod
class AnalysisController extends _$AnalysisController {
  late final Root _root;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 500));

  Timer? _startEngineEvalTimer;

  @override
  AnalysisState build(AnalysisOptions options) {
    ref.onDispose(() {
      _startEngineEvalTimer?.cancel();
      _engineEvalDebounce.dispose();
    });

    final initialPosition = Position.setupPosition(
      options.variant.rules,
      Setup.parseFen(options.initialFen),
    );

    Root root = Root(position: initialPosition);
    UciPath path = UciPath.empty;
    Move? lastMove;
    IMap<String, String>? pgnHeaders =
        options.id is GameId ? null : _defaultPgnHeaders;

    if (options.pgn != null) {
      final game = PgnGame.parsePgn(options.pgn!);
      // only include headers if the game is not an online lichess game
      if (options.id is! GameId) {
        pgnHeaders = pgnHeaders?.addMap(game.headers) ?? IMap(game.headers);
      }

      root = Root.fromPgnGame(game, (root, branch, isMainline) {
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
    }

    _root = root;

    final currentPath =
        options.initialMoveCursor == null ? _root.mainlinePath : path;
    final currentNode = _root.nodeAt(currentPath);

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    final evalContext = EvaluationContext(
      variant: options.variant,
      initialPosition: _root.position,
      contextId: options.id,
      multiPv: prefs.numEvalLines,
      cores: prefs.numEngineCores,
    );

    _startEngineEvalTimer = Timer(const Duration(milliseconds: 300), () {
      _startEngineEval();
    });

    return AnalysisState(
      id: options.id,
      isLocalEvaluationAllowed: options.isLocalEvaluationAllowed,
      isLocalEvaluationEnabled: prefs.enableLocalEvaluation,
      initialPath: UciPath.empty,
      currentPath: currentPath,
      root: _root.view,
      currentNode: currentNode.view,
      pgnHeaders: pgnHeaders,
      lastMove: lastMove,
      pov: options.orientation,
      evaluationContext: evalContext,
      contextOpening: options.opening,
    );
  }

  void onUserMove(Move move) {
    if (!state.position.isLegal(move)) return;
    final (newPath, isNewNode) = _root.addMoveAt(state.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, isNewNode: isNewNode);
    }
  }

  void userNext() {
    if (state.currentNode.children.isEmpty) return;
    _setPath(
      state.currentPath + state.currentNode.children.first.id,
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
      _startEngineEval();
    } else {
      _stopEngineEval();
    }
  }

  void setNumEvalLines(int numEvalLines) {
    ref
        .read(analysisPreferencesProvider.notifier)
        .setNumEvalLines(numEvalLines);

    _stopEngineEval();

    _root.updateAll((node) => node.eval = null);

    state = state.copyWith(
      evaluationContext: state.evaluationContext.copyWith(
        multiPv: numEvalLines,
      ),
      currentNode: _root.nodeAt(state.currentPath).view,
    );

    _startEngineEval();
  }

  void setEngineCores(int numEngineCores) {
    ref
        .read(analysisPreferencesProvider.notifier)
        .setEngineCores(numEngineCores);

    _stopEngineEval();

    state = state.copyWith(
      evaluationContext: state.evaluationContext.copyWith(
        cores: numEngineCores,
      ),
    );

    _startEngineEval();
  }

  void updatePgnHeader(String key, String value) {
    final headers = state.pgnHeaders?.add(key, value) ?? IMap({key: value});
    state = state.copyWith(pgnHeaders: headers);
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
    return _root.makePgn(state.pgnHeaders);
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
        currentNode: currentNode.view,
        lastMove: currentNode.sanMove.move,
        currentBranchOpening: opening,
        // root view is only used to display move list, so we need to
        // recompute the root view only when a new node is added
        root: isNewNode ? _root.view : state.root,
      );
    } else {
      state = state.copyWith(
        currentPath: path,
        currentNode: state.root,
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
        state = state.copyWith(currentNode: fromNode.nodeAt(path).view);
      }
    }
  }

  void _startEngineEval() {
    if (!state.isEngineAvailable) return;
    ref
        .read(
          engineEvaluationProvider(state.evaluationContext).notifier,
        )
        .start(
          state.currentPath,
          _root.nodesOn(state.currentPath).map(Step.fromNode),
          state.currentNode.position,
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
    ref.read(engineEvaluationProvider(state.evaluationContext).notifier).stop();
  }
}

@freezed
class AnalysisState with _$AnalysisState {
  const AnalysisState._();

  const factory AnalysisState({
    required ViewRoot root,
    required ViewNode currentNode,
    required UciPath initialPath,
    required UciPath currentPath,
    required ID id,
    required Side pov,
    required EvaluationContext evaluationContext,
    required bool isLocalEvaluationAllowed,
    required bool isLocalEvaluationEnabled,
    Move? lastMove,
    Opening? contextOpening,
    Opening? currentBranchOpening,
    IMap<String, String>? pgnHeaders,
  }) = _AnalysisState;

  IMap<String, ISet<String>> get validMoves =>
      algebraicLegalMoves(currentNode.position);

  bool get isEngineAvailable =>
      isLocalEvaluationAllowed &&
      isLocalEvaluationEnabled &&
      engineSupportedVariants.contains(
        evaluationContext.variant,
      );

  Position get position => currentNode.position;
  bool get canGoNext => currentNode.children.isNotEmpty;
  bool get canGoBack => currentPath.size > initialPath.size;
}

const IMap<String, String> _defaultPgnHeaders = IMapConst({
  'Event': '?',
  'Site': '?',
  'Date': '????.??.??',
  'Round': '?',
  'White': '?',
  'Black': '?',
  'Result': '*',
  'WhiteElo': '?',
  'BlackElo': '?',
});
