import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';

part 'practice_structure.freezed.dart';

/// All the practice content: sections of studies of chapters, in display order.
///
/// Built from `assets/practice.json` (see `scripts/gen_practice.dart`). Totals are computed from
/// the content, never assumed.
class PracticeStructure(final IList<PracticeSection> sections) {
  final Map<StudyId, PracticeStudy> _studies = {
    for (final section in sections)
      for (final study in section.studies) study.id: study,
  };

  final Map<StudyChapterId, PracticeStudy> _studyOfChapter = {
    for (final section in sections)
      for (final study in section.studies)
        for (final chapter in study.chapters) chapter.id: study,
  };

  /// Parses the practice asset.
  factory fromJson(Map<String, dynamic> json) => PracticeStructure(
    pick(json, 'sections').asListOrThrow((section) => PracticeSection.fromPick(section)).lock,
  );

  int get nbChapters => _studyOfChapter.length;

  PracticeStudy? study(StudyId id) => _studies[id];

  /// The study [chapterId] belongs to.
  PracticeStudy? studyOf(StudyChapterId chapterId) => _studyOfChapter[chapterId];

  PracticeChapter? chapter(StudyChapterId id) =>
      _studyOfChapter[id]?.chapters.firstWhere((chapter) => chapter.id == id);

  /// The chapter following [chapterId] in its study, or null if it is the last one.
  PracticeChapter? nextChapter(StudyChapterId chapterId) {
    final chapters = _studyOfChapter[chapterId]?.chapters;
    if (chapters == null) return null;
    final index = chapters.indexWhere((chapter) => chapter.id == chapterId);
    return index + 1 < chapters.length ? chapters[index + 1] : null;
  }
}

@freezed
sealed class const PracticeSection._() with _$PracticeSection {
  const factory({required String id, required String name, required IList<PracticeStudy> studies}) =
      _PracticeSection;

  factory fromPick(RequiredPick pick) => PracticeSection(
    id: pick('id').asStringOrThrow(),
    name: pick('name').asStringOrThrow(),
    studies: pick('studies').asListOrThrow((study) => PracticeStudy.fromPick(study)).lock,
  );

  /// The translated [name], or [name] itself for a section the translations don't know.
  String l10nName(AppLocalizations l10n) => switch (id) {
    'checkmates' => l10n.practiceSecHeadCheckmates,
    'fundamental-tactics' => l10n.practiceSecHeadFundamentalTactics,
    'advanced-tactics' => l10n.practiceSecHeadAdvancedTactics,
    'pawn-endgames' => l10n.practiceSecHeadPawnEndgames,
    'rook-endgames' => l10n.practiceSecHeadRookEndgames,
    _ => name,
  };
}

@freezed
sealed class const PracticeStudy._() with _$PracticeStudy {
  const factory({
    required StudyId id,
    required String slug,
    required String name,

    /// A short line on what the study is about, as lichess.org shows it under the name.
    String? description,
    required IList<PracticeChapter> chapters,
  }) = _PracticeStudy;

  factory fromPick(RequiredPick pick) => PracticeStudy(
    id: StudyId(pick('id').asStringOrThrow()),
    slug: pick('slug').asStringOrThrow(),
    name: pick('name').asStringOrThrow(),
    description: pick('description').asStringOrNull(),
    chapters: pick('chapters').asListOrThrow((chapter) => PracticeChapter.fromPick(chapter)).lock,
  );

