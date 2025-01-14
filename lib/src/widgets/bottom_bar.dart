import 'package:flutter/cupertino.dart';
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
    this.transparentCupertinoBar = true,
  });

  const PlatformBottomBar.empty({this.transparentCupertinoBar = true})
    : children = const [],
      expandChildren = true,
      mainAxisAlignment = MainAxisAlignment.spaceAround;

  /// Children to display in the bottom bar's [Row]. Typically instances of [BottomBarButton].
  final List<Widget> children;

  /// Alignment of the bottom bar's internal row. Defaults to [MainAxisAlignment.spaceAround].
  final MainAxisAlignment mainAxisAlignment;

  /// Whether to expand the children to fill the available space. Defaults to true.
  final bool expandChildren;

  /// Whether to make the Cupertino bar transparent. Defaults to true.
  final bool transparentCupertinoBar;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return ColoredBox(
        color: CupertinoTheme.of(
          context,
        ).barBackgroundColor.withValues(alpha: transparentCupertinoBar ? 0.0 : 1.0),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: kBottomBarHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: mainAxisAlignment,
              children:
                  expandChildren
                      ? children.map((child) => Expanded(child: child)).toList()
                      : children,
            ),
          ),
        ),
      );
    }

    return BottomAppBar(
      height: kBottomBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children:
            expandChildren ? children.map((child) => Expanded(child: child)).toList() : children,
      ),
    );
  }
}
