import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/styles/puzzle_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/layout.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:lichess_mobile/src/view/tools/tools_tab_screen.dart';
import 'package:lichess_mobile/src/view/watch/watch_tab_screen.dart';

enum BottomTab {
  play(Icons.home),
  puzzles(PuzzleIcons.mix),
  tools(CupertinoIcons.wrench),
  watch(Icons.live_tv);

  const BottomTab(this.icon);

  final IconData icon;

  String label(AppLocalizations strings) {
    switch (this) {
      case BottomTab.play:
        return strings.play;
      case BottomTab.puzzles:
        return strings.puzzles;
      case BottomTab.tools:
        return strings.tools;
      case BottomTab.watch:
        return strings.watch;
    }
  }
}

final currentBottomTabProvider =
    StateProvider<BottomTab>((ref) => BottomTab.play);

final currentNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.play:
      return homeNavigatorKey;
    case BottomTab.puzzles:
      return puzzlesNavigatorKey;
    case BottomTab.tools:
      return toolsNavigatorKey;
    case BottomTab.watch:
      return watchNavigatorKey;
  }
});

final currentRootScrollControllerProvider = Provider<ScrollController>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.play:
      return homeScrollController;
    case BottomTab.puzzles:
      return puzzlesScrollController;
    case BottomTab.tools:
      return toolsScrollController;
    case BottomTab.watch:
      return watchScrollController;
  }
});

final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final puzzlesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'puzzles');
final toolsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'tools');
final watchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'watch');

final homeScrollController = ScrollController(debugLabel: 'HomeScroll');
final puzzlesScrollController = ScrollController(debugLabel: 'PuzzlesScroll');
final toolsScrollController = ScrollController(debugLabel: 'ToolsScroll');
final watchScrollController = ScrollController(debugLabel: 'WatchScroll');

final RouteObserver<PageRoute<void>> rootNavPageRouteObserver =
    RouteObserver<PageRoute<void>>();

final RouteObserver<PageRoute<void>> homeRouteObserver =
    RouteObserver<PageRoute<void>>();

final tabsProvider = Provider<List<_Tab>>((ref) {
  final l10n = ref.watch(l10nProvider);

  return BottomTab.values.map((tab) {
    return _Tab(
      label: tab.label(l10n.strings),
      icon: Icon(
        tab.icon,
        size: tab == BottomTab.tools ? 22 : null,
      ),
    );
  }).toList();
});

