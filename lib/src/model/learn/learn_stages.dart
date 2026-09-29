import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/learn/learn_assert.dart';
import 'package:lichess_mobile/src/model/learn/learn_level.dart';

/// The learn stages, ported from `ui/learn/src/stage/*.ts` on lichess.org.
///
/// Keep the order and the content in sync with the website: progress is stored per stage key and
/// level index, and will be synced with lichess.org.

/// All the categories, in display order.
final IList<LearnCategory> learnCategories = IList([
  LearnCategory(
    key: 'chess-pieces',
    name: (l) => l.learnChessPieces,
    stages: IList([_rook, _bishop, _queen, _king, _knight, _pawn]),
  ),
  LearnCategory(
    key: 'fundamentals',
    name: (l) => l.learnFundamentals,
    stages: IList([_capture, _protection, _combat, _check1, _outOfCheck, _checkmate1]),
  ),
  LearnCategory(
    key: 'intermediate',
    name: (l) => l.learnIntermediate,
    stages: IList([_setup, _castling, _enpassant, _stalemate]),
  ),
  LearnCategory(key: 'advanced', name: (l) => l.learnAdvanced, stages: IList([_value, _check2])),
]);

/// All the stages, in display order.
final IList<LearnStage> learnStages = learnCategories.expand((c) => c.stages).toIList();

/// The stage with the given [key], if any.
LearnStage? learnStageByKey(String key) => learnStages.firstWhereOrNull((s) => s.key == key);

ScenarioStep _step(String uci, [List<LearnShape> shapes = const []]) =>
    ScenarioStep(uci, shapes: shapes.lock);

// -- Chess pieces

final _rook = LearnStage(
  key: 'rook',
  title: (l) => l.learnTheRook,
  subtitle: (l) => l.learnItMovesInStraightLines,
  image: 'pieces/R',
  intro: (l) => l.learnRookIntro,
  complete: (l) => l.learnRookComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnRookGoal,
      fen: '8/8/8/8/8/8/4R3/8 w - -',
      apples: 'e7',
      nbMoves: 1,
      shapes: [arrow('e2e7')],
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/2R5/8/8/8/8/8/8 w - -',
      apples: 'c5 g5',
      nbMoves: 2,
      shapes: [arrow('c7c5'), arrow('c5g5')],
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTheFewerMoves,
      fen: '8/8/8/8/3R4/8/8/8 w - -',
      apples: 'a4 g3 g4',
      nbMoves: 3,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTheFewerMoves,
      fen: '7R/8/8/8/8/8/8/8 w - -',
      apples: 'f8 g1 g7 g8 h7',
      nbMoves: 5,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnUseTwoRooks,
      fen: '8/1R6/8/8/3R4/8/8/8 w - -',
      apples: 'a4 g3 g7 h4',
      nbMoves: 4,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnUseTwoRooks,
      fen: '8/8/8/8/8/5R2/8/R7 w - -',
      apples: 'b7 d1 d5 f2 f7 g4 g7',
      nbMoves: 7,
    ),
  ]),
);

final _bishop = LearnStage(
  key: 'bishop',
  title: (l) => l.learnTheBishop,
  subtitle: (l) => l.learnItMovesDiagonally,
  image: 'pieces/B',
  intro: (l) => l.learnBishopIntro,
  complete: (l) => l.learnBishopComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/8/5B2/8/8 w - -',
      apples: 'd5 g8',
      nbMoves: 2,
      shapes: [arrow('f3d5'), arrow('d5g8')],
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTheFewerMoves,
      fen: '8/8/8/8/8/1B6/8/8 w - -',
      apples: 'a2 b1 b5 d1 d3 e2',
      nbMoves: 6,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/3B4/8/8/8 w - -',
      apples: 'a1 b6 c1 e3 g7 h6',
      nbMoves: 6,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/2B5/8/8/8 w - -',
      apples: 'a4 b1 b3 c2 d3 e2',
      nbMoves: 6,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnYouNeedBothBishops,
      fen: '8/8/8/8/8/8/8/2B2B2 w - -',
      apples: 'd3 d4 d5 e3 e4 e5',
      nbMoves: 6,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnYouNeedBothBishops,
      fen: '8/3B4/8/8/8/2B5/8/8 w - -',
      apples: 'a3 c2 e7 f5 f6 g8 h4 h7',
      nbMoves: 11,
    ),
  ]),
);

