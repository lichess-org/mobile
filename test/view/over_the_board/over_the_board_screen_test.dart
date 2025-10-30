import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/view/more/more_tab_screen.dart';

import '../../model/auth/fake_session_storage.dart';
import '../../test_provider_scope.dart';

void main() {
  group('MoreTabScreen', () {
    testWidgets('should see all items when logged out', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(tester, home: const MoreTabScreen());

      await tester.pumpWidget(app);

      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Load position'), findsOneWidget);
      expect(find.text('Analysis board'), findsOneWidget);
      expect(find.text('Opening explorer'), findsOneWidget);
      expect(find.text('Board editor'), findsOneWidget);
      expect(find.text('Clock'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Friends'), findsNothing);
    });

    testWidgets('should see all items when logged in', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const MoreTabScreen(),
        userSession: fakeSession,
      );

      await tester.pumpWidget(app);

      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Load position'), findsOneWidget);
      expect(find.text('Analysis board'), findsOneWidget);
      expect(find.text('Opening explorer'), findsOneWidget);
      expect(find.text('Board editor'), findsOneWidget);
      expect(find.text('Clock'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Friends'), findsOneWidget);
    });
  });
}
