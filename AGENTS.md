# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Project Overview

Lichess Mobile is a Flutter-based mobile application (iOS/Android) for lichess.org. The app uses:
- **Flutter**: Cross-platform UI framework (Flutter 3.38.0+, Dart 3.10.0+)
- **Riverpod**: State management with providers
- **Freezed**: Immutable data classes
- **Code generation**: For data classes, JSON serialization, and localization
- **Firebase**: Crashlytics and messaging
- **Stockfish**: Chess engine integration via `multistockfish` package

## Development Setup

### Initial Setup
```bash
# Install dependencies
flutter pub get

# Generate code (required before first run)
dart run build_runner build

# For continuous development
dart run build_runner watch &
flutter analyze --watch &
```

### Running the App
```bash
# Run on all devices (uses lichess.dev server by default)
flutter run -d all

# Run with custom server
flutter run \
  --dart-define=LICHESS_HOST=localhost:8080 \
  --dart-define=LICHESS_WS_HOST=localhost:8080
```

**Note**: Do not include scheme (https:// or ws://) in host values.

### For Android with local lila-docker
```bash
# Map ports
adb reverse tcp:8080 tcp:8080

# Run app
flutter run --dart-define=LICHESS_HOST=localhost:8080 --dart-define=LICHESS_WS_HOST=localhost:8080
```

## Testing & Quality

### Run Tests
```bash
# All tests
flutter test

# Single test file
flutter test test/model/engine/engine_test.dart

# Specific test
flutter test test/model/engine/engine_test.dart --name "test name"
```

### Testing Strategy: Prefer HTTP Mocking Over Provider Overrides

**Always mock at the HTTP layer** (override `httpClientFactoryProvider`) rather than overriding Riverpod providers directly. Reasons:

1. **`autoDispose` + `ref.read` interaction**: Many providers are `FutureProvider.autoDispose` and use `ref.withClientCacheFor` which calls `keepAlive()` to prevent premature disposal. Overriding the provider directly bypasses `keepAlive()`, so the provider can be disposed before its future resolves — causing silent test failures where navigation never happens.

2. **Tests provider logic, not mocks**: Most providers contain real logic (caching, fallback, data transformation) that should be exercised in tests. Replacing a provider with `(_) async => fakeValue` skips all that logic.

**Pattern to use:**
```dart
overrides: {
  httpClientFactoryProvider: httpClientFactoryProvider.overrideWith((ref) {
    return FakeHttpClientFactory(
      () => MockClient((request) async {
        if (request.url.path == '/api/puzzle/daily') {
          return http.Response(mockDailyPuzzleResponse, 200);
        }
        return http.Response('', 404);
      }),
    );
  }),
},
```

Direct provider overrides are acceptable for **non-network providers** (repositories backed by mocks, services with no HTTP, etc.) where the provider has no `keepAlive` dependency and the override doesn't skip meaningful logic.

### Chessboard Testing Patterns

Since chessground v10, pieces and highlights are rendered by `CustomPainter`s, not as individual widgets. **Do not use `find.byKey(Key('e2-whitepawn'))` or `find.byKey(ValueKey('${sq}-highlight'))` — those keys no longer exist.**

Use the helpers in `test/test_helpers.dart` instead:

```dart
// Check pieces on any Chessboard (interactive or Chessboard.fixed)
getBoardPieces(tester)                             // Map<Square, Piece>
boardHasPiece(tester, Square.f3, Piece.whiteKnight) // bool

// Check premove highlight
boardHasPremove(tester, move)                      // bool

// Tap/move at a board square
squareOffset(square, tester.getRect(find.byType(Chessboard)))
```

For `ChessboardEditor` (board editor screen), read pieces directly from the widget:
```dart
tester.widget<ChessboardEditor>(find.byType(ChessboardEditor)).pieces
```

### Analysis Rules (CRITICAL)

**Always run `flutter analyze` on every file you edit, including test files, before finishing.**

Two rules the analyzer enforces that are easy to miss:

- **`const` constructors**: use `const` (not `final`) when constructing a const-capable class. The analyzer will flag `prefer_const_constructors`. This applies everywhere, including test files. When the enclosing expression is not `const` (e.g. a non-const record or class), constructor calls inside it still need their own explicit `const` — e.g. `(time: const Duration(minutes: 3), increment: const Duration(seconds: 2))`.
- **No leading underscores for local identifiers**: local variables and functions must not start with `_`. Reserve `_` for library-private top-level or class members.

### Code Quality Checks
```bash
# Static analysis
flutter analyze

# Format check (files to format)
dart format --output=none --set-exit-if-changed $(find lib/src -name "*.dart" -not \( -name "*.*freezed.dart" -o -name "*.*g.dart" -o -name "*lichess_icons.dart" \) )
dart format --output=none --set-exit-if-changed $(find test -name "*.dart" -not \( -name "*.*freezed.dart" -o -name "*.*g.dart" \) )

# Format all code
dart format lib/src test
```

### Formatting Rules (CRITICAL)

**Always run `dart format` on every file you edit before finishing.** CI will fail if formatting is wrong.

```bash
dart format path/to/file.dart
```

The formatter is configured via `analysis_options.yaml` (`formatter: page_width: 100`) and `dart format` picks this up automatically. Key rules enforced by the formatter:

- **Page width: 100 characters** — lines exceeding 100 chars will be reflowed
- **Trailing commas drive formatting**: a trailing comma after the last argument/parameter forces the formatter to expand the list to one-item-per-line; omitting it allows the formatter to keep items on one line if they fit within 100 chars
- **Do not manually wrap lines** — let the formatter decide based on trailing commas and line length; hand-wrapping without trailing commas will be reformatted by the tool
- The formatter may reformat code you didn't touch in the same expression if you change surrounding structure

**Comments are the exception: the formatter never reflows them, so they are yours to wrap.**
Wrap comments and doc comments (`//` and `///`) to the same 100 character page width, not to
80. `dart format` leaves prose untouched, so a comment wrapped at 80 will simply stay that way
and look inconsistent with the code around it. Fill each line before wrapping to the next.

## Translations (i18n)

**CRITICAL**: Never manually edit `lib/l10n/app_*.arb` files - they are generated.

### Adding New Translations
1. Edit `translation/source/mobile.xml` for mobile-specific strings
2. Regenerate everything:
```bash
./scripts/gen-translations.sh
```

This runs `gen-arb.mjs`, `flutter gen-l10n`, and `gen-widget-strings.mjs` in order.

Mobile-specific translations get a `mobile` prefix (e.g., "foo" becomes `mobileFoo` in Dart).

## Architecture

### Directory Structure
```
lib/src/
├── model/          # Business logic, state management (Riverpod providers); never imports view/ or widgets/
│   ├── account/
│   ├── analysis/
│   ├── auth/
│   ├── challenge/
│   ├── common/     # Shared models and utilities
│   ├── engine/     # Stockfish integration
│   ├── game/
│   ├── puzzle/
│   ├── settings/
│   ├── ui_events.dart  # UI event bus: lets the model layer ask the view to show a snackbar
│   └── ...
├── service/        # Long-running app services and cross-cutting helpers (may depend on view/)
├── view/           # UI screens and pages
│   ├── account/
│   ├── analysis/
│   ├── game/
│   ├── home/
│   ├── play/
│   ├── puzzle/
│   ├── settings/
│   └── ...
├── widgets/        # Reusable UI components
├── network/        # HTTP client, WebSocket, connectivity
├── utils/          # Helper functions and utilities
├── styles/         # Theme, colors, icons
├── db/             # Local database (sqflite)
├── app.dart        # Main app widget
├── binding.dart    # Plugin/API abstraction layer
├── constants.dart  # App-wide constants
└── ui_event_coordinator.dart  # Turns UI events from the model layer into snackbars
```

The test tree mirrors this layout: tests for `lib/src/service/foo_service.dart` live in
`test/service/foo_service_test.dart`, along with the service fakes (`fake_sound_service.dart`, ...).

### Key Architectural Patterns

**State Management**: Riverpod providers throughout `lib/src/model/`. Controllers, repositories, and services are implemented as providers. State is immutable and managed with Freezed data classes.

**Riverpod 3.x good practices (CRITICAL)**

This project uses `flutter_riverpod 3.x` / `riverpod 3.x`.

- **Reading async data**: `AsyncValue<T>.value` returns `T?`, which is `null` while loading or on
  error. Use it when you only need the data, and `switch` on the `AsyncValue` when loading and
  error states must be rendered.
- **Don't name provider types**: `ProviderListenable<T>` and the type returned by `.select()` are
  internal, so never use them as type annotations. Pass providers and `select` results straight to
  `ref.watch`/`ref.read`/`ref.listenManual`. Where a signature would need such a type (e.g. an
  abstract method), expose two concrete methods instead (`readCurrentState()` +
  `listenToStateChanges()`).
- **Explicit type on nullable `listenManual`**: when the selected value is nullable (e.g.
  `provider.select((v) => v.value)` → `T?`), Dart cannot infer the listener's type, so write it
  out: `ref.listenManual<T?>(provider.select(...), listener)`.
- **`listenManual` in `ConsumerState`**: subscriptions made in `initState()` with
  `ref.listenManual` are cancelled automatically when the widget is disposed; don't store or
  cancel them yourself.

**Binding Layer**: `LichessBinding` (in `binding.dart`) provides a testable abstraction for plugins and external APIs:
- SharedPreferences
- Firebase (messaging, crashlytics)
- Stockfish factory

Use `AppLichessBinding.ensureInitialized()` in production, `TestLichessBinding` in tests.

**Network Layer**:
- HTTP: `lib/src/network/http.dart` - Platform-specific clients (Cronet for Android, Cupertino for iOS) with authentication, caching, and retry logic
- WebSocket: `lib/src/network/socket.dart` - Handles ping/pong, message acks, auto-reconnection, event versioning
- Helper: `lichessUri(path, queryParams)` for HTTP, `lichessWSUri(path, queryParams)` for WebSocket

**Layering**: `model/` holds business logic and must not import `view/` or `widgets/` (enforced by
`test/model/model_layer_test.dart`). `view/` and `service/` may depend on `model/`, and services
may depend on the view layer (to navigate, show dialogs, etc.). Model code that needs to tell
the user something goes through the UI event bus instead of a `BuildContext`.

**Services** (`lib/src/service/`): app-wide services, one file per service, e.g. `AccountService`,
`NotificationService`, `MessageService`, `ChallengeService`, `CorrespondenceService`,
`AppLinksService`, `SoundService`, `StockfishNnueService`. The long-running ones are started in
`_AppState.initState()` in `app.dart`.

**UI events**: the model layer emits `UiEvent`s on `uiEventBusProvider`
(`lib/src/model/ui_events.dart`); `UiEventCoordinator` (`lib/src/ui_event_coordinator.dart`),
started first in `_AppState.initState()`, listens to them and shows them using the current tab's
navigator context. The bus is deliberately limited to snackbars (`ShowErrorEvent`): navigation,
dialogs and confirmations belong at the view layer call site, not on the bus.

**Navigation**: Uses Flutter's Navigator with custom route resolution via `app_links.dart` for deep linking.

## Dart Event Loop Execution Model

Understanding Dart's event loop is critical for this codebase due to heavy async operations (network requests, WebSocket communication, Stockfish engine interaction).

### Event Loop Basics

Dart is single-threaded and uses an event loop with two queues:

1. **Microtask Queue** (higher priority)
   - Executed before the event queue
   - Scheduled with `scheduleMicrotask()` or via `Future` completions
   - Used internally by `Future.then()`, `async`/`await`

2. **Event Queue** (lower priority)
   - I/O events, timers, user interactions
   - Scheduled with `Future()`, `Timer`, `Stream` events
   - UI rendering happens between event queue items

**Execution order**:
```
1. Execute current synchronous code
2. Process ALL microtasks (until microtask queue is empty)
3. Process ONE event from event queue
4. Repeat from step 2
```

### Async/Await Behavior

```dart
// This does NOT block the event loop
Future<void> fetchData() async {
  final response = await http.get(uri);  // Yields to event loop
  // Resumes here when response completes
  processData(response);
}
```

When `await` is encountered:
1. Current function execution pauses
2. Control returns to event loop
3. Function resumes as a microtask when Future completes

### Common Patterns in This Codebase

**Riverpod AsyncNotifier**: State updates are async but don't block UI:
```dart
class MyController extends AsyncNotifier<Data> {
  @override
  Future<Data> build() async {
    // Fetches async, UI shows loading state
    return await repository.getData();
  }
}
```

**WebSocket Message Handling** (see `lib/src/network/socket.dart`):
- Messages arrive as events
- Processed in event queue
- Microtasks schedule state updates

**Stockfish Engine Communication**:
- Engine runs in isolate (separate event loop)
- Communication via `SendPort`/`ReceivePort` (event queue)

### Important Gotchas

**Microtask Queue Starvation**: Never create infinite microtask loops - they block the event queue and freeze the UI:
```dart
// BAD - Starves event queue
void badLoop() {
  scheduleMicrotask(() {
    doWork();
    badLoop();  // Immediately schedules another microtask
  });
}

// GOOD - Allows event queue processing
void goodLoop() {
  Future(() {  // Uses event queue
    doWork();
    goodLoop();
  });
}
```

**Future vs Future.microtask**:
- `Future(callback)` → event queue
- `Future.microtask(callback)` → microtask queue
- Prefer event queue for non-critical work

**Stream Subscriptions**: Always cancel to prevent memory leaks:
```dart
// In StatefulWidget or Riverpod
final subscription = stream.listen(onData);

@override
void dispose() {
  subscription.cancel();  // Critical!
  super.dispose();
}
```

**Testing with fake_async**: Use `FakeAsync` for tests involving timers and microtasks to control time progression.

## Coding Standards

### Immutability (Required)
All data structures must be immutable (all fields `final` or `late final`):
- Use **Freezed** for data classes
- Use **fast_immutable_collections** for collections in public APIs
- Standard Dart collections (`List`, `Map`) are forbidden in public APIs but allowed in local scopes

### Strong Typing
Prefer strong types over primitives (e.g., `Duration` instead of `int`).

### Dot Shorthand Syntax (Dart 3.10+)
Use dot shorthand syntax (`.foo`) to write more concise code when the type can be inferred from context. This is especially useful for enums, named constructors, and static members.

```dart
// Enums - use shorthand
Status current = .running;           // Good
Status current = Status.running;     // Verbose

// Switch statements
switch (status) {
  case .running: ...
  case .stopped: ...
}

// Named constructors
Point p = .origin();                 // Good
Point p = Point.origin();            // Verbose

// Widget properties
MainAxisAlignment: .center,          // Good
MainAxisAlignment: MainAxisAlignment.center,  // Verbose

// Equality checks (shorthand on right side)
if (color == .red) ...               // Good
if (.red == color) ...               // Won't work
```

**Note**: Shorthand requires clear context type inference and cannot start expression statements.

### Functional Style
Prefer functional constructs over imperative:
```dart
// Good
return [
  if (check) Text('conditional'),
  for (el in items) Text(el.name),
];

// Bad
final widgets = <Widget>[];
if (check) widgets.add(Text('conditional'));
for (el in items) widgets.add(Text(el.name));
```

### Widget Guidelines
- Avoid functions returning widgets (use `StatelessWidget` for reusables)
- Don't create private widgets used only once - inline them
- Write reusable widgets as classes even if single-screen scope

### Analysis
- Strict mode enabled: `strict-casts`, `strict-inference`, `strict-raw-types`
- Use single quotes for strings
- Always use package imports (no relative imports)
- Page width: 100 characters
- Generated files (`*.g.dart`, `*.freezed.dart`) are excluded from analysis

## Code Generation

This project heavily uses code generation. Always run `dart run build_runner build` (or `watch`) after:
- Modifying Freezed classes
- Adding JSON serialization
- Changing models with code generation annotations

Generated files are NOT committed to git.

## Common Gotchas

- **Don't edit generated files**: Anything ending in `.g.dart`, `.freezed.dart`, or in `lib/l10n/`
- **Translations**: Start with hardcoded English text for new features. Add translations after the feature is stable and in use
- **Error messages**: Don't translate non-critical error messages (e.g., "could not load XY")
- **Brand names**: Don't translate names like "Puzzle Storm" or "Puzzle Streak"
- **FVM users**: Remember to prefix commands with `fvm` (e.g., `fvm flutter test`)

## iOS Liquid Glass (iOS 26 design)

On iOS the app uses the iOS 26 liquid glass look through the `liquid_glass_widgets` package.
Android must not change: every glass code path is behind a
`Theme.of(context).platform == TargetPlatform.iOS` check. The package's own agent skill is in
`.claude/skills/liquid-glass-widgets/SKILL.md`.

### Before iOS 26 (temporary fallback)

Glass is for iOS 26 and later only. Before iOS 26, the app keeps the same layouts (body behind the
bars, large titles, scroll-aware bar tint, inset sheets) with plain controls and opaque surfaces:
every glass widget is built only when `useLiquidGlass(context)` (`platform.dart`) is true, with a
non-glass fallback (`BlurredBarBackground` bars, `_BlurredTabBar`, an opaque `GlassModalCard`, no
`GlassSheetScope`, `CupertinoSlidingSegmentedControl`, the `popover` popover and Material menu).
Run with `--dart-define=NO_LIQUID_GLASS=true` to see that look on an iOS 26 device.

The fallback is meant to be deleted once iOS < 26 is no longer supported, and to cost as little as
possible until then. Rules:

- **Contained**: fallback code lives in the shared widgets (`lib/src/widgets/`,
  `tab_scaffold.dart`), next to the glass code it replaces. Screens don't branch on it; the only
  exception is the broadcast round pinned tabs (`broadcast_round_screen.dart`, with
  `PlatformAppBar.scrolledUnderTint`, which exists for it). Add a screen exception only when there
  is no shared widget to put it in.
- **Greppable**: every fallback branch is an `if (!useLiquidGlass(context))` (or a ternary on it)
  that can be deleted on its own, keeping the glass branch. Removing the fallback means deleting
  those branches and the helpers only they use (`_BlurredTabBar`, `scrolledUnderTint`), then
  `useLiquidGlass` itself.
- **Cheap**: a fallback reuses what exists (the Android/Material path, the flat mode of a control,
  `BlurredBarBackground`, `opaqueModalColor`), with no design work of its own. Never change the
  glass code or a layout to accommodate it.
- **No tests**: tests only cover glass (in tests `useLiquidGlass` is true on iOS). Check the
  fallback on an iOS 18 simulator or with the dart define above.
- **New glass code**: a new glass widget gets a fallback in the same shared widget, following
  these rules. If a plain or opaque equivalent isn't trivial, ask before adding one.

### Where glass comes from

- **Screens**: use `PlatformScaffold` + `PlatformAppBar` (`lib/src/widgets/platform.dart`). On
  iOS they build a `GlassScaffold` with a `GlassAppBar`, and a plain Material `Scaffold` + `AppBar`
  elsewhere. A screen built with a bare `Scaffold` + `AppBar` keeps the old opaque bar on iOS.
- **Tab bar**: `MainTabScaffold` (`lib/src/tab_scaffold.dart`) uses `GlassTabBar` on iOS. The
  root screen of a tab has a non-sticky app bar that scrolls away with the content, with an iOS
  large title (`PlatformAppBar` styles it automatically: don't pass a `titleTextStyle`).
- **Floating action buttons**: use `PlatformFloatingActionButton` (a tinted glass capsule on iOS)
  instead of `FloatingActionButton`. A FAB is not an iOS pattern though: for a new primary action,
  prefer a nav bar action on iOS.
- **Search fields**: a `PlatformSearchBar` placed in an app bar (e.g. its `bottom`) takes
  `inAppBar: true`, which makes it a glass search field on iOS. A search field inside the body is
  the same field, flat (`GlassControlBackground`, `platform.dart`). A search screen is opened by
  a `SearchHeroButton` in the app bar (not a fake search field in the body), as a normal push,
  and wraps its field in a `SearchFieldHero` with the same tag, so that the button morphs into
  the field.
- **App bar tabs**: use `PlatformTabBar` (`lib/src/widgets/platform_tab_bar.dart`) as a
  `PlatformAppBar` `bottom`, not a Material `TabBar`. On iOS, 2 or 3 tabs are a glass
  segmented control (driven by the same `TabController`); 4 tabs or more stay a Material `TabBar`.
  A control in an app bar `bottom` (segmented control, study chips) uses
  `kGlassAppBarBottomPadding` and `kGlassAppBarBottomControlHeight` (`platform.dart`) on
  iOS, so every bar has the same spacing and height.
  A segmented control in the content (e.g. a header not pinned yet) is flat, not glass:
  `PlatformTabBar(glass: false)`, the same control with its glass faded out (settings
  `visibility`) on the text field fill (`GlassControlBackground`); glass is for bars only. The
  `bottom` of a large title app bar is in the content until it sticks below the bar buttons: its
  `PlatformTabBar` / `PlatformSearchBar` follow that automatically (`AppBarBottomGlassScope`).
- **Bottom bars over scrolling content** (not board toolbars): `BottomBar(cupertinoGlass: true)`
  has no background on iOS and its `BottomBarButton`s / `BottomBarTextButton`s are glass capsules,
  as wide as their content and evenly spaced.
- **Text fields and search bars** are rounded by the iOS theme (`theme.dart`): a capsule
  `SearchBar`, and a 28pt input border radius, which makes a single line field a capsule. Don't
  give an iOS field its own `border` radius.
- **Bar tint**: `PlatformScaffold` tints a sticky `PlatformAppBar` that has a title with the iOS
  bar tint (`cupertinoBarTint`) and a hairline, only while content is scrolled under it (like a
  UIKit navigation bar), detected from the body's vertical scroll notifications. Bars without a
  title (or with a search field as title), board screens and tab root headers are never tinted.
  Don't pass a placeholder title (`SizedBox.shrink()`): leave it null.
- **Large titles on pushed screens**: `PlatformAppBar(largeTitle: true)` shows the title as an iOS
  large title at the top of the body, which collapses into the bar once scrolled away (the bar is
  tinted from then on). For a pushed list screen whose body is one vertical scroll view (not in a
  `TabBarView`) using `MediaQuery.paddingOf(context)` (it gets the large title height)
  (e.g. `puzzle_history_screen.dart`). Its `bottom`, such as a glass search field, is below the
  large title and sticks below the bar buttons once scrolled (`puzzle_themes_screen.dart`).
- **Glass tint**: the package's dark glass is nearly clear, so over busy content (boards) or a
  background image or color theme, glass controls use `tintedGlassSettings` (`platform.dart`).
  `PlatformAppBar` does it for its buttons with `tintedGlass: true`, and always with a background
  theme.
- **Bottom sheets**: never call `showModalBottomSheet` directly. A sheet that expands uses
  `showAdaptiveDraggableBottomSheet` (a `DraggableScrollableSheet`, always with a drag handle; on
  iOS the same inset card, but opaque and flat: `OpaqueBottomSheetFrame`); an information sheet
  whose content may be long uses `showAdaptiveFullHeightBottomSheet` (always at full height, a
  close button and a title in its header, scrollable content; on iOS an opaque, flat edge to edge
  card, like an iOS 26 sheet at its large detent, e.g. the broadcast overview). The content of
  these two opaque sheets is opaque too (no glass controls). Every other sheet uses
  `showAdaptiveBottomSheet` (`adaptive_bottom_sheet.dart`): on iOS a Material modal sheet whose
  content sits in a glass card (`GlassBottomSheetFrame`). Inside it (`GlassSheetScope`), cards turn translucent, `PlatformSwitch`
  / `SwitchSettingTile` and `NonLinearSlider` become glass controls. Filled and outlined buttons are
  capsules on iOS (app theme). A sheet's main action is a `PlatformFilledButton` (a tinted glass
  capsule on a glass sheet). Selectable chips use `PlatformChoiceChip` (a glass pill on iOS); give
  their `Wrap` an iOS `runSpacing`, glass chips have no tap target margin. The iOS sheet doesn't
  expand: no drag handle, and a shared minimum height (`kGlassBottomSheetMinHeightFraction`, 45% of
  the screen) instead of the call site's. A labelled group of chips is a `Filter`
  (`widgets/filter.dart`), or starts with a `FilterTitle`: same title and spacing in every sheet,
  16pt around the content and between groups.
- **Popovers**: use `PlatformPopover` (`popover.dart`), a `GlassPopover` that morphs out of its
  trigger on iOS. Wheel pickers stay `cupertino_ui` wheels (the package has no glass wheel).
- Glass is for the navigation and control layer that floats above content (bars, floating
  buttons, sheets), not for content such as cards or list rows.

### Laying out a body under glass bars

- **The body extends behind the bars**: `MediaQuery.paddingOf(context)` inside a
  `PlatformScaffold` body includes the status bar, the app bar height (44pt + `bottom`) and, in a
  tab, the tab bar height. Content must use that padding so that it starts below the bar and
  scrolls under it.
- A `ListView` / `CustomScrollView` with no explicit `padding` applies it automatically. With an
  explicit padding, add the media query padding to it:
  `padding: Styles.bodyPadding.add(MediaQuery.paddingOf(context))`.
- **Never wrap a scrolling body in a `SafeArea`**: it shrinks the scroll view to the area below
  the bar, so the content is clipped at the bar's bottom edge (the bar looks opaque) and above the
  home indicator. Put `MediaQuery.paddingOf(context)` in the scroll view's padding instead.
  `SafeArea` is fine for non-scrolling layouts (a form with a fixed button, a fixed board preview).
- **Screens that don't scroll** (board screens) pass `extendBodyBehindAppBar: false` to
  `PlatformScaffold`: the body is laid out below the glass bar, like in a Material `Scaffold`,
  and the status bar blur is off. Their bottom toolbar (`BottomBar`) stays a regular bar.
- **Pinned slivers** (sticky section headers) always stick to the top of their scroll view, which
  is behind the bar. For such a list, lay the body out below the bar instead
  (`PlatformScaffold(extendBodyBehindAppBar: false)`, which also keeps the bar untinted), and give
  the headers the background behind the bar: a pinned header always covers that edge, so nothing
  is lost (`broadcast_list_screen.dart`).
- A pull-to-refresh indicator is a `HapticRefreshIndicator`: on iOS it sets its own `edgeOffset`
  from its top padding, so that its spinner appears below the bar, not behind it.

### Package caveats

- **`GlassScaffold` does not inset its body**, despite its docs: `PlatformScaffold` and
  `MainTabScaffold` add the bar heights to `MediaQuery.padding` themselves.
- **Two Cupertino libraries**: the package uses the SDK `flutter/cupertino`, the app uses
  `cupertino_ui` / `material_ui`. `MaterialApp.builder` (`app.dart`) wraps the app in
  `MaterialUiCompatibilityBridge` and `CupertinoUiCompatibilityBridge`, which provide the SDK
  `Theme`, `CupertinoTheme` and localizations from the app ones, so glass widgets (and other
  unmigrated packages) see the app theme, including its brightness. Don't remove them until every
  such package is migrated.
- **Primary colored icons**: an SDK `CupertinoTheme` sets the `IconTheme` to its primary color.
  The app `IconTheme` is restored inside the bridges, and `GlassScaffold` installs its own
  `CupertinoTheme`, so `PlatformScaffold` and `MainTabScaffold` restore it again inside it; any
  other direct use of `GlassScaffold` must do the same.
- **Material ancestor**: glass bars sit outside any Material `Scaffold`; wrap them in
  `Material(type: MaterialType.transparency)`, or text gets yellow underlines and Material
  `IconButton`s break.
- **`GlassAppBar` has its own `SafeArea`**: when it is laid out inside the body, give it the
  original `MediaQuery` (without the bar height added), or its content is pushed out of its bounds.
- **Glass look**: use the package's default glass settings. Don't use `GlassScaffold`'s top edge
  effect: `PlatformScaffold` turns it off and blurs only the status bar area itself (a
  `GlassScrollEdgeEffect`, `.blur` style, sigma 8, top only), where nothing else covers it (no
  tinted app bar). The `soft` fade is invisible in dark mode and with background themes, and the
  package's blur covers the whole app bar (too heavy). No bottom edge effect. Don't add app-wide
  glass overrides without a design decision.
- In widget tests on iOS, `GlassTabBar` renders each tab label twice, so use `findsWidgets`.

## iOS Home Screen Widgets (WidgetKit Extension)

The app includes a native iOS WidgetKit extension (`ios/LichessWidgets/`) providing home screen widgets. See `ios/EXTENSIONS.md` for contributor setup instructions (requires Apple Developer account configuration).

### Architecture

- **`LichessWidgetsBundle.swift`** — `@main` entry point registering all 4 widgets.
- **`LichessAppGroup.swift`** — Reads shared `UserDefaults` from App Group `group.org.lichess.mobileV2.LichessWidgets`:
  - `lichessHost`, `boardTheme`, `pieceSet`, `isKidMode`
- **`Deeplinks.swift`** — Custom URI scheme encoding for opening URLs in the in-app browser.
- **Dependencies**: WidgetKit, ChessgroundAssets (Swift Package, shared with Dart), FeedKit, XMLKit.

### Flutter Integration

The Flutter app (via `home_widget` package) writes to the shared App Group from `app.dart`:
- `lichessHost` — server URL
- `boardTheme` / `pieceSet` — board appearance (triggers `DailyPuzzleWidget` reload)
- `isKidMode` — hides blog widgets when active (triggers blog widget reload)

When modifying widget-related settings or board theme/piece set preferences in Dart, ensure the corresponding `HomeWidget.saveWidgetData` call and `HomeWidget.updateWidget` are kept in sync in `lib/src/app.dart`.

Widget UI strings are translated via `ios/LichessWidgets/Localizable.xcstrings` (a String Catalog). To add a new translatable string, register it under `WIDGET_KEYS` in `scripts/gen-widget-strings.mjs` and run `./scripts/gen-translations.sh`.

### Code Signing

The extension has its own bundle ID (`org.lichess.mobileV2.LichessWidgets`) and App Group entitlement. fastlane `sync_code_signing` handles provisioning for both targets (see `ios/fastlane/Matchfile`).

## Debugging

```bash
# Start DevTools for logging
dart devtools

# Then run app and follow printed link
flutter run
```
