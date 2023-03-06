import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/ui/home/home_screen.dart';
import 'package:lichess_mobile/src/ui/account/profile_screen.dart';
import 'package:lichess_mobile/src/ui/watch/watch_screen.dart';
import 'package:lichess_mobile/src/ui/puzzle/puzzle_dashboard_screen.dart';

enum BottomTab {
  play,
  puzzles,
  watch,
  profile;
}

final currentBottomTabProvider =
    StateProvider<BottomTab>((ref) => BottomTab.play);

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
      ref.read(currentBottomTabProvider.notifier).state =
          BottomTab.values[index];
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Scaffold(
          body: _TabSwitchingView(
            currentTab: currentTab,
            tabBuilder: _tabBuilder,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentTab.index,
            destinations: [
              for (final tab in tabs)
                NavigationDestination(icon: tab.icon, label: tab.label)
            ],
            onDestinationSelected: onItemTapped,
          ),
        );
      case TargetPlatform.iOS:
        return CupertinoTabScaffold(
          tabBuilder: _tabBuilder,
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

  Widget _tabBuilder(BuildContext context, int index) {
    switch (index) {
      case 0:
        return CupertinoTabView(
          defaultTitle: 'Home',
          builder: (context) => const HomeScreen(),
        );
      case 1:
        return CupertinoTabView(
          defaultTitle: context.l10n.puzzles,
          builder: (context) => const PuzzleDashboardScreen(),
        );
      case 2:
        return CupertinoTabView(
          defaultTitle: context.l10n.watch,
          builder: (context) => const WatchScreen(),
        );
      case 3:
        return CupertinoTabView(
          defaultTitle: context.l10n.profile,
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
