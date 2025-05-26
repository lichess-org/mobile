import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:lichess_mobile/src/view/tools/tools_tab_screen.dart';
import 'package:lichess_mobile/src/view/watch/watch_tab_screen.dart';
import 'package:lichess_mobile/src/widgets/background.dart';
import 'package:material_symbols_icons/symbols.dart';

enum BottomTab {
  home,
  puzzles,
  watch,
  tools;

  String label(AppLocalizations strings) {
    switch (this) {
      case BottomTab.home:
        return strings.mobileHomeTab;
      case BottomTab.puzzles:
        return strings.mobilePuzzlesTab;
      case BottomTab.tools:
        return strings.mobileToolsTab;
      case BottomTab.watch:
        return strings.mobileWatchTab;
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
      case BottomTab.tools:
        return Symbols.handyman_rounded;
    }
  }
}

class _BottomTabNotifier extends Notifier<BottomTab> {
  @override
  BottomTab build() {
    return BottomTab.home;
  }

  @override
  set state(BottomTab tab) {
    state = tab;
  }
}

final currentBottomTabProvider = NotifierProvider.autoDispose<_BottomTabNotifier, BottomTab>(
  _BottomTabNotifier.new,
  name: 'currentBottomTabProvider',
);

final currentNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  final currentTab = ref.watch(currentBottomTabProvider);
  switch (currentTab) {
    case BottomTab.home:
      return homeNavigatorKey;
    case BottomTab.puzzles:
      return puzzlesNavigatorKey;
    case BottomTab.watch:
      return watchNavigatorKey;
    case BottomTab.tools:
      return toolsNavigatorKey;
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

final RouteObserver<PageRoute<void>> rootNavPageRouteObserver = RouteObserver<PageRoute<void>>();

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
final watchTabInteraction = _BottomTabInteraction();

class _BottomTabInteraction extends ChangeNotifier {
  void notifyItemTapped() {
    notifyListeners();
  }
}

/// Main scaffold that provides the bottom navigation bar and tab switching view.
class MainTabScaffold extends ConsumerWidget {
  const MainTabScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);

    final extendBody = Theme.of(context).platform == TargetPlatform.iOS;

    return FullScreenBackground(
      child: MainTabScaffoldProperties(
        extendBody: extendBody,
        child: Scaffold(
          body: _TabSwitchingView(currentTab: currentTab, tabBuilder: _tabBuilder),
          extendBody: extendBody,
          bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoTabBar(
                  height: 50,
                  backgroundColor: NavigationBarTheme.of(context).backgroundColor,
                  border: const Border(top: BorderSide(color: Colors.transparent)),
                  activeColor: ColorScheme.of(context).onSurface,
                  currentIndex: currentTab.index,
                  items: [
                    for (final tab in BottomTab.values)
                      BottomNavigationBarItem(
                        icon: Icon(tab.icon, fill: tab == currentTab ? 1 : 0),
                        label: tab.label(context.l10n),
                      ),
                  ],
                  onTap: (i) => _onItemTapped(ref, i),
                )
              : NavigationBar(
                  selectedIndex: currentTab.index,
                  destinations: [
                    for (final tab in BottomTab.values)
                      NavigationDestination(
                        icon: Icon(tab.icon, fill: tab == currentTab ? 1 : 0),
                        label: tab.label(context.l10n),
                      ),
                  ],
                  onDestinationSelected: (i) => _onItemTapped(ref, i),
                ),
        ),
      ),
    );
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
          case BottomTab.watch:
            watchTabInteraction.notifyItemTapped();
        }
      }
    } else {
      ref.read(currentBottomTabProvider.notifier).state = tappedTab;
    }
  }

  Widget _tabBuilder(BuildContext context, int index) {
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
          navigatorKey: watchNavigatorKey,
          tab: BottomTab.watch,
          builder: (context) => const WatchTabScreen(),
        );
      case 3:
        return _MaterialTabView(
          navigatorKey: toolsNavigatorKey,
          tab: BottomTab.tools,
          builder: (context) => const ToolsTabScreen(),
        );
      default:
        assert(false, 'Unexpected tab');
        return const SizedBox.shrink();
    }
  }
}

/// [InheritedWidget] providing [Scaffold] properties of the [MainTabScaffold].
class MainTabScaffoldProperties extends InheritedWidget {
  /// Constructs a new [MainTabScaffoldProperties].
  const MainTabScaffoldProperties({required super.child, required this.extendBody, super.key});

  /// The value of [Scaffold.extendBody] defined in the [MainTabScaffold].
  final bool extendBody;

  @override
  bool updateShouldNotify(MainTabScaffoldProperties oldWidget) {
    return extendBody != oldWidget.extendBody;
  }

  /// Retrieve the [MainTabScaffoldProperties] background color from the context.
  static MainTabScaffoldProperties? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainTabScaffoldProperties>();
  }

  /// Returns true if the [MainTabScaffold] has an extended body.
  static bool hasExtendedBody(BuildContext context) {
    final properties = maybeOf(context);
    return properties != null && properties.extendBody;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('extendBody', extendBody));
  }
}

// --

// Below code taken and adapted from https://github.com/flutter/flutter/blob/135454af32477f815a7525073027a3ff9eff1bfd/packages/flutter/lib/src/cupertino/tab_scaffold.dart#L403

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
            (int index) =>
                FocusScopeNode(debugLabel: '$MainTabScaffold Tab ${index + tabFocusNodes.length}'),
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
      onPopWithResult: enablePopHandler
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
