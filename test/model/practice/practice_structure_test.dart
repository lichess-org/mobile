import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/practice/practice_goal.dart';
import 'package:lichess_mobile/src/model/practice/practice_structure.dart';

void main() {
  group('PracticeStructure', () {
    final structure = PracticeStructure.fromJson({
      'sections': [
        {
          'id': 'checkmates',
          'name': 'Checkmates',
          'studies': [
            {
              'id': 'study1',
              'slug': 'study-one',
              'name': 'Study one',
              'description': 'The first study',
              'chapters': [
                {
                  'id': 'engine01',
                  'name': 'Engine',
                  'kind': 'practice',
                  'orientation': 'white',
                  'fen': '8/8/3k4/8/8/4K3/8/Q6R w - - 0 1',
                  'description': 'Mate in 3.',
                  'goal': {'result': 'mateIn', 'moves': 3},
                },
                {
                  'id': 'gamebk01',
                  'name': 'Gamebook',
                  'kind': 'gamebook',
                  'orientation': 'black',
                  'fen': '8/8/3k4/8/8/4K3/8/Q6R b - - 0 1',
                  'pgn': '{ Find the move }',
                  'hints': [null, 'A hint'],
                },
              ],
            },
          ],
        },
        {
          'id': 'endgames',
          'name': 'Endgames',
          'studies': [
            {
              'id': 'study2',
              'slug': 'study-two',
              'name': 'Study two',
              'chapters': [
                {
                  'id': 'lesson01',
                  'name': 'Lesson',
                  'kind': 'lesson',
                  'orientation': 'white',
                  'fen': '8/8/3k4/8/8/4K3/8/Q6R w - - 0 1',
                  'pgn': '1. Qa6+ *',
                },
              ],
            },
          ],
        },
      ],
    });

    test('parses each chapter kind', () {
      final study = structure.study(const PracticeStudyId('study1'))!;
      expect(study.name, 'Study one');
      expect(study.description, 'The first study');
      expect(structure.study(const PracticeStudyId('study2'))!.description, isNull);

      final engine = study.chapters[0] as PracticeEngineChapter;
      expect(engine.orientation, Side.white);
      expect(engine.description, 'Mate in 3.');
      expect(engine.goal, const PracticeGoal.mateIn(moves: 3));

      final gamebook = study.chapters[1] as PracticeGamebookChapter;
      expect(gamebook.orientation, Side.black);
      expect(gamebook.description, isNull);
      expect(gamebook.hints, IList(const [null, 'A hint']));
      expect(gamebook.deviations, isEmpty, reason: 'omitted from the asset when all null');

      final lesson = structure.chapter(const PracticeChapterId('lesson01'))!;
      expect(lesson, isA<PracticeLessonChapter>());
      expect((lesson as PracticeLessonChapter).pgn, '1. Qa6+ *');
    });

    test('counts chapters across sections', () {
      expect(structure.nbChapters, 3);
    });

    test('finds the study of a chapter', () {
      expect(structure.studyOf(const PracticeChapterId('lesson01'))?.id, 'study2');
      expect(structure.studyOf(const PracticeChapterId('unknown1')), isNull);
    });

    test('gives the next chapter within the study only', () {
      expect(structure.nextChapter(const PracticeChapterId('engine01'))?.id, 'gamebk01');
      expect(structure.nextChapter(const PracticeChapterId('gamebk01')), isNull);
      expect(structure.nextChapter(const PracticeChapterId('unknown1')), isNull);
    });

    test('ignores unknown ids', () {
      expect(structure.chapter(const PracticeChapterId('unknown1')), isNull);
      expect(structure.study(const PracticeStudyId('unknown')), isNull);
    });

    test('rejects an unknown chapter kind', () {
      expect(
        () => PracticeChapter.fromPick(
          pick({
            'id': 'chapter1',
            'name': 'Chapter',
            'kind': 'quiz',
            'orientation': 'white',
            'fen': '8/8/3k4/8/8/4K3/8/Q6R w - - 0 1',
          }).required(),
        ),
        throwsA(isA<PickException>()),
      );
    });
  });
}
