import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:lichess_mobile/src/view/settings/settings_tab_screen.dart';
import 'package:lichess_mobile/src/view/tools/tools_tab_screen.dart';
import 'package:lichess_mobile/src/view/watch/watch_tab_screen.dart';
import 'package:lichess_mobile/src/widgets/background.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

enum BottomTab {
  home,
  puzzles,
  tools,
  //watch,
  settings;

  String label(AppLocalizations strings) {
    switch (this) {
      case BottomTab.home:
        return strings.mobileHomeTab;
      case BottomTab.puzzles:
        return strings.mobilePuzzlesTab;
      case BottomTab.tools:
        return strings.mobileToolsTab;
      // case BottomTab.watch:
      //   return strings.mobileWatchTab;
      case BottomTab.settings:
        return strings.mobileSettingsTab;
    }
  }

  IconData get icon {
    switch (this) {
      case BottomTab.home:
        return Icons.home_outlined;
      case BottomTab.puzzles:
        return Icons.extension_outlined;
      case BottomTab.tools:
        return Icons.handyman_outlined;
      // case BottomTab.watch:
      //   return Icons.live_tv_outlined;
      case BottomTab.settings:
        return Icons.settings_outlined;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case BottomTab.home:
        return Icons.home;
      case BottomTab.puzzles:
        return Icons.extension;
      case BottomTab.tools:
        return Icons.handyman;
      // case BottomTab.watch:
      //   return Icons.live_tv;
      case BottomTab.settings:
        return Icons.settings;
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
    case BottomTab.tools:
      return toolsNavigatorKey;
    // case BottomTab.watch:
    //   return watchNavigatorKey;
    case BottomTab.settings:
      return settingsNavigatorKey;
  }
});

final currentRootScrollControllerProvider = Provider<ScrollController>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.home:
      return homeScrollController;
    case BottomTab.puzzles:
      return puzzlesScrollController;
    case BottomTab.tools:
      return toolsScrollController;
    // case BottomTab.watch:
    //   return watchScrollController;
    case BottomTab.settings:
      return settingsScrollController;
  }
});

final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final puzzlesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'puzzles');
final toolsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'tools');
//final watchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'watch');
final settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final homeScrollController = ScrollController(debugLabel: 'HomeScroll');
final puzzlesScrollController = ScrollController(debugLabel: 'PuzzlesScroll');
final toolsScrollController = ScrollController(debugLabel: 'ToolsScroll');
//final watchScrollController = ScrollController(debugLabel: 'WatchScroll');
final settingsScrollController = ScrollController(debugLabel: 'SettingsScroll');

final RouteObserver<PageRoute<void>> rootNavPageRouteObserver = RouteObserver<PageRoute<void>>();

final _cupertinoTabController = CupertinoTabController();

/// A [ChangeNotifier] that can be used to notify when the Home tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
final homeTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the Puzzles tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
final puzzlesTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the Tools tab is tapped, and all the built interactions
/// (pop stack, scroll to top) are done.
final toolsTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the Watch tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
//final watchTabInteraction = _BottomTabInteraction();

/// A [ChangeNotifier] that can be used to notify when the Settings tab is tapped, and all the built in
/// interactions (pop stack, scroll to top) are done.
final settingsTabInteraction = _BottomTabInteraction();

class _BottomTabInteraction extends ChangeNotifier {
  void notifyItemTapped() {
    notifyListeners();
  }
}

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

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return FullScreenBackground(
          child: Scaffold(
            body: _TabSwitchingView(currentTab: currentTab, tabBuilder: _androidTabBuilder),
            bottomNavigationBar: Consumer(
              builder: (context, ref, _) {
                final isOnline =
                    ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? true;
                return NavigationBar(
                  selectedIndex: currentTab.index,
                  destinations: [
                    for (final tab in BottomTab.values)
                      NavigationDestination(
                        icon: Icon(tab == currentTab ? tab.activeIcon : tab.icon),
                        label: tab.label(context.l10n),
                      ),
                  ],
                  onDestinationSelected: (i) => _onItemTapped(ref, i, isOnline: isOnline),
                );
              },
            ),
          ),
        );
      case TargetPlatform.iOS:
        final isOnline = ref.watch(connectivityChangesProvider).valueOrNull?.isOnline ?? true;
        return FullScreenBackground(
          child: CupertinoTabScaffold(
            tabBuilder: _iOSTabBuilder,
            controller: _cupertinoTabController,
            tabBar: CupertinoTabBar(
              currentIndex: currentTab.index,
              items: [
                for (final tab in BottomTab.values)
                  BottomNavigationBarItem(
                    icon: Icon(tab == currentTab ? tab.activeIcon : tab.icon),
                    label: tab.label(context.l10n),
                  ),
              ],
              onTap: (i) => _onItemTapped(ref, i, isOnline: isOnline),
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform ${Theme.of(context).platform}');
        return const SizedBox.shrink();
    }
  }

  /// If tapped tab is the same as the current tab, pop to the first route in
  /// the tab's stack.
  /// If the route is already at the first route, scroll the tab's root
  /// scrollable to the top.
  /// Otherwise, switch to the tapped tab.
  void _onItemTapped(WidgetRef ref, int index, {required bool isOnline}) {
    // if (index == BottomTab.watch.index && !isOnline) {
    //   _cupertinoTabController.index = ref.read(currentBottomTabProvider).index;
    //   showPlatformSnackbar(ref.context, 'Not available in offline mode', type: SnackBarType.info);
    //   return;
    // }

    final curTab = ref.read(currentBottomTabProvider);
    final tappedTab = BottomTab.values[index];

    if (tappedTab == curTab) {
      final navState = ref.read(currentNavigatorKeyProvider).currentState;
      final scrollController = ref.read(currentRootScrollControllerProvider);
      if (navState?.canPop() == true) {
        navState?.popUntil((route) => route.isFirst);
      } else if (scrollController.hasClients && scrollController.offset > 0) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        switch (tappedTab) {
          case BottomTab.home:
            homeTabInteraction.notifyItemTapped();
          case BottomTab.puzzles:
            puzzlesTabInteraction.notifyItemTapped();
          case BottomTab.tools:
            toolsTabInteraction.notifyItemTapped();
          /*case BottomTab.watch:
            watchTabInteraction.notifyItemTapped();*/
          case BottomTab.settings:
            settingsTabInteraction.notifyItemTapped();
        }
      }
    } else {
      ref.read(currentBottomTabProvider.notifier).state = tappedTab;
    }
  }
}

