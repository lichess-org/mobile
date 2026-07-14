import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

enum BottomTab {
  home,
  puzzles,
  learn,
  watch,
  more;

  String label(AppLocalizations strings) {
    switch (this) {
      case BottomTab.home:
        return strings.mobileHomeTab;
      case BottomTab.puzzles:
        return strings.mobilePuzzlesTab;
      case BottomTab.learn:
        return strings.learnMenu;
      case BottomTab.watch:
        return strings.mobileWatchTab;
      case BottomTab.more:
        return strings.more;
    }
  }

  IconData get icon {
    switch (this) {
      case BottomTab.home:
        return Symbols.home_rounded;
      case BottomTab.puzzles:
        return Symbols.extension_rounded;
      case BottomTab.watch:
        return Symbols.live_tv_rounded;
      case BottomTab.learn:
        return Symbols.school_rounded;
      case BottomTab.more:
        return Symbols.menu_rounded;
    }
  }
}

final currentBottomTabProvider = StateProvider<BottomTab>((ref) => BottomTab.home);

final currentNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.home:
      return homeNavigatorKey;
    case BottomTab.puzzles:
      return puzzlesNavigatorKey;
    case BottomTab.learn:
      return learnNavigatorKey;
    case BottomTab.watch:
      return watchNavigatorKey;
    case BottomTab.more:
      return moreNavigatorKey;
  }
});

final currentRootScrollControllerProvider = Provider<ScrollController>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.home:
      return homeScrollController;
    case BottomTab.puzzles:
      return puzzlesScrollController;
    case BottomTab.learn:
      return learnScrollController;
    case BottomTab.watch:
      return watchScrollController;
    case BottomTab.more:
      return moreScrollController;
  }
});

final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final puzzlesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'puzzles');
final learnNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'learn');
final watchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'watch');
final moreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'more');

final homeScrollController = ScrollController(debugLabel: 'HomeScroll');
final puzzlesScrollController = ScrollController(debugLabel: 'PuzzlesScroll');
final learnScrollController = ScrollController(debugLabel: 'learnScroll');
final watchScrollController = ScrollController(debugLabel: 'WatchScroll');
final moreScrollController = ScrollController(debugLabel: 'MoreScroll');

/// A [NavigatorObserver] that keeps track of the routes currently on the
/// navigator it observes, so that code can query whether a named route is
/// present in the stack (which Flutter does not expose publicly).
class RouteStackObserver extends NavigatorObserver {
  final List<Route<dynamic>> _stack = [];

  /// Whether a route with the given [name] is currently in the stack.
  ///
  /// If [arguments] is provided, the route's [RouteSettings.arguments] must also
  /// be equal to it.
  bool containsRoute(String name, {Object? arguments}) => _stack.any(
    (route) =>
        route.settings.name == name && (arguments == null || route.settings.arguments == arguments),
  );

  /// Clears the tracked stack. Only useful in tests, where the global instance
  /// is shared across test cases.
  @visibleForTesting
  void clear() => _stack.clear();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final index = oldRoute != null ? _stack.indexOf(oldRoute) : -1;
    if (index >= 0 && newRoute != null) {
      _stack[index] = newRoute;
    } else {
      if (oldRoute != null) _stack.remove(oldRoute);
      if (newRoute != null) _stack.add(newRoute);
    }
  }
}

/// Tracks the stack of routes on the root navigator (see [rootNavRouteStackObserver]
/// registration in `app.dart`).
final RouteStackObserver rootNavRouteStackObserver = RouteStackObserver();

final RouteObserver<PageRoute<void>> rootNavPageRouteObserver = RouteObserver<PageRoute<void>>();

class BottomTabInteraction extends ChangeNotifier {
  void notifyItemTapped() {
    notifyListeners();
  }
}

final homeTabInteraction = BottomTabInteraction();
final puzzlesTabInteraction = BottomTabInteraction();
final learnTabInteraction = BottomTabInteraction();
final watchTabInteraction = BottomTabInteraction();
final moreTabInteraction = BottomTabInteraction();

class MainTabScaffoldProperties extends InheritedWidget {
  const MainTabScaffoldProperties({required super.child, required this.extendBody, super.key});

  final bool extendBody;

  @override
  bool updateShouldNotify(MainTabScaffoldProperties oldWidget) {
    return extendBody != oldWidget.extendBody;
  }

  static MainTabScaffoldProperties? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainTabScaffoldProperties>();
  }

  static bool hasExtendedBody(BuildContext context) {
    return maybeOf(context)?.extendBody ?? false;
  }
}
