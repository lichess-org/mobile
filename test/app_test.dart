import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/app.dart';

import 'test_provider_scope.dart';

void main() {
  testWidgets('App initialization screen', (tester) async {
    final app = await makeProviderScope(
      tester,
      child: const AppInitializationScreen(),
    );

    await tester.pumpWidget(app);

    expect(find.byKey(const Key('app_splash_screen')), findsOneWidget);
  });
}
