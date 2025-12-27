import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';

const double _kEvalGaugeSize = 24.0;
const double _kEvalGaugeFontSize = 11.0;

double getEvalGaugeWidth(BuildContext context) {
  return isTabletOrLarger(context) ? _kEvalGaugeSize : _kEvalGaugeSize - 6.0;
}

double getEvalGaugeFontSize(BuildContext context) {
  return isTabletOrLarger(context) ? _kEvalGaugeFontSize : _kEvalGaugeFontSize - 2.0;
}

typedef EngineGaugeParams = ({
  bool isLocalEngineAvailable,

  /// Orientation of the board.
  Side orientation,

  /// Position to evaluate.
  Position position,

  /// Cached evaluation to display when the current evaluation is not available.
  ClientEval? savedEval,

  /// Server evaluation to display when the current evaluation and the cached evaluation is not available.
  ExternalEval? serverEval,
});

class EngineGauge extends ConsumerWidget {
  const EngineGauge({required this.params, super.key});

  final EngineGaugeParams params;

  static Color backgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? lighten(ColorScheme.of(context).surface, .07)
      : lighten(ColorScheme.of(context).onSurface, .17);

  static Color valueColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? darken(ColorScheme.of(context).onSurface, .1)
      : darken(ColorScheme.of(context).surface, .01);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localEval = params.isLocalEngineAvailable
        ? ref.watch(engineEvaluationProvider).eval
        : null;
    final eval = pickBestEval(
      localEval: localEval,
      savedEval: params.savedEval,
      serverEval: params.serverEval,
    );

    return Opacity(
      // if the local engine is not available and there is no server eval, show the gauge as disabled
      // this is typically a case where user is on a node not on main line and the game has the server
      // analysis
      opacity: !params.isLocalEngineAvailable && params.serverEval == null ? 0.5 : 1.0,
      child: _EvalGauge(position: params.position, orientation: params.orientation, eval: eval),
    );
  }
}

class _EvalGauge extends StatefulWidget {
  const _EvalGauge({required this.position, required this.orientation, this.eval});

  final Position position;
  final Eval? eval;
  final Side orientation;

  double? get whiteWinningChances => eval?.winningChances(Side.white);
  double? get animationValue => position.outcome != null
      ? position.outcome!.winner == null
            ? 0.5
            : position.outcome!.winner == Side.white
            ? 1.0
            : 0.0
      : whiteWinningChances != null
      ? (((whiteWinningChances! + 1) * 0.5).abs() * 100).roundToDouble() / 100
      : null;

  @override
  State<_EvalGauge> createState() => _EvalGaugeState();
}

class _EvalGaugeState extends State<_EvalGauge> {
  double fromValue = 0.5;

  Eval? oldEval;

  double get toValue => widget.animationValue ?? fromValue;

  @override
  void didUpdateWidget(_EvalGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    fromValue = oldWidget.animationValue ?? fromValue;
    if (oldWidget.eval != null) {
      oldEval = oldWidget.eval;
    }
  }

  @override
  Widget build(BuildContext context) {
    final evalDisplay = widget.position.outcome != null
        ? widget.position.outcome!.winner == null
              ? ''
              : '#'
        : widget.eval?.evalString ?? oldEval?.evalString;

    final evalStyle = TextStyle(
      color: toValue >= 0.5 ? Colors.black54 : Colors.white70,
      fontSize: getEvalGaugeFontSize(context),
      letterSpacing: -0.8,
      fontWeight: FontWeight.bold,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    final width = getEvalGaugeWidth(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: fromValue, end: toValue),
      duration: const Duration(milliseconds: 800),
      curve: Curves.ease,
      builder: (BuildContext context, double value, Widget? child) {
        return Semantics(
          label: context.l10n.evaluationGauge,
          value: evalDisplay ?? context.l10n.loadingEngine,
          child: RepaintBoundary(
            child: Container(
              constraints: BoxConstraints(minWidth: width, minHeight: double.infinity),
              width: width,
              child: CustomPaint(
                painter: _EvalGaugeVerticalPainter(
                  orientation: widget.orientation,
                  backgroundColor: EngineGauge.backgroundColor(context),
                  valueColor: EngineGauge.valueColor(context),
                  value: value,
                ),
                child: toValue != 0.5
                    ? Align(
                        alignment: toValue >= 0.5
                            ? widget.orientation == Side.white
                                  ? Alignment.bottomCenter
                                  : Alignment.topCenter
                            : widget.orientation == Side.white
                            ? Alignment.topCenter
                            : Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Text(
                              //   evalDisplay?.startsWith(RegExp('[-+]')) == true
                              //       ? evalDisplay!.substring(0, 1)
                              //       : '',
                              //   style: evalStyle,
                              // ),
                              Text(
                                evalDisplay?.replaceFirst(RegExp('[-+]'), '') ?? '',
                                style: evalStyle,
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EvalGaugeVerticalPainter extends CustomPainter {
  const _EvalGaugeVerticalPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.orientation,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final Side orientation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    paint.color = valueColor;

    void drawBar(double y, double height) {
      if (height == 0.0) {
        return;
      }

      canvas.drawRect(Offset(0.0, y) & Size(size.width, height), paint);
    }

    final double height = clampDouble(value, 0.0, 1.0) * size.height;

    drawBar(
      orientation == Side.white ? size.height : 0.0,
      height * (orientation == Side.white ? -1.0 : 1.0),
    );
  }

  @override
  bool shouldRepaint(_EvalGaugeVerticalPainter oldPainter) {
    return oldPainter.orientation != orientation ||
        oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value;
  }
}
