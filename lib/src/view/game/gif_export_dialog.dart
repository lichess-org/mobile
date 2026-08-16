import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/gif_export.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_ui/material_ui.dart';

class GifExport extends ConsumerStatefulWidget {
  const GifExport({super.key, required this.gameId, required this.orientation});

  final GameId gameId;
  final Side orientation;

  static Route<dynamic> buildRoute({required GameId gameId, required Side orientation}) {
    return buildScreenRoute(
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
  String? loadingMessage;
  final List<Timer> _timers = [];

  void _addMessageTimer(Duration delay, String message) {
    _timers.add(
      Timer(delay, () {
        if (mounted) {
          setState(() {
            loadingMessage = message;
          });
        }
      }),
    );
  }

  void _clearTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  Future<void> _export() async {
    setState(() {
      loadingMessage = 'Generating GIF...';
    });
    _addMessageTimer(const Duration(seconds: 10), 'Long games take a bit more time...');
    _addMessageTimer(const Duration(seconds: 30), 'Almost there! Finalizing the GIF...');

    try {
      await shareGameGif(
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
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to export GIF: $e')));
      }
    } finally {
      _clearTimers();
      if (mounted) {
        setState(() {
          loadingMessage = null;
        });
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _clearTimers();
    super.dispose();
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: loadingMessage != null ? null : _export,
                child: loadingMessage != null
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(strokeWidth: 3),
                      )
                    : Text(context.l10n.next, textAlign: TextAlign.center),
              ),
              if (loadingMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    loadingMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
