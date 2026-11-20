# Practice goal reachability check

Replays every engine practice chapter against the engine the app plays them on, with the player
playing the engine's own best move, and judges each one with the app's own `PracticeGoal.judge`.
What it answers: **can this chapter be solved at all on this device's engine, at the depth the app
judges at?**

It matters because the goals are lichess.org's, written against an evaluation the web has and the
app does not — a cloud eval dozens of plies deep, often a mate score, where the app has a depth-15
search of Stockfish 19's small embedded network. A goal can be out of reach however well the player
plays, and the player is told they failed. The findings, and the four goals lowered in the asset
because of them, are in `practice.md` §13.

Worth re-running when the engine changes (a new Stockfish, a different network, other search
limits), when the judging depth changes, and after a content refresh, since the chapters are the
study authors' to edit.

## Running it

```bash
# Builds Stockfish 19 + small net as a host UCI binary, into .cache/practice_engine.
# Needs a checkout of dart-multistockfish: beside this repo, in ~/dev, or MULTISTOCKFISH=<path>.
scripts/practice_engine_check/build_engine.sh

# ~6 minutes for 279 chapters on 6 engines.
flutter test scripts/practice_engine_check/goal_reachability_check.dart
```

The check is Dart run through `flutter test`, rather than a `dart run` script, because it judges
with the app's own `PracticeGoal.judge` — the point being that it measures the code that ships, not
a second implementation of it that could drift. That code reaches `package:flutter` through
`ClientEval`, which only the Flutter test runner can load. `flutter test` accepts a path anywhere in
the package, so the check sits here with the rest of its tooling and stays out of the suite CI
runs.

It prints a line per chapter and a summary of the unsolved ones, and writes a JSON report to
`.cache/practice_engine/report.json`. It never fails the run on an unsolved chapter: which ones
those are is a question about the content, answered by reading the report.

Environment:

| | |
|---|---|
| `PRACTICE_ENGINE` | the binary (default `.cache/practice_engine/stockfish-light`) |
| `PRACTICE_DEPTH` | search depth, and so the eval judged on (default 15, `kPracticeUsableDepth` in release; a debug app uses 13) |
| `PRACTICE_JOBS` | engines at once (default 6) |
| `PRACTICE_REPORT` | where the JSON report goes |
| `PRACTICE_CHAPTER` | a single chapter id, to look at one in isolation |

## What is in here

- `goal_reachability_check.dart` — the check itself; see its header for the options.
- `build_engine.sh` — compiles the `multistockfish_light` sources into a host binary.
- `uci_bridge.cpp` — a `main` that pumps stdin and stdout through the plugin's private engine I/O,
  which is what makes the plugin's engine drivable as an ordinary UCI binary.

## Reading the result

A chapter reported as `failed` was played perfectly and still missed its goal, so no player can
solve it on this engine. The line it was played through and the eval it reached are in the report;
pasting the FEN into lichess.org's analysis and comparing with the cloud eval shows how much of the
gap is depth and how much is the chapter.

`ongoing` means the chapter ran out of moves without being decided — for a goal with no move
budget, that is the check's own cap rather than the app's behaviour.
