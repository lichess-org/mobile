import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/app.dart';
import 'package:lichess_mobile/src/navigation.dart';

import 'test_provider_scope.dart';

void main() {
  testWidgets('App loads', (tester) async {
    final app = await makeProviderScope(
      tester,
      child: const Application(),
    );

    await tester.pumpWidget(app);

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App loads with system theme, which defaults to light',
      (tester) async {
    final app = await makeProviderScope(
      tester,
      child: const Application(),
    );

    await tester.pumpWidget(app);

    expect(
      Theme.of(tester.element(find.byType(MaterialApp))).brightness,
      Brightness.light,
    );
  });

  testWidgets('Bottom navigation', (tester) async {
    final app = await makeProviderScope(
      tester,
      child: const Application(),
    );

    await tester.pumpWidget(app);

    expect(find.byType(BottomNavScaffold), findsOneWidget);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      expect(find.byType(BottomNavigationBarItem), findsNWidgets(5));
    } else {
      expect(find.byType(NavigationDestination), findsNWidgets(5));
    }

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Puzzles'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Watch'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
