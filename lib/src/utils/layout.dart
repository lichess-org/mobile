import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/constants.dart';

final _appBarHeight = defaultTargetPlatform == TargetPlatform.iOS ? 44.0 : 56.0;

/// Returns the estimated height of screen left the board
double estimateRemainingHeightLeftBoard(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final padding = MediaQuery.paddingOf(context);
  final safeViewportHeight = size.height - padding.top - padding.bottom;
  final boardSize = size.width;

  return safeViewportHeight - boardSize - _appBarHeight - kBottomBarHeight;
}

// ignore: avoid_classes_with_only_static_members
abstract class FormFactor {
  static double desktop = 900;
  static double tablet = 600;
  static double handset = 300;
}

enum ScreenType { watch, handset, tablet, desktop }

ScreenType getScreenType(BuildContext context) {
  // Use .shortestSide to detect device type regardless of orientation
  final double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > FormFactor.desktop) return ScreenType.desktop;
  if (deviceWidth > FormFactor.tablet) return ScreenType.tablet;
  if (deviceWidth > FormFactor.handset) return ScreenType.handset;
  return ScreenType.watch;
}
