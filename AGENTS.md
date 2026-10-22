# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

Area-specific rules live in `.claude/rules/` (Claude Code loads each one when it works on matching
files; other agents should read the relevant one before working in that area):

- `testing.md`: HTTP mocking, chessboard test helpers, liquid glass in widget tests
- `views.md`: navigation (tab navigators, hiding the tab bar, root navigator), widget guidelines
- `liquid-glass.md`: iOS 26 liquid glass, pre-iOS 26 fallback, laying out a body under glass bars
- `ios-widgets.md`: iOS home screen widgets (WidgetKit extension)

## Project Overview

Lichess Mobile is the Flutter (3.38.0+, Dart 3.10.0+) iOS/Android app for lichess.org, using
Riverpod for state management, Freezed for immutable data classes, code generation (data classes,
JSON, localization), Firebase (Crashlytics, messaging) and Stockfish via `multistockfish`.

## Development Setup

```bash
flutter pub get
dart run build_runner build   # required before first run; or `watch`

# Run (uses lichess.dev by default); custom server, without scheme (https:// or ws://):
flutter run --dart-define=LICHESS_HOST=localhost:8080 --dart-define=LICHESS_WS_HOST=localhost:8080
# Android with local lila-docker: first `adb reverse tcp:8080 tcp:8080`
```

FVM users: prefix commands with `fvm`.

## Testing & Quality

```bash
flutter test test/model/engine/engine_test.dart                   # single file
flutter test test/model/engine/engine_test.dart --name "test name" # single test
```

In tests, mock at the HTTP layer (override `httpClientFactoryProvider`) rather than overriding
Riverpod providers: see `.claude/rules/testing.md`.

### Analysis Rules (CRITICAL)

**Always run `flutter analyze` on every file you edit, including test files, before finishing.**

- Strict mode: `strict-casts`, `strict-inference`, `strict-raw-types`. Single quotes, package
  imports only (no relative imports). Generated files are excluded from analysis.
- **`const` constructors**: use `const` (not `final`) when constructing a const-capable class
  (`prefer_const_constructors`), including in test files. When the enclosing expression is not
  `const` (e.g. a non-const record or class), constructor calls inside it still need their own
  explicit `const` — e.g. `(time: const Duration(minutes: 3), increment: const Duration(seconds: 2))`.
- **No leading underscores for local identifiers**: reserve `_` for library-private top-level or
  class members.

### Formatting Rules (CRITICAL)

**Always run `dart format path/to/file.dart` on every file you edit before finishing.** CI fails
if formatting is wrong. `dart format lib/src test` formats everything.

- **Page width: 100 characters** (`analysis_options.yaml`).
- **Trailing commas drive formatting**: a trailing comma after the last argument/parameter forces
  one item per line; without it the formatter keeps items on one line if they fit.
- **Do not manually wrap lines**: the formatter reflows them. It may also reformat untouched code
  in the same expression.
- **Comments are the exception: the formatter never reflows them, so they are yours to wrap.**
  Wrap `//` and `///` comments to the same 100 character width, not 80. Fill each line before
  wrapping to the next.

## Translations (i18n)

**CRITICAL**: Never manually edit `lib/l10n/app_*.arb` files - they are generated.

To add a mobile-specific string, edit `translation/source/mobile.xml`, then run
`./scripts/gen-translations.sh` (runs `gen-arb.mjs`, `flutter gen-l10n`, `gen-widget-strings.mjs`).
Mobile strings get a `mobile` prefix ("foo" becomes `mobileFoo` in Dart).

- Start with hardcoded English text for new features; add translations once the feature is stable.
- Don't translate non-critical error messages (e.g., "could not load XY") or brand names ("Puzzle
  Storm", "Puzzle Streak").

## Architecture

```
lib/src/
├── model/          # Business logic, Riverpod providers, by domain (account, analysis, game,
│                   #   puzzle, engine, settings, common...); never imports view/ or widgets/
│   └── ui_events.dart  # UI event bus: lets the model layer ask the view to show a snackbar
├── service/        # Long-running app services and cross-cutting helpers (may depend on view/)
├── view/           # UI screens and pages, by feature
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

**State Management**: Riverpod providers throughout `lib/src/model/`. Controllers, repositories,
and services are implemented as providers. State is immutable and managed with Freezed classes.

**Riverpod 3.x good practices (CRITICAL)** (`flutter_riverpod 3.x` / `riverpod 3.x`):

- **Reading async data**: `AsyncValue<T>.value` returns `T?`, which is `null` while loading or on
  error. Use it when you only need the data, and `switch` on the `AsyncValue` when loading and
  error states must be rendered. Pattern match the `AsyncValue` (`AsyncData(:final value)`,
  `AsyncError(:final error)`, `AsyncLoading()`) rather than its callback methods (`when`, `map`,
  `whenData`...), including to transform it (e.g. in a `select`).
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

**Binding Layer**: `LichessBinding` (`binding.dart`) abstracts plugins and external APIs
(SharedPreferences, Firebase messaging/crashlytics, Stockfish factory) for testability. Use
`AppLichessBinding.ensureInitialized()` in production, `TestLichessBinding` in tests.

**Network Layer**: HTTP in `lib/src/network/http.dart` (Cronet on Android, Cupertino on iOS, with
auth, caching, retry); WebSocket in `lib/src/network/socket.dart` (ping/pong, acks, reconnection,
event versioning). Build URIs with `lichessUri(path, queryParams)` / `lichessWSUri(...)`.

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

**Async**: the Stockfish engine runs in an isolate (communication through ports). Never schedule
recursive microtasks (they starve the event queue and freeze the UI), and always cancel stream
subscriptions.

## Coding Standards

- **Immutability (required)**: all fields `final` or `late final`. Use Freezed for data classes
  and `fast_immutable_collections` in public APIs (plain `List`/`Map` only in local scopes).
- **Strong typing**: prefer strong types over primitives (e.g., `Duration` instead of `int`).
- **Dot shorthand (Dart 3.10+)**: write `.foo` when the type can be inferred from context (enums,
  named constructors, static members, switch cases, widget properties): `Status current =
  .running;`, `mainAxisAlignment: .center`, `if (color == .red)`. The shorthand only works on the
  right side of `==` and cannot start an expression statement.
- **Functional style**: prefer collection `if`/`for` in list literals over building a list
  imperatively with `add`.
- **Widgets**: no functions returning widgets, no private widget used only once (inline it); see
  `.claude/rules/views.md`.

## Code Generation

Run `dart run build_runner build` (or `watch`) after modifying Freezed classes, JSON
serialization, or other annotated models. Generated files are NOT committed to git. Never edit
generated files: anything ending in `.g.dart`, `.freezed.dart`, or in `lib/l10n/`.
