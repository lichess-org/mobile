---
paths:
  - "lib/src/widgets/**/*.dart"
  - "lib/src/tab_scaffold.dart"
---

# iOS Liquid Glass (iOS 26 design)

iOS uses the iOS 26 liquid glass look through the `liquid_glass_widgets` package. Screens never
use the package directly: they use the app's `Platform*` widgets (`lib/src/widgets/`), which build
glass on iOS and Material elsewhere.

The `liquid-glass-widgets` skill is the package's own generic guide, kept as published. Use it for
the package API when changing a shared widget. Where it contradicts these rules (e.g. it suggests
`GlassScaffold`, `GlassModalSheet`, `GlassCard` or the `soft` edge effect), these rules win.

## General rules

- Android must not change: put every glass code path behind
  `Theme.of(context).platform == TargetPlatform.iOS`.
- Glass is only for the layer floating above content: bars, floating buttons, menus, popovers.
  Never make content glass (cards, list rows, forms, settings, sheet surfaces).
- Never put a glass element over another glass element. Controls embedded in a glass surface
  (dialog buttons) are part of it, which is fine.
- Use the package's default glass settings. Don't add app-wide glass overrides without asking.

## Before iOS 26 (fallback)

Glass is built only when `useLiquidGlass(context)` (`platform.dart`) is true. Before iOS 26 the
same layouts use plain controls and opaque surfaces. The fallback will be deleted once iOS < 26 is
dropped, so keep it cheap:

- Write every fallback branch as `if (!useLiquidGlass(context))` (or a ternary on it), deletable on
  its own while keeping the glass branch.
- Put fallback code in the shared widgets (`lib/src/widgets/`, `tab_scaffold.dart`), next to the
  glass code. Screens never branch on `useLiquidGlass`.
- Reuse what exists for a fallback (the Material path, a control's flat mode,
  `BlurredBarBackground`, `opaqueModalColor`). Never change glass code or a layout for it.
- A new glass widget gets its fallback in the same shared widget. If a plain equivalent isn't
  trivial, ask first.
- Don't test the fallback (tests run with glass).

## Controls

- Any control in an app bar `bottom` uses `kGlassAppBarBottomPadding` and
  `kGlassAppBarBottomControlHeight` (`platform.dart`) on iOS.
- Search field in an app bar: `PlatformSearchBar(inAppBar: true)`. Open a search screen with a
  `SearchHeroButton` in the app bar (never a fake search field in the body), and wrap the search
  screen's field in a `SearchFieldHero` with the same tag.
- Text fields: don't give an iOS field its own `border` radius (the iOS theme makes them capsules).
- Bottom toolbar: `BottomBar(cupertinoGlass: true)` with `BottomBarButton` /
  `BottomBarTextButton`. Put buttons that belong together (previous / next) in a `BottomBarGroup`.
  A custom button draws itself as a `BottomBarGlassButton` when `BottomBar.isGlass(context)`.
- Menu of actions: never a bottom sheet. From a button, `ContextMenuIconButton`; on long press of
  an item, wrap it in a `ContextMenuRegion` (`platform_context_menu_button.dart`).
- Popover: `PlatformPopover` (`popover.dart`); pass `opaque: true` when its content would be hard
  to read on glass (e.g. engine details over the board).
- Wheel pickers stay `cupertino_ui` wheels.

## Laying out a body under glass bars

- In a `PlatformScaffold` body, `MediaQuery.paddingOf(context)` includes the status bar, the app
  bar (44pt + `bottom`) and the tab bar. Content must apply it, to start below the bars and scroll
  under them.
- A `ListView` / `CustomScrollView` without `padding` applies it itself. With an explicit padding,
  add it: `padding: Styles.bodyPadding.add(MediaQuery.paddingOf(context))`.
- Never wrap a scrolling body in a `SafeArea` (it clips the content at the bar). `SafeArea` is
  fine for non-scrolling layouts.
- Screens that don't scroll (board screens) pass `extendBodyBehindAppBar: false` to
  `PlatformScaffold`, with a glass `BottomBar` below the content.
- A list with pinned slivers (sticky headers) also uses `extendBodyBehindAppBar: false`, with the
  headers painting the bar background (`broadcast_list_screen.dart`).
- Pull to refresh: `HapticRefreshIndicator`, never `RefreshIndicator`.

## Package caveats (shared widgets)

- `GlassScaffold` does not inset its body: `PlatformScaffold` and `MainTabScaffold` add the bar
  heights to `MediaQuery.padding`.
- Keep `MaterialUiCompatibilityBridge` and `CupertinoUiCompatibilityBridge` in
  `MaterialApp.builder` (`app.dart`): they give the package (SDK `flutter/cupertino`) the app's
  `cupertino_ui` / `material_ui` theme.
- A direct use of `GlassScaffold` must restore the app `IconTheme` inside it, as
  `PlatformScaffold` does, or icons take the primary color.
- Wrap glass bars in `Material(type: MaterialType.transparency)`.
- A `GlassAppBar` laid out inside the body gets the original `MediaQuery` (without the bar heights),
  since it has its own `SafeArea`.
- Don't use `GlassScaffold`'s top edge effect: `PlatformScaffold` turns it off and blurs only the
  status bar (`GlassScrollEdgeEffect`, `.blur`, sigma 8). No bottom edge effect.
