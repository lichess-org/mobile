import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

const _iconSize = 45.0;
const _iconSpacer = SizedBox(width: 16);

class ClockSettings extends ConsumerWidget {
  const ClockSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(clockControllerProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _PlayResumeButton(),
        _iconSpacer,
        PlatformIconButton(
          semanticsLabel: context.l10n.reset,
          iconSize: _iconSize,
          onTap: () => controller.reset(),
          icon: Icons.cached,
        ),
        _iconSpacer,
        PlatformIconButton(
          semanticsLabel: context.l10n.settingsSettings,
          iconSize: _iconSize,
          onTap: () {
            final double screenHeight = MediaQuery.sizeOf(context).height;
            showAdaptiveBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              constraints: BoxConstraints(
                maxHeight: screenHeight - (screenHeight / 10),
              ),
              builder: (BuildContext context) {
                return const TimeControlModal();
              },
            );
          },
          icon: Icons.settings,
        ),
        _iconSpacer,
        PlatformIconButton(
          semanticsLabel: context.l10n.close,
          iconSize: _iconSize,
          onTap: () => Navigator.of(context).pop(),
          icon: Icons.home,
        ),
        _iconSpacer,
        RotatedBox(
          quarterTurns: 1,
          child: Text(
            ref
                .watch(
                  clockControllerProvider.select((value) => value.moveCount),
                )
                .toString(),
            style: Styles.bold.copyWith(fontSize: 24),
          ),
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
