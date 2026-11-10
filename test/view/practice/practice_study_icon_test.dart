import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/practice/practice_repository.dart';
import 'package:lichess_mobile/src/view/practice/practice_study_icon.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every study of the bundled practice has its icon', () async {
    final structure = await PracticeRepository(rootBundle).getStructure();
    for (final section in structure.sections) {
      for (final study in section.studies) {
        final asset = PracticeStudyIcon.assetOf(study);
        expect(asset, isNotNull, reason: '${study.id} ${study.name}');
        expect((await rootBundle.load(asset!)).lengthInBytes, greaterThan(0), reason: asset);
      }
    }
  });
}
