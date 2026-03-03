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

    /// Number of checks given by this side. Only relevant in the 3-check variant, null otherwise.
    required int? checksGiven,
  }) = _MaterialDiffSide;

  factory MaterialDiffSide.empty() =>
      MaterialDiffSide(pieces: IMap(), score: 0, capturedPieces: IMap(), checksGiven: null);
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

  factory MaterialDiff.fromPosition(Position position) {
    if (position.rule == Rule.crazyhouse || position.rule == Rule.horde) {
      return MaterialDiff(black: MaterialDiffSide.empty(), white: MaterialDiffSide.empty());
    }

    int score = 0;
    final IMap<Role, int> blackCount = position.board.materialCount(Side.black);
    final IMap<Role, int> whiteCount = position.board.materialCount(Side.white);

    final startingPosition = Position.initialPosition(position.rule);

    final IMap<Role, int> blackStartingCount = startingPosition.board.materialCount(Side.black);
    final IMap<Role, int> whiteStartingCount = startingPosition.board.materialCount(Side.white);

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

    int? checksGiven(Side side) => switch (position) {
      ThreeCheck(remainingChecks: (final white, final black)) =>
        3 - (side == Side.white ? white : black),
      _ => null,
    };

    return MaterialDiff(
      black: MaterialDiffSide(
        pieces: black.toIMap(),
        score: -score,
        capturedPieces: blackCapturedPieces,
        checksGiven: checksGiven(Side.black),
      ),
      white: MaterialDiffSide(
        pieces: white.toIMap(),
        score: score,
        capturedPieces: whiteCapturedPieces,
        checksGiven: checksGiven(Side.white),
      ),
    );
  }

  MaterialDiffSide bySide(Side side) => side == Side.black ? black : white;
}
