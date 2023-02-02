import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform.dart';

/// A platform agnostic list section that fits inside a card.
///
/// It should be used for a small number of children only.
class CardListSection extends StatelessWidget {
  const CardListSection({
    super.key,
    required this.children,
    this.margin,
    this.hasLeading = false,
    this.showDivider = false,
    this.dense = false,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  /// Only useful on iOS
  final bool hasLeading;

  /// Only on android
  final bool showDivider;

  /// Only on android
  final bool dense;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformCard(
          margin: margin,
          child: ListTileTheme(
            dense: dense,
            child: Column(
              children: showDivider
                  ? ListTile.divideTiles(
                      context: context,
                      tiles: children,
                    ).toList(growable: false)
                  : children,
            ),
          ),
        );
      case TargetPlatform.iOS:
        return CupertinoListSection.insetGrouped(
          // to match android where default margin is here to show the drop shadow
          margin: margin ?? EdgeInsets.zero,
          hasLeading: hasLeading,
          children: children,
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
