import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';

class ClockTile extends ConsumerWidget {
  final ClockPlayerType playerType;
  const ClockTile({required this.playerType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final state = ref.watch(clockControllerProvider);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: themeData.colorScheme.primary.withOpacity(0.5),
        child: InkWell(
          onTap: () {
            ref.read(clockControllerProvider.notifier).endTurn(playerType);
          },
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: FittedBox(
              child: RotatedBox(
                quarterTurns: playerType == ClockPlayerType.top ? 2 : 0,
                child: CountdownClock(
                  duration: state.getDuration(playerType),
                  active: state.activePlayer == playerType,
                  onStop: (remaining) {
                    scheduleMicrotask(() {
                      ref.read(clockControllerProvider.notifier).updateDuration(playerType, remaining);
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
