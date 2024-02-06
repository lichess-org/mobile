import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';

const _darkClockStyle = ClockStyle(
  textColor: Colors.black,
  activeTextColor: Colors.white,
  emergencyTextColor: Colors.white,
  backgroundColor: Colors.transparent,
  activeBackgroundColor: Colors.transparent,
  emergencyBackgroundColor: Color(0xFF673431),
);

const _lightClockStyle = ClockStyle(
  textColor: Colors.black,
  activeTextColor: Colors.white,
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
    final state = ref.watch(clockControllerProvider);

    Color getBackgroundColor() {
      if (state.isLoser(playerType)) {
        return LichessColors.red;
      } else if (state.isPlayersTurn(playerType) &&
          state.currentPlayer != null) {
        return LichessColors.green;
      } else {
        return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: getBackgroundColor(),
        child: InkWell(
          onTap: state.isPlayersTurnAllowed(playerType)
              ? () {
                  ref
                      .read(clockControllerProvider.notifier)
                      .endTurn(playerType);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: FittedBox(
              child: RotatedBox(
                quarterTurns: playerType == ClockPlayerType.top ? 2 : 0,
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: CountdownClock(
                    key: Key('${state.id}-$playerType'),
                    lightColorStyle: _lightClockStyle,
                    darkColorStyle: _darkClockStyle,
                    duration: state.getDuration(playerType),
                    active: state.isActivePlayer(playerType),
                    onFlag: () {
                      ref
                          .read(clockControllerProvider.notifier)
                          .setLoser(playerType);
                    },
                    onStop: (remaining) {
                      ref
                          .read(clockControllerProvider.notifier)
                          .updateDuration(playerType, remaining);
                    },
                  ),
                  secondChild: const Icon(Icons.flag),
                  crossFadeState: state.isLoser(playerType)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
