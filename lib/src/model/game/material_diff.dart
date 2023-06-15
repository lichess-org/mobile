import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'material_diff.freezed.dart';

@freezed
class MaterialDiffSide with _$MaterialDiffSide {
  const factory MaterialDiffSide({
    required IMap<Role, int> pieces,
    required int score,
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
class MaterialDiff with _$MaterialDiff {
  const MaterialDiff._();

  const factory MaterialDiff({
    required MaterialDiffSide black,
    required MaterialDiffSide white,
  }) = _MaterialDiff;

  factory MaterialDiff.fromBoard(Board board) {
    int score = 0;
    final IMap<Role, int> blackCount = board.materialCount(Side.black);
    final IMap<Role, int> whiteCount = board.materialCount(Side.white);

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
      black: MaterialDiffSide(pieces: black.toIMap(), score: -score),
      white: MaterialDiffSide(pieces: white.toIMap(), score: score),
    );
  }

  MaterialDiffSide bySide(Side side) => side == Side.black ? black : white;
}
