import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_repository.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/view/engine/engine_gauge.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_controller.freezed.dart';
part 'study_controller.g.dart';

@riverpod
class StudyController extends _$StudyController
    with EngineEvaluationMixin
    implements PgnTreeNotifier {
  late Root _root;

  Timer? _opponentFirstMoveTimer;
  StreamSubscription<SocketEvent>? _socketSubscription;
  final _likeDebouncer = Debouncer(const Duration(milliseconds: 500));

  late SocketClient _socketClient;

  @override
  @protected
  SocketClient get socketClient => _socketClient;

  @override
  @protected
  Root get positionTree => _root;

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
  StudyState get evaluationState => state.requireValue;

  @override
  Future<StudyState> build(StudyId id) async {
    ref.onDispose(() {
      _opponentFirstMoveTimer?.cancel();
      _socketSubscription?.cancel();
      _likeDebouncer.cancel();
      disposeEngineEvaluation();
    });

    final socketPool = ref.watch(socketPoolProvider);
    _socketClient = socketPool.open(Uri(path: '/study/$id/socket/v6'));

    final chapter = await _fetchChapter(id);

    _socketSubscription?.cancel();
    _socketSubscription = _socketClient.stream.listen(_handleSocketEvent);

    initEngineEvaluation();

    return chapter;
  }

  @override
  void onCurrentPathEvalChanged(bool isSameEvalString) {
    _refreshCurrentNode(recomputeRootView: !isSameEvalString);
  }

  void _refreshCurrentNode({bool recomputeRootView = false}) {
    state = AsyncData(
      state.requireValue.copyWith(
        root: recomputeRootView ? _root.view : state.requireValue.root,
        currentNode: StudyCurrentNode.fromNode(_root.nodeAt(state.requireValue.currentPath)),
      ),
    );
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
    await _fetchChapter(state.requireValue.study.id, chapterId: chapterId);
    _ensureItsOurTurnIfGamebook();
  }

  Future<StudyState> _fetchChapter(StudyId id, {StudyChapterId? chapterId}) async {
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
        // EvaluationContext needs an initial posiiton, but it doesn't matter what we pass here,
        // since the position is illegal and `isComputerAnalysisAllowed` is false anyway.
        evaluationContext: EvaluationContext(
          variant: variant,
          initialPosition: study.chapter.setup.variant.initialPosition,
        ),
        pgnRootComments: rootComments,
        pov: orientation,
        isComputerAnalysisAllowed: false,
        gamebookActive: false,
        pgn: pgn,
      );
    }

    const currentPath = UciPath.empty;
    Move? lastMove;

    final studyState = StudyState(
      variant: variant,
      study: study,
      currentPath: currentPath,
      isOnMainline: true,
      root: _root.view,
      currentNode: StudyCurrentNode.fromNode(_root),
      evaluationContext: EvaluationContext(variant: variant, initialPosition: _root.position),
      pgnRootComments: rootComments,
      lastMove: lastMove,
      pov: orientation,
      isComputerAnalysisAllowed: study.chapter.features.computer && !study.chapter.gamebook,
      gamebookActive: study.chapter.gamebook,
      pgn: pgn,
    );

    // We need to define the state value in the build method because `requestEval` require the state
    // to have a value.
    state = AsyncData(studyState);

    if (state.requireValue.isEngineAvailable(evaluationPrefs)) {
      socketClient.firstConnection.then((_) {
        requestEval();
      });
    }

    return studyState;
  }

  void toggleLike() {
    _likeDebouncer(() {
      if (!state.hasValue) return;
      final liked = state.requireValue.study.liked;
      _socketClient.send('like', {'liked': !liked});
      state = AsyncValue.data(
        state.requireValue.copyWith(study: state.requireValue.study.copyWith(liked: !liked)),
      );
    });
  }

  void _handleSocketEvent(SocketEvent event) {
    if (!state.hasValue) {
      assert(false, 'received a game SocketEvent while StudyState is null');
      return;
    }
    switch (event.topic) {
      case 'liking':
        final data = (event.data as Map<String, dynamic>)['l'] as Map<String, dynamic>;
        final likes = data['likes'] as int;
        final bool meLiked = data['me'] as bool;
        state = AsyncValue.data(
          state.requireValue.copyWith(
            study: state.requireValue.study.copyWith(liked: meLiked, likes: likes),
          ),
        );
    }
  }

  // The PGNs of some gamebook studies start with the opponent's turn, so trigger their move after a delay
  void _ensureItsOurTurnIfGamebook() {
    _opponentFirstMoveTimer?.cancel();
    if (state.requireValue.isAtStartOfChapter &&
        state.requireValue.gamebookActive &&
        state.requireValue.gamebookComment == null &&
        state.requireValue.currentPosition!.turn != state.requireValue.pov) {
      _opponentFirstMoveTimer = Timer(const Duration(milliseconds: 750), () {
        userNext();
      });
    }
  }

  void onUserMove(NormalMove move) {
    if (!state.hasValue || state.requireValue.currentPosition == null) return;

    if (!state.requireValue.currentPosition!.isLegal(move)) return;

    if (isPromotionPawnMove(state.requireValue.currentPosition!, move)) {
      state = AsyncValue.data(state.requireValue.copyWith(promotionMove: move));
      return;
    }

    final (newPath, isNewNode) = _root.addMoveAt(state.requireValue.currentPath, move);
    if (newPath != null) {
      _setPath(newPath, shouldRecomputeRootView: isNewNode, shouldForceShowVariation: true);
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

  void userPrevious() {
    if (state.hasValue) {
      _setPath(state.requireValue.currentPath.penultimate, isNavigating: true);
    }
  }

  void userNext() {
    final state = this.state.valueOrNull;
    if (state!.currentNode.children.isEmpty) return;
    _setPath(
      state.currentPath + _root.nodeAt(state.currentPath).children.first.id,
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
    final state = this.state.valueOrNull;
    if (state != null) {
      this.state = AsyncValue.data(state.copyWith(pov: state.pov.opposite));
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

    final childrenToShow = _root.isOnMainline(path) ? node.children.skip(1) : node.children;

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
      state.copyWith(isOnMainline: _root.isOnMainline(state.currentPath), root: _root.view),
    );
  }

  @override
  void deleteFromHere(UciPath path) {
    if (!state.hasValue) return;

    _root.deleteAt(path);
    _setPath(path.penultimate, shouldRecomputeRootView: true);
  }

  void _setPath(
    UciPath path, {
    bool shouldForceShowVariation = false,
    bool shouldRecomputeRootView = false,

    /// Whether the user is navigating through the moves (as opposed to playing a move).
    bool isNavigating = false,
  }) {
    final state = this.state.valueOrNull;
    if (state == null) return;

    final pathChange = state.currentPath != path;
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
    final rootView = shouldForceShowVariation || shouldRecomputeRootView ? _root.view : state.root;

    final isForward = path.size > state.currentPath.size;
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
      requestEval();
    }
  }
}

enum GamebookState { startLesson, findTheMove, correctMove, incorrectMove, lessonComplete }

@freezed
sealed class StudyState with _$StudyState implements EvaluationMixinState {
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

    /// The context that the local engine is initialized with.
    required EvaluationContext evaluationContext,

    /// The side to display the board from.
    required Side pov,

    /// Whether local evaluation is allowed for this study.
    required bool isComputerAnalysisAllowed,

    /// Whether we're currently in gamebook mode, where the user has to find the right moves.
    required bool gamebookActive,

    /// The last move played.
    Move? lastMove,

    /// Possible promotion move to be played.
    NormalMove? promotionMove,

    /// The PGN root comments of the study
    IList<PgnComment>? pgnRootComments,
  }) = _StudyState;

  @override
  bool get alwaysRequestCloudEval => false;

  /// Whether the engine is available for evaluation
  @override
  bool isEngineAvailable(EngineEvaluationPrefState prefs) =>
      isComputerAnalysisAllowed && engineSupportedVariants.contains(variant) && prefs.isEnabled;

  bool get isOpeningExplorerAvailable => !gamebookActive && study.chapter.features.explorer;

  EngineGaugeParams? engineGaugeParams(EngineEvaluationPrefState prefs) =>
      isEngineAvailable(prefs)
          ? (
            isLocalEngineAvailable: isEngineAvailable(prefs),
            orientation: pov,
            position: currentPosition!,
            savedEval: currentNode.eval,
            serverEval: null,
          )
          : null;

  @override
  Position? get currentPosition => currentNode.position;

  StudyChapter get currentChapter => study.chapter;
  bool get canGoNext => currentNode.children.isNotEmpty;
  bool get canGoBack => currentPath.size > UciPath.empty.size;

  String get currentChapterTitle {
    final index = study.getChapterIndex(currentChapter.id);
    return '${index + 1}. ${study.chapters[index].name}';
  }

  bool get hasNextChapter => study.chapter.id != study.chapters.last.id;

  bool get isAtEndOfChapter => isOnMainline && currentNode.children.isEmpty;

  bool get isAtStartOfChapter => currentPath.isEmpty;

  String? get gamebookComment {
    final comment = (currentNode.isRoot ? pgnRootComments : currentNode.comments)
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

  String? get gamebookDeviationComment => study.deviationComments.getOrNull(currentPath.size);

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

  bool get isIntroductoryChapter => currentNode.isRoot && currentNode.children.isEmpty;

  IList<PgnCommentShape> get pgnShapes => IList(
    (currentNode.isRoot ? pgnRootComments : currentNode.comments)
        ?.map((comment) => comment.shapes)
        .flattened,
  );

  PlayerSide get playerSide =>
      gamebookActive ? (pov == Side.white ? PlayerSide.white : PlayerSide.black) : PlayerSide.both;
}

@freezed
sealed class StudyCurrentNode with _$StudyCurrentNode {
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
    return const StudyCurrentNode(position: null, children: [], isRoot: true);
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
