import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/haptic_refresh_indicator.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

Widget makeScreen() => PlatformScaffold(
  appBar: const PlatformAppBar(title: Text('Title')),
  body: HapticRefreshIndicator(
    onRefresh: () async {},
    child: ListView.builder(
      itemCount: 100,
      itemBuilder: (context, i) => SizedBox(height: 50, child: Text('item $i')),
    ),
  ),
);

double edgeOffset(WidgetTester tester) =>
    tester.widget<RefreshIndicator>(find.byType(RefreshIndicator)).edgeOffset;

void main() {
  testWidgets('iOS refresh indicator appears below the glass app bar', (tester) async {
    await tester.pumpWidget(await makeTestProviderScopeApp(tester, home: makeScreen()));
    await tester.pumpAndSettle();
    final listTop = tester.getTopLeft(find.text('item 0')).dy;
    expect(edgeOffset(tester), greaterThan(0));
    expect(edgeOffset(tester), listTop);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  testWidgets('Android refresh indicator has no edge offset', (tester) async {
    await tester.pumpWidget(await makeTestProviderScopeApp(tester, home: makeScreen()));
    await tester.pumpAndSettle();
    expect(edgeOffset(tester), 0.0);
  }, variant: const TargetPlatformVariant({TargetPlatform.android}));
}
