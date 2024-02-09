import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/view/clock/clock_settings.dart';
import 'package:lichess_mobile/src/view/clock/clock_tile.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  final _boardKey = defaultTargetPlatform == TargetPlatform.android
      ? GlobalKey(debugLabel: 'clockScreen')
      : null;

  @override
  Widget build(BuildContext context) {
    return ImmersiveModeWidget(
      boardKey: _boardKey,
      child: PlatformWidget(
        androidBuilder: _androidBuilder,
        iosBuilder: _iosBuilder,
      ),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: _Body(),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return const SafeArea(
      child: CupertinoPageScaffold(
        child: _Body(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clockControllerProvider);

    return Column(
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
    );
  }
}
