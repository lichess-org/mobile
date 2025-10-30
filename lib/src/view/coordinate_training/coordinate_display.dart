import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/coordinate_training/coordinate_training_controller.dart';

const Offset _kNextCoordFractionalTranslation = Offset(0.8, 0.3);
const double _kNextCoordScale = 0.4;

const double _kCurrCoordOpacity = 0.9;
const double _kNextCoordOpacity = 0.7;

class CoordinateDisplay extends ConsumerStatefulWidget {
  const CoordinateDisplay({
    required this.currentCoord,
    required this.nextCoord,
  });

  final Square currentCoord;

  final Square nextCoord;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      CoordinateDisplayState();
}

class CoordinateDisplayState extends ConsumerState<CoordinateDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  )..value = 1.0;

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: _kNextCoordScale,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  late final Animation<Offset> _currCoordSlideInAnimation = Tween<Offset>(
    begin: _kNextCoordFractionalTranslation,
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  late final Animation<Offset> _nextCoordSlideInAnimation = Tween<Offset>(
    begin: const Offset(0.5, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  late final Animation<double> _currCoordOpacityAnimation = Tween<double>(
    begin: _kNextCoordOpacity,
    end: _kCurrCoordOpacity,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  late final Animation<double> _nextCoordFadeInAnimation = Tween<double>(
    begin: 0.0,
    end: _kNextCoordOpacity,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

  @override
  Widget build(BuildContext context) {
    final trainingState = ref.watch(coordinateTrainingControllerProvider);

    final textStyle = DefaultTextStyle.of(context).style.copyWith(
      fontSize: 110.0,
      fontFamily: 'monospace',
      color: Colors.white.withValues(alpha: 0.9),
      fontWeight: FontWeight.bold,
      fontFeatures: [const FontFeature.tabularFigures()],
      shadows: const [
        Shadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 40.0),
      ],
    );

    return IgnorePointer(
      child: Stack(
        children: [
          FadeTransition(
            opacity: _currCoordOpacityAnimation,
            child: SlideTransition(
              position: _currCoordSlideInAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  trainingState.currentCoord?.name ?? '',
                  style: textStyle,
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _nextCoordFadeInAnimation,
            child: SlideTransition(
              position: _nextCoordSlideInAnimation,
              child: FractionalTranslation(
                translation: _kNextCoordFractionalTranslation,
                child: Transform.scale(
                  scale: _kNextCoordScale,
                  child: Text(
                    trainingState.nextCoord?.name ?? '',
                    style: textStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CoordinateDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.nextCoord != widget.nextCoord) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
