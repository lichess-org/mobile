---
paths:
  - "lib/src/view/**/*.dart"
  - "lib/src/widgets/**/*.dart"
  - "lib/src/service/**/*.dart"
  - "lib/src/tab_*.dart"
  - "lib/src/app.dart"
---

# Views

## Navigation

There is one navigator per tab (`tab_navigation.dart`, `tab_scaffold.dart`), plus the root
navigator above `MainTabScaffold`. Deep links are resolved in `app_links.dart`.

- Push screens on the current navigator, `Navigator.of(context)`. Never push a screen with
  `rootNavigator: true`.
- Push a full screen (game, puzzle, analysis, study, any board screen) with
  `Navigator.of(context).pushHidingTabBar(route)` (or `pushReplacementHidingTabBar` /
  `pushAndRemoveUntilHidingTabBar`). `popUntilTabBarShown()` pops back to the screen below.
- Use the root navigator only for:
  - dialogs (Flutter's default) and fullscreen dialogs;
  - sheets and action sheets presented from a screen with the tab bar shown
    (`useRootNavigator: true`);
  - pushes from services (notifications, deep links, quick actions).
- A dialog on root over a tab screen can't push on the screen's navigator: close it and call back
  with the screen's context (e.g. `onAnalysisCallback` of `GameResultDialog`).
- Route observers are per navigator: a `RouteAware` screen subscribes to
  `pageRouteObserverOf(context)`; stack lookups use `routeStackObserverOf(navigator)`.

## Widgets

- Don't write functions returning widgets: write a `StatelessWidget` class.
- Inline a private widget used only once. Write a reusable widget as a class, even if only one
  screen uses it.
- Read the media query with its specific accessors (`MediaQuery.paddingOf`, `sizeOf`,
  `viewInsetsOf`, `orientationOf`...), never `MediaQuery.of(context)`, which rebuilds on every
  change of any field. When the whole data is needed, read it in a small `Builder` around children
  built outside it (`_MaterialTabViewState` in `tab_scaffold.dart`).
- A screen that loads builds the same tree down to its app bar in every `AsyncValue` state: one
  `PlatformScaffold` (with the same wrappers, e.g. `WakelockWidget`) whose title, actions and body
  switch on the state. Never a different scaffold per state, or a widget class of its own for the
  loaded state (`analysis_screen.dart`, `retro_screen.dart`).

## Screens and app bars

- Build screens with `PlatformScaffold` + `PlatformAppBar` (`platform.dart`), never a bare
  `Scaffold` + `AppBar`.
- When an action watches providers the screen doesn't, or the screen has no ref, use
  `PlatformAppBar.actionsBuilder: (context, ref) => [...]` and that context and ref.
- Never make an action a widget class of its own that navigates, presents or reads providers with
  its own context or ref: give it callbacks.
- Tabs in an app bar: `PlatformTabBar` (`platform_tab_bar.dart`) as the `PlatformAppBar` `bottom`,
  never a Material `TabBar`. In the content, use `PlatformTabBar(glass: false)`.
