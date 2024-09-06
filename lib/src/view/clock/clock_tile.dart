import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';

import 'custom_clock_settings.dart';

const _darkClockStyle = ClockStyle(
  textColor: Colors.black87,
  activeTextColor: Colors.white,
  emergencyTextColor: Colors.white,
  backgroundColor: Colors.transparent,
  activeBackgroundColor: Colors.transparent,
  emergencyBackgroundColor: Color(0xFF673431),
);

const _lightClockStyle = ClockStyle(
  textColor: Colors.black87,
  activeTextColor: Colors.white,
  emergencyTextColor: Colors.black,
  backgroundColor: Colors.transparent,
  activeBackgroundColor: Colors.transparent,
  emergencyBackgroundColor: Color(0xFFF2CCCC),
);

class ClockTile extends ConsumerWidget {
  const ClockTile({
    required this.playerType,
    required this.clockState,
    super.key,
  });

  final ClockPlayerType playerType;
  final ClockState clockState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = clockState.isLoser(playerType)
        ? LichessColors.red
        : clockState.isPlayersTurn(playerType) &&
                clockState.currentPlayer != null
            ? LichessColors.brag
            : Colors.grey;

    return RotatedBox(
      quarterTurns: playerType == ClockPlayerType.top ? 2 : 0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: clockState.paused ? 0.7 : 1,
            child: Material(
              color: backgroundColor,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: clockState.isPlayersMoveAllowed(playerType)
                    ? () {
                        ref
                            .read(clockControllerProvider.notifier)
                            .onTap(playerType);
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: CountdownClock(
                            key: Key('${clockState.id}-$playerType'),
                            padLeft: true,
                            lightColorStyle: _lightClockStyle,
                            darkColorStyle: _darkClockStyle,
                            duration: clockState.getDuration(playerType),
                            active: clockState.isActivePlayer(playerType),
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
                          crossFadeState: clockState.isLoser(playerType)
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                        ),
                      ),
                      if (!clockState.started)
                        PlatformIconButton(
                          semanticsLabel: context.l10n.settingsSettings,
                          iconSize: 32,
                          icon: Icons.tune,
                          onTap: () => showAdaptiveBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomClockSettings(
                              player: playerType,
                              clock: playerType == ClockPlayerType.top
                                  ? TimeIncrement.fromDurations(
                                      clockState.options.timePlayerTop,
                                      clockState.options.incrementPlayerTop,
                                    )
                                  : TimeIncrement.fromDurations(
                                      clockState.options.timePlayerBottom,
                                      clockState.options.incrementPlayerBottom,
                                    ),
                              onSubmit: (
                                ClockPlayerType player,
                                TimeIncrement clock,
                              ) {
                                Navigator.of(context).pop();
                                ref
                                    .read(clockControllerProvider.notifier)
                                    .updateOptionsCustom(clock, player);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: Text(
              '${context.l10n.stormMoves}: ${clockState.getMovesCount(playerType)}',
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
