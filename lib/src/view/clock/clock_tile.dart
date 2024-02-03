import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';

const _darkClockStyle = ClockStyle(
  textColor: Colors.white,
  activeTextColor: Colors.black,
  emergencyTextColor: Colors.white,
  backgroundColor: Colors.transparent,
  activeBackgroundColor: Colors.transparent,
  emergencyBackgroundColor: Color(0xFF673431),
);

const _lightClock = ClockStyle(
  textColor: Colors.white,
  activeTextColor: Colors.black,
  emergencyTextColor: Colors.black,
  backgroundColor: Colors.transparent,
  activeBackgroundColor: Colors.transparent,
  emergencyBackgroundColor: Color(0xFFF2CCCC),
);

class ClockTile extends ConsumerWidget {
  final ClockPlayerType playerType;
  const ClockTile({required this.playerType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final state = ref.watch(clockControllerProvider);

    bool isActive() => state.activePlayer == playerType;

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: isActive() ? themeData.colorScheme.primary : Colors.grey,
        child: InkWell(
          onTap: isActive()
              ? () {
                  ref.read(clockControllerProvider.notifier).endTurn(playerType);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: FittedBox(
              child: RotatedBox(
                quarterTurns: playerType == ClockPlayerType.top ? 2 : 0,
                child: CountdownClock(
                  lightColorStyle: _lightClock,
                  darkColorStyle: _darkClockStyle,
                  duration: state.getDuration(playerType),
                  active: isActive(),
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
