import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';

const _iconSize = 38.0;
const _kIconPadding = EdgeInsets.all(10.0);

class ClockSettings extends ConsumerWidget {
  const ClockSettings({required this.orientation, super.key});

  final Orientation orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clockToolControllerProvider);
    final buttonsEnabled = !state.started || state.paused;
    final clockOrientation = state.clockOrientation;

    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled),
    );

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: (orientation == Orientation.portrait ? Row.new : Column.new)(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: clockOrientation.quarterTurns,
              child: const _PlayResumeButton(_iconSize),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: clockOrientation.quarterTurns,
              child: IconButton(
                padding: _kIconPadding,
                tooltip: context.l10n.reset,
                iconSize: _iconSize,
                onPressed:
                    buttonsEnabled
                        ? () {
                          ref.read(clockToolControllerProvider.notifier).reset();
                        }
                        : null,
                icon: const Icon(Icons.refresh),
              ),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: clockOrientation.quarterTurns,
              child: IconButton(
                padding: _kIconPadding,
                tooltip: context.l10n.settingsSettings,
                iconSize: _iconSize,
                onPressed:
                    buttonsEnabled
                        ? () {
                          final double screenHeight = MediaQuery.sizeOf(context).height;
                          showAdaptiveBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            constraints: BoxConstraints(
                              maxHeight: screenHeight - (screenHeight / 10),
                            ),
                            builder: (BuildContext context) {
                              final options = ref.watch(
                                clockToolControllerProvider.select((value) => value.options),
                              );
                              return TimeControlModal(
                                excludeUltraBullet: true,
                                value: TimeIncrement(
                                  options.whiteTime.inSeconds,
                                  options.whiteIncrement.inSeconds,
                                ),
                                onSelected: (choice) {
                                  ref
                                      .read(clockToolControllerProvider.notifier)
                                      .updateOptions(choice);
                                },
                              );
                            },
                          );
                        }
                        : null,
                icon: const Icon(Icons.settings),
              ),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: clockOrientation.quarterTurns,
              child: IconButton(
                padding: _kIconPadding,
                iconSize: _iconSize,
                // TODO: translate
                tooltip: 'Toggle sound',
                onPressed: () => ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled(),
                icon: Icon(isSoundEnabled ? Icons.volume_up : Icons.volume_off),
              ),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: clockOrientation.quarterTurns,
              child: IconButton(
                padding: _kIconPadding,
                iconSize: _iconSize,
                // TODO: translate
                tooltip: 'Flip clock',
                onPressed:
                    () => ref
                        .read(clockToolControllerProvider.notifier)
                        .toggleOrientation(clockOrientation.toggle),
                icon: const Icon(Icons.screen_rotation),
              ),
            ),
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: clockOrientation.quarterTurns,
              child: IconButton(
                padding: _kIconPadding,
                tooltip: context.l10n.close,
                iconSize: _iconSize,
                onPressed: buttonsEnabled ? () => Navigator.of(context).pop() : null,
                icon: const Icon(Icons.home),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayResumeButton extends ConsumerWidget {
  const _PlayResumeButton(this.iconSize);

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(clockToolControllerProvider.notifier);
    final state = ref.watch(clockToolControllerProvider);

    return ColoredBox(
      color:
          !state.started
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Colors.transparent,
      child:
          !state.started
              ? IconButton(
                padding: _kIconPadding,
                color: Theme.of(context).colorScheme.primary,
                tooltip: context.l10n.play,
                iconSize: iconSize,
                onPressed: () => controller.start(),
                icon: const Icon(Icons.play_arrow),
              )
              : state.paused
              ? IconButton(
                padding: _kIconPadding,
                tooltip: context.l10n.resume,
                iconSize: iconSize,
                onPressed: () => controller.resume(),
                icon: const Icon(Icons.play_arrow),
              )
              : IconButton(
                padding: _kIconPadding,
                tooltip: context.l10n.pause,
                iconSize: iconSize,
                onPressed: () => controller.pause(),
                icon: const Icon(Icons.pause),
              ),
    );
  }
}
