import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/view/play/time_control_modal.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';

class ClockSettings extends ConsumerWidget {
  const ClockSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(clockControllerProvider.notifier);
    return Row(
      children: [
        const Expanded(child: SizedBox.shrink()),
        const _PlayResumeButton(),
        IconButton(
          onPressed: () => controller.reset(),
          icon: const Icon(Icons.repeat),
        ),
        IconButton(
          onPressed: () {
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
          icon: const Icon(Icons.settings),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.home),
        ),
        IconButton(
          onPressed: null,
          icon: RotatedBox(
            quarterTurns: 1,
            child: Text(
              ref.watch(clockControllerProvider).moveCount.toString(),
              style: Styles.bold,
            ),
          ),
        ),
        const Expanded(child: SizedBox.shrink()),
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
      return IconButton(
        onPressed: () => controller.resume(),
        icon: const Icon(Icons.play_arrow),
      );
    }
    return IconButton(
      onPressed: state.currentPlayer != null ? () => controller.pause() : null,
      icon: const Icon(Icons.pause),
    );
  }
}
