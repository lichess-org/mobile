import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/gif_export.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class GifExport extends ConsumerStatefulWidget {
  const GifExport({super.key, required this.gameId, required this.orientation});

  final GameId gameId;
  final Side orientation;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required GameId gameId,
    required Side orientation,
  }) {
    return buildScreenRoute(
      context,
      screen: GifExport(gameId: gameId, orientation: orientation),
    );
  }

  @override
  ConsumerState<GifExport> createState() => _GifExportState();
}

class _GifExportState extends ConsumerState<GifExport> {
  bool playerNames = true;
  bool showPlayerRatings = true;
  bool moveAnnotations = false;
  bool chessClock = false;

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        ListSection(
          header: const Text('GIF Export Options'),
          materialFilledCard: true,
          children: [
            SwitchSettingTile(
              title: const Text('Player names'),
              value: playerNames,
              onChanged: (bool value) {
                setState(() {
                  playerNames = value;
                });
              },
            ),
            SwitchSettingTile(
              title: Text(context.l10n.preferencesShowPlayerRatings),
              value: showPlayerRatings,
              onChanged: (bool value) {
                setState(() {
                  showPlayerRatings = value;
                });
              },
            ),
            SwitchSettingTile(
              title: const Text('Move annotations'),
              value: moveAnnotations,
              onChanged: (bool value) {
                setState(() {
                  moveAnnotations = value;
                });
              },
            ),
            SwitchSettingTile(
              title: const Text('Chess clock'),
              value: chessClock,
              onChanged: (bool value) {
                setState(() {
                  chessClock = value;
                });
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FilledButton(
            onPressed: () => {
              Navigator.pop(context),
              shareGameGif(
                context,
                ref,
                widget.gameId,
                widget.orientation,
                GifExportOptions(
                  playerNames: playerNames,
                  showPlayerRatings: showPlayerRatings,
                  moveAnnotations: moveAnnotations,
                  chessClock: chessClock,
                ),
              ),
            },
            child: Text(context.l10n.next, textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
