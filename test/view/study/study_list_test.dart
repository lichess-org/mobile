import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:lichess_mobile/l10n/l10n_en.dart';
import 'package:lichess_mobile/src/model/study/study_filter.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
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

  testWidgets(
    'study subtitle shows creation time instead of last update time',
    variant: kPlatformVariant,
    (tester) async {
      final createdAt = DateTime.now().subtract(const Duration(hours: 5));
      final updatedAt = DateTime.now().subtract(const Duration(hours: 1));
      final mockClient = MockClient((request) {
        if (request.url.path == '/study/all/hot') {
          return mockResponse('''
{
  "paginator": {
    "currentPage": 1,
    "maxPerPage": 16,
    "currentPageResults": [
      {
        "id": "g26XbGpT",
        "name": "Study With Different Dates",
        "liked": false,
        "likes": 1,
        "createdAt": ${createdAt.millisecondsSinceEpoch},
        "updatedAt": ${updatedAt.millisecondsSinceEpoch},
        "owner": null,
        "chapters": [],
        "topics": [],
        "visibility": "public",
        "members": []
      }
    ],
    "previousPage": null,
    "nextPage": null,
    "nbResults": 1,
    "nbPages": 1
  }
}
''', 200);
        }
        return mockResponse('', 404);
      });

      final app = await makeTestProviderScopeApp(
        tester,
        home: Scaffold(
          body: StudyList(
            category: StudyCategory.all,
            order: StudyListOrder.hot,
            onStudyTap: (_, _) {},
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

      final l10n = AppLocalizationsEn();
      expect(find.textContaining(relativeDate(l10n, createdAt), findRichText: true), findsWidgets);
      expect(find.textContaining(relativeDate(l10n, updatedAt), findRichText: true), findsNothing);
    },
  );
}
