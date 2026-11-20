import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/view/study/create_study_bottom_sheet.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';

import '../../model/auth/fake_auth_storage.dart';
import '../../test_bottom_sheet_opener.dart';
import '../../test_provider_scope.dart';

void main() {
  group('CreateStudyBottomSheet', () {
    testWidgets('Uses same defaults as the website', (tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: TestBottomSheetOpener(
          builder: (_) => CreateStudyBottomSheet(user: fakeAuthUser.user),
        ),
        authUser: fakeAuthUser,
      );

      await tester.pumpWidget(app);

      await TestBottomSheetOpener.openBottomSheet(tester);

      expect(find.byType(CreateStudyBottomSheet), findsOneWidget);

      expect(find.text("${fakeAuthUser.user.name}'s Study"), findsOneWidget);

      await tester.tap(find.text('Create study'));
      await tester.pumpAndSettle();

      // Should now open the CreateStudyChapterBottomSheet with the correct parameters
      expect(
        tester.widget(find.byType(CreateStudyChapterBottomSheet)),
        isA<CreateStudyChapterBottomSheet>().having(
          (sheet) => sheet.params,
          'params',
          isA<CreateFirstChapterOfNewStudy>().having(
            (it) => it.studyPayload,
            'study payload',
            equals(
              CreateStudyPayload(
                name: "${fakeAuthUser.user.name}'s Study",
                visibility: StudyVisibility.unlisted,
                chat: StudyFeatureAccess.member,
                computer: StudyFeatureAccess.everyone,
                explorer: StudyFeatureAccess.everyone,
                cloneable: StudyFeatureAccess.everyone,
                shareable: StudyFeatureAccess.everyone,
                sticky: true,
              ),
            ),
          ),
        ),
      );
    });
  });
}