/// Implements a tabbed (iOS style) root layout and behavior structure.
///
/// This widget is intended to be used as the root of the app, and it provides
/// the structure necessary to display tabs in iOS style. It also defines the
/// tab bar and tab switching behavior, but does not define the contents of
/// each tab.
class BottomNavScaffold extends ConsumerWidget {
  const BottomNavScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);
    final isHomeRoot = ref.watch(isHomeRootProvider);
    final tabs = ref.watch(tabsProvider);
    final isHandset = getScreenType(context) == ScreenType.handset;
    final shouldRemoveTabBarBorder =
        isHandset && currentTab == BottomTab.play && isHomeRoot;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return NavigatorPopHandler(
          onPop: () async {
            final navState = ref.read(currentNavigatorKeyProvider).currentState;
            return navState?.pop();
          },
          child: Scaffold(
            body: _TabSwitchingView(
              currentTab: currentTab,
              tabBuilder: _androidTabBuilder,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentTab.index,
              destinations: [
                for (final tab in tabs)
                  NavigationDestination(icon: tab.icon, label: tab.label),
              ],
              onDestinationSelected: (i) => _onItemTapped(ref, i),
            ),
          ),
        );
      case TargetPlatform.iOS:
        return CupertinoTabScaffold(
          tabBuilder: _iOSTabBuilder,
          tabBar: CupertinoTabBar(
            border: shouldRemoveTabBarBorder
                ? const Border(top: BorderSide.none)
                : const Border(
                    top: BorderSide(
                      color: Styles.cupertinoDefaultTabBarBorderColor,
                      width: 0.0, // 0.0 means one physical pixel
                    ),
                  ),
            currentIndex: currentTab.index,
            items: [
              for (final tab in tabs)
                BottomNavigationBarItem(icon: tab.icon, label: tab.label),
            ],
            onTap: (i) => _onItemTapped(ref, i),
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }

  /// If tapped tab is the same as the current tab, pop to the first route in
  /// the tab's stack.
  /// If the route is already at the first route, scroll the tab's root
  /// scrollable to the top.
  /// Otherwise, switch to the tapped tab.
  void _onItemTapped(WidgetRef ref, int index) {
    final curTab = ref.read(currentBottomTabProvider);
    final tappedTab = BottomTab.values[index];
    if (tappedTab == curTab) {
      final navState = ref.read(currentNavigatorKeyProvider).currentState;
      if (navState?.canPop() == true) {
        navState?.popUntil((route) => route.isFirst);
      } else {
        final scrollController = ref.read(currentRootScrollControllerProvider);
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    } else {
      ref.read(currentBottomTabProvider.notifier).state = tappedTab;
    }
  }

  Widget _androidTabBuilder(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _MaterialTabView(
          navigatorKey: homeNavigatorKey,
          navigatorObservers: [
            homeRouteObserver,
          ],
          builder: (context) => const HomeTabScreen(),
        );
      case 1:
        return _MaterialTabView(
          navigatorKey: puzzlesNavigatorKey,
          builder: (context) => const PuzzleTabScreen(),
        );
      case 2:
        return _MaterialTabView(
          navigatorKey: toolsNavigatorKey,
          builder: (context) => const ToolsTabScreen(),
        );
      case 3:
        return _MaterialTabView(
          navigatorKey: watchNavigatorKey,
          builder: (context) => const WatchTabScreen(),
        );
      default:
        assert(false, 'Unexpected tab');
        return const SizedBox.shrink();
    }
  }

  Widget _iOSTabBuilder(BuildContext context, int index) {
    switch (index) {
      case 0:
        return CupertinoTabView(
          defaultTitle: context.l10n.play,
          navigatorKey: homeNavigatorKey,
          navigatorObservers: [
            homeRouteObserver,
          ],
          builder: (context) => const HomeTabScreen(),
        );
      case 1:
        return CupertinoTabView(
          defaultTitle: context.l10n.puzzles,
          navigatorKey: puzzlesNavigatorKey,
          builder: (context) => const PuzzleTabScreen(),
        );
      case 2:
        return CupertinoTabView(
          defaultTitle: context.l10n.tools,
          navigatorKey: toolsNavigatorKey,
          builder: (context) => const ToolsTabScreen(),
        );
      case 3:
        return CupertinoTabView(
          defaultTitle: context.l10n.watch,
          navigatorKey: watchNavigatorKey,
          builder: (context) => const WatchTabScreen(),
        );
      default:
        assert(false, 'Unexpected tab');
        return const SizedBox.shrink();
    }
  }
}

// --

// Below code taken and adapted from https://github.com/flutter/flutter/blob/135454af32477f815a7525073027a3ff9eff1bfd/packages/flutter/lib/src/cupertino/tab_scaffold.dart#L403
// in order to have nested stateful navigation support in each tab on Android

