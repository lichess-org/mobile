import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/clock/clock_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/countdown_clock.dart';

import 'custom_clock_settings.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImmersiveModeWidget(
      child: PopScope(canPop: false, child: Scaffold(body: _Body())),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clockControllerProvider);

    return OrientationBuilder(
      builder: (context, orientation) {
        return (orientation == Orientation.portrait ? Column.new : Row.new)(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClockTile(
                orientation: orientation,
                playerType: ClockPlayerType.top,
                clockState: state,
              ),
            ),
            ClockSettings(orientation: orientation),
            Expanded(
              child: ClockTile(
                orientation: orientation,
                playerType: ClockPlayerType.bottom,
                clockState: state,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ClockTile extends ConsumerWidget {
  const ClockTile({
    required this.playerType,
    required this.clockState,
    required this.orientation,
    super.key,
  });

  final ClockPlayerType playerType;
  final ClockState clockState;
  final Orientation orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = clockState.isLoser(playerType)
        ? context.lichessColors.error
        : !clockState.paused && clockState.isPlayersTurn(playerType)
            ? colorScheme.primary
            : clockState.activeSide == playerType
                ? colorScheme.secondaryContainer
                : colorScheme.surfaceContainer;

    final clockStyle = ClockStyle(
      textColor: clockState.activeSide == playerType
          ? colorScheme.onSecondaryContainer
          : colorScheme.onSurface,
      activeTextColor: colorScheme.onPrimary,
      emergencyTextColor: Colors.white,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Colors.transparent,
      emergencyBackgroundColor: const Color(0xFF673431),
    );

    return RotatedBox(
      quarterTurns: orientation == Orientation.portrait &&
              playerType == ClockPlayerType.top
          ? 2
          : 0,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Material(
            color: backgroundColor,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: !clockState.started
                  ? () {
                      ref
                          .read(clockControllerProvider.notifier)
                          .setActiveSide(playerType);
                    }
                  : null,
              onTapDown: clockState.started &&
                      clockState.isPlayersMoveAllowed(playerType)
                  ? (_) {
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
                          clockStyle: clockStyle,
                          timeLeft: clockState.getDuration(playerType),
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
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: Text(
              '${context.l10n.stormMoves}: ${clockState.getMovesCount(playerType)}',
              style: TextStyle(
                fontSize: 13,
                color:
                    !clockState.paused && clockState.isPlayersTurn(playerType)
                        ? clockStyle.activeTextColor
                        : clockStyle.textColor,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.paddingOf(context).bottom + 48.0,
            child: AnimatedOpacity(
              opacity: clockState.started ? 0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: PlatformIconButton(
                semanticsLabel: context.l10n.settingsSettings,
                iconSize: 32,
                icon: Icons.tune,
                color: clockStyle.textColor,
                onTap: clockState.started
                    ? null
                    : () => showAdaptiveBottomSheet<void>(
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
            ),
          ),
        ],
      ),
    );
  }
}
