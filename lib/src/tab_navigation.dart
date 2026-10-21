import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

enum BottomTab() {
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
class RouteStackObserver() extends NavigatorObserver {
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

Animation<double>? _animationOf(Route<dynamic> route) =>
    route is TransitionRoute ? route.animation : null;

/// A [NavigatorObserver] of a tab navigator that tracks the routes hiding the tab bar, pushed with
/// [TabBarHidingNavigator.pushHidingTabBar].
///
/// A route hiding the tab bar fades it out, and the routes pushed above it keep it hidden until it
/// is popped. Its page is laid out over the whole screen, as if there was no tab bar.
///
/// It notifies its listeners when [hasTabBarHidingRoute] may have changed.
class TabNavigatorObserver() extends RouteStackObserver with ChangeNotifier {
  /// The routes pushed with [TabBarHidingNavigator.pushHidingTabBar].
  final Set<Route<dynamic>> _hidingRoutes = {};

  final ProxyAnimation _tabBarVisibility = ProxyAnimation(kAlwaysCompleteAnimation);

  /// The lowest route of the stack hiding the tab bar, or the last one popped while it is
  /// animating out.
  Route<dynamic>? _hidingRoute;

  /// The page route observer of the tab navigator, for [RouteAware] widgets (see
  /// [pageRouteObserverOf]).
  final RouteObserver<PageRoute<void>> pageRouteObserver = RouteObserver<PageRoute<void>>();

  /// The visibility of the tab bar, from 0 (hidden) to 1 (visible).
  ///
  /// Like the iOS tab bar, the tab bar is hidden as soon as a route hiding it starts being pushed,
  /// and fades back in with the animation of that route while it is popped, including during a
  /// back swipe.
  Animation<double> get tabBarVisibility => _tabBarVisibility;

  /// Whether a route of the stack hides the tab bar.
  ///
  /// It is false as soon as the last route hiding the tab bar starts being popped.
  bool get hasTabBarHidingRoute => _stack.any(_hidingRoutes.contains);

  /// Whether [route] is in the stack.
  bool contains(Route<dynamic> route) => _stack.contains(route);

  /// Whether the tab bar is hidden while [route] is shown: [route] hides it, or is above a route
  /// hiding it.
  bool routeHidesTabBar(Route<dynamic> route) {
    final index = _stack.indexOf(route);
    if (index < 0) return _hidingRoutes.contains(route);
    return _stack.take(index + 1).any(_hidingRoutes.contains);
  }

  /// Makes [route] hide the tab bar once it is pushed.
  void _hideTabBarFor(Route<dynamic> route) => _hidingRoutes.add(route);

  /// Clears the tracked stack. Only useful in tests, where the global instances are shared across
  /// test cases.
  @override
  @visibleForTesting
  void clear() {
    super.clear();
    _hidingRoutes.clear();
    _hidingRoute = null;
    _notifiedHasTabBarHidingRoute = false;
    _tabBarVisibility.parent = kAlwaysCompleteAnimation;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    pageRouteObserver.didPush(route, previousRoute);
    _update();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    pageRouteObserver.didPop(route, previousRoute);
    _update(popped: route);
    _hidingRoutes.remove(route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    pageRouteObserver.didRemove(route, previousRoute);
    _hidingRoutes.remove(route);
    _update();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    pageRouteObserver.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) _hidingRoutes.remove(oldRoute);
    _update();
  }

  void _update({Route<dynamic>? popped}) {
    final lowest = _stack.where(_hidingRoutes.contains).firstOrNull;
    if (lowest != null) {
      if (lowest != _hidingRoute) {
        _hidingRoute = lowest;
        _hideTabBar(lowest);
      }
    } else if (popped != null && popped == _hidingRoute && _animationOf(popped) != null) {
      // The tab bar fades in while the last route hiding it is popped.
      final animation = _animationOf(popped)!;
      _tabBarVisibility.parent = ReverseAnimation(animation);
      if (animation.isDismissed) {
        _showTabBar();
      } else {
        void listener(AnimationStatus status) {
          if (status != AnimationStatus.dismissed) return;
          animation.removeStatusListener(listener);
          if (_hidingRoute == popped) _showTabBar();
        }

        animation.addStatusListener(listener);
      }
    } else {
      _showTabBar();
    }
    _notifyIfChanged();
  }

  bool _notifiedHasTabBarHidingRoute = false;

  /// Notifies the listeners if [hasTabBarHidingRoute] changed, after the build phase if a route was
  /// pushed while building (e.g. the initial route).
  void _notifyIfChanged() {
    if (hasTabBarHidingRoute == _notifiedHasTabBarHidingRoute) return;
    _notifiedHasTabBarHidingRoute = hasTabBarHidingRoute;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    } else {
      notifyListeners();
    }
  }

