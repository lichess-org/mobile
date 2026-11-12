import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

void main() {
  group('UserFullNameWidget', () {
    for (final scenario in [
      (
        name: 'preserves the chosen patron color alongside the online indicator',
        config: null,
        palette: 3,
        show: true,
      ),
      (
        name: 'hides the patron icon without hiding the online indicator',
        config: const PatronIconConfig(show: false),
        palette: null,
        show: false,
      ),
      (
        name: 'overrides the patron color without changing the online indicator',
        config: const PatronIconConfig(color: 4),
        palette: 4,
        show: true,
      ),
      (
        name: 'inherits the patron icon color when the configured color is null',
        config: const PatronIconConfig(),
        palette: null,
        show: true,
      ),
    ]) {
      testWidgets(scenario.name, (WidgetTester tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: Scaffold(
            body: UserFullNameWidget(
              user: const LightUser(
                id: UserId('patron'),
                name: 'Patron',
                patronColor: 3,
                isOnline: true,
              ),
              shouldShowOnline: true,
              patronIcon: scenario.config,
            ),
          ),
        );
        await tester.pumpWidget(app);

        expect(find.text('Patron'), findsOneWidget);
        expect(tester.widget<ConnectedIcon>(find.byType(ConnectedIcon)).isConnected, isTrue);
        expect(find.byType(PatronIcon), scenario.show ? findsOneWidget : findsNothing);
        if (scenario.show) {
          final icon = tester.widget<Icon>(
            find.descendant(of: find.byType(PatronIcon), matching: find.byType(Icon)),
          );
          final expectedColor = scenario.palette != null
              ? PatronIcon.patronColorsLight[scenario.palette! - 1]
              : null;
          expect(icon.color, expectedColor);
        }
      });
    }

    for (final scenario in [
      (
        name: 'shows the online circle alongside the patron icon',
        config: const UserStatusIconConfig(isOnline: true),
        fill: 1.0,
      ),
      (
        name: 'shows the offline circle alongside the patron icon',
        config: const UserStatusIconConfig(isOnline: false),
        fill: 0.0,
      ),
      (
        name: 'hides the status circle without hiding the patron icon',
        config: const UserStatusIconConfig(isOnline: true, show: false),
        fill: null,
      ),
    ]) {
      testWidgets(scenario.name, (WidgetTester tester) async {
        final app = await makeTestProviderScopeApp(
          tester,
          home: Scaffold(
            body: UserFullNameWidget(
              user: const LightUser(id: UserId('patron'), name: 'Patron', patronColor: 3),
              statusIcon: scenario.config,
            ),
          ),
        );
        await tester.pumpWidget(app);

        expect(find.byType(PatronIcon), findsOneWidget);
        expect(find.byType(ConnectedIcon), findsNothing);
        expect(find.byType(UserStatusIcon), scenario.fill == null ? findsNothing : findsOneWidget);
        if (scenario.fill != null) {
          final icon = tester.widget<Icon>(
            find.descendant(of: find.byType(UserStatusIcon), matching: find.byType(Icon)),
          );
          expect(icon.fill, scenario.fill);
        }
      });
    }

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