Widget _androidTabBuilder(BuildContext context, int index) {
  switch (index) {
    case 0:
      return _MaterialTabView(
        navigatorKey: homeNavigatorKey,
        tab: BottomTab.home,
        builder: (context) => const HomeTabScreen(),
      );
    case 1:
      return _MaterialTabView(
        navigatorKey: puzzlesNavigatorKey,
        tab: BottomTab.puzzles,
        builder: (context) => const PuzzleTabScreen(),
      );
    case 2:
      return _MaterialTabView(
        navigatorKey: toolsNavigatorKey,
        tab: BottomTab.tools,
        builder: (context) => const ToolsTabScreen(),
      );
    // case 3:
    //   return _MaterialTabView(
    //     navigatorKey: watchNavigatorKey,
    //     tab: BottomTab.watch,
    //     builder: (context) => const WatchTabScreen(),
    //   );
    case 3:
      return _MaterialTabView(
        navigatorKey: settingsNavigatorKey,
        tab: BottomTab.settings,
        builder: (context) => const SettingsTabScreen(),
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
        defaultTitle: context.l10n.mobileHomeTab,
        navigatorKey: homeNavigatorKey,
        builder: (context) => const HomeTabScreen(),
      );
    case 1:
      return CupertinoTabView(
        defaultTitle: context.l10n.mobilePuzzlesTab,
        navigatorKey: puzzlesNavigatorKey,
        builder: (context) => const PuzzleTabScreen(),
      );
    case 2:
      return CupertinoTabView(
        defaultTitle: context.l10n.mobileToolsTab,
        navigatorKey: toolsNavigatorKey,
        builder: (context) => const ToolsTabScreen(),
      );
    // case 3:
    //   return CupertinoTabView(
    //     defaultTitle: context.l10n.mobileWatchTab,
    //     navigatorKey: watchNavigatorKey,
    //     builder: (context) => const WatchTabScreen(),
    //   );
    case 3:
      return CupertinoTabView(
        defaultTitle: context.l10n.mobileSettingsTab,
        navigatorKey: settingsNavigatorKey,
        builder: (context) => const SettingsTabScreen(),
      );
    default:
      assert(false, 'Unexpected tab');
      return const SizedBox.shrink();
  }
}

// --

// Below code taken and adapted from https://github.com/flutter/flutter/blob/135454af32477f815a7525073027a3ff9eff1bfd/packages/flutter/lib/src/cupertino/tab_scaffold.dart#L403
// in order to have nested stateful navigation support in each tab on Android

/// A widget laying out multiple tabs with only one active tab being built
/// at a time and on stage. Off stage tabs' animations are stopped.
class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({required this.currentTab, required this.tabBuilder});

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
        tabFocusNodes.removeRange(BottomTab.values.length, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            BottomTab.values.length - tabFocusNodes.length,
            (int index) => FocusScopeNode(
              debugLabel: '$BottomNavScaffold Tab ${index + tabFocusNodes.length}',
            ),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTab.index]);
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
                    return shouldBuildTab[index] ? widget.tabBuilder(context, index) : Container();
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

// Following code copied and adapted from
// https://github.com/flutter/flutter/blob/2ad6cd72c040113b47ee9055e722606a490ef0da/packages/flutter/lib/src/cupertino/tab_view.dart#L41

class _MaterialTabView extends ConsumerStatefulWidget {
  const _MaterialTabView({
    // ignore: unused_element_parameter
    super.key,
    required this.tab,
    this.builder,
    this.navigatorKey,
    // ignore: unused_element_parameter
    this.routes,
    // ignore: unused_element_parameter
    this.onGenerateRoute,
    // ignore: unused_element_parameter
    this.onUnknownRoute,
    // ignore: unused_element_parameter
    this.navigatorObservers = const <NavigatorObserver>[],
    // ignore: unused_element_parameter
    this.restorationScopeId,
  });

  final BottomTab tab;

  final WidgetBuilder? builder;

  final GlobalKey<NavigatorState>? navigatorKey;

  final Map<String, WidgetBuilder>? routes;

  final RouteFactory? onGenerateRoute;

  final RouteFactory? onUnknownRoute;

  final List<NavigatorObserver> navigatorObservers;

  final String? restorationScopeId;

  @override
  ConsumerState<_MaterialTabView> createState() => _MaterialTabViewState();
}

class _MaterialTabViewState extends ConsumerState<_MaterialTabView> {
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
    final currentTab = ref.watch(currentBottomTabProvider);
    final enablePopHandler = currentTab == widget.tab;
    return NavigatorPopHandler(
      onPopWithResult:
          enablePopHandler
              ? (_) {
                widget.navigatorKey?.currentState?.maybePop();
              }
              : null,
      enabled: enablePopHandler,
      child: Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: _onGenerateRoute,
        onUnknownRoute: _onUnknownRoute,
        observers: _navigatorObservers,
        restorationScopeId: widget.restorationScopeId,
      ),
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
      return MaterialPageRoute<dynamic>(builder: routeBuilder, settings: settings);
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