  void _showTabBar() {
    _hidingRoute = null;
    _tabBarVisibility.parent = kAlwaysCompleteAnimation;
  }

  /// Hides the tab bar for [route], and makes it follow the animation of [route] once it is in, so
  /// that a back swipe fades it in.
  void _hideTabBar(Route<dynamic> route) {
    _tabBarVisibility.parent = kAlwaysDismissedAnimation;
    final animation = _animationOf(route);
    if (animation == null) return;
    if (animation.isCompleted) {
      _tabBarVisibility.parent = ReverseAnimation(animation);
      return;
    }
    // The status of a replacing route can be completed for a moment before it comes in, so the
    // route is followed until it is no longer the one hiding the tab bar: the tab bar is hidden
    // again whenever the route goes forward on its own, but not when a back swipe is abandoned,
    // which fades it out.
    void listener(AnimationStatus status) {
      if (_hidingRoute != route) {
        animation.removeStatusListener(listener);
      } else if (status == AnimationStatus.completed) {
        _tabBarVisibility.parent = ReverseAnimation(animation);
      } else if (status == AnimationStatus.forward &&
          !(route.navigator?.userGestureInProgress ?? false)) {
        _tabBarVisibility.parent = kAlwaysDismissedAnimation;
      }
    }

    animation.addStatusListener(listener);
  }
}

final Map<BottomTab, TabNavigatorObserver> tabNavigatorObservers = {
  for (final tab in BottomTab.values) tab: TabNavigatorObserver(),
};

/// Pushes routes that hide the tab bar while they are shown (see [TabNavigatorObserver]).
///
/// On a navigator that is not a tab navigator (the root one), they are plain pushes.
extension TabBarHidingNavigator on NavigatorState {
  TabNavigatorObserver? get _tabNavigatorObserver =>
      widget.observers.whereType<TabNavigatorObserver>().firstOrNull;

  /// Pushes [route], hiding the tab bar while it is shown. See [push].
  ///
  /// Such a route covers the whole screen, and is never stacked over a sheet: on the navigator of a
  /// navigation sheet ([showAdaptiveNavigationSheet]), it closes the sheet, then is pushed on the
  /// navigator that the sheet was presented on once the sheet is gone.
  Future<T?> pushHidingTabBar<T extends Object?>(Route<T> route) {
    final sheet = widget.observers.whereType<NavigationSheetObserver>().firstOrNull;
    if (sheet != null) {
      final sheetNavigator = sheet.sheetNavigator;
      if (sheet.sheetRoute.isCurrent) {
        sheetNavigator.pop();
      } else {
        sheetNavigator.removeRoute(sheet.sheetRoute);
      }
      return sheet.sheetRoute.completed.then(
        (_) => sheetNavigator.mounted ? sheetNavigator.pushHidingTabBar(route) : null,
      );
    }
    _tabNavigatorObserver?._hideTabBarFor(route);
    return push(route);
  }

  /// Replaces the current route with [newRoute], hiding the tab bar while it is shown. See
  /// [pushReplacement].
  Future<T?> pushReplacementHidingTabBar<T extends Object?, TO extends Object?>(
    Route<T> newRoute, {
    TO? result,
  }) {
    _tabNavigatorObserver?._hideTabBarFor(newRoute);
    return pushReplacement(newRoute, result: result);
  }

  /// Pushes [newRoute] and removes the routes below it until [predicate] returns true, hiding the
  /// tab bar while it is shown. See [pushAndRemoveUntil].
  Future<T?> pushAndRemoveUntilHidingTabBar<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) {
    _tabNavigatorObserver?._hideTabBarFor(newRoute);
    return pushAndRemoveUntil(newRoute, predicate);
  }

  /// Pops the routes hiding the tab bar, back to the route below them, shown with the tab bar. On a
  /// navigator that is not a tab navigator, pops back to its first route.
  void popUntilTabBarShown() {
    final observer = _tabNavigatorObserver;
    popUntil((route) => route.isFirst || !(observer?.routeHidesTabBar(route) ?? true));
  }
}

/// Whether the tab bar is hidden while the route of [context] is shown, in a tab navigator.
bool isTabBarHiddenAt(BuildContext context) {
  final scope = TabNavigatorScope.maybeOf(context);
  final route = ModalRoute.of(context);
  return scope != null && route != null && scope.observer.routeHidesTabBar(route);
}

/// The [RouteObserver] of the navigator of [context], to subscribe a [RouteAware] widget of a
/// page to.
RouteObserver<PageRoute<void>> pageRouteObserverOf(BuildContext context) {
  return Navigator.of(context).widget.observers
          .whereType<TabNavigatorObserver>()
          .firstOrNull
          ?.pageRouteObserver ??
      rootNavPageRouteObserver;
}

