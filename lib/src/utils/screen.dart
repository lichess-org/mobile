import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/widgets/pockets.dart';

/// Returns the estimated height of what is left after removing the height of the board from the screen.
double estimateHeightMinusBoard(MediaQueryData mediaQuery) {
  final size = mediaQuery.size;
  final viewPadding = mediaQuery.viewPadding;
  final boardSize = size.width;
  return size.height - viewPadding.vertical - boardSize - kToolbarHeight - kBottomBarHeight;
}

/// Returns the estimated height of what is left after removing the height of the board from the screen.
///
/// This function uses the top-level MediaQuery to ensure that computed height is consistent regardless of the context used.
double estimateHeightMinusBoardFromContext(BuildContext context) {
  // Use the top-level MediaQuery to ensure we get always the same `viewPadding` regardless of the context.
  final topLevelMediaQuery = MediaQueryData.fromView(View.of(context));
  return estimateHeightMinusBoard(topLevelMediaQuery);
}

/// Returns true if the device has a short amount of vertical space on board screens.
bool isShortVerticalScreen(BuildContext context) {
  return estimateHeightMinusBoardFromContext(context) < kSmallHeightMinusBoard;
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

/// How big a square in the [PocketsMenu] should be, based on the size of the board and whether the device is a tablet.
double pocketSquareSize({required double boardSize, required bool isTablet}) {
  final squareSize = boardSize / 8;
  // On tablets, displaying the pockets at the same size as regular pieces
  // can lead to overflows and looks weird, so reduce the size a bit.
  return isTablet ? 0.7 * squareSize : squareSize;
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
