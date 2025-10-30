import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'material_diff.freezed.dart';

@freezed
sealed class MaterialDiffSide with _$MaterialDiffSide {
  const factory MaterialDiffSide({
    required IMap<Role, int> pieces,
    required int score,
    required IMap<Role, int> capturedPieces,
  }) = _MaterialDiffSide;
}

const IMap<Role, int> pieceScores = IMapConst({
  Role.king: 0,
  Role.queen: 9,
  Role.rook: 5,
  Role.bishop: 3,
  Role.knight: 3,
  Role.pawn: 1,
});

@freezed
sealed class MaterialDiff with _$MaterialDiff {
  const MaterialDiff._();

  const factory MaterialDiff({required MaterialDiffSide black, required MaterialDiffSide white}) =
      _MaterialDiff;

  factory MaterialDiff.fromBoard(Board board, {Board? startingPosition}) {
    int score = 0;
    final IMap<Role, int> blackCount = board.materialCount(Side.black);
    final IMap<Role, int> whiteCount = board.materialCount(Side.white);

    final IMap<Role, int> blackStartingCount =
        startingPosition?.materialCount(Side.black) ?? Board.standard.materialCount(Side.black);
    final IMap<Role, int> whiteStartingCount =
        startingPosition?.materialCount(Side.white) ?? Board.standard.materialCount(Side.white);

    IMap<Role, int> subtractPieceCounts(
      IMap<Role, int> startingCount,
      IMap<Role, int> subtractCount,
    ) {
      return startingCount.map(
        (role, count) => MapEntry(role, count - (subtractCount.get(role) ?? 0)),
      );
    }

    final IMap<Role, int> blackCapturedPieces = subtractPieceCounts(whiteStartingCount, whiteCount);
    final IMap<Role, int> whiteCapturedPieces = subtractPieceCounts(blackStartingCount, blackCount);

    Map<Role, int> count;
    Map<Role, int> black;
    Map<Role, int> white;

    count = {
      Role.king: 0,
      Role.queen: 0,
      Role.rook: 0,
      Role.bishop: 0,
      Role.knight: 0,
      Role.pawn: 0,
    };

    black = {
      Role.king: 0,
      Role.queen: 0,
      Role.rook: 0,
      Role.bishop: 0,
      Role.knight: 0,
      Role.pawn: 0,
    };

    white = {
      Role.king: 0,
      Role.queen: 0,
      Role.rook: 0,
      Role.bishop: 0,
      Role.knight: 0,
      Role.pawn: 0,
    };

    whiteCount.forEach((role, cnt) {
      count[role] = cnt - blackCount[role]!;
      score += pieceScores[role]! * count[role]!;
    });

    count.forEach((role, cnt) {
      if (cnt > 0) {
        white[role] = cnt;
      } else if (cnt < 0) {
        black[role] = -cnt;
      }
    });

    return MaterialDiff(
      black: MaterialDiffSide(
        pieces: black.toIMap(),
        score: -score,
        capturedPieces: blackCapturedPieces,
      ),
      white: MaterialDiffSide(
        pieces: white.toIMap(),
        score: score,
        capturedPieces: whiteCapturedPieces,
      ),
    );
  }

  MaterialDiffSide bySide(Side side) => side == Side.black ? black : white;
}
