import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/view/clock/clock_tile.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
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
    ref.watch(clockControllerProvider);

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: ClockTile(playerType: ClockPlayerType.top,)),
        Expanded(child: ClockTile(playerType: ClockPlayerType.bottom,)),
      ],
    );
  }
}
