import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

void main() {
  group('UserFullNameWidget', () {
    testWidgets('displays fallback name when user is null', (WidgetTester tester) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const Scaffold(
          body: UserFullNameWidget.player(user: null, name: 'Kasparov, Garry', aiLevel: null),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('Kasparov, Garry'), findsOneWidget);
    });

    testWidgets('displays Anonymous when neither user nor name is available', (
      WidgetTester tester,
    ) async {
      final app = await makeTestProviderScopeApp(
        tester,
        home: const Scaffold(
          body: UserFullNameWidget.player(user: null, name: null, aiLevel: null),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('Anonymous'), findsOneWidget);
    });
  });
}
