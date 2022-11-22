import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/utils/extensions/l10n_context.dart';

import 'constants.dart';

import 'features/authentication/ui/auth_widget.dart';
import 'features/settings/ui/settings_screen.dart';
import 'features/settings/ui/theme_mode_screen.dart';
import 'features/settings/ui/theme_mode_controller.dart';
import './utils/lichess_icons.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    return MaterialApp.router(
      restorationScopeId: 'app',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: kSupportedLocales,
      onGenerateTitle: (BuildContext context) => 'lichess.org',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/puzzles',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/puzzles',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const PuzzlesScreen(),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) =>
                  const DetailsScreen(label: 'Puzzles'),
            ),
          ],
        ),
        GoRoute(
          path: '/watch',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const RootScreen(
                label: 'Watch',
                detailsPath: '/watch/details',
                fullScreenPath: '/watch/details_fullscreen'),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) => const DetailsScreen(label: 'Watch'),
            ),
            GoRoute(
              path: 'details_fullscreen',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const DetailsFullscreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'themeMode',
              builder: (context, state) => const ThemeModeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  final tabs = const [
    '/puzzles',
    '/watch',
    '/settings',
  ];

  int _locationToTabIndex(String location) {
    final index = tabs.indexWhere((t) => location.startsWith(t));
    // if index not found (-1), return 0
    return index < 0 ? 0 : index;
  }

  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  void _onItemTapped(BuildContext context, int tabIndex) {
    // Only navigate if the tab index has changed
    if (tabIndex != _currentIndex) {
      context.go(tabs[tabIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    const icons = {
      '/puzzles': Icon(LichessIcons.target),
      '/watch': Icon(Icons.live_tv),
      '/settings': Icon(Icons.settings),
    };
    final labels = {
      '/puzzles': context.l10n.puzzles,
      '/watch': context.l10n.watch,
      '/settings': context.l10n.settings,
    };
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kOrange,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: icons[tab]!,
              label: labels[tab]!,
            )
        ],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

/// Widget for the root/initial pages in the bottom navigation bar.
class RootScreen extends StatelessWidget {
  /// Creates a RootScreen
  const RootScreen(
      {required this.label,
      required this.detailsPath,
      required this.fullScreenPath,
      Key? key})
      : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;
  final String fullScreenPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab root - $label'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Screen $label',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () => context.go(detailsPath),
              child: const Text('View details'),
            ),
            TextButton(
              onPressed: () => context.go(fullScreenPath),
              child: const Text('View details fullscreen'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsFullscreen extends StatelessWidget {
  /// Creates a RootScreen
  const DetailsFullscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details fullscreen'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Details fullscreen',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
          ],
        ),
      ),
    );
  }
}

/// The details screen for either the A or B screen.
class DetailsScreen extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const DetailsScreen({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<DetailsScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen - ${widget.label}'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Details for ${widget.label} - Counter: $_counter',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: const Text('Increment counter'),
            ),
          ],
        ),
      ),
    );
  }
}

class PuzzlesScreen extends StatelessWidget {
  const PuzzlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('lichess.org'), actions: const [
        AuthWidget(),
      ]),
      body: const Center(child: Text('Todo')),
    );
  }
}
