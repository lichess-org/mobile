import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';
import 'package:lichess_mobile/src/model/offline_computer/tablebase_eval.dart';

// A non-terminal KQ vs K position used across tests.
// White: Ka2, Qc2; Black: Kh1 — no side in check, non-terminal.
const _whiteFen = '8/8/8/8/8/8/K1Q5/7k w - - 0 1';
const _blackFen = '8/8/8/8/8/8/K1Q5/7k b - - 0 1';

TablebaseEntry _makeEntry({
  required TablebaseCategory category,
  int? dtm,
  IList<TablebaseMove>? moves,
}) {
  return TablebaseEntry(
    dtz: null,
    dtc: null,
    dtm: dtm,
    checkmate: false,
    stalemate: false,
    insufficientMaterial: false,
    category: category,
    moves: moves ?? IList(const []),
  );
}

TablebaseMove _makeMove(String uci, TablebaseCategory category) {
  return TablebaseMove(
    uci: uci,
    san: uci,
    dtz: null,
    dtc: null,
    dtm: null,
    zeroing: false,
    conversion: false,
    checkmate: false,
    stalemate: false,
    insufficientMaterial: false,
    category: category,
  );
}

void main() {
  final whiteToMove = Chess.fromSetup(Setup.parseFen(_whiteFen));
  final blackToMove = Chess.fromSetup(Setup.parseFen(_blackFen));

  // DTM is in half-moves. The mate score in full moves is ⌈DTM/2⌉ = (DTM+1)~/2.
  // Examples: DTM=1→1, DTM=3→2, DTM=5→3, DTM=2→1, DTM=4→2, DTM=6→3.

  group('tablebaseEntryToCloudEval', () {
    group('win / syzygyWin', () {
      // White is to move and winning: mate score is positive.
      test('white to move, DTM=5 half-moves → mate +3', () {
        final entry = _makeEntry(category: TablebaseCategory.win, dtm: 5);
        final eval = tablebaseEntryToCloudEval(entry, whiteToMove)!;
        expect(eval.mate, 3); // (5+1)~/2 = 3
        expect(eval.cp, isNull);
      });

      // Black is to move and winning: mate score is negative.
      test('black to move, DTM=3 half-moves → mate -2', () {
        final entry = _makeEntry(category: TablebaseCategory.win, dtm: 3);
        final eval = tablebaseEntryToCloudEval(entry, blackToMove)!;
        expect(eval.mate, -2); // (3+1)~/2 = 2
        expect(eval.cp, isNull);
      });

      test('DTM=1 (next half-move is checkmate) → mate ±1', () {
        expect(
          tablebaseEntryToCloudEval(
            _makeEntry(category: TablebaseCategory.win, dtm: 1),
            whiteToMove,
          )!.mate,
          1, // (1+1)~/2 = 1
        );
        expect(
          tablebaseEntryToCloudEval(
            _makeEntry(category: TablebaseCategory.win, dtm: 1),
            blackToMove,
          )!.mate,
          -1,
        );
      });

      test('DTM=null falls back to ±10', () {
        expect(
          tablebaseEntryToCloudEval(_makeEntry(category: TablebaseCategory.win), whiteToMove)!.mate,
          10,
        );
        expect(
          tablebaseEntryToCloudEval(_makeEntry(category: TablebaseCategory.win), blackToMove)!.mate,
          -10,
        );
      });

      test('syzygyWin behaves the same as win', () {
        final entry = _makeEntry(category: TablebaseCategory.syzygyWin, dtm: 7);
        expect(tablebaseEntryToCloudEval(entry, whiteToMove)!.mate, 4); // (7+1)~/2 = 4
        expect(tablebaseEntryToCloudEval(entry, blackToMove)!.mate, -4);
      });
    });

    group('loss / syzygyLoss', () {
      // The side to move is losing; the opponent delivers mate.
      // White is to move and losing → black mates → negative score.
      test('white to move, DTM=4 half-moves → mate -2 (black wins)', () {
        final entry = _makeEntry(category: TablebaseCategory.loss, dtm: 4);
        final eval = tablebaseEntryToCloudEval(entry, whiteToMove)!;
        expect(eval.mate, -2); // (4+1)~/2 = 2
        expect(eval.cp, isNull);
      });

      // Black is to move and losing → white mates → positive score.
      test('black to move, DTM=2 half-moves → mate +1 (white wins)', () {
        final entry = _makeEntry(category: TablebaseCategory.loss, dtm: 2);
        final eval = tablebaseEntryToCloudEval(entry, blackToMove)!;
        expect(eval.mate, 1); // (2+1)~/2 = 1
        expect(eval.cp, isNull);
      });

      test('DTM=null falls back to ∓10', () {
        expect(
          tablebaseEntryToCloudEval(
            _makeEntry(category: TablebaseCategory.loss),
            whiteToMove,
          )!.mate,
          -10,
        );
        expect(
          tablebaseEntryToCloudEval(
            _makeEntry(category: TablebaseCategory.loss),
            blackToMove,
          )!.mate,
          10,
        );
      });

      test('syzygyLoss behaves the same as loss', () {
        final entry = _makeEntry(category: TablebaseCategory.syzygyLoss, dtm: 6);
        expect(tablebaseEntryToCloudEval(entry, whiteToMove)!.mate, -3); // (6+1)~/2 = 3
        expect(tablebaseEntryToCloudEval(entry, blackToMove)!.mate, 3);
      });
    });

    group('draw / cursedWin / blessedLoss → cp=0', () {
      for (final category in [
        TablebaseCategory.draw,
        TablebaseCategory.cursedWin,
        TablebaseCategory.blessedLoss,
      ]) {
        test('$category: cp=0, no mate', () {
          final eval = tablebaseEntryToCloudEval(_makeEntry(category: category), whiteToMove)!;
          expect(eval.cp, 0);
          expect(eval.mate, isNull);
        });
      }
    });

    group('non-conclusive categories → null', () {
      for (final category in [
        TablebaseCategory.unknown,
        TablebaseCategory.maybeWin,
        TablebaseCategory.maybeLoss,
      ]) {
        test('$category returns null', () {
          expect(tablebaseEntryToCloudEval(_makeEntry(category: category), whiteToMove), isNull);
        });
      }
    });

    group('PV / best move', () {
      test('first move of entry.moves is included in PV', () {
        final moves = IList([
          _makeMove('c2c1', TablebaseCategory.loss),
          _makeMove('c2h2', TablebaseCategory.loss),
        ]);
        final entry = _makeEntry(category: TablebaseCategory.win, dtm: 3, moves: moves);
        final eval = tablebaseEntryToCloudEval(entry, whiteToMove)!;
        expect(eval.pvs[0].moves, IList(const ['c2c1']));
      });

      test('empty moves list → empty PV', () {
        final entry = _makeEntry(category: TablebaseCategory.win, dtm: 3);
        final eval = tablebaseEntryToCloudEval(entry, whiteToMove)!;
        expect(eval.pvs[0].moves, IList(const []));
      });
    });

    group('CloudEval metadata', () {
      test('depth is always 99', () {
        final eval = tablebaseEntryToCloudEval(
          _makeEntry(category: TablebaseCategory.win, dtm: 1),
          whiteToMove,
        )!;
        expect(eval.depth, 99);
      });

      test('nodes is always 0', () {
        final eval = tablebaseEntryToCloudEval(
          _makeEntry(category: TablebaseCategory.win, dtm: 1),
          whiteToMove,
        )!;
        expect(eval.nodes, 0);
      });
    });
  });
}
