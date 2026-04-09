import 'package:dartchess/dartchess.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';

import '../test_provider_scope.dart';

// A PGN that exercises all three comment locations we changed in pgn.dart.
//
// In two-column display mode (the default), _hasNonInlineSideLine() returns
// true for any mainline node whose first child has a text comment. This causes
// the mainline to be split into a new _TwoColumnMainlinePart after every
// commented move. Each part then renders its last branch's comment as a
// standalone Linkify widget (_TwoColumnMainlinePart comment rendering).
//
// This means ALL three changed locations end up producing a Linkify widget:
//
//  { Root comment }   → Consumer+Linkify before the first move   (_PgnTreeView root comment rendering)
//  1. e4 { ... }      → end-of-mainline Linkify for part 1       (_TwoColumnMainlinePart comment rendering)
//  e5  { ... }        → end-of-mainline Linkify for part 2       (_TwoColumnMainlinePart comment rendering)
//  2. Nf3 { ... }     → end-of-mainline Linkify for part 3       (_TwoColumnMainlinePart comment rendering)
//
// We include one comment with a URL and one without for each location, to
// verify both plain text and linkified URL rendering.
const _pgnWithComments =
    '{ Root comment. Visit https://lichess.org } '
    '1. e4 { A plain move comment } e5 { Move with url https://example.com } '
    '2. Nf3 { End comment with https://lichess.org/analysis } *';

// Helper that builds the AnalysisScreen with our PGN and pumps it.
// Re-used in every test so we don't repeat ourselves.
//
// Note: clearSavedStandaloneAnalysis() is called in tearDown to reset the
// cached analysis state between tests — the same pattern used in
// analysis_screen_test.dart.
Future<void> _pumpPgnScreen(WidgetTester tester) async {
  final app = await makeTestProviderScopeApp(
    tester,
    home: const AnalysisScreen(
      options: AnalysisOptions.pgn(
        id: StringId('pgn-comment-test'),
        orientation: Side.white,
        pgn: _pgnWithComments,
        // We keep computer analysis off — we only care about comment display.
        isComputerAnalysisAllowed: false,
        variant: Variant.standard,
      ),
    ),
  );
  await tester.pumpWidget(app);
  // pumpAndSettle waits for all animations and async rebuilds to finish.
  await tester.pumpAndSettle();
}

// Returns the text of every Linkify widget currently in the widget tree.
// We use this instead of find.textContaining() because Linkify renders via
// Text.rich → RichText, whose text is not reliably searchable without
// reading the widget property directly.
List<String> _linkifyTexts(WidgetTester tester) =>
    tester.widgetList<Linkify>(find.byType(Linkify)).map((w) => w.text).toList();

void main() {
  tearDown(() {
    // Reset the cached standalone analysis between tests, otherwise the second
    // test would reuse the tree from the first test and see stale state.
    clearSavedStandaloneAnalysis();
  });

  group('PGN comment rendering', () {
    // --- Location 1: root comment ---
    //
    // The root comment sits before the first move. It is rendered by a
    // Consumer+Linkify widget in _PgnTreeView's root comment rendering.

    testWidgets('root comment text is visible', (tester) async {
      await _pumpPgnScreen(tester);

      expect(_linkifyTexts(tester).any((t) => t.contains('Root comment')), isTrue);
    });

    testWidgets('root comment URL is passed to Linkify', (tester) async {
      await _pumpPgnScreen(tester);

      // By checking Linkify.text directly we verify that the URL was passed to
      // the widget, not just that it appears somewhere on screen by coincidence.
      expect(_linkifyTexts(tester).any((t) => t.contains('https://lichess.org')), isTrue);
    });

    // --- Location 2: move comment (inline in PGN, end-of-part in two-column UI) ---
    //
    // In two-column mode, a commented move causes _hasNonInlineSideLine() to
    // return true, which ends the current mainline part. The comment is then
    // rendered as a standalone Linkify widget at the bottom of that part
    // (_TwoColumnMainlinePart comment rendering), not inline with the move notation.

    testWidgets('plain move comment text is visible', (tester) async {
      await _pumpPgnScreen(tester);

      expect(_linkifyTexts(tester).any((t) => t.contains('A plain move comment')), isTrue);
    });

    testWidgets('move comment URL is passed to Linkify', (tester) async {
      await _pumpPgnScreen(tester);

      expect(_linkifyTexts(tester).any((t) => t.contains('https://example.com')), isTrue);
    });

    // --- Location 3: end-of-mainline comment ---
    //
    // Same mechanism as Location 2 — the Nf3 comment ends up as a standalone
    // Linkify widget at the bottom of its mainline part (_TwoColumnMainlinePart comment rendering).

    testWidgets('end-of-mainline comment text is visible', (tester) async {
      await _pumpPgnScreen(tester);

      expect(_linkifyTexts(tester).any((t) => t.contains('End comment')), isTrue);
    });

    testWidgets('end-of-mainline comment URL is passed to Linkify', (tester) async {
      await _pumpPgnScreen(tester);

      expect(_linkifyTexts(tester).any((t) => t.contains('https://lichess.org/analysis')), isTrue);
    });

    // --- Linkify widget count ---
    //
    // Our PGN produces 4 Linkify widgets:
    //   1. root comment (_PgnTreeView root comment rendering)
    //   2. e4 comment — end-of-part 1 (_TwoColumnMainlinePart comment rendering)
    //   3. e5 comment — end-of-part 2 (_TwoColumnMainlinePart comment rendering)
    //   4. Nf3 comment — end-of-part 3 (_TwoColumnMainlinePart comment rendering)

    testWidgets('all four comments are rendered as Linkify widgets', (tester) async {
      await _pumpPgnScreen(tester);

      expect(find.byType(Linkify), findsNWidgets(4));
    });
  });
}
