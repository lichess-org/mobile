import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';

class DefaultBroadcastImage extends StatelessWidget {
  final double? width;

  const DefaultBroadcastImage({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 2,
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
            builder: (context, constraints) => UnconstrainedBox(
              child: SvgPicture.asset(
                'assets/images/radio-tower.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                  BlendMode.srcATop,
                ),
                width: constraints.maxWidth / 4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