final _queen = LearnStage(
  key: 'queen',
  title: (l) => l.learnTheQueen,
  subtitle: (l) => l.learnQueenCombinesRookAndBishop,
  image: 'pieces/Q',
  intro: (l) => l.learnQueenIntro,
  complete: (l) => l.learnQueenComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/8/8/4Q3/8 w - -',
      apples: 'e5 b8',
      nbMoves: 2,
      shapes: [arrow('e2e5'), arrow('e5b8')],
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/3Q4/8/8/8 w - -',
      apples: 'a3 f2 f8 h3',
      nbMoves: 4,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/2Q5/8/8/8 w - -',
      apples: 'a3 d6 f1 f8 g3 h6',
      nbMoves: 6,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/6Q1/8/8/8/8/8/8 w - -',
      apples: 'a2 b5 d3 g1 g8 h2 h5',
      nbMoves: 7,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/8/8/8/4Q3 w - -',
      apples: 'a6 d1 f2 f6 g6 g8 h1 h4',
      nbMoves: 9,
    ),
  ]),
);

final _king = LearnStage(
  key: 'king',
  title: (l) => l.learnTheKing,
  subtitle: (l) => l.learnTheMostImportantPiece,
  image: 'pieces/K',
  intro: (l) => l.learnKingIntro,
  complete: (l) => l.learnKingComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnTheKingIsSlow,
      fen: '8/8/8/8/8/3K4/8/8 w - -',
      apples: 'e6',
      nbMoves: 3,
      shapes: [arrow('d3d4'), arrow('d4d5'), arrow('d5e6')],
      emptyApples: true,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/8/8/8/4K3 w - -',
      apples: 'c2 d3 e2 e3',
      nbMoves: 4,
      emptyApples: true,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnLastOne,
      fen: '8/8/8/4K3/8/8/8/8 w - -',
      apples: 'b5 c5 d6 e3 f3 g4',
      nbMoves: 8,
      emptyApples: true,
    ),
  ]),
);

final _knight = LearnStage(
  key: 'knight',
  title: (l) => l.learnTheKnight,
  subtitle: (l) => l.learnItMovesInAnLShape,
  image: 'pieces/N',
  intro: (l) => l.learnKnightIntro,
  complete: (l) => l.learnKnightComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnKnightsHaveAFancyWay,
      fen: '8/8/8/8/4N3/8/8/8 w - -',
      apples: 'c5 d7',
      nbMoves: 2,
      shapes: [arrow('e4c5'), arrow('c5d7')],
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/8/8/8/1N6 w - -',
      apples: 'c3 d4 e2 f3 f7 g5 h8',
      nbMoves: 8,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/2N5/8/8/8/8/8/8 w - -',
      apples: 'b6 d5 d7 e6 f4',
      nbMoves: 5,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnKnightsCanJumpOverObstacles,
      fen: '8/8/8/8/5N2/8/8/8 w - -',
      apples: 'e3 e4 e5 f3 f5 g3 g4 g5',
      nbMoves: 9,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/8/8/8/8/3N4/8/8 w - -',
      apples: 'c3 e2 e4 f2 f4 g6',
      nbMoves: 6,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStars,
      fen: '8/2N5/8/8/8/8/8/8 w - -',
      apples: 'b4 b5 c6 c8 d4 d5 e3 e7 f5',
      nbMoves: 9,
    ),
  ]),
);

final _pawn = LearnStage(
  key: 'pawn',
  title: (l) => l.learnThePawn,
  subtitle: (l) => l.learnItMovesForwardOnly,
  image: 'pieces/P',
  intro: (l) => l.learnPawnIntro,
  complete: (l) => l.learnPawnComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnPawnsMoveOneSquareOnly,
      fen: '8/8/8/P7/8/8/8/8 w - -',
      apples: 'f3',
      nbMoves: 4,
      shapes: [arrow('a5a6'), arrow('a6a7'), arrow('a7a8'), arrow('a8f3')],
      explainPromotion: true,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnMostOfTheTimePromotingToAQueenIsBest,
      fen: '8/8/8/5P2/8/8/8/8 w - -',
      apples: 'b6 c4 d7 e5 a8',
      nbMoves: 8,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnPawnsMoveForward,
      fen: '8/8/8/8/8/4P3/8/8 w - -',
      apples: 'c6 d5 d7',
      nbMoves: 4,
      shapes: [arrow('e3e4'), arrow('e4d5'), arrow('d5c6'), arrow('c6d7')],
      failure: .noPieceOn('e3 e4 c6 d5 d7'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnCaptureThenPromote,
      fen: '8/8/8/8/8/1P6/8/8 w - -',
      apples: 'b4 b6 c4 c6 c7 d6',
      nbMoves: 8,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnCaptureThenPromote,
      fen: '8/8/8/8/8/3P4/8/8 w - -',
      apples: 'c4 b5 b6 d5 d7 e6 c8',
      failure: .whitePawnOnAnyOf('b5 d4 d6 c7'),
      nbMoves: 8,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnUseAllThePawns,
      fen: '8/8/8/8/8/P1PP3P/8/8 w - -',
      apples: 'b5 c5 d4 e5 g4',
      nbMoves: 7,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnAPawnOnTheSecondRank,
      fen: '8/8/8/8/8/8/4P3/8 w - -',
      apples: 'd6',
      nbMoves: 3,
      shapes: [arrow('e2e4')],
      failure: .whitePawnOnAnyOf('e3'),
      highlightedRank: 2,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnGrabAllTheStarsNoNeedToPromote,
      fen: '8/8/8/8/8/8/2PPPP2/8 w - -',
      apples: 'c5 d5 e5 f5 d3 e4',
      nbMoves: 9,
    ),
  ]),
);

