import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/engine/work.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_controller.freezed.dart';
part 'study_controller.g.dart';

@riverpod
class StudyController extends _$StudyController implements PgnTreeNotifier {
  late Root _root;

  final _engineEvalDebounce = Debouncer(const Duration(milliseconds: 150));

  Timer? _startEngineEvalTimer;

  Timer? _opponentFirstMoveTimer;

  @override
  Future<StudyState> build(StudyId id) async {
    final evaluationService = ref.watch(evaluationServiceProvider);
    ref.onDispose(() {
      _startEngineEvalTimer?.cancel();
      _opponentFirstMoveTimer?.cancel();
      _engineEvalDebounce.dispose();
      evaluationService.disposeEngine();
    });
    return _fetchChapter(id);
  }

  Future<void> nextChapter() async {
    if (state.hasValue) {
      final chapters = state.requireValue.study.chapters;
      final currentChapterIndex = chapters.indexWhere(
        (chapter) => chapter.id == state.requireValue.study.chapter.id,
      );
      goToChapter(chapters[currentChapterIndex + 1].id);
    }
  }

  Future<void> goToChapter(StudyChapterId chapterId) async {
    state = AsyncValue.data(
      await _fetchChapter(
        state.requireValue.study.id,
        chapterId: chapterId,
      ),
    );
    _ensureItsOurTurnIfGamebook();
  }

