import 'package:dartchess/dartchess.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/practice/practice_repository.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';

/// The practice content that ships with the app, as `scripts/gen_practice.dart` crawled it.
///
/// Assertions are structural rather than exact: the asset is regenerated from lichess.org, where
/// study owners edit chapters, and pinned counts would fail on every refresh.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PracticeStructure structure;
  late List<PracticeChapter> chapters;

  setUpAll(() async {
    structure = await PracticeRepository(rootBundle).getStructure();
    chapters = [
      for (final section in structure.sections)
        for (final study in section.studies) ...study.chapters,
    ];
  });

  test('has every kind of chapter, each with a unique id', () {
    expect(structure.sections, isNotEmpty);
    expect(chapters.length, greaterThan(250));
    expect(structure.nbChapters, chapters.length, reason: 'chapter ids are unique');
    expect(chapters.whereType<PracticeEngineChapter>(), isNotEmpty);
    expect(chapters.whereType<PracticeGamebookChapter>(), isNotEmpty);
    expect(chapters.whereType<PracticeLessonChapter>(), isNotEmpty);
  });

  test('every study has a description and chapters', () {
    for (final section in structure.sections) {
      for (final study in section.studies) {
        expect(study.chapters, isNotEmpty, reason: study.name);
        expect(study.description, isNotEmpty, reason: study.name);
      }
    }
  });

  test('every chapter starts from a legal position', () {
    for (final chapter in chapters) {
      expect(
        () => Chess.fromSetup(Setup.parseFen(chapter.fen)),
        returnsNormally,
        reason: '${chapter.id} ${chapter.name}',
      );
    }
  });

  test('every gamebook and lesson builds a move tree from its own position', () {
    for (final chapter in chapters) {
      final (pgn, hints, deviations) = switch (chapter) {
        PracticeGamebookChapter(:final pgn, :final hints, :final deviations) => (
          pgn,
          hints,
          deviations,
        ),
        PracticeLessonChapter(:final pgn) => (pgn, null, null),
        PracticeEngineChapter() => (null, null, null),
      };
      if (pgn == null) continue;
      final reason = '${chapter.id} ${chapter.name}';

      final root = Root.fromPgnGame(PgnGame.parsePgn(pgn));
      expect(root.position.fen, Chess.fromSetup(Setup.parseFen(chapter.fen)).fen, reason: reason);

      // Hints and deviations are indexed by ply along the mainline, root included.
      final mainlinePositions = root.mainline.length + 1;
      expect(hints?.length ?? 0, lessThanOrEqualTo(mainlinePositions), reason: reason);
      expect(deviations?.length ?? 0, lessThanOrEqualTo(mainlinePositions), reason: reason);
    }
  });

  test('gamebook hints and deviations line up with the plies they belong to', () {
    final gamebooks = chapters.whereType<PracticeGamebookChapter>();
    expect(gamebooks.where((gamebook) => gamebook.hints.nonNulls.isNotEmpty), isNotEmpty);

    for (final gamebook in gamebooks) {
      final playerStarts = Setup.parseFen(gamebook.fen).turn == gamebook.orientation;
      bool isPlayerTurn(int ply) => playerStarts == ply.isEven;
      for (final (ply, hint) in gamebook.hints.indexed) {
        // A hint is for finding a move, so on a position where the player is to move.
        if (hint != null) expect(isPlayerTurn(ply), isTrue, reason: '${gamebook.id} hint $ply');
      }
      for (final (ply, deviation) in gamebook.deviations.indexed) {
        // A deviation comments a wrong move, so the one the player just played.
        if (deviation != null) {
          expect(isPlayerTurn(ply), isFalse, reason: '${gamebook.id} deviation $ply');
        }
      }
    }
  });

  test('a lesson has moves to browse', () {
    for (final lesson in chapters.whereType<PracticeLessonChapter>()) {
      expect(Root.fromPgnGame(PgnGame.parsePgn(lesson.pgn)).mainline, isNotEmpty);
    }
  });
}