// -- Fundamentals

final _capture = LearnStage(
  key: 'capture',
  title: (l) => l.learnCapture,
  subtitle: (l) => l.learnTakeTheEnemyPieces,
  image: 'bowman',
  intro: (l) => l.learnCaptureIntro,
  complete: (l) => l.learnCaptureComplete,
  levels: IList([
    // rook
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPieces,
      fen: '8/2p2p2/8/8/8/2R5/8/8 w - -',
      nbMoves: 2,
      captures: 2,
      shapes: [arrow('c3c7'), arrow('c7f7')],
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    // queen
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '8/2r2p2/8/8/5Q2/8/8/8 w - -',
      nbMoves: 2,
      captures: 2,
      shapes: [arrow('f4c7'), arrow('f4f7', .red), arrow('c7f7', .yellow)],
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    // bishop
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '8/5r2/8/1r3p2/8/3B4/8/8 w - -',
      nbMoves: 5,
      captures: 3,
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    // queen
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '8/5b2/5p2/3n2p1/8/6Q1/8/8 w - -',
      nbMoves: 7,
      captures: 4,
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    // knight
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '8/3b4/2p2q2/8/3p1N2/8/8/8 w - -',
      nbMoves: 6,
      captures: 4,
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
  ]),
);

final _protection = LearnStage(
  key: 'protection',
  title: (l) => l.learnProtection,
  subtitle: (l) => l.learnKeepYourPiecesSafe,
  image: 'bolt-shield',
  intro: (l) => l.learnProtectionIntro,
  complete: (l) => l.learnProtectionComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnEscape,
      fen: '8/8/8/4bb2/8/8/P2P4/R2K4 w - -',
      nbMoves: 1,
      shapes: [arrow('e5a1', .red), arrow('a1c1')],
    ),
    // escape
    LearnLevel.parse(goal: (l) => l.learnEscape, fen: '8/8/2q2N2/8/8/8/8/8 w - -', nbMoves: 1),
    // protect
    LearnLevel.parse(
      goal: (l) => l.learnNoEscape,
      fen: '8/N2q4/8/8/8/8/6R1/8 w - -',
      nbMoves: 1,
      scenario: [
        _step('g2a2', [arrow('a2a7', .green)]),
      ],
    ),
    LearnLevel.parse(goal: (l) => l.learnNoEscape, fen: '8/8/1Bq5/8/2P5/8/8/8 w - -', nbMoves: 1),
    LearnLevel.parse(
      goal: (l) => l.learnNoEscape,
      fen: '1r6/8/5b2/8/8/5N2/P2P4/R1B5 w - -',
      nbMoves: 1,
      shapes: [arrow('f6a1', .red), arrow('d2d4')],
    ),
    LearnLevel.parse(
      goal: (l) => l.learnDontLetThemTakeAnyUndefendedPiece,
      fen: '8/1b6/8/8/8/3P2P1/5NRP/r7 w - -',
      nbMoves: 1,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnDontLetThemTakeAnyUndefendedPiece,
      fen: 'rr6/3q4/4n3/4P1B1/7P/P7/1B1N1PP1/R5K1 w - -',
      nbMoves: 1,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnDontLetThemTakeAnyUndefendedPiece,
      fen: '8/3q4/8/1N3R2/8/2PB4/8/8 w - -',
      nbMoves: 1,
    ),
  ]),
);

