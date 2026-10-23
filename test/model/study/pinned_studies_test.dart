import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/pinned_studies.dart';

void main() {
  group('PinnedStudies', () {
    const study = PinnedStudy(
      id: StudyId('abc'),
      name: 'My repertoire',
      chapterCount: 3,
      lastChapterId: StudyChapterId('ch2'),
    );

    test('serialization round-trip', () {
      const pinned = PinnedStudies(studies: IListConst([study]));

      final json = jsonDecode(jsonEncode(pinned.toJson())) as Map<String, dynamic>;

      expect(PinnedStudies.fromJson(json), pinned);
    });

    test('last chapter is optional', () {
      final json = jsonDecode(
        '{"studies":[{"id":"abc","name":"My repertoire","chapterCount":3}]}',
      ) as Map<String, dynamic>;

      expect(PinnedStudies.fromJson(json).studies.single.lastChapterId, isNull);
    });

    test('fromJson with invalid data returns empty', () {
      expect(PinnedStudies.fromJson({'studies': 'not_a_list'}), PinnedStudies.empty);
    });

    test('isPinned and isFull', () {
      final pinned = PinnedStudies(
        studies: IList([
          for (int i = 0; i < kMaxPinnedStudies; i++) study.copyWith(id: StudyId('$i')),
        ]),
      );

      expect(pinned.isPinned(const StudyId('0')), isTrue);
      expect(pinned.isPinned(const StudyId('abc')), isFalse);
      expect(pinned.isFull, isTrue);
      expect(PinnedStudies.empty.isFull, isFalse);
    });
  });
}
