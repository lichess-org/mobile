import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoColors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/home/home_tab_screen.dart';
import 'package:lichess_mobile/src/view/learn/learn_tab_screen.dart';
import 'package:lichess_mobile/src/view/more/more_tab_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_tab_screen.dart';
import 'package:lichess_mobile/src/view/watch/watch_tab_screen.dart';
import 'package:lichess_mobile/src/widgets/background.dart';
import 'package:lichess_mobile/src/widgets/platform.dart'
    show BlurredBarBackground, tintedGlassSettings, useLiquidGlass, usePinnedNavBar;
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show GlassNavigationShell, GlassScaffold, GlassTab, GlassTabBar, LiquidGlassSettings;
import 'package:material_ui/material_ui.dart';

/// Main scaffold that provides the bottom navigation bar and tab switching view.
class const MainTabScaffold({super.key}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentBottomTabProvider);

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final body = _TabSwitchingView(currentTab: currentTab, tabBuilder: _tabBuilder);

    final tabBarVisibility = tabNavigatorObservers[currentTab]!.tabBarVisibility;

    if (!isIOS) {
      final tabBarHeight =
          (NavigationBarTheme.of(context).height ?? _kNavigationBarDefaultHeight) +
          MediaQuery.paddingOf(context).bottom;
      final navigationBar = NavigationBar(
        selectedIndex: currentTab.index,
        destinations: [
          for (final tab in BottomTab.values)
            NavigationDestination(
              icon: Icon(tab.icon, fill: tab == currentTab ? 1 : 0),
              label: tab.label(context.l10n),
            ),
        ],
        onDestinationSelected: (i) => _onItemTapped(ref, i),
      );
      // The tab navigators cover the whole screen, below the navigation bar: the routes shown with
      // it are laid out above it ([TabRoutePage]), the routes hiding it cover the whole screen.
      return FullScreenBackground(
        child: Builder(
          builder: (context) => ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _TabBarLayout(
              height: tabBarHeight,
              extendBody: false,
              child: Stack(
                children: [
                  Positioned.fill(child: body),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    // Rebuilt with the media query (on every frame of a keyboard animation), but
                    // the navigation bar is the same widget.
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: _TabBarTransition(visibility: tabBarVisibility, child: navigationBar),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // On iOS the tabs content extends below a floating liquid glass tab bar, or before iOS 26 a
    // docked translucent one.
    // The package default label color: the app Cupertino theme text color (onSurface) has less
    // contrast over the content seen through the glass.
    final tabColor = CupertinoColors.label.resolveFrom(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glass = useLiquidGlass(context);
    // The package default indicator color in light mode.
    final indicatorColor = isDark ? const Color(0x80000000) : const Color(0x1A000000);
    final glassSettings = isDark
        // Tinted like the other glass controls ([tintedGlassSettings]): a theme surface color.
        ? _kTabBarGlassSettings.copyWith(glassColor: tintedGlassSettings(context).glassColor)
        : _kTabBarGlassSettings;
    // The glass, icons, labels and selection indicator of the glass tab bar are faded through its
    // own parameters with the same [visibility], since glass cannot be faded by an ancestor
    // [Opacity] and its content is not a child of its glass.
    GlassTabBar buildGlassTabBar(double visibility) {
      Color fade(Color color) => color.withValues(alpha: color.a * visibility);
      return GlassTabBar.bottom(
        settings: visibility == 1.0
            ? glassSettings
            : glassSettings.copyWith(visibility: visibility),
        indicatorColor: fade(indicatorColor),
        selectedIconColor: fade(tabColor),
        unselectedIconColor: fade(tabColor),
        selectedIndex: currentTab.index,
        tabs: [
          for (final tab in BottomTab.values)
            GlassTab(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.icon, fill: 1),
              label: tab.label(context.l10n),
            ),
        ],
        onTabSelected: (i) => _onItemTapped(ref, i),
      );
    }

    final PreferredSizeWidget tabBar = !glass
        ? _BlurredTabBar(
            currentTab: currentTab,
            onTap: (i) => _onItemTapped(ref, i),
            bottomPadding: MediaQuery.paddingOf(context).bottom,
          )
        : buildGlassTabBar(1.0);

    return FullScreenBackground(
      // The bars are outside of any Scaffold: provide a Material for their text and icons.
      child: Material(
        type: MaterialType.transparency,
        child: GlassScaffold(
          // Transparent with a background image or color, so that [FullScreenBackground] shows
          // through.
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // The background is a plain color, there is nothing worth sampling.
          enableBackgroundSampling: false,
          // Each tab screen resizes for the keyboard in its own Scaffold.
          resizeToAvoidBottomInset: false,
          bottomBar: _PreferredTabBarTransition(
            visibility: tabBarVisibility,
            tabBar: tabBar,
            builder: glass ? buildGlassTabBar : null,
          ),
          // The floating tab bar has no edge effect around it, like in iOS apps.
          bottomEdgeFade: false,
          // GlassScaffold does not inset the body: the routes shown with the tab bar get its height
          // as their bottom padding ([TabRoutePage]), and the tab screens' [PlatformScaffold]
          // extend their body into it.
          body: _TabBarLayout(
            height: tabBar.preferredSize.height,
            extendBody: true,
            // GlassScaffold installs a CupertinoTheme that sets the icon color to its primary
            // color: restore the app icon theme.
            child: IconTheme(data: IconTheme.of(context), child: body),
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
          case BottomTab.learn:
            learnTabInteraction.notifyItemTapped();
          case BottomTab.watch:
            watchTabInteraction.notifyItemTapped();
          case BottomTab.more:
            moreTabInteraction.notifyItemTapped();
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
          navigatorKey: learnNavigatorKey,
          tab: BottomTab.learn,
          builder: (context) => const LearnTabScreen(),
        );
      case 3:
        return _MaterialTabView(
          navigatorKey: watchNavigatorKey,
          tab: BottomTab.watch,
          builder: (context) => const WatchTabScreen(),
        );
      case 4:
        return _MaterialTabView(
          navigatorKey: moreNavigatorKey,
          tab: BottomTab.more,
          builder: (context) => const MoreTabScreen(),
        );
      default:
        assert(false, 'Unexpected tab');
        return const SizedBox.shrink();
    }
  }
}

// --

// Below code taken and adapted from https://github.com/flutter/flutter/blob/135454af32477f815a7525073027a3ff9eff1bfd/packages/flutter/lib/src/cupertino/tab_scaffold.dart#L403

/// A widget laying out multiple tabs with only one active tab being built
/// at a time and on stage. Off stage tabs' animations are stopped.
class const _TabSwitchingView({
  required final BottomTab currentTab,
  required final IndexedWidgetBuilder tabBuilder,
}) extends StatefulWidget {
  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState() extends State<_TabSwitchingView> {
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

class const _MaterialTabView({
  // ignore: unused_element_parameter
  super.key,
  required final BottomTab tab,
  final WidgetBuilder? builder,
  final GlobalKey<NavigatorState>? navigatorKey,
  // ignore: unused_element_parameter
  final Map<String, WidgetBuilder>? routes,
  // ignore: unused_element_parameter
  final RouteFactory? onGenerateRoute,
  // ignore: unused_element_parameter
  final RouteFactory? onUnknownRoute,
  // ignore: unused_element_parameter
  final List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
  // ignore: unused_element_parameter
  final String? restorationScopeId,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MaterialTabView> createState() => _MaterialTabViewState();
}

class _MaterialTabViewState() extends ConsumerState<_MaterialTabView> {
  late HeroController _heroController;
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
      ..add(_heroController)
      ..add(tabNavigatorObservers[widget.tab]!);
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(currentBottomTabProvider);
    final enablePopHandler = currentTab == widget.tab;
    final observer = tabNavigatorObservers[widget.tab]!;
    final tabBarLayout = _TabBarLayout.of(context);
    // One shell per navigator: it ranks the routes of a single navigator.
    final shell = GlassNavigationShell(
      enabled: usePinnedNavBar(context),
      // The routes that are not pages (sheets, dialogs, menus) are laid out for the tab bar while
      // it is shown, and over the whole screen while a route hides it.
      //
      // The shape of the tree is the same either way: a change of shape would move the navigator
      // (it has a global key), deactivating and activating every element of the tab, which is
      // costly and trips an overlay portal whose controller is attached elsewhere meanwhile.
      child: ListenableBuilder(
        listenable: observer,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          final tabBarShown = !observer.hasTabBarHidingRoute;
          return MediaQuery(
            data: tabBarShown
                ? mediaQuery.copyWith(
                    padding: mediaQuery.padding.copyWith(bottom: tabBarLayout.height),
                  )
                : mediaQuery,
            child: MainTabScaffoldProperties(
              // Like no properties at all, while the tab bar is hidden.
              extendBody: tabBarShown && tabBarLayout.extendBody,
              child: child!,
            ),
          );
        },
        child: Navigator(
          key: widget.navigatorKey,
          onGenerateRoute: _onGenerateRoute,
          onUnknownRoute: _onUnknownRoute,
          observers: _navigatorObservers,
          restorationScopeId: widget.restorationScopeId,
        ),
      ),
    );
    // The media query changes on every frame of a keyboard animation: only this builder rebuilds
    // then, the shell and the navigator under it are the same widgets.
    final scope = Builder(
      builder: (context) => TabNavigatorScope(
        observer: observer,
        mediaQuery: MediaQuery.of(context),
        tabBarHeight: tabBarLayout.height,
        extendBody: tabBarLayout.extendBody,
        child: shell,
      ),
    );
    return NavigatorPopHandler(
      onPopWithResult: enablePopHandler
          ? (_) {
              widget.navigatorKey?.currentState?.maybePop();
            }
          : null,
      enabled: enablePopHandler,
      child: scope,
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
      final builder = routeBuilder;
      return MaterialPageRoute<dynamic>(
        builder: (context) => TabRoutePage(child: builder(context)),
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

/// The package defaults of the tab bar (`kBottomBarGlassDefaults`, not exported), with less blur and
/// no desaturation, closer to the iOS 26 tab bar, which keeps the colors of the content behind it.
/// The tint is more opaque than the package default, so that busy content (boards) seen through the
/// bar does not compete with the tab labels.
const _kTabBarGlassSettings = LiquidGlassSettings(
  thickness: 30,
  blur: 1,
  chromaticAberration: 0.3,
  lightIntensity: 0.6,
  refractiveIndex: 1.59,
  saturation: 1.0,
  ambientStrength: 1,
  lightAngle: 0.75 * math.pi,
  glassColor: Color(0xBFFFFFFF),
);

/// The default height of the Material 3 [NavigationBar], above the bottom safe area.
const double _kNavigationBarDefaultHeight = 80.0;

/// The tab bar layout, for the tab navigators (see [TabNavigatorScope]).
class const _TabBarLayout({
  /// The height of the tab bar, including the bottom safe area.
  required final double height,

  /// Whether the routes extend their body behind the tab bar.
  required final bool extendBody,
  required super.child,
}) extends InheritedWidget {
  static _TabBarLayout of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TabBarLayout>()!;
  }

  @override
  bool updateShouldNotify(_TabBarLayout oldWidget) {
    return height != oldWidget.height || extendBody != oldWidget.extendBody;
  }
}

/// Fades the tab bar in and out with [visibility] (see [TabNavigatorObserver.tabBarVisibility]).
///
/// The tab bar is the [child], faded by a [FadeTransition], or is built by [builder] with the
/// visibility, to fade itself (glass cannot be faded by an ancestor [Opacity]). It can only be used
/// once fully visible.
class const _TabBarTransition({
  required final Animation<double> visibility,
  final Widget? child,
  final Widget Function(double visibility)? builder,
}) extends StatelessWidget {
  this : assert((child == null) != (builder == null));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: visibility,
      builder: (context, child) {
        final visible = visibility.value == 1.0;
        return IgnorePointer(
          ignoring: !visible,
          child: ExcludeSemantics(excluding: !visible, child: child ?? builder!(visibility.value)),
        );
      },
      child: child != null ? FadeTransition(opacity: visibility, child: child) : null,
    );
  }
}

/// A [_TabBarTransition] for the bottom bar of a [GlassScaffold], which reads the height of the
/// [tabBar].
class const _PreferredTabBarTransition({
  required final Animation<double> visibility,
  required final PreferredSizeWidget tabBar,

  /// Builds the [tabBar] with the visibility, for a tab bar that fades itself.
  final Widget Function(double visibility)? builder,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return builder != null
        ? _TabBarTransition(visibility: visibility, builder: builder)
        : _TabBarTransition(visibility: visibility, child: tabBar);
  }
}

/// Height of the [_BlurredTabBar], above the bottom safe area, like the iOS 18 tab bar.
const double _kBlurredTabBarHeight = 50.0;

/// The tab bar before iOS 26 ([useLiquidGlass]), in place of the glass one: docked at the bottom of
/// the screen on a [BlurredBarBackground], like the iOS 18 tab bar.
class const _BlurredTabBar({
  required final BottomTab currentTab,
  required final ValueChanged<int> onTap,

  /// The bottom safe area, which the bar extends into.
  required final double bottomPadding,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(_kBlurredTabBarHeight + bottomPadding);

  @override
  Widget build(BuildContext context) {
    final activeColor = ColorScheme.of(context).onSurface;
    final inactiveColor = CupertinoColors.inactiveGray.resolveFrom(context);
    // Like the iOS tab bar, the labels are not scaled.
    return MediaQuery.withNoTextScaling(
      child: BlurredBarBackground(
        atBottom: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: SizedBox(
            height: _kBlurredTabBarHeight,
            child: Row(
              children: [
                for (final tab in BottomTab.values)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: tab == currentTab,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTap(tab.index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 2.0,
                          children: [
                            Icon(
                              tab.icon,
                              fill: tab == currentTab ? 1 : 0,
                              color: tab == currentTab ? activeColor : inactiveColor,
                            ),
                            Text(
                              tab.label(context.l10n),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: tab == currentTab ? activeColor : inactiveColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
