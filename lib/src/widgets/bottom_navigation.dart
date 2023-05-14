import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/ui/home/home_screen.dart';
import 'package:lichess_mobile/src/ui/account/profile_screen.dart';
import 'package:lichess_mobile/src/ui/watch/watch_screen.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_dashboard_screen.dart';

enum BottomTab {
  home,
  puzzles,
  watch,
  profile;
}

final currentBottomTabProvider =
    StateProvider<BottomTab>((ref) => BottomTab.home);

final currentNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.home:
      return homeNavigatorKey;
    case BottomTab.puzzles:
      return puzzlesNavigatorKey;
    case BottomTab.watch:
      return watchNavigatorKey;
    case BottomTab.profile:
      return profileNavigatorKey;
  }
});

final currentRootScrollControllerProvider = Provider<ScrollController>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.home:
      return homeScrollController;
    case BottomTab.puzzles:
      return puzzlesScrollController;
    case BottomTab.watch:
      return watchScrollController;
    case BottomTab.profile:
      return profileScrollController;
  }
});

final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final puzzlesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'puzzles');
final watchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'watch');
final profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final homeScrollController = ScrollController(debugLabel: 'HomeScroll');
final puzzlesScrollController = ScrollController(debugLabel: 'PuzzlesScroll');
final watchScrollController = ScrollController(debugLabel: 'WatchScroll');
final profileScrollController = ScrollController(debugLabel: 'ProfileScroll');

/// Implements a tabbed (iOS style) root layout and behavior structure.
///
/// The scaffold lays out the tab bar at the bottom and the content between or
/// behind the tab bar.
class BottomNavScaffold extends ConsumerWidget {
  const BottomNavScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);

    final tabs = [
      const _Tab(
        label: 'Home',
        icon: Icon(Icons.home),
      ),
      _Tab(
        label: context.l10n.puzzles,
        icon: const Icon(LichessIcons.target),
      ),
      _Tab(
        label: context.l10n.watch,
        icon: const Icon(Icons.live_tv),
      ),
      _Tab(
        label: context.l10n.profile,
        icon: const Icon(CupertinoIcons.profile_circled),
      ),
    ];

    void onItemTapped(int index) {
      final curTab = ref.read(currentBottomTabProvider);
      final tappedTab = BottomTab.values[index];
      if (tappedTab == curTab) {
        final navState = ref.read(currentNavigatorKeyProvider).currentState;
        if (navState?.canPop() == true) {
          navState?.popUntil((route) => route.isFirst);
        } else {
          final scrollController =
              ref.read(currentRootScrollControllerProvider);
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

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return WillPopScope(
          onWillPop: () async {
            final navState = ref.read(currentNavigatorKeyProvider).currentState;
            final popResult = await navState?.maybePop();
            return popResult != null && !popResult;
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
                  NavigationDestination(icon: tab.icon, label: tab.label)
              ],
              onDestinationSelected: onItemTapped,
            ),
          ),
        );
      case TargetPlatform.iOS:
        return CupertinoTabScaffold(
          tabBuilder: _iOSTabBuilder,
          tabBar: CupertinoTabBar(
            currentIndex: currentTab.index,
            items: [
              for (final tab in tabs)
                BottomNavigationBarItem(icon: tab.icon, label: tab.label)
            ],
            onTap: onItemTapped,
          ),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }

  Widget _androidTabBuilder(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _MaterialTabView(
          navigatorKey: homeNavigatorKey,
          builder: (context) => const HomeScreen(),
        );
      case 1:
        return _MaterialTabView(
          navigatorKey: puzzlesNavigatorKey,
          builder: (context) => const PuzzleDashboardScreen(),
        );
      case 2:
        return _MaterialTabView(
          navigatorKey: watchNavigatorKey,
          builder: (context) => const WatchScreen(),
        );
      case 3:
        return _MaterialTabView(
          navigatorKey: profileNavigatorKey,
          builder: (context) => const ProfileScreen(),
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
          defaultTitle: 'Home',
          navigatorKey: homeNavigatorKey,
          builder: (context) => const HomeScreen(),
        );
      case 1:
        return CupertinoTabView(
          defaultTitle: context.l10n.puzzles,
          navigatorKey: puzzlesNavigatorKey,
          builder: (context) => const PuzzleDashboardScreen(),
        );
      case 2:
        return CupertinoTabView(
          defaultTitle: context.l10n.watch,
          navigatorKey: watchNavigatorKey,
          navigatorObservers: [watchRouteObserver],
          builder: (context) => const WatchScreen(),
        );
      case 3:
        return CupertinoTabView(
          defaultTitle: context.l10n.profile,
          navigatorKey: profileNavigatorKey,
          builder: (context) => const ProfileScreen(),
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
