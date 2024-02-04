import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';

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
    if (ref.watch(clockControllerProvider).paused) {
      return IconButton(
        onPressed: () => controller.resume(),
        icon: const Icon(Icons.play_arrow),
      );
    }
    return IconButton(
      onPressed: () => controller.pause(),
      icon: const Icon(Icons.pause),
    );
  }
}
