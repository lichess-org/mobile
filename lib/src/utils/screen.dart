import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';

/// Returns the estimated height of screen after removing the height of the board
double estimateRemainingHeightLeftBoard(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final padding = MediaQuery.paddingOf(context);
  final safeViewportHeight = size.height - padding.top - padding.bottom;
  final boardSize = size.width;
  final appBarHeight = Theme.of(context).platform == TargetPlatform.iOS ? 44.0 : 56.0;
  return safeViewportHeight - boardSize - appBarHeight - kBottomBarHeight;
}

// ignore: avoid_classes_with_only_static_members
abstract class FormFactor {
  static const double desktop = 900;
  static const double tablet = 600;
  static const double handset = 300;
}

/// Detect device type regardless of orientation
ScreenType getScreenType(BuildContext context) {
  final double deviceWidth = MediaQuery.sizeOf(context).shortestSide;
  if (deviceWidth > FormFactor.desktop) return ScreenType.desktop;
  if (deviceWidth > FormFactor.tablet) return ScreenType.tablet;
  if (deviceWidth > FormFactor.handset) return ScreenType.handset;
  return ScreenType.watch;
}

/// Returns true if the device form factor is at least as large as a tablet
bool isTabletOrLarger(BuildContext context) {
  return getScreenType(context) >= ScreenType.tablet;
}

enum ScreenType { watch, handset, tablet, desktop }

extension ScreenTypeComparisonOperators on ScreenType {
  bool operator <(ScreenType other) {
    return index < other.index;
  }

  bool operator <=(ScreenType other) {
    return index <= other.index;
  }

  bool operator >(ScreenType other) {
    return index > other.index;
  }

  bool operator >=(ScreenType other) {
    return index >= other.index;
  }
}