final _combat = LearnStage(
  key: 'combat',
  title: (l) => l.learnCombat,
  subtitle: (l) => l.learnCaptureAndDefendPieces,
  image: 'battle-gear',
  intro: (l) => l.learnCombatIntro,
  complete: (l) => l.learnCombatComplete,
  levels: IList([
    // rook
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '8/8/8/8/P2r4/6B1/8/8 w - -',
      nbMoves: 3,
      captures: 1,
      shapes: [arrow('a4a5'), arrow('g3f2'), arrow('f2d4'), arrow('d4a4', .yellow)],
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '2r5/8/3b4/2P5/8/1P6/2B5/8 w - -',
      nbMoves: 4,
      captures: 2,
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '1r6/8/5n2/3P4/4P1P1/1Q6/8/8 w - -',
      nbMoves: 4,
      captures: 2,
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '2r5/8/3N4/5b2/8/8/PPP5/8 w - -',
      nbMoves: 4,
      captures: 2,
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTakeTheBlackPiecesAndDontLoseYours,
      fen: '8/6q1/8/4P1P1/8/4B3/r2P2N1/8 w - -',
      nbMoves: 8,
      captures: 2,
      pointsForCapture: true,
      success: .extinct(Side.black),
    ),
  ]),
);

LearnLevel _check1Level({required String fen, List<LearnShape> shapes = const []}) =>
    LearnLevel.parse(
      goal: (l) => l.learnCheckInOneGoal,
      fen: fen,
      shapes: shapes,
      nbMoves: 1,
      failure: .check.not,
      success: .check,
    );

final _check1 = LearnStage(
  key: 'check1',
  title: (l) => l.learnCheckInOne,
  subtitle: (l) => l.learnAttackTheOpponentsKing,
  image: 'winged-sword',
  intro: (l) => l.learnCheckInOneIntro,
  complete: (l) => l.learnCheckInOneComplete,
  levels: IList([
    _check1Level(fen: '4k3/8/2b5/8/8/8/8/R7 w - -', shapes: [arrow('a1e1')]),
    _check1Level(fen: '8/8/4k3/3n4/8/1Q6/8/8 w - -'),
    _check1Level(fen: '3qk3/1pp5/3p4/4p3/8/3B4/6r1/8 w - -'),
    _check1Level(fen: '2r2q2/2n5/8/4k3/8/2N1P3/3P2B1/8 w - -'),
    _check1Level(fen: '8/2b1q2n/1ppk4/2N5/8/8/8/8 w - -'),
    _check1Level(fen: '6R1/1k3r2/8/4Q3/8/2n5/8/8 w - -'),
    _check1Level(fen: '7r/4k3/8/3n4/4N3/8/2R5/4Q3 w - -'),
  ]),
);

LearnLevel _outOfCheckLevel({
  required LearnText goal,
  required String fen,
  List<LearnShape> shapes = const [],
}) => LearnLevel.parse(
  goal: goal,
  fen: fen,
  shapes: shapes,
  detectCapture: .none,
  offerIllegalMove: true,
  nbMoves: 1,
);

final _outOfCheck = LearnStage(
  key: 'outOfCheck',
  title: (l) => l.learnOutOfCheck,
  subtitle: (l) => l.learnDefendYourKing,
  image: 'guards',
  intro: (l) => l.learnOutOfCheckIntro,
  complete: (l) => l.learnOutOfCheckComplete,
  levels: IList([
    _outOfCheckLevel(
      goal: (l) => l.learnEscapeWithTheKing,
      fen: '8/8/8/4q3/8/8/8/4K3 w - -',
      shapes: [arrow('e5e1', .red), arrow('e1f1')],
    ),
    _outOfCheckLevel(goal: (l) => l.learnEscapeWithTheKing, fen: '8/2n5/5b2/8/2K5/8/2q5/8 w - -'),
    _outOfCheckLevel(
      goal: (l) => l.learnTheKingCannotEscapeButBlock,
      fen: '8/7r/6r1/8/R7/7K/8/8 w - -',
    ),
    _outOfCheckLevel(
      goal: (l) => l.learnYouCanGetOutOfCheckByTaking,
      fen: '8/8/8/3b4/8/4N3/KBn5/1R6 w - -',
    ),
    _outOfCheckLevel(
      goal: (l) => l.learnThisKnightIsCheckingThroughYourDefenses,
      fen: '4q3/8/8/8/8/5nb1/3PPP2/3QKBNr w - -',
    ),
    _outOfCheckLevel(goal: (l) => l.learnEscapeOrBlock, fen: '8/8/7p/2q5/5n2/1N1KP2r/3R4/8 w - -'),
    _outOfCheckLevel(goal: (l) => l.learnEscapeOrBlock, fen: '8/6b1/8/8/q4P2/2KN4/3P4/8 w - -'),
  ]),
);

