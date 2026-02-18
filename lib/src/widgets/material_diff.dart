import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

class MaterialDifferenceDisplay extends StatelessWidget {
  const MaterialDifferenceDisplay({
    required this.materialDiff,
    this.materialDifferenceFormat = MaterialDifferenceFormat.materialDifference,
  });

  final MaterialDiffSide? materialDiff;
  final MaterialDifferenceFormat? materialDifferenceFormat;

  static const _iconByRole = {
    Role.king: LichessIcons.chess_king,
    Role.queen: LichessIcons.chess_queen,
    Role.rook: LichessIcons.chess_rook,
    Role.bishop: LichessIcons.chess_bishop,
    Role.knight: LichessIcons.chess_knight,
    Role.pawn: LichessIcons.chess_pawn,
  };

  @override
  Widget build(BuildContext context) {
    final IMap<Role, int> piecesToRender = materialDiff != null
        ? (materialDifferenceFormat == MaterialDifferenceFormat.capturedPieces
              ? materialDiff!.capturedPieces
              : materialDiff!.pieces)
        : IMap();

    Icon roleIcon(Role role) => Icon(_iconByRole[role], size: 13, color: textShade(context, 0.5));

    return materialDifferenceFormat?.visible ?? true
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final role in Role.values)
                for (int i = 0; i < (piecesToRender.get(role) ?? 0); i++) roleIcon(role),
              ...Iterable.generate(materialDiff?.checksGiven ?? 0, (_) => roleIcon(Role.king)),
              const SizedBox(width: 3),
              Text(
                // a text font size of 14 is used to ensure that the text will take more vertical space
                // than the icons
                // this is a trick to make sure the player name widget will not shift, since the text
                // widget is always present (contrary to the icons)
                style: TextStyle(fontSize: 14, color: textShade(context, 0.5)),
                materialDiff != null && materialDiff!.score > 0 ? '+${materialDiff!.score}' : '',
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
