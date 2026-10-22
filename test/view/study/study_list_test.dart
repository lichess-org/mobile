import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/view/study/study_list.dart';
import 'package:material_ui/material_ui.dart';

import '../../test_helpers.dart';
import '../../test_provider_scope.dart';
import 'study_list_screen_test.dart' show kStudyAllHotPage1Response;

void main() {
  testWidgets(
    'a tap that unfocuses the search field does not open a study',
    variant: kPlatformVariant,
    (tester) async {
      final tappedStudies = <String>[];
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/all/hot') {
          return mockResponse(kStudyAllHotPage1Response, 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: StudyList(
            category: StudyCategory.all,
            order: StudyListOrder.hot,
            onStudyTap: (_, study) => tappedStudies.add(study.name),
          ),
        ),
        overrides: {
          lichessClientProvider: lichessClientProvider.overrideWith((ref) {
            return LichessClient(mockClient, ref);
          }),
        },
      );
      await tester.pumpWidget(app);
      await tester.pump();

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(tester.testTextInput.isVisible, isTrue);

      await tester.tap(find.text('First Study Page 1'));
      await tester.pump();
      expect(tappedStudies, isEmpty);
      expect(FocusManager.instance.primaryFocus?.context?.widget, isNot(isA<EditableText>()));

      await tester.tap(find.text('First Study Page 1'));
      await tester.pump();
      expect(tappedStudies, ['First Study Page 1']);
    },
  );
}
