import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';

/// Replicates the display logic from [_GameResultListTile] in
/// broadcast_player_results_screen.dart to verify it matches the web behavior.
String displayedPoints({
  required BroadcastPoints? points,
  required double? customPoints,
  required Side color,
}) {
  return customPoints != null && customPoints != 0.0 && customPoints != points?.value
      ? NumberFormat('0.##').format(customPoints)
      : points?.resultFor(color).resultToString(color) ?? '*';
}

void main() {
  group('BroadcastPoints.value', () {
    test('returns correct numeric values', () {
      expect(BroadcastPoints.one.value, 1.0);
      expect(BroadcastPoints.half.value, 0.5);
      expect(BroadcastPoints.zero.value, 0.0);
    });
  });

  group('Broadcast player game result display', () {
    group('without custom scoring', () {
      test('win shows 1', () {
        expect(
          displayedPoints(points: BroadcastPoints.one, customPoints: null, color: Side.white),
          '1',
        );
      });

      test('draw shows ½', () {
        expect(
          displayedPoints(points: BroadcastPoints.half, customPoints: null, color: Side.white),
          '½',
        );
      });

      test('loss shows 0', () {
        expect(
          displayedPoints(points: BroadcastPoints.zero, customPoints: null, color: Side.white),
          '0',
        );
      });

      test('ongoing shows *', () {
        expect(displayedPoints(points: null, customPoints: null, color: Side.white), '*');
      });
    });

    group('with custom scoring where custom differs from standard', () {
      test('custom win 3 points shows 3', () {
        expect(
          displayedPoints(points: BroadcastPoints.one, customPoints: 3.0, color: Side.white),
          '3',
        );
      });

      test('custom draw 1.5 points shows 1.5', () {
        expect(
          displayedPoints(points: BroadcastPoints.half, customPoints: 1.5, color: Side.white),
          '1.5',
        );
      });

      test('custom draw 1 point shows 1', () {
        expect(
          displayedPoints(points: BroadcastPoints.half, customPoints: 1.0, color: Side.white),
          '1',
        );
      });

      test('custom draw with 0 custom points shows ½, not 0', () {
        // In Norway Chess, a classical draw awards 0 custom points because
        // points are awarded via the armageddon game instead.
        // The web shows ½ (standard result); the mobile must match.
        expect(
          displayedPoints(points: BroadcastPoints.half, customPoints: 0.0, color: Side.white),
          '½',
        );
      });

      test('custom loss 0 points shows 0', () {
        expect(
          displayedPoints(points: BroadcastPoints.zero, customPoints: 0.0, color: Side.white),
          '0',
        );
      });
    });

    group('with custom scoring where custom matches standard', () {
      test('custom win 1.0 shows standard 1', () {
        expect(
          displayedPoints(points: BroadcastPoints.one, customPoints: 1.0, color: Side.white),
          '1',
        );
      });

      test('custom draw 0.5 shows standard ½', () {
        expect(
          displayedPoints(points: BroadcastPoints.half, customPoints: 0.5, color: Side.white),
          '½',
        );
      });

      test('custom loss 0.0 shows standard 0', () {
        expect(
          displayedPoints(points: BroadcastPoints.zero, customPoints: 0.0, color: Side.white),
          '0',
        );
      });
    });

    group('color does not affect custom points display', () {
      test('black side win with custom 3 shows 3', () {
        expect(
          displayedPoints(points: BroadcastPoints.one, customPoints: 3.0, color: Side.black),
          '3',
        );
      });

      test('black side draw with custom 0 shows ½', () {
        expect(
          displayedPoints(points: BroadcastPoints.half, customPoints: 0.0, color: Side.black),
          '½',
        );
      });
    });
  });
}
