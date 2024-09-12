import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';

const _iconSize = 38.0;

class ClockSettings extends ConsumerWidget {
  const ClockSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clockControllerProvider);
    final buttonsEnabled = !state.started || state.paused;

    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((prefs) => prefs.isSoundEnabled),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const _PlayResumeButton(_iconSize),
          IconButton(
            tooltip: context.l10n.reset,
            iconSize: _iconSize,
            onPressed: buttonsEnabled
                ? () {
                    ref.read(clockControllerProvider.notifier).reset();
                  }
                : null,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: context.l10n.settingsSettings,
            iconSize: _iconSize,
            onPressed: buttonsEnabled
                ? () {
                    final double screenHeight =
                        MediaQuery.sizeOf(context).height;
                    showAdaptiveBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      constraints: BoxConstraints(
                        maxHeight: screenHeight - (screenHeight / 10),
                      ),
                      builder: (BuildContext context) {
                        final options = ref.watch(
                          clockControllerProvider
                              .select((value) => value.options),
                        );
                        return TimeControlModal(
                          excludeUltraBullet: true,
                          value: TimeIncrement(
                            options.timePlayerTop.inSeconds,
                            options.incrementPlayerTop.inSeconds,
                          ),
                          onSelected: (choice) {
                            ref
                                .read(clockControllerProvider.notifier)
                                .updateOptions(choice);
                          },
                        );
                      },
                    );
                  }
                : null,
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            iconSize: _iconSize,
            // TODO: translate
            tooltip: 'Toggle sound',
            onPressed: () => ref
                .read(generalPreferencesProvider.notifier)
                .toggleSoundEnabled(),
            icon: Icon(isSoundEnabled ? Icons.volume_up : Icons.volume_off),
          ),
          IconButton(
            tooltip: context.l10n.close,
            iconSize: _iconSize,
            onPressed:
                buttonsEnabled ? () => Navigator.of(context).pop() : null,
            icon: const Icon(Icons.home),
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
    final controller = ref.read(clockControllerProvider.notifier);
    final state = ref.watch(clockControllerProvider);

    if (!state.started) {
      return IconButton(
        tooltip: context.l10n.play,
        iconSize: iconSize,
        onPressed: () => controller.start(),
        icon: const Icon(Icons.play_arrow),
      );
    }

    if (state.paused) {
      return IconButton(
        tooltip: context.l10n.resume,
        iconSize: iconSize,
        onPressed: () => controller.resume(),
        icon: const Icon(Icons.play_arrow),
      );
    }

    return IconButton(
      tooltip: context.l10n.pause,
      iconSize: iconSize,
      onPressed: () => controller.pause(),
      icon: const Icon(Icons.pause),
    );
  }
}
