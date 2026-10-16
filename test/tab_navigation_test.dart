import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('TabNavigatorObserver', () {
    late TabNavigatorObserver observer;
    final navigatorKey = GlobalKey<NavigatorState>();

    Future<void> pumpNavigator(WidgetTester tester) async {
      observer = TabNavigatorObserver();
      addTearDown(observer.dispose);
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          navigatorObservers: [observer],
          home: const Text('root'),
        ),
      );
    }

    testWidgets('a route hiding the tab bar hides it, and fades it in when popped', (tester) async {
      await pumpNavigator(tester);
      expect(observer.tabBarVisibility.value, 1.0);
      expect(observer.hasTabBarHidingRoute, isFalse);

      navigatorKey.currentState!.pushHidingTabBar(_TestRoute(const Text('game')));
      await tester.pump();
      expect(observer.hasTabBarHidingRoute, isTrue);
      expect(observer.tabBarVisibility.value, 0.0);
      await tester.pump(const Duration(milliseconds: 100));
      expect(observer.tabBarVisibility.value, 0.0);

      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 0.0);

      navigatorKey.currentState!.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(observer.hasTabBarHidingRoute, isFalse);
      expect(observer.tabBarVisibility.value, inExclusiveRange(0.0, 1.0));

      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 1.0);
    });

    testWidgets('a route pushed above a route hiding the tab bar keeps it hidden', (tester) async {
      await pumpNavigator(tester);

      final gameRoute = _TestRoute(const Text('game'));
      navigatorKey.currentState!.pushHidingTabBar(gameRoute);
      await tester.pumpAndSettle();

      final profileRoute = _TestRoute(const Text('profile'));
      navigatorKey.currentState!.push(profileRoute);
      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 0.0);
      expect(observer.routeHidesTabBar(profileRoute), isTrue);

      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 0.0);
      expect(observer.hasTabBarHidingRoute, isTrue);

      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 1.0);
    });

    testWidgets('a route replacing a route hiding the tab bar keeps it hidden', (tester) async {
      await pumpNavigator(tester);

      navigatorKey.currentState!.pushHidingTabBar(_TestRoute(const Text('game 1')));
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pushReplacementHidingTabBar(_TestRoute(const Text('game 2')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(observer.tabBarVisibility.value, 0.0);

      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 0.0);

      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 1.0);
    });

    testWidgets('popping everything down to the root shows the tab bar', (tester) async {
      await pumpNavigator(tester);

      navigatorKey.currentState!.pushHidingTabBar(_TestRoute(const Text('game')));
      navigatorKey.currentState!.push(_TestRoute(const Text('profile')));
      await tester.pumpAndSettle();

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      await tester.pumpAndSettle();
      expect(observer.hasTabBarHidingRoute, isFalse);
      expect(observer.tabBarVisibility.value, 1.0);
    });

    testWidgets('a route that does not hide the tab bar leaves it visible', (tester) async {
      await pumpNavigator(tester);

      navigatorKey.currentState!.push(_TestRoute(const Text('profile')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(observer.tabBarVisibility.value, 1.0);
      await tester.pumpAndSettle();
      expect(observer.tabBarVisibility.value, 1.0);
      expect(observer.hasTabBarHidingRoute, isFalse);
    });
  });
}

class _TestRoute(final Widget page) extends MaterialPageRoute<void> {
  this : super(builder: (_) => page);
}
