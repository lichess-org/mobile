import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/platform_tab_bar.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassSegmentedControl;
import 'package:material_ui/material_ui.dart';

import '../test_helpers.dart';

Widget _buildApp(List<String> tabs) {
  return MaterialApp(
    home: DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(bottom: PlatformTabBar(tabs: tabs)),
        body: TabBarView(children: [for (final tab in tabs) Text('$tab content')]),
      ),
    ),
  );
}

void main() {
  testWidgets('3 tabs are a segmented control on iOS', variant: kPlatformVariant, (tester) async {
    await tester.pumpWidget(_buildApp(['First', 'Second', 'Third']));

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(GlassSegmentedControl), isIOS ? findsOneWidget : findsNothing);
    expect(find.byType(TabBar), isIOS ? findsNothing : findsOneWidget);
  });

  testWidgets('2 tabs are a segmented control on iOS', variant: kPlatformVariant, (tester) async {
    await tester.pumpWidget(_buildApp(['First', 'Second']));

    final isIOS = debugDefaultTargetPlatformOverride == TargetPlatform.iOS;
    expect(find.byType(GlassSegmentedControl), isIOS ? findsOneWidget : findsNothing);
    expect(find.byType(TabBar), isIOS ? findsNothing : findsOneWidget);

    await tester.tap(find.text('Second').first);
    await tester.pumpAndSettle();

    expect(find.text('Second content'), findsOneWidget);
    expect(find.text('First content'), findsNothing);
  });

  testWidgets('more tabs are a tab bar', variant: kPlatformVariant, (tester) async {
    await tester.pumpWidget(_buildApp(['First', 'Second', 'Third', 'Fourth']));

    expect(find.byType(GlassSegmentedControl), findsNothing);
    expect(find.byType(TabBar), findsOneWidget);
  });
}
