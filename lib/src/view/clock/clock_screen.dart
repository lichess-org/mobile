import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/view/clock/clock_settings.dart';
import 'package:lichess_mobile/src/view/clock/clock_tile.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  @override
  Widget build(BuildContext context) {
    return const ImmersiveModeWidget(
      child: Scaffold(body: _Body()),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clockControllerProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClockTile(
              playerType: ClockPlayerType.top,
              clockState: state,
            ),
          ),
          const ClockSettings(),
          Expanded(
            child: ClockTile(
              playerType: ClockPlayerType.bottom,
              clockState: state,
            ),
          ),
        ],
      ),
    );
  }
}
