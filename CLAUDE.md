# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

### Code Quality Checks
```bash
# Static analysis
flutter analyze

# Riverpod linting
dart run custom_lint

# Format check (files to format)
dart format --output=none --set-exit-if-changed $(find lib/src -name "*.dart" -not \( -name "*.*freezed.dart" -o -name "*.*g.dart" -o -name "*lichess_icons.dart" \) )
dart format --output=none --set-exit-if-changed $(find test -name "*.dart" -not \( -name "*.*freezed.dart" -o -name "*.*g.dart" \) )

# Format all code
dart format lib/src test
```

## Translations (i18n)

**CRITICAL**: Never manually edit `lib/l10n/app_*.arb` files - they are generated.

### Adding New Translations
1. Edit `translation/source/mobile.xml` for mobile-specific strings
2. Generate ARB files and Dart code:
```bash
./scripts/gen-arb.mjs
flutter gen-l10n
```

Mobile-specific translations get a `mobile` prefix (e.g., "foo" becomes `mobileFoo` in Dart).

## Architecture

### Directory Structure
```
lib/src/
├── model/          # Business logic, state management (Riverpod providers)
│   ├── account/
│   ├── analysis/
│   ├── auth/
│   ├── challenge/
│   ├── common/     # Shared models and utilities
│   ├── engine/     # Stockfish integration
│   ├── game/
│   ├── puzzle/
│   ├── settings/
│   └── ...
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
└── constants.dart  # App-wide constants
```

### Key Architectural Patterns

**State Management**: Riverpod providers throughout `lib/src/model/`. Controllers, repositories, and services are implemented as providers. State is immutable and managed with Freezed data classes.

**Binding Layer**: `LichessBinding` (in `binding.dart`) provides a testable abstraction for plugins and external APIs:
- SharedPreferences
- Firebase (messaging, crashlytics)
- Stockfish factory

Use `AppLichessBinding.ensureInitialized()` in production, `TestLichessBinding` in tests.

**Network Layer**:
- HTTP: `lib/src/network/http.dart` - Platform-specific clients (Cronet for Android, Cupertino for iOS) with authentication, caching, and retry logic
- WebSocket: `lib/src/network/socket.dart` - Handles ping/pong, message acks, auto-reconnection, event versioning
- Helper: `lichessUri(path, queryParams)` for HTTP, `lichessWSUri(path, queryParams)` for WebSocket

**Services**: Long-running background services initialized in `app.dart`:
- `AccountService`, `NotificationService`, `MessageService`, `ChallengeService`, `CorrespondenceService`
- Start in `_AppState.initState()`

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

## Debugging

```bash
# Start DevTools for logging
dart devtools

# Then run app and follow printed link
flutter run
```