  /// The translated [name], or [name] itself for a study the translations don't know.
  ///
  /// Keyed by id rather than slug: the two 7th-rank rook pawn studies share their slug.
  String l10nName(AppLocalizations l10n) => switch (id.value) {
    'BJy6fEDf' => l10n.practiceStNamPieceCheckmatesI,
    'fE4k21MW' => l10n.practiceStNamCheckmatePatternsI,
    '8yadFPpU' => l10n.practiceStNamCheckmatePatternsII,
    'PDkQDt6u' => l10n.practiceStNamCheckmatePatternsIII,
    '96Lij7wH' => l10n.practiceStNamCheckmatePatternsIV,
    'Rg2cMBZ6' => l10n.practiceStNamPieceCheckmatesII,
    'ByhlXnmM' => l10n.practiceStNamKnightAndBishopMate,
    '9ogFv8Ac' => l10n.practiceStNamThePin,
    'tuoBxVE5' => l10n.practiceStNamTheSkewer,
    'Qj281y1p' => l10n.practiceStNamTheFork,
    'MnsJEWnI' => l10n.practiceStNamDiscoveredAttacks,
    'RUQASaZm' => l10n.practiceStNamDoubleCheck,
    'o734CNqp' => l10n.practiceStNamOverloadedPieces,
    'ITWY4GN2' => l10n.practiceStNamZwischenzug,
    'lyVYjhPG' => l10n.practiceStNamXRay,
    '9cKgYrHb' => l10n.practiceStNamZugzwang,
    'g1fxVZu9' => l10n.practiceStNamInterference,
    's5pLU7Of' => l10n.practiceStNamGreekGift,
    'kdKpaYLW' => l10n.practiceStNamDeflection,
    'jOZejFWk' => l10n.practiceStNamAttraction,
    '49fDW0wP' => l10n.practiceStNamUnderpromotion,
    '0YcGiH4Y' => l10n.practiceStNamDesperado,
    'CgjKPvxQ' => l10n.practiceStNamCounterCheck,
    'udx042D6' => l10n.practiceStNamUndermining,
    'Grmtwuft' => l10n.practiceStNamClearance,
    'xebrDvFe' => l10n.practiceStNamKeySquares,
    'A4ujYOer' => l10n.practiceStNamOpposition,
    'pt20yRkT' => l10n.practiceStNam7thRankRookPawn,
    'MkDViieT' => l10n.practiceStNam7thRankRookPawn,
    'pqUSUw8Y' => l10n.practiceStNamBasicRookEndgames,
    'heQDnvq7' => l10n.practiceStNamIntermediateRookEndings,
    'wS23j5Tm' => l10n.practiceStNamPracticalRookEndings,
    _ => name,
  };

  /// The translated [description], or [description] itself for a study the translations don't
  /// know.
  String? l10nDescription(AppLocalizations l10n) => switch (id.value) {
    'BJy6fEDf' => l10n.practiceStDesBasicCheckmates,
    'fE4k21MW' => l10n.practiceStDesRecognizeThePatterns,
    '8yadFPpU' => l10n.practiceStDesRecognizeThePatterns,
    'PDkQDt6u' => l10n.practiceStDesRecognizeThePatterns,
    '96Lij7wH' => l10n.practiceStDesRecognizeThePatterns,
    'Rg2cMBZ6' => l10n.practiceStDesChallengingCheckmates,
    'ByhlXnmM' => l10n.practiceStDesInteractiveLesson,
    '9ogFv8Ac' => l10n.practiceStDesPinItToWinIt,
    'tuoBxVE5' => l10n.practiceStDesYumSkewers,
    'Qj281y1p' => l10n.practiceStDesUseTheForkLuke,
    'MnsJEWnI' => l10n.practiceStDesIncludingDiscoveredChecks,
    'RUQASaZm' => l10n.practiceStDesAVeryPowerfulTactic,
    'o734CNqp' => l10n.practiceStDesTheyHaveTooMuchWork,
    'ITWY4GN2' => l10n.practiceStDesInBetweenMoves,
    'lyVYjhPG' => l10n.practiceStDesAttackingThroughAnEnemyPiece,
    '9cKgYrHb' => l10n.practiceStDesBeingForcedToMove,
    'g1fxVZu9' => l10n.practiceStDesInterposeAPieceToGreatEffect,
    's5pLU7Of' => l10n.practiceStDesStudyTheGreekGiftSacrifice,
    'kdKpaYLW' => l10n.practiceStDesDistractingADefender,
    'jOZejFWk' => l10n.practiceStDesLureAPieceToABadSquare,
    '49fDW0wP' => l10n.practiceStDesPromoteButNotToAQueen,
    '0YcGiH4Y' => l10n.practiceStDesAPieceIsLostButItCanStillHelp,
    'CgjKPvxQ' => l10n.practiceStDesRespondToACheckWithACheck,
    'udx042D6' => l10n.practiceStDesRemoveTheDefendingPiece,
    'Grmtwuft' => l10n.practiceStDesGetOutOfTheWay,
    'xebrDvFe' => l10n.practiceStDesReachAKeySquare,
    'A4ujYOer' => l10n.practiceStDesTakeTheOpposition,
    'pt20yRkT' => l10n.practiceStDesVersusAQueen,
    'MkDViieT' => l10n.practiceStDesAndPassiveRookVsRook,
    'pqUSUw8Y' => l10n.practiceStDesLucenaAndPhilidor,
    'heQDnvq7' => l10n.practiceStDesBroadenYourKnowledge,
    'wS23j5Tm' => l10n.practiceStDesRookEndingsWithSeveralPawns,
    _ => description,
  };
}

