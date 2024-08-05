import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';

class DefaultBroadcastImage extends StatelessWidget {
  final double? width;
  final double aspectRatio;

  const DefaultBroadcastImage({
    super.key,
    this.width,
    this.aspectRatio = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                LichessColors.primary.withOpacity(0.7),
                LichessColors.brag.withOpacity(0.7),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Icon(
              LichessIcons.radio_tower_lichess,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: constraints.maxWidth / 4,
            ),
          ),
        ),
      ),
    );
  }
}
