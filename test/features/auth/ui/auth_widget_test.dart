import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:lichess_mobile/src/features/auth/ui/auth_widget.dart';
import 'package:lichess_mobile/src/features/auth/data/auth_repository.dart';
import 'package:lichess_mobile/src/features/settings/ui/theme_mode_notifier.dart';
import '../data/fake_auth_repository.dart';

void main() {
  testWidgets('Auth widget sign in and sign out', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository(null)),
          selectedBrigthnessProvider.overrideWithValue(Brightness.dark),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Consumer(builder: (context, ref, _) {
            return Scaffold(
              appBar: AppBar(
                actions: const [
                  AuthWidget(),
                ],
              ),
            );
          }),
        ),
      ),
    );

    // first frame is a loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();

    expect(find.text('Sign in'), findsOneWidget);

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1)); // wait for sign in future

    expect(find.byIcon(Icons.person), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // finish the menu animation

    await tester.tap(find.text('Sign out'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1)); // wait for sign out future

    expect(find.text('Sign in'), findsOneWidget);
  });
}
