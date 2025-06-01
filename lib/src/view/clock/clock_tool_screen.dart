import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/clock/clock_tool_controller.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/clock/clock_settings.dart';
import 'package:lichess_mobile/src/view/clock/custom_clock_settings.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/clock.dart';

class ClockToolScreen extends StatelessWidget {
  const ClockToolScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ClockToolScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const ImmersiveModeWidget(
      child: PopScope(canPop: false, child: Scaffold(body: _Body())),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool isTablet = false;

  @override
  void initState() {
    super.initState();
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final data = MediaQueryData.fromView(view);
    isTablet = data.size.shortestSide >= FormFactor.tablet;
    if (isTablet) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    if (isTablet) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clockToolControllerProvider);

    return OrientationBuilder(
      builder: (context, orientation) {
        return (orientation == Orientation.portrait ? Column.new : Row.new)(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClockTile(
                orientation: orientation,
                playerType: ClockSide.top,
                clockState: state,
              ),
            ),
            Opacity(
              opacity: 0.8,
              child: SizedBox(
                width: orientation == Orientation.portrait ? double.infinity : 98,
                height: orientation == Orientation.portrait ? 98 : double.infinity,
                child: Padding(
                  padding: orientation == Orientation.portrait
                      ? const EdgeInsets.symmetric(vertical: 8.0)
                      : const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClockSettings(orientation: orientation),
                ),
              ),
            ),
            Expanded(
              child: ClockTile(
                orientation: orientation,
                playerType: ClockSide.bottom,
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

  final ClockSide playerType;
  final ClockState clockState;
  final Orientation orientation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ColorScheme.of(context);
    final activeColor = darken(colorScheme.primaryFixedDim, 0.2);
    final backgroundColor = clockState.isFlagged(playerType)
        ? context.lichessColors.error
        : clockState.isPlayersTurn(playerType)
        ? activeColor
        : colorScheme.surfaceContainerHighest;

    final textColor = clockState.isFlagged(playerType)
        ? Colors.white
        : clockState.isPlayersTurn(playerType)
        ? Colors.white
        : colorScheme.onSurface;

    final clockStyle = ClockStyle(
      textColor: textColor,
      activeTextColor: Colors.white,
      emergencyTextColor: Colors.white,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Colors.transparent,
      emergencyBackgroundColor: Colors.transparent,
    );

    final clockOrientation = ref.watch(clockToolControllerProvider).clockOrientation;

    return AnimatedOpacity(
      opacity: clockState.paused ? 0.8 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: RotatedBox(
        quarterTurns: clockOrientation.isPortrait
            ? (playerType == ClockSide.top
                  ? clockOrientation.oppositeQuarterTurns
                  : clockOrientation.quarterTurns)
            : clockOrientation.quarterTurns,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Material(
              color: backgroundColor,
              child: InkWell(
                splashFactory: NoSplash.splashFactory,
                onTapDown: !clockState.started
                    ? (_) {
                        ref.read(clockToolControllerProvider.notifier).start(playerType);
                      }
                    : clockState.isPlayersMoveAllowed(playerType)
                    ? (_) {
                        ref.read(clockToolControllerProvider.notifier).onTap(playerType);
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            firstChild: _ClockDisplay(
                              clockState: clockState,
                              playerType: playerType,
                              clockStyle: clockStyle,
                            ),
                            secondChild: const Icon(Icons.flag),
                            crossFadeState: clockState.isFlagged(playerType)
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                          ),
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
                  color: !clockState.paused && clockState.isPlayersTurn(playerType)
                      ? clockStyle.activeTextColor
                      : clockStyle.textColor,
                ),
              ),
            ),
            if (orientation == Orientation.portrait && clockOrientation.isPortrait)
              Positioned(
                top: 24,
                left: 24,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: _ClockDisplay(
                    clockState: clockState,
                    playerType: playerType,
                    clockStyle: clockStyle,
                  ),
                ),
              ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 48.0,
              child: IgnorePointer(
                ignoring: clockState.started,
                child: AnimatedOpacity(
                  opacity: clockState.started ? 0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SemanticIconButton(
                        semanticsLabel: context.l10n.settingsSettings,
                        iconSize: 32,
                        icon: const Icon(Icons.tune),
                        color: clockStyle.textColor,
                        onPressed: clockState.started
                            ? null
                            : () => showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) => CustomClockSettings(
                                  player: playerType,
                                  clock: playerType == ClockSide.top
                                      ? TimeIncrement.fromDurations(
                                          clockState.options.topTime,
                                          clockState.options.topIncrement,
                                        )
                                      : TimeIncrement.fromDurations(
                                          clockState.options.bottomTime,
                                          clockState.options.bottomIncrement,
                                        ),
                                  onSubmit: (ClockSide player, TimeIncrement clock) {
                                    Navigator.of(context).pop();
                                    ref
                                        .read(clockToolControllerProvider.notifier)
                                        .updateOptionsCustom(clock, player);
                                  },
                                ),
                              ),
                      ),
                      if (clockState.options.hasIncrement(playerType)) ...[
                        const SizedBox(width: 8),
                        Text(
                          '+${clockState.options.getIncrement(playerType)}',
                          style: TextStyle(fontSize: 28, color: clockStyle.textColor),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClockDisplay extends StatelessWidget {
  const _ClockDisplay({
    required this.clockState,
    required this.playerType,
    required this.clockStyle,
  });

  final ClockState clockState;
  final ClockSide playerType;
  final ClockStyle clockStyle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: clockState.getDuration(playerType),
      builder: (context, value, _) {
        return Clock(
          padLeft: true,
          clockStyle: clockStyle,
          timeLeft: value,
          active: clockState.isActivePlayer(playerType),
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}