/// A widget laying out multiple tabs with only one active tab being built
/// at a time and on stage. Off stage tabs' animations are stopped.
class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTab,
    required this.tabBuilder,
  });

  final BottomTab currentTab;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  final List<bool> shouldBuildTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];

  // When focus nodes are no longer needed, we need to dispose of them, but we
  // can't be sure that nothing else is listening to them until this widget is
  // disposed of, so when they are no longer needed, we move them to this list,
  // and dispose of them when we dispose of this widget.
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];

  @override
  void initState() {
    super.initState();
    shouldBuildTab.addAll(List<bool>.filled(BottomTab.values.length, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _focusActiveTab();
  }

  // Will focus the active tab if the FocusScope above it has focus already.  If
  // not, then it will just mark it as the preferred focus for that scope.
  void _focusActiveTab() {
    if (tabFocusNodes.length != BottomTab.values.length) {
      if (tabFocusNodes.length > BottomTab.values.length) {
        discardedNodes.addAll(tabFocusNodes.sublist(BottomTab.values.length));
        tabFocusNodes.removeRange(
          BottomTab.values.length,
          tabFocusNodes.length,
        );
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            BottomTab.values.length - tabFocusNodes.length,
            (int index) => FocusScopeNode(
              debugLabel:
                  '$BottomNavScaffold Tab ${index + tabFocusNodes.length}',
            ),
          ),
        );
      }
    }
    FocusScope.of(context)
        .setFirstFocus(tabFocusNodes[widget.currentTab.index]);
  }

  @override
  void dispose() {
    for (final FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final FocusScopeNode focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List<Widget>.generate(BottomTab.values.length, (int index) {
        final bool active = index == widget.currentTab.index;
        shouldBuildTab[index] = active || shouldBuildTab[index];

        return HeroMode(
          enabled: active,
          child: Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: tabFocusNodes[index],
                child: Builder(
                  builder: (BuildContext context) {
                    return shouldBuildTab[index]
                        ? widget.tabBuilder(context, index)
                        : Container();
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Tab {
  const _Tab({
    required this.label,
    required this.icon,
  });

  final String label;
  final Icon icon;
}

// Following code copied and adapted from
// https://github.com/flutter/flutter/blob/2ad6cd72c040113b47ee9055e722606a490ef0da/packages/flutter/lib/src/cupertino/tab_view.dart#L41

class _MaterialTabView extends StatefulWidget {
  const _MaterialTabView({
    // ignore: unused_element
    super.key,
    this.builder,
    this.navigatorKey,
    // ignore: unused_element
    this.routes,
    // ignore: unused_element
    this.onGenerateRoute,
    // ignore: unused_element
    this.onUnknownRoute,
    // ignore: unused_element
    this.navigatorObservers = const <NavigatorObserver>[],
    // ignore: unused_element
    this.restorationScopeId,
  });

  final WidgetBuilder? builder;

  final GlobalKey<NavigatorState>? navigatorKey;

  final Map<String, WidgetBuilder>? routes;

  final RouteFactory? onGenerateRoute;

  final RouteFactory? onUnknownRoute;

  final List<NavigatorObserver> navigatorObservers;

  final String? restorationScopeId;

  @override
  State<_MaterialTabView> createState() => _MaterialTabViewState();
}

class _MaterialTabViewState extends State<_MaterialTabView> {
  // ignore: avoid-late-keyword
  late HeroController _heroController;

  // ignore: avoid-late-keyword
  late List<NavigatorObserver> _navigatorObservers;

  @override
  void initState() {
    super.initState();
    _heroController = MaterialApp.createMaterialHeroController();
    _updateObservers();
  }

  @override
  void didUpdateWidget(_MaterialTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigatorKey != oldWidget.navigatorKey ||
        widget.navigatorObservers != oldWidget.navigatorObservers) {
      _updateObservers();
    }
  }

  void _updateObservers() {
    _navigatorObservers = List<NavigatorObserver>.of(widget.navigatorObservers)
      ..add(_heroController);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: _onGenerateRoute,
      onUnknownRoute: _onUnknownRoute,
      observers: _navigatorObservers,
      restorationScopeId: widget.restorationScopeId,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;
    WidgetBuilder? routeBuilder;
    if (name == Navigator.defaultRouteName && widget.builder != null) {
      routeBuilder = widget.builder;
    } else if (widget.routes != null) {
      routeBuilder = widget.routes![name];
    }
    if (routeBuilder != null) {
      return MaterialPageRoute<dynamic>(
        builder: routeBuilder,
        settings: settings,
      );
    }
    if (widget.onGenerateRoute != null) {
      return widget.onGenerateRoute!(settings);
    }
    return null;
  }

  Route<dynamic>? _onUnknownRoute(RouteSettings settings) {
    assert(() {
      if (widget.onUnknownRoute == null) {
        throw FlutterError(
          'Could not find a generator for route $settings in the $runtimeType.\n'
          'Generators for routes are searched for in the following order:\n'
          ' 1. For the "/" route, the "builder" property, if non-null, is used.\n'
          ' 2. Otherwise, the "routes" table is used, if it has an entry for '
          'the route.\n'
          ' 3. Otherwise, onGenerateRoute is called. It should return a '
          'non-null value for any valid route not handled by "builder" and "routes".\n'
          ' 4. Finally if all else fails onUnknownRoute is called.\n'
          'Unfortunately, onUnknownRoute was not set.',
        );
      }
      return true;
    }());
    final Route<dynamic>? result = widget.onUnknownRoute!(settings);
    assert(() {
      if (result == null) {
        throw FlutterError(
          'The onUnknownRoute callback returned null.\n'
          'When the $runtimeType requested the route $settings from its '
          'onUnknownRoute callback, the callback returned null. Such callbacks '
          'must never return null.',
        );
      }
      return true;
    }());
    return result;
  }
}
