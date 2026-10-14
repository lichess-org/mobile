import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' show GlassContainer;
import 'package:material_ui/material_ui.dart';

import '../test_provider_scope.dart';

/// The app bar tint layers: an [AnimatedOpacity] over a blur ([BackdropFilter]).
Iterable<AnimatedOpacity> appBarTints(WidgetTester tester) => tester.widgetList<AnimatedOpacity>(
  find.ancestor(of: find.byType(BackdropFilter), matching: find.byType(AnimatedOpacity)),
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

  testWidgets('iOS app bar leading capsule is only as wide as its content', (tester) async {
    await tester.pumpWidget(
      await makeTestProviderScopeApp(
        tester,
        home: PlatformScaffold(
          appBar: PlatformAppBar(
            leading: BackButton(onPressed: () {}),
            title: const Text('Title'),
          ),
          body: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final capsule = find.ancestor(
      of: find.byType(BackButton),
      matching: find.byType(GlassContainer),
    );
    expect(tester.getSize(capsule.first).width, lessThan(100));
    expect(find.text('Title'), findsOneWidget);
  }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

  group('iOS app bar title style', () {
    double titleFontSize(WidgetTester tester) =>
        DefaultTextStyle.of(tester.element(find.text('Title'))).style.fontSize!;

    testWidgets('is the large title on the root screen of a tab', (tester) async {
      await tester.pumpWidget(
        await makeTestProviderScopeApp(
          tester,
          home: const MainTabScaffoldProperties(
            extendBody: true,
            child: PlatformScaffold(
              appBar: PlatformAppBar(title: Text('Title')),
              body: SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(titleFontSize(tester), 34.0);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

    testWidgets('is the regular title elsewhere', (tester) async {
      await tester.pumpWidget(
        await makeTestProviderScopeApp(
          tester,
          home: const PlatformScaffold(
            appBar: PlatformAppBar(title: Text('Title')),
            body: SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(titleFontSize(tester), lessThan(34.0));
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));
  });
}
