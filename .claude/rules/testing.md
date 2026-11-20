---
paths:
  - "test/**/*.dart"
---

# Tests

## Mock HTTP, not providers

Override `httpClientFactoryProvider`, never a network provider:

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

- Why: an overridden `FutureProvider.autoDispose` skips the `keepAlive()` of
  `ref.withClientCacheFor`, so it can be disposed before its future resolves (the test silently
  fails, e.g. navigation never happens), and the provider's own logic goes untested.
- Overriding a non-network provider (a repository backed by a mock, a service without HTTP) is
  fine.

## Chessboard

Pieces and highlights are drawn by `CustomPainter`s: never use `find.byKey(Key('e2-whitepawn'))`
or `find.byKey(ValueKey('$sq-highlight'))`. Use the helpers in `test/test_helpers.dart`:

```dart
getBoardPieces(tester)                              // Map<Square, Piece>
boardHasPiece(tester, Square.f3, Piece.whiteKnight) // bool
boardHasPremove(tester, move)                       // bool
squareOffset(square, tester.getRect(find.byType(Chessboard))) // to tap/move at a square
```

For `ChessboardEditor`, read `tester.widget<ChessboardEditor>(find.byType(ChessboardEditor)).pieces`.

## iOS liquid glass

- `GlassTabBar` renders each tab label twice: expect them with `findsWidgets`.
- A pushed screen's app bar button is in the tree twice (a placeholder in the route and the pinned
  copy): tap and expect it with `.hitTestable()`.
- `pump()` once more after a screen's app bar actions change (the pinned copy is redrawn a frame
  later).
- Accessibility checks can't reach custom bar items
  (https://github.com/sdegenaar/liquid_glass_widgets/issues/432): the puzzle, storm and streak a11y
  tests run on Android only until it is fixed.

## Timers

Use `FakeAsync` for tests involving timers and microtasks.