/// A chapter of a practice study.
///
/// Studies mix the three kinds, so moving to the next chapter can change how it is played.
@freezed
sealed class const PracticeChapter._() with _$PracticeChapter {
  /// A position to play against the engine until [goal] is reached or failed.
  ///
  /// lila strips the move tree of these chapters: the opponent's moves and the verdicts all come
  /// from the local engine.
  const factory engine({
    required StudyChapterId id,
    required String name,
    required String fen,

    /// The side the player plays.
    required Side orientation,
    String? description,
    required PracticeGoal goal,

    /// The shapes the author drew on [fen], shown until the first move is played.
    @Default(IListConst([])) IList<PgnCommentShape> shapes,
  }) = PracticeEngineChapter;

  /// An authored line to find move by move: a wrong move is commented and taken back.
  const factory gamebook({
    required StudyChapterId id,
    required String name,
    required String fen,

    /// The side the player plays.
    required Side orientation,
    String? description,

    /// The move tree, its comments and shapes.
    required String pgn,

    /// The hint for the position at each ply of the mainline, counted from the start of [pgn].
    required IList<String?> hints,

    /// The comment for a move off the mainline, indexed like [hints] by the ply of that move.
    required IList<String?> deviations,
  }) = PracticeGamebookChapter;

  /// A commented game to browse, with nothing to solve.
  const factory lesson({
    required StudyChapterId id,
    required String name,
    required String fen,
    required Side orientation,
    String? description,
    required String pgn,
  }) = PracticeLessonChapter;

  factory fromPick(RequiredPick pick) {
    final id = StudyChapterId(pick('id').asStringOrThrow());
    final name = pick('name').asStringOrThrow();
    final fen = pick('fen').asStringOrThrow();
    final orientation = pick('orientation').asSideOrThrow();
    final description = pick('description').asStringOrNull();
    // Nulls are kept: the lists are indexed by ply.
    IList<String?> perPly(String key) =>
        pick(key)
            .asListOrNull<String?>((ply) => ply.asStringOrThrow(), whenNull: (_) => null)
            ?.lock ??
        const IListConst([]);

    return switch (pick('kind').asStringOrThrow()) {
      'practice' => PracticeChapter.engine(
        id: id,
        name: name,
        fen: fen,
        orientation: orientation,
        description: description,
        goal: PracticeGoal.fromPick(pick('goal').required()),
        shapes:
            pick('shapes').asListOrNull((shape) {
              final pgn = shape.asStringOrThrow();
              return PgnCommentShape.fromPgn(pgn) ??
                  (throw PickException('Invalid shape "$pgn" at ${shape.debugParsingExit}'));
            })?.lock ??
            const IListConst([]),
      ),
      'gamebook' => PracticeChapter.gamebook(
        id: id,
        name: name,
        fen: fen,
        orientation: orientation,
        description: description,
        pgn: pick('pgn').asStringOrThrow(),
        hints: perPly('hints'),
        deviations: perPly('deviations'),
      ),
      'lesson' => PracticeChapter.lesson(
        id: id,
        name: name,
        fen: fen,
        orientation: orientation,
        description: description,
        pgn: pick('pgn').asStringOrThrow(),
      ),
      final kind => throw PickException(
        'Unknown practice chapter kind "$kind" at ${pick.debugParsingExit}',
      ),
    };
  }
}