LearnLevel _checkmate1Level({
  required String fen,
  List<LearnShape> shapes = const [],
  List<ScenarioStep> scenario = const [],
}) => LearnLevel.parse(
  goal: (l) => l.learnAttackYourOpponentsKing,
  fen: fen,
  shapes: shapes,
  scenario: scenario,
  nbMoves: 1,
  failure: .mate.not,
  success: .mate,
  showFailureFollowUp: true,
);

final _checkmate1 = LearnStage(
  key: 'checkmate1',
  title: (l) => l.learnMateInOne,
  subtitle: (l) => l.learnDefeatTheOpponentsKing,
  image: 'guillotine',
  intro: (l) => l.learnMateInOneIntro,
  complete: (l) => l.learnMateInOneComplete,
  levels: IList([
    // rook
    _checkmate1Level(fen: '3qk3/3ppp2/8/8/2B5/5Q2/8/8 w - -', shapes: [arrow('f3f7')]),
    // smothered
    _checkmate1Level(fen: '6rk/6pp/7P/6N1/8/8/8/8 w - -'),
    // rook
    _checkmate1Level(fen: 'R7/8/7k/2r5/5n2/8/6Q1/8 w - -'),
    // Q+N
    _checkmate1Level(fen: '2rb4/2k5/5N2/1Q6/8/8/8/8 w - -'),
    // discovered
    _checkmate1Level(fen: '1r2kb2/ppB1p3/2P2p2/2p1N3/B7/8/8/3R4 w - -'),
    // tricky
    _checkmate1Level(
      fen: '8/pk1N4/n7/b7/6B1/1r3b2/8/1RR5 w - -',
      scenario: [
        _step('g4f3', [arrow('b1b7', .yellow), arrow('f3b7', .yellow)]),
      ],
    ),
    // tricky
    _checkmate1Level(fen: 'r1b5/ppp5/2N2kpN/5q2/8/Q7/8/4B3 w - -'),
  ]),
);

// -- Intermediate

final _setup = LearnStage(
  key: 'setup',
  title: (l) => l.learnBoardSetup,
  subtitle: (l) => l.learnHowTheGameStarts,
  image: 'rally-the-troops',
  intro: (l) => l.learnBoardSetupIntro,
  complete: (l) => l.learnBoardSetupComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnThisIsTheInitialPosition,
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - -',
      nbMoves: 1,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnFirstPlaceTheRooks,
      fen: 'r6r/pppppppp/8/8/8/8/8/2RR4 w - -',
      apples: 'a1 h1',
      nbMoves: 2,
      shapes: [arrow('c1a1'), arrow('d1h1')],
      success: .every([.pieceOn(Piece.whiteRook, 'a1'), .pieceOn(Piece.whiteRook, 'h1')]),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnThenPlaceTheKnights,
      fen: 'rn4nr/pppppppp/8/8/8/8/2NN4/R6R w - -',
      apples: 'b1 g1',
      nbMoves: 4,
      success: .every([.pieceOn(Piece.whiteKnight, 'b1'), .pieceOn(Piece.whiteKnight, 'g1')]),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnPlaceTheBishops,
      fen: 'rnb2bnr/pppppppp/8/8/4BB2/8/8/RN4NR w - -',
      apples: 'c1 f1',
      nbMoves: 4,
      success: .every([.pieceOn(Piece.whiteBishop, 'c1'), .pieceOn(Piece.whiteBishop, 'f1')]),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnPlaceTheQueen,
      fen: 'rnbq1bnr/pppppppp/8/8/5Q2/8/8/RNB2BNR w - -',
      apples: 'd1',
      nbMoves: 2,
      success: .pieceOn(Piece.whiteQueen, 'd1'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnPlaceTheKing,
      fen: 'rnbqkbnr/pppppppp/8/8/5K2/8/8/RNBQ1BNR w - -',
      apples: 'e1',
      nbMoves: 3,
      success: .pieceOn(Piece.whiteKing, 'e1'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnPawnsFormTheFrontLine,
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - -',
      nbMoves: 1,
      highlightedRank: 2,
    ),
  ]),
);

