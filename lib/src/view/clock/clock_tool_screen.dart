import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/clock/clock_settings.dart';
import 'package:lichess_mobile/src/view/clock/custom_clock_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';

class ClockToolScreen extends StatelessWidget {
  const ClockToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImmersiveModeWidget(
      child: PopScope(canPop: false, child: Scaffold(body: _Body())),
    );
  }
}

enum TilePosition { bottom, top }

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clockToolControllerProvider);

    return OrientationBuilder(
      builder: (context, orientation) {
        return (orientation == Orientation.portrait ? Column.new : Row.new)(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClockTile(
                position: TilePosition.top,
                orientation: orientation,
                playerType: state.bottomPlayer.opposite,
                clockState: state,
              ),
            ),
            ClockSettings(orientation: orientation),
            Expanded(
              child: ClockTile(
                position: TilePosition.bottom,
                orientation: orientation,
                playerType: state.bottomPlayer,
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
    required this.position,
    required this.playerType,
    required this.clockState,
    required this.orientation,
    super.key,
  });

  final TilePosition position;
  final Side playerType;
  final ClockState clockState;
  final Orientation orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor =
        clockState.isFlagged(playerType)
            ? colorScheme.error
            : !clockState.paused && clockState.isPlayersTurn(playerType)
            ? colorScheme.primaryFixed
            : clockState.activeSide == playerType
            ? colorScheme.primaryFixedDim
            : colorScheme.surface;

    final clockStyle = ClockStyle(
      textColor:
          clockState.activeSide == playerType ? colorScheme.onPrimaryFixed : colorScheme.onSurface,
      activeTextColor: colorScheme.onPrimaryFixed,
      emergencyTextColor: Colors.white,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Colors.transparent,
      emergencyBackgroundColor: const Color(0xFF673431),
    );

    return RotatedBox(
      quarterTurns: orientation == Orientation.portrait && position == TilePosition.top ? 2 : 0,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Material(
            color: backgroundColor,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap:
                  !clockState.started
                      ? () {
                        ref
                            .read(clockToolControllerProvider.notifier)
                            .setBottomPlayer(
                              position == TilePosition.bottom ? Side.white : Side.black,
                            );
                      }
                      : null,
              onTapDown:
                  clockState.started && clockState.isPlayersMoveAllowed(playerType)
                      ? (_) {
                        ref.read(clockToolControllerProvider.notifier).onTap(playerType);
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
                        firstChild: ValueListenableBuilder(
                          valueListenable: clockState.getDuration(playerType),
                          builder: (context, value, _) {
                            return Clock(
                              padLeft: true,
                              clockStyle: clockStyle,
                              timeLeft: value,
                              active: clockState.isActivePlayer(playerType),
                            );
                          },
                        ),
                        secondChild: const Icon(Icons.flag),
                        crossFadeState:
                            clockState.isFlagged(playerType)
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
                onTap:
                    clockState.started
                        ? null
                        : () => showAdaptiveBottomSheet<void>(
                          context: context,
                          builder:
                              (BuildContext context) => CustomClockSettings(
                                player: playerType,
                                clock:
                                    playerType == Side.white
                                        ? TimeIncrement.fromDurations(
                                          clockState.options.whiteTime,
                                          clockState.options.whiteIncrement,
                                        )
                                        : TimeIncrement.fromDurations(
                                          clockState.options.blackTime,
                                          clockState.options.blackIncrement,
                                        ),
                                onSubmit: (Side player, TimeIncrement clock) {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(clockToolControllerProvider.notifier)
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
