import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/constants.dart';

/// A container in the style of a bottom app bar, containg a [Row] of children widgets.
///
/// It adapts to the current platform, using a [BottomAppBar] on Android and a [ColoredBox] on iOS.
///
/// The height of the bar is always [kBottomBarHeight].
class PlatformBottomBar extends StatelessWidget {
  const PlatformBottomBar({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.expandChildren = true,
    this.transparentBackground = true,
  });

  const PlatformBottomBar.empty({this.transparentBackground = true})
    : children = const [],
      expandChildren = true,
      mainAxisAlignment = MainAxisAlignment.spaceAround;

  /// Children to display in the bottom bar's [Row]. Typically instances of [BottomBarButton].
  final List<Widget> children;

  /// Alignment of the bottom bar's internal row. Defaults to [MainAxisAlignment.spaceAround].
  final MainAxisAlignment mainAxisAlignment;

  /// Whether to expand the children to fill the available space. Defaults to true.
  final bool expandChildren;

  /// Whether to make the bar transparent. Defaults to true.
  final bool transparentBackground;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.4,
      child: BottomAppBar(
        color: transparentBackground ? Colors.transparent : null,
        height: kBottomBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children:
              expandChildren ? children.map((child) => Expanded(child: child)).toList() : children,
        ),
      ),
    );
  }
}
