import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lichess_mobile/src/ui/auth/sign_in_widget.dart';
import 'package:lichess_mobile/src/model/settings/providers.dart';
import 'package:lichess_mobile/src/model/account/account_providers.dart';
import '../../utils.dart';
import '../../model/account/fake_account_repository.dart';

void main() {
  testWidgets(
    'SignInWidget',
    (WidgetTester tester) async {
      final app = await buildTestApp(
        tester,
        home: Consumer(
          builder: (context, ref, _) {
            return Scaffold(
              appBar: AppBar(
                actions: const [
                  SignInWidget(),
                ],
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ...defaultProviderOverrides,
            accountRepositoryProvider
                .overrideWithValue(FakeAccountRepository()),
            currentBrightnessProvider.overrideWithValue(Brightness.dark),
          ],
          child: app,
        ),
      );

      // first frame is a loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('Sign in'), findsOneWidget);

      await tester.tap(find.text('Sign in'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 1)); // wait for sign in future

      expect(find.text('Sign in'), findsNothing);
    },
    variant: kPlatformVariant,
  );
}
