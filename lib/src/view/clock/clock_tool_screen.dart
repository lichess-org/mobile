import 'package:flutter/cupertino.dart' show CupertinoIcons;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClockTile(
            orientation: Orientation.portrait,
            playerType: ClockSide.top,
            clockState: state,
          ),
        ),
        const Opacity(
          opacity: 0.8,
          child: SizedBox(
            width: double.infinity,
            height: 88,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: ClockSettings(orientation: Orientation.portrait),
            ),
          ),
        ),
        Expanded(
          child: ClockTile(
            orientation: Orientation.portrait,
            playerType: ClockSide.bottom,
            clockState: state,
          ),
        ),
      ],
    );
  }
}

class ClockTile extends ConsumerStatefulWidget {
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
  ConsumerState<ClockTile> createState() => _ClockTileState();
}

class _ClockTileState extends ConsumerState<ClockTile> with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  bool _inEmergency = false;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    widget.clockState.getDuration(widget.playerType).addListener(_onTimeChanged);
  }

  @override
  void didUpdateWidget(ClockTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clockState.getDuration(oldWidget.playerType) !=
        widget.clockState.getDuration(widget.playerType)) {
      oldWidget.clockState.getDuration(oldWidget.playerType).removeListener(_onTimeChanged);
      widget.clockState.getDuration(widget.playerType).addListener(_onTimeChanged);
    }
    // Re-evaluate emergency when active side changes (e.g. after a tap).
    _onTimeChanged();
  }

  @override
  void dispose() {
    widget.clockState.getDuration(widget.playerType).removeListener(_onTimeChanged);
    _blinkController.dispose();
    super.dispose();
  }

  void _onTimeChanged() {
    if (!mounted) return;
    final initialTime = widget.playerType == ClockSide.top
        ? widget.clockState.options.topTime
        : widget.clockState.options.bottomTime;
    final threshold = Duration(milliseconds: (initialTime.inMilliseconds * 0.1).round());
    final timeLeft = widget.clockState.getDuration(widget.playerType).value;
    final isActive = widget.clockState.isActivePlayer(widget.playerType);
    final isEmergency = timeLeft > Duration.zero && timeLeft <= threshold && isActive;
    if (isEmergency == _inEmergency) return;
    _inEmergency = isEmergency;
    if (isEmergency) {
      _blinkController.repeat(reverse: true);
    } else {
      _blinkController.stop();
      _blinkController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clockState = widget.clockState;
    final playerType = widget.playerType;
    final colorScheme = ColorScheme.of(context);
    final activeColor = darken(colorScheme.primaryFixedDim, 0.25);
    final normalBackground = clockState.isFlagged(playerType)
        ? context.lichessColors.error.withValues(alpha: 0.7)
        : clockState.isPlayersTurn(playerType)
        ? activeColor
        : colorScheme.surfaceContainerHighest;

    final textColor = clockState.isFlagged(playerType)
        ? Colors.white70
        : clockState.isPlayersTurn(playerType)
        ? Colors.white70
        : colorScheme.onSurface.withValues(alpha: 0.7);

    final clockStyle = ClockStyle(
      textColor: textColor,
      activeTextColor: Colors.white,
      emergencyTextColor: Colors.white70,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Colors.transparent,
      emergencyBackgroundColor: Colors.transparent,
    );

    final clockOrientation = ref.watch(clockToolControllerProvider).clockOrientation;
    final emergencyColor = context.lichessColors.error;

    return AnimatedOpacity(
      opacity: clockState.paused ? 0.8 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: RotatedBox(
        quarterTurns: clockOrientation.isPortrait
            ? (playerType == ClockSide.top
                  ? clockOrientation.oppositeQuarterTurns
                  : clockOrientation.quarterTurns)
            : clockOrientation.quarterTurns,
        child: AnimatedBuilder(
          animation: _blinkController,
          builder: (context, child) {
            final backgroundColor = _inEmergency
                ? Color.lerp(normalBackground, emergencyColor, _blinkController.value)!
                : normalBackground;
            return Stack(
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
                                secondChild: const Icon(
                                  CupertinoIcons.flag_fill,
                                  color: Colors.white70,
                                ),
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
                  child: IgnorePointer(
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
                ),
                if (widget.orientation == Orientation.portrait && clockOrientation.isPortrait)
                  Positioned(
                    top: 24,
                    left: 24,
                    child: IgnorePointer(
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: _ClockDisplay(
                          clockState: clockState,
                          playerType: playerType,
                          clockStyle: clockStyle,
                        ),
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
            );
          },
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
          clockStyle: clockStyle,
          timeLeft: value,
          active: clockState.isActivePlayer(playerType),
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}
