import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

const _iconSize = 45.0;

class ClockSettings extends ConsumerWidget {
  const ClockSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(clockControllerProvider.notifier);
    final buttonsEnabled = ref.watch(
      clockControllerProvider
          .select((value) => value.paused || value.currentPlayer == null),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const _PlayResumeButton(),
        PlatformIconButton(
          semanticsLabel: context.l10n.reset,
          iconSize: _iconSize,
          onTap: buttonsEnabled ? () => controller.reset() : null,
          icon: Icons.cached,
        ),
        PlatformIconButton(
          semanticsLabel: context.l10n.settingsSettings,
          iconSize: _iconSize,
          onTap: buttonsEnabled
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
                        clockControllerProvider
                            .select((value) => value.options),
                      );
                      return TimeControlModal(
                        excludeUltraBullet: true,
                        value: TimeIncrement(
                          options.time.inSeconds,
                          options.increment.inSeconds,
                        ),
                        onSelected: (choice) {
                          controller.updateOptions(choice);
                        },
                      );
                    },
                  );
                }
              : null,
          icon: Icons.settings,
        ),
        PlatformIconButton(
          semanticsLabel: context.l10n.close,
          iconSize: _iconSize,
          onTap: buttonsEnabled ? () => Navigator.of(context).pop() : null,
          icon: Icons.home,
        ),
      ],
    );
  }
}

class _PlayResumeButton extends ConsumerWidget {
  const _PlayResumeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(clockControllerProvider.notifier);
    final state = ref.watch(clockControllerProvider);
    if (state.paused) {
      return PlatformIconButton(
        semanticsLabel: context.l10n.resume,
        iconSize: 35,
        onTap: () => controller.resume(),
        icon: Icons.play_arrow,
      );
    }
    return PlatformIconButton(
      semanticsLabel: context.l10n.pause,
      iconSize: 35,
      onTap: state.currentPlayer != null ? () => controller.pause() : null,
      icon: Icons.pause,
    );
  }
}
