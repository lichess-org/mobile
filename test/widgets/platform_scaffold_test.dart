import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

/// The app bar tint layers: an [AnimatedOpacity] over a [DecoratedBox] with a hairline border.
Iterable<AnimatedOpacity> appBarTints(WidgetTester tester) => tester
    .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
    .where(
      (w) =>
          w.child is DecoratedBox &&
          ((w.child! as DecoratedBox).decoration as BoxDecoration).border != null,
    );

Widget makeScreen({bool reverse = false, Widget? title = const Text('Title')}) => PlatformScaffold(
  appBar: PlatformAppBar(title: title),
  body: ListView.builder(
    reverse: reverse,
    itemCount: 100,
    itemBuilder: (context, i) => SizedBox(height: 50, child: Text('item $i')),
  ),
);

void main() {
  group('iOS app bar tint', () {
    testWidgets('appears only while content is scrolled under the app bar', (tester) async {
      await tester.pumpWidget(await makeTestProviderScopeApp(tester, home: makeScreen()));
      await tester.pumpAndSettle();
      expect(appBarTints(tester).single.opacity, 0.0);

      await tester.drag(find.text('item 3'), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(appBarTints(tester).single.opacity, 1.0);

      await tester.drag(find.byType(ListView), const Offset(0, 2000));
      await tester.pumpAndSettle();
      expect(appBarTints(tester).single.opacity, 0.0);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

    testWidgets('appears at once over a reversed list', (tester) async {
      await tester.pumpWidget(
        await makeTestProviderScopeApp(tester, home: makeScreen(reverse: true)),
      );
      await tester.pumpAndSettle();
      expect(appBarTints(tester).single.opacity, 1.0);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

    testWidgets('is absent without a title', (tester) async {
      await tester.pumpWidget(
        await makeTestProviderScopeApp(tester, home: makeScreen(title: null)),
      );
      await tester.pumpAndSettle();
      expect(appBarTints(tester), isEmpty);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));
  });
}
