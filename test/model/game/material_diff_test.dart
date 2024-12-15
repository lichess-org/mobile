import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';

void main() {
  group('GameMaterialDiff', () {
    test('generation from board', () {
      final Board board = Board.parseFen('r5k1/3Q1pp1/2p4p/4P1b1/p3R3/3P4/6PP/R5K1');
      final MaterialDiff diff = MaterialDiff.fromBoard(board);

      expect(diff.bySide(Side.black).score, equals(-10));
      expect(diff.bySide(Side.white).score, equals(10));
      expect(
        diff.bySide(Side.black).pieces,
        equals(
          IMap<Role, int>(const {
            Role.king: 0,
            Role.queen: 0,
            Role.rook: 0,
            Role.bishop: 1,
            Role.knight: 0,
            Role.pawn: 1,
          }),
        ),
      );
      expect(
        diff.bySide(Side.white).pieces,
        equals(
          IMap<Role, int>(const {
            Role.king: 0,
            Role.queen: 1,
            Role.rook: 1,
            Role.bishop: 0,
            Role.knight: 0,
            Role.pawn: 0,
          }),
        ),
      );
      expect(
        diff.bySide(Side.black).capturedPieces,
        equals(
          IMap<Role, int>(const {
            Role.king: 0,
            Role.queen: 0,
            Role.rook: 0,
            Role.bishop: 2,
            Role.knight: 2,
            Role.pawn: 4,
          }),
        ),
      );
      expect(
        diff.bySide(Side.white).capturedPieces,
        equals(
          IMap<Role, int>(const {
            Role.king: 0,
            Role.queen: 1,
            Role.rook: 1,
            Role.bishop: 1,
            Role.knight: 2,
            Role.pawn: 3,
          }),
        ),
      );
    });
  });
}
