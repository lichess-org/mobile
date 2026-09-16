import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';

part 'practice_structure.freezed.dart';

/// All the practice content: sections of studies of chapters, in display order.
///
/// Built from `assets/practice.json` (see `scripts/gen_practice.dart`). Totals are computed from
/// the content, never assumed.
class PracticeStructure(final IList<PracticeSection> sections) {
  final Map<PracticeStudyId, PracticeStudy> _studies = {
    for (final section in sections)
      for (final study in section.studies) study.id: study,
  };

  final Map<PracticeChapterId, PracticeStudy> _studyOfChapter = {
    for (final section in sections)
      for (final study in section.studies)
        for (final chapter in study.chapters) chapter.id: study,
  };

  /// Parses the practice asset.
  factory fromJson(Map<String, dynamic> json) => PracticeStructure(
    pick(json, 'sections').asListOrThrow((section) => PracticeSection.fromPick(section)).lock,
  );

  int get nbChapters => _studyOfChapter.length;

  PracticeStudy? study(PracticeStudyId id) => _studies[id];

  /// The study [chapterId] belongs to.
  PracticeStudy? studyOf(PracticeChapterId chapterId) => _studyOfChapter[chapterId];

  PracticeChapter? chapter(PracticeChapterId id) =>
      _studyOfChapter[id]?.chapters.firstWhere((chapter) => chapter.id == id);

  /// The chapter following [chapterId] in its study, or null if it is the last one.
  PracticeChapter? nextChapter(PracticeChapterId chapterId) {
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
}

@freezed
sealed class const PracticeStudy._() with _$PracticeStudy {
  const factory({
    required PracticeStudyId id,
    required String slug,
    required String name,
    required IList<PracticeChapter> chapters,
  }) = _PracticeStudy;

  factory fromPick(RequiredPick pick) => PracticeStudy(
    id: PracticeStudyId(pick('id').asStringOrThrow()),
    slug: pick('slug').asStringOrThrow(),
    name: pick('name').asStringOrThrow(),
    chapters: pick('chapters').asListOrThrow((chapter) => PracticeChapter.fromPick(chapter)).lock,
  );
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
    required PracticeChapterId id,
    required String name,
    required String fen,

    /// The side the player plays.
    required Side orientation,
    String? description,
    required PracticeGoal goal,
  }) = PracticeEngineChapter;

  /// An authored line to find move by move: a wrong move is commented and taken back.
  const factory gamebook({
    required PracticeChapterId id,
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
    required PracticeChapterId id,
    required String name,
    required String fen,
    required Side orientation,
    String? description,
    required String pgn,
  }) = PracticeLessonChapter;

  factory fromPick(RequiredPick pick) {
    final id = PracticeChapterId(pick('id').asStringOrThrow());
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
