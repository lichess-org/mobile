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
        IconButton(
          onPressed: () => controller.reset(),
          icon: const Icon(Icons.repeat),
        ),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }
}