/// The [RouteStackObserver] of [navigator], if any.
RouteStackObserver? routeStackObserverOf(NavigatorState navigator) {
  return navigator.widget.observers.whereType<RouteStackObserver>().firstOrNull;
}

/// The layout that the main tab scaffold gives to the routes of a tab navigator, read by
/// [TabRoutePage].
class const TabNavigatorScope({
  required final TabNavigatorObserver observer,

  /// The [MediaQueryData] around the tab navigator, without the tab bar.
  required final MediaQueryData mediaQuery,

  /// The height of the tab bar, including the bottom safe area.
  required final double tabBarHeight,

  /// Whether the routes extend their body behind the tab bar (iOS), instead of being laid out above
  /// it (Android).
  required final bool extendBody,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static TabNavigatorScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabNavigatorScope>();
  }

  /// The [MediaQueryData] of the routes that are shown with the tab bar.
  MediaQueryData get tabBarMediaQuery => extendBody
      ? mediaQuery.copyWith(padding: mediaQuery.padding.copyWith(bottom: tabBarHeight))
      : mediaQuery.removePadding(removeBottom: true).removeViewInsets(removeBottom: true);

  /// The space below the routes that are shown with the tab bar, when they are laid out above it.
  double get tabBarBottomInset =>
      extendBody ? 0.0 : math.max(tabBarHeight, mediaQuery.viewInsets.bottom);

  @override
  bool updateShouldNotify(TabNavigatorScope oldWidget) {
    return observer != oldWidget.observer ||
        mediaQuery != oldWidget.mediaQuery ||
        tabBarHeight != oldWidget.tabBarHeight ||
        extendBody != oldWidget.extendBody;
  }
}

/// Lays out the page of a route of a tab navigator for the tab bar: with the tab bar, the page
/// extends behind it (iOS) or is laid out above it (Android); without it (see
/// [TabBarHidingNavigator.pushHidingTabBar]), the page covers the whole screen, like on the root
/// navigator.
///
/// On the root navigator, it returns [child] unchanged. In a navigation sheet
/// ([showAdaptiveNavigationSheet]), the scroll controller of the sheet is the primary scroll
/// controller of the page: its main scroll view drags the sheet once scrolled to its top.
class const TabRoutePage({required final Widget child, super.key}) extends StatefulWidget {
  @override
  State<TabRoutePage> createState() => _TabRoutePageState();
}

class _TabRoutePageState() extends State<TabRoutePage> {
  /// Whether the tab bar is hidden while the route is shown, which does not change during the
  /// lifetime of the route: cached, so that a route popped above a route hiding the tab bar keeps
  /// its layout while it animates out, once it is no longer in the stack.
  bool? _hidesTabBar;

  @override
  Widget build(BuildContext context) {
    // The sheet is closer than the tab navigator around it.
    final sheet = NavigationSheetScope.maybeOf(context);
    if (sheet != null) {
      return PrimaryScrollController(controller: sheet.scrollController, child: widget.child);
    }

    final scope = TabNavigatorScope.maybeOf(context);
    final route = ModalRoute.of(context);
    if (scope == null || route == null) return widget.child;

    final hidesTabBar = _hidesTabBar ??= scope.observer.contains(route)
        ? scope.observer.routeHidesTabBar(route)
        : null;
    if (hidesTabBar ?? scope.observer.routeHidesTabBar(route)) {
      return MediaQuery(data: scope.mediaQuery, child: widget.child);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: scope.tabBarBottomInset),
      child: MediaQuery(
        data: scope.tabBarMediaQuery,
        child: MainTabScaffoldProperties(extendBody: scope.extendBody, child: widget.child),
      ),
    );
  }
}

/// Tracks the stack of routes on the root navigator (see [rootNavRouteStackObserver]
/// registration in `app.dart`).
final RouteStackObserver rootNavRouteStackObserver = RouteStackObserver();

final RouteObserver<PageRoute<void>> rootNavPageRouteObserver = RouteObserver<PageRoute<void>>();

class BottomTabInteraction() extends ChangeNotifier {
  void notifyItemTapped() {
    notifyListeners();
  }
}

final homeTabInteraction = BottomTabInteraction();
final puzzlesTabInteraction = BottomTabInteraction();
final learnTabInteraction = BottomTabInteraction();
final watchTabInteraction = BottomTabInteraction();
final moreTabInteraction = BottomTabInteraction();

class const MainTabScaffoldProperties({
  required super.child,
  required final bool extendBody,
  super.key,
}) extends InheritedWidget {
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