final _castledKingSide = LearnAssert.castled(CastlingSide.king);
final _castledQueenSide = LearnAssert.castled(CastlingSide.queen);

LearnAssert _cantCastle(CastlingSide side, {required String blackKing}) => .every([
  .castled(side).not,
  .any([
    .pieceNotOn(Piece.whiteKing, 'e1'),
    .pieceNotOn(Piece.whiteRook, side == CastlingSide.king ? 'h1' : 'a1'),
    .mate,
    .pieceNotOn(Piece.blackKing, blackKing),
  ]),
]);

final _castling = LearnStage(
  key: 'castling',
  title: (l) => l.learnCastling,
  subtitle: (l) => l.learnTheSpecialKingMove,
  image: 'castle',
  intro: (l) => l.learnCastlingIntro,
  complete: (l) => l.learnCastlingComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnCastleKingSide,
      fen: 'rnbqkbnr/pppppppp/8/8/2B5/4PN2/PPPP1PPP/RNBQK2R w KQkq -',
      nbMoves: 1,
      shapes: [arrow('e1g1')],
      success: _castledKingSide,
      failure: _cantCastle(CastlingSide.king, blackKing: 'e8'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnCastleQueenSide,
      fen: 'rnbqkbnr/pppppppp/8/8/4P3/1PN5/PBPPQPPP/R3KBNR w KQkq -',
      nbMoves: 1,
      shapes: [arrow('e1c1')],
      success: _castledQueenSide,
      failure: _cantCastle(CastlingSide.queen, blackKing: 'e8'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTheKnightIsInTheWay,
      fen: 'rnbqkbnr/pppppppp/8/8/8/4P3/PPPPBPPP/RNBQK1NR w KQkq -',
      nbMoves: 2,
      shapes: [arrow('e1g1'), arrow('g1f3')],
      success: _castledKingSide,
      failure: _cantCastle(CastlingSide.king, blackKing: 'e8'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnCastleKingSideMovePiecesFirst,
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
      nbMoves: 4,
      shapes: [arrow('e1g1')],
      success: _castledKingSide,
      failure: _cantCastle(CastlingSide.king, blackKing: 'e8'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnCastleQueenSideMovePiecesFirst,
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -',
      nbMoves: 6,
      shapes: [arrow('e1c1')],
      success: _castledQueenSide,
      failure: _cantCastle(CastlingSide.queen, blackKing: 'e8'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnYouCannotCastleIfMoved,
      fen: 'rnbqkbnr/pppppppp/8/8/3P4/1PN1PN2/PBPQBPPP/R3K1R1 w Qkq -',
      nbMoves: 1,
      shapes: [arrow('e1g1', .red), arrow('e1c1')],
      success: _castledQueenSide,
      failure: _cantCastle(CastlingSide.queen, blackKing: 'e8'),
    ),
    LearnLevel.parse(
      goal: (l) => l.learnYouCannotCastleIfAttacked,
      fen: 'rn1qkbnr/ppp1pppp/3p4/8/2b5/4PN2/PPPP1PPP/RNBQK2R w KQkq -',
      nbMoves: 2,
      shapes: [arrow('c4f1', .red), circle('e1'), circle('f1'), circle('g1')],
      success: _castledKingSide,
      failure: _cantCastle(CastlingSide.king, blackKing: 'e8'),
      detectCapture: .none,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnFindAWayToCastleKingSide,
      fen: 'rnb2rk1/pppppppp/8/8/8/4Nb1n/PPPP1P1P/RNB1KB1R w KQkq -',
      nbMoves: 2,
      shapes: [arrow('e1g1')],
      success: _castledKingSide,
      failure: _cantCastle(CastlingSide.king, blackKing: 'g8'),
      detectCapture: .none,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnFindAWayToCastleQueenSide,
      fen: '1r1k2nr/p2ppppp/7b/7b/4P3/2nP4/P1P2P2/RN2K3 w Q -',
      nbMoves: 4,
      shapes: [arrow('e1c1')],
      success: _castledQueenSide,
      failure: _cantCastle(CastlingSide.queen, blackKing: 'd8'),
      detectCapture: .none,
    ),
  ]),
);

final _enpassant = LearnStage(
  key: 'enpassant',
  title: (l) => l.enPassant,
  subtitle: (l) => l.learnTheSpecialPawnMove,
  image: 'spinning-blades',
  intro: (l) => l.learnEnPassantIntro,
  complete: (l) => l.learnEnPassantComplete,
  levels: IList([
    LearnLevel.parse(
      goal: (l) => l.learnBlackJustMovedThePawnByTwoSquares,
      fen: 'rnbqkbnr/pppppppp/8/2P5/8/8/PP1PPPPP/RNBQKBNR b KQkq -',
      color: Side.white,
      nbMoves: 1,
      success: .scenarioComplete,
      failure: .scenarioFailed,
      detectCapture: .none,
      scenario: [
        _step('d7d5', [arrow('c5d6')]),
        _step('c5d6'),
      ],
      captures: 1,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnEnPassantOnlyWorksImmediately,
      fen: 'rnbqkbnr/ppp1pppp/8/2Pp3P/8/8/PP1PPPP1/RNBQKBNR b KQkq -',
      color: Side.white,
      nbMoves: 1,
      success: .scenarioComplete,
      failure: .scenarioFailed,
      detectCapture: .none,
      scenario: [
        _step('g7g5', [arrow('h5g6'), arrow('c5d6', .red)]),
        _step('h5g6'),
      ],
      captures: 1,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnEnPassantOnlyWorksOnFifthRank,
      fen: 'rnbqkbnr/pppppppp/P7/2P5/8/8/PP1PPPP1/RNBQKBNR b KQkq -',
      color: Side.white,
      nbMoves: 1,
      success: .scenarioComplete,
      failure: .scenarioFailed,
      detectCapture: .none,
      scenario: [
        _step('b7b5', [arrow('c5b6'), arrow('a6b7', .red)]),
        _step('c5b6'),
      ],
      captures: 1,
      highlightedRank: 5,
    ),
    LearnLevel.parse(
      goal: (l) => l.learnTakeAllThePawnsEnPassant,
      fen: 'rnbqkbnr/pppppppp/8/2PPP2P/8/8/PP1P1PP1/RNBQKBNR b KQkq -',
      color: Side.white,
      nbMoves: 4,
      detectCapture: .none,
      success: .scenarioComplete,
      failure: .scenarioFailed,
      scenario: [
        _step('b7b5'),
        _step('c5b6'),
        _step('f7f5'),
        _step('e5f6'),
        _step('c7c5'),
        _step('d5c6'),
        _step('g7g5'),
        _step('h5g6'),
      ],
      captures: 4,
    ),
  ]),
);

LearnLevel _stalemateLevel({
  required String fen,
  List<LearnShape> shapes = const [],
  required List<ScenarioStep> scenario,
}) => LearnLevel.parse(
  goal: (l) => l.learnStalemateGoal,
  fen: fen,
  shapes: shapes,
  scenario: scenario,
  detectCapture: .none,
  nbMoves: 1,
  nextButton: true,
  showFailureFollowUp: true,
  success: .scenarioComplete,
  failure: .scenarioFailed,
);

final _stalemate = LearnStage(
  key: 'stalemate',
  title: (l) => l.learnStalemate,
  subtitle: (l) => l.learnTheGameIsADraw,
  image: 'scales',
  intro: (l) => l.learnStalemateIntro,
  complete: (l) => l.learnStalemateComplete,
  levels: IList([
    _stalemateLevel(
      fen: 'k7/8/8/6B1/8/1R6/8/8 w - -',
      shapes: [arrow('g5e3')],
      scenario: [
        _step('g5e3', [
          arrow('e3a7', .blue),
          arrow('b3b7', .blue),
          arrow('b3b8', .blue),
          circle('a7', .blue),
          circle('b7', .blue),
          circle('b8', .blue),
        ]),
      ],
    ),
    _stalemateLevel(
      fen: '8/7p/4N2k/8/8/3N4/8/1K6 w - -',
      scenario: [
        _step('d3f4', [
          arrow('e6g7', .blue),
          arrow('e6g5', .blue),
          arrow('f4g6', .blue),
          arrow('f4h5', .blue),
          circle('g7', .blue),
          circle('g5', .blue),
          circle('g6', .blue),
          circle('h5', .blue),
        ]),
      ],
    ),
    _stalemateLevel(
      fen: '4k3/6p1/5p2/p4P2/PpB2N2/1K6/8/3R4 w - -',
      scenario: [
        _step('f4g6', [
          arrow('c4f7', .blue),
          arrow('d1d8', .blue),
          arrow('g6e7', .blue),
          arrow('g6f8', .blue),
        ]),
      ],
    ),
    _stalemateLevel(
      fen: '8/6pk/6np/7K/8/3B4/8/1R6 w - -',
      scenario: [
        _step('b1b8', [
          arrow('b8g8', .blue),
          arrow('b8h8', .blue),
          arrow('d3h7', .red),
          arrow('g6e7', .red),
        ]),
      ],
    ),
    _stalemateLevel(
      fen: '7R/pk6/p1pP4/K7/3BB2p/7p/1r5P/8 w - -',
      scenario: [
        _step('d4b2', [
          arrow('h8a8', .blue),
          arrow('a5b6', .blue),
          arrow('d6c7', .blue),
          arrow('e4b7', .red),
          arrow('c6c5', .red),
        ]),
      ],
    ),
  ]),
);

// -- Advanced

LearnLevel _valueLevel({
  required LearnText goal,
  required String fen,
  required String scenario,
  List<LearnShape> shapes = const [],
  DetectCapture? detectCapture,
  bool offerIllegalMove = false,
}) => LearnLevel.parse(
  goal: goal,
  fen: fen,
  scenario: [_step(scenario)],
  shapes: shapes,
  nbMoves: 1,
  captures: 1,
  pointsForCapture: true,
  showPieceValues: true,
  offerIllegalMove: offerIllegalMove,
  success: .scenarioComplete,
  failure: .scenarioFailed,
  detectCapture: detectCapture,
);

final _value = LearnStage(
  key: 'value',
  title: (l) => l.learnPieceValue,
  subtitle: (l) => l.learnEvaluatePieceStrength,
  image: 'sprint',
  intro: (l) => l.learnPieceValueIntro,
  complete: (l) => l.learnPieceValueComplete,
  levels: IList([
    // rook
    _valueLevel(
      goal: (l) => l.learnQueenOverBishop,
      fen: '8/8/2qrbnp1/3P4/8/8/8/8 w - -',
      scenario: 'd5c6',
      shapes: [arrow('d5c6')],
      detectCapture: .none,
    ),
    _valueLevel(
      goal: (l) => l.learnPieceValueExchange,
      fen: '8/8/4b3/1p6/6r1/8/4Q3/8 w - -',
      scenario: 'e2e6',
      detectCapture: .any,
    ),
    _valueLevel(
      goal: (l) => l.learnPieceValueLegal,
      fen: '5b2/8/6N1/2q5/3Kn3/2rp4/3B4/8 w - -',
      scenario: 'd4e4',
      offerIllegalMove: true,
    ),
    _valueLevel(
      goal: (l) => l.learnTakeThePieceWithTheHighestValue,
      fen: '1k4q1/pp6/8/3B4/2P5/1P1p2P1/P3Kr1P/3n4 w - -',
      scenario: 'e2d1',
      offerIllegalMove: true,
      detectCapture: .none,
    ),
    _valueLevel(
      goal: (l) => l.learnTakeThePieceWithTheHighestValue,
      fen: '7k/3bqp1p/7r/5N2/6K1/6n1/PPP5/R1B5 w - -',
      scenario: 'c1h6',
      offerIllegalMove: true,
    ),
  ]),
);

LearnLevel _check2Level({required String fen, List<LearnShape> shapes = const []}) =>
    LearnLevel.parse(
      goal: (l) => l.learnCheckInTwoGoal,
      fen: fen,
      shapes: shapes,
      nbMoves: 2,
      failure: .noCheckIn(2),
      success: .checkIn(2),
    );

final _check2 = LearnStage(
  key: 'check2',
  title: (l) => l.learnCheckInTwo,
  subtitle: (l) => l.learnTwoMovesToGiveCheck,
  image: 'crossed-swords',
  intro: (l) => l.learnCheckInTwoIntro,
  complete: (l) => l.learnCheckInTwoComplete,
  levels: IList([
    _check2Level(fen: '2k5/2pb4/8/2R5/8/8/8/8 w - -', shapes: [arrow('c5a5'), arrow('a5a8')]),
    _check2Level(fen: '8/8/5k2/8/8/1N6/5b2/8 w - -'),
    _check2Level(fen: '6k1/2r3pp/8/1N6/8/8/4B3/8 w - -'),
    _check2Level(fen: 'r3k3/7b/8/4B3/8/8/4N3/4R3 w - -'),
    _check2Level(fen: 'r1bqkb1r/pppp1p1p/2n2np1/4p3/2B5/4PN2/PPPP1PPP/RNBQK2R w KQkq -'),
    _check2Level(fen: '8/8/8/2k5/q7/4N3/3B4/8 w - -'),
    _check2Level(fen: 'r6r/1Q2nk2/1B3p2/8/8/8/8/8 w - -'),
  ]),
);
