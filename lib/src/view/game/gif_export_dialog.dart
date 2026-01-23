import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/model/game/gif_export.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class GifExport extends StatefulWidget {
  const GifExport({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const GifExport());
  }

  @override
  State<GifExport> createState() => _GifExportState();
}

class _GifExportState extends State<GifExport> {
  bool playerNames = true;
  bool showPlayerRatings = true;
  bool moveAnnotations = false;
  bool chessClock = false;

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      children: [
        ListSection(
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
        FilledButton.tonal(
          onPressed: () => {
            Navigator.pop(
              context,
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
      ],
    );
  }
}