  Future<StudyState> _fetchChapter(
    StudyId id, {
    StudyChapterId? chapterId,
  }) async {
    final (study, pgn) = await ref
        .read(studyRepositoryProvider)
        .getStudy(id: id, chapterId: chapterId);

    final game = PgnGame.parsePgn(pgn);

    final rootComments = IList(game.comments.map((c) => PgnComment.fromPgn(c)));

    final variant = study.chapter.setup.variant;
    final orientation = study.chapter.setup.orientation;

    // Some studies have illegal starting positions. This is usually the case for introductory chapters.
    // We do not treat this as an error, but display a static board instead.
    try {
      _root = Root.fromPgnGame(game);
    } on PositionSetupException {
      return StudyState(
        variant: variant,
        study: study,
        currentPath: UciPath.empty,
        isOnMainline: true,
        root: null,
        currentNode: StudyCurrentNode.illegalPosition(),
        pgnRootComments: rootComments,
        pov: orientation,
        isComputerAnalysisAllowed: false,
        isLocalEvaluationEnabled: false,
        gamebookActive: false,
        pgn: pgn,
      );
    }

    // don't use ref.watch here: we don't want to invalidate state when the
    // analysis preferences change
    final prefs = ref.read(analysisPreferencesProvider);

    const currentPath = UciPath.empty;
    Move? lastMove;

    final studyState = StudyState(
      variant: variant,
      study: study,
      currentPath: currentPath,
      isOnMainline: true,
      root: _root.view,
      currentNode: StudyCurrentNode.fromNode(_root),
      pgnRootComments: rootComments,
      lastMove: lastMove,
      pov: orientation,
      isComputerAnalysisAllowed:
          study.chapter.features.computer && !study.chapter.gamebook,
      isLocalEvaluationEnabled: prefs.enableLocalEvaluation,
      gamebookActive: study.chapter.gamebook,
      pgn: pgn,
    );

    final evaluationService = ref.watch(evaluationServiceProvider);
    if (studyState.isEngineAvailable) {
      await evaluationService.disposeEngine();

      evaluationService
          .initEngine(
        _evaluationContext(studyState.variant),
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

    return studyState;
  }

  // The PGNs of some gamebook studies start with the opponent's turn, so trigger their move after a delay
  void _ensureItsOurTurnIfGamebook() {
    _opponentFirstMoveTimer?.cancel();
    if (state.requireValue.isAtStartOfChapter &&
        state.requireValue.gamebookActive &&
        state.requireValue.gamebookComment == null &&
        state.requireValue.position!.turn != state.requireValue.pov) {
      _opponentFirstMoveTimer = Timer(const Duration(milliseconds: 750), () {
        userNext();
      });
    }
  }

  EvaluationContext _evaluationContext(Variant variant) => EvaluationContext(
        variant: variant,
        initialPosition: _root.position,
      );

  void onUserMove(NormalMove move) {
    if (!state.hasValue || state.requireValue.position == null) return;

    if (!state.requireValue.position!.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.position!, move)) {
      state = AsyncValue.data(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    final (newPath, isNewNode) =
        _root.addMoveAt(state.requireValue.currentPath, move);
    if (newPath != null) {
      _setPath(
        newPath,
        shouldRecomputeRootView: isNewNode,
        shouldForceShowVariation: true,
      );
    }

    if (state.requireValue.gamebookActive) {
      final comment = state.requireValue.gamebookComment;
      // If there's no explicit comment why the move was good/bad, trigger next/previous move automatically
      if (comment == null) {
        Timer(const Duration(milliseconds: 750), () {
          if (state.requireValue.isOnMainline) {
            userNext();
          } else {
            userPrevious();
          }
        });
      }
    }
  }

  void onPromotionSelection(Role? role) {
    final state = this.state.valueOrNull;
    if (state == null) return;

    if (role == null) {
      this.state = AsyncValue.data(state.copyWith(promotionMove: null));
      return;
    }
    final promotionMove = state.promotionMove;
    if (promotionMove != null) {
      final promotion = promotionMove.withPromotion(role);
      onUserMove(promotion);
    }
  }

  void showGamebookSolution() {
    onUserMove(state.requireValue.currentNode.children.first as NormalMove);
  }

  void userNext() {
    final state = this.state.valueOrNull;
    if (state!.currentNode.children.isEmpty) return;
    _setPath(
      state.currentPath + _root.nodeAt(state.currentPath).children.first.id,
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
    final state = this.state.valueOrNull;
    if (state != null) {
      this.state = AsyncValue.data(state.copyWith(pov: state.pov.opposite));
    }
  }

  void userPrevious() {
    if (state.hasValue) {
      _setPath(state.requireValue.currentPath.penultimate, replaying: true);
    }
  }

  void reset() {
    if (state.hasValue) {
      _setPath(UciPath.empty);
      _ensureItsOurTurnIfGamebook();
    }
  }

  @override
  void userJump(UciPath path) {
    _setPath(path);
  }

  @override
  void expandVariations(UciPath path) {
    if (!state.hasValue) return;

    final node = _root.nodeAt(path);

    final childrenToShow =
        _root.isOnMainline(path) ? node.children.skip(1) : node.children;

    for (final child in childrenToShow) {
      child.isCollapsed = false;
      for (final grandChild in child.children) {
        grandChild.isCollapsed = false;
      }
    }
    state = AsyncValue.data(state.requireValue.copyWith(root: _root.view));
  }

  @override
  void collapseVariations(UciPath path) {
    if (!state.hasValue) return;

    final node = _root.nodeAt(path);

    for (final child in node.children) {
      child.isCollapsed = true;
    }

    state = AsyncValue.data(state.requireValue.copyWith(root: _root.view));
  }

  @override
  void promoteVariation(UciPath path, bool toMainline) {
    final state = this.state.valueOrNull;
    if (state == null) return;
    _root.promoteAt(path, toMainline: toMainline);
    this.state = AsyncValue.data(
      state.copyWith(
        isOnMainline: _root.isOnMainline(state.currentPath),
        root: _root.view,
      ),
    );
  }

  @override
  void deleteFromHere(UciPath path) {
    if (!state.hasValue) return;

    _root.deleteAt(path);
    _setPath(path.penultimate, shouldRecomputeRootView: true);
  }

  Future<void> toggleLocalEvaluation() async {
    if (!state.hasValue) return;

    ref
        .read(analysisPreferencesProvider.notifier)
        .toggleEnableLocalEvaluation();

    state = AsyncValue.data(
      state.requireValue.copyWith(
        isLocalEvaluationEnabled: !state.requireValue.isLocalEvaluationEnabled,
      ),
    );

    if (state.requireValue.isEngineAvailable) {
      final prefs = ref.read(analysisPreferencesProvider);
      await ref.read(evaluationServiceProvider).initEngine(
            _evaluationContext(state.requireValue.variant),
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

    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentNode: StudyCurrentNode.fromNode(
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

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,
    bool replaying = false,
  }) {
    final state = this.state.valueOrNull;
    if (state == null) return;

    final pathChange = state.currentPath != path;
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
        : state.root;

    final isForward = path.size > state.currentPath.size;
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

      this.state = AsyncValue.data(
        state.copyWith(
          currentPath: path,
          isOnMainline: _root.isOnMainline(path),
          currentNode: StudyCurrentNode.fromNode(currentNode),
          lastMove: currentNode.sanMove.move,
          promotionMove: null,
          root: rootView,
        ),
      );
    } else {
      this.state = AsyncValue.data(
        state.copyWith(
          currentPath: path,
          isOnMainline: _root.isOnMainline(path),
          currentNode: StudyCurrentNode.fromNode(currentNode),
          lastMove: null,
          promotionMove: null,
          root: rootView,
        ),
      );
    }

    if (pathChange) {
      _debouncedStartEngineEval();
    }
  }

  void _startEngineEval() {
    final state = this.state.valueOrNull;
    if (state == null || !state.isEngineAvailable) return;

    ref
        .read(evaluationServiceProvider)
        .start(
          state.currentPath,
          _root.branchesOn(state.currentPath).map(Step.fromNode),
          // Note: AnalysisController passes _root.eval as initialPositionEval here,
          // but for studies this leads to false positive cache hits when switching between chapters.
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

    if (!state.hasValue) return;

    // update the current node with last cached eval
    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentNode: StudyCurrentNode.fromNode(
          _root.nodeAt(state.requireValue.currentPath),
        ),
      ),
    );
  }
}

enum GamebookState {
  startLesson,
  findTheMove,
  correctMove,
  incorrectMove,
  lessonComplete
}

@freezed
class StudyState with _$StudyState {
  const StudyState._();

  const factory StudyState({
    required Study study,
    required String pgn,

    /// The variant of the current chapter
    required Variant variant,

    /// Immutable view of the whole tree. Null if the chapter's starting position is illegal.
    required ViewRoot? root,

    /// The current node in the study tree view.
    ///
    /// This is an immutable copy of the actual [Node] at the `currentPath`.
    /// We don't want to use [Node.view] here because it'd copy the whole tree
    /// under the current node and it's expensive.
    required StudyCurrentNode currentNode,

    /// The path to the current node in the analysis view.
    required UciPath currentPath,

    /// Whether the current path is on the mainline.
    required bool isOnMainline,

    /// The side to display the board from.
    required Side pov,

    /// Whether local evaluation is allowed for this study.
    required bool isComputerAnalysisAllowed,

    /// Whether we're currently in gamebook mode, where the user has to find the right moves.
    required bool gamebookActive,

    /// Whether the user has enabled local evaluation.
    required bool isLocalEvaluationEnabled,

    /// The last move played.
    Move? lastMove,

    /// Possible promotion move to be played.
    NormalMove? promotionMove,

    /// The PGN root comments of the study
    IList<PgnComment>? pgnRootComments,
  }) = _StudyState;

  IMap<Square, ISet<Square>> get validMoves => currentNode.position != null
      ? makeLegalMoves(currentNode.position!)
      : const IMap.empty();

  /// Whether the engine is available for evaluation
  bool get isEngineAvailable =>
      isComputerAnalysisAllowed &&
      engineSupportedVariants.contains(variant) &&
      isLocalEvaluationEnabled;

  EngineGaugeParams? get engineGaugeParams => isEngineAvailable
      ? (
          orientation: pov,
          isLocalEngineAvailable: isEngineAvailable,
          position: position!,
          savedEval: currentNode.eval,
        )
      : null;

  Position? get position => currentNode.position;
  StudyChapter get currentChapter => study.chapter;
  bool get canGoNext => currentNode.children.isNotEmpty;
  bool get canGoBack => currentPath.size > UciPath.empty.size;

  String get currentChapterTitle => study.chapters
      .firstWhere(
        (chapter) => chapter.id == currentChapter.id,
      )
      .name;
  bool get hasNextChapter => study.chapter.id != study.chapters.last.id;

  bool get isAtEndOfChapter => isOnMainline && currentNode.children.isEmpty;

  bool get isAtStartOfChapter => currentPath.isEmpty;

  String? get gamebookComment {
    final comment =
        (currentNode.isRoot ? pgnRootComments : currentNode.comments)
            ?.map((comment) => comment.text)
            .nonNulls
            .join('\n');
    return comment?.isNotEmpty == true
        ? comment
        : gamebookState == GamebookState.incorrectMove
            ? gamebookDeviationComment
            : null;
  }

  String? get gamebookHint => study.hints.getOrNull(currentPath.size);

  String? get gamebookDeviationComment =>
      study.deviationComments.getOrNull(currentPath.size);

  GamebookState get gamebookState {
    if (isAtEndOfChapter) return GamebookState.lessonComplete;

    final bool myTurn = currentNode.position!.turn == pov;
    if (isAtStartOfChapter && !myTurn) return GamebookState.startLesson;

    return myTurn
        ? GamebookState.findTheMove
        : isOnMainline
            ? GamebookState.correctMove
            : GamebookState.incorrectMove;
  }

  bool get isIntroductoryChapter =>
      currentNode.isRoot && currentNode.children.isEmpty;

  IList<PgnCommentShape> get pgnShapes => IList(
        (currentNode.isRoot ? pgnRootComments : currentNode.comments)
            ?.map((comment) => comment.shapes)
            .flattened,
      );

  PlayerSide get playerSide => gamebookActive
      ? (pov == Side.white ? PlayerSide.white : PlayerSide.black)
      : PlayerSide.both;
}

@freezed
class StudyCurrentNode with _$StudyCurrentNode {
  const StudyCurrentNode._();

  const factory StudyCurrentNode({
    // Null if the chapter's starting position is illegal.
    required Position? position,
    required List<Move> children,
    required bool isRoot,
    SanMove? sanMove,
    IList<PgnComment>? startingComments,
    IList<PgnComment>? comments,
    IList<int>? nags,
    ClientEval? eval,
  }) = _StudyCurrentNode;

  factory StudyCurrentNode.illegalPosition() {
    return const StudyCurrentNode(
      position: null,
      children: [],
      isRoot: true,
    );
  }

  factory StudyCurrentNode.fromNode(Node node) {
    final children = node.children.map((n) => n.sanMove.move).toList();
    if (node is Branch) {
      return StudyCurrentNode(
        sanMove: node.sanMove,
        position: node.position,
        isRoot: false,
        children: children,
        eval: node.eval,
        startingComments: IList(node.startingComments),
        comments: IList(node.comments),
        nags: IList(node.nags),
      );
    } else {
      return StudyCurrentNode(
        position: node.position,
        children: children,
        eval: node.eval,
        isRoot: true,
      );
    }
  }
}
