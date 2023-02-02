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
    this.header,
    this.onHeaderTap,
    this.margin,
    this.hasLeading = false,
    this.showDivider = false,
    this.dense = false,
  });

  /// Usually a list of [PlatformListTile] widgets
  final List<Widget> children;

  final EdgeInsetsGeometry? margin;

  /// Only useful on iOS
  final bool hasLeading;

  /// Only on android
  final bool showDivider;

  /// Only on android, use it to set [ListTileTheme.dense] property.
  final bool dense;

  /// Show a header above the children rows. Will be wrapped in a [PlatformListTile].
  final Widget? header;
  final GestureTapCallback? onHeaderTap;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final childrenAndHeader = [
          if (header != null)
            ListTile(
              dense: false,
              title: header,
              onTap: onHeaderTap,
              trailing: onHeaderTap != null
                  ? const Icon(CupertinoIcons.forward)
                  : null,
            ),
          ...children,
        ];
        return PlatformCard(
          margin: margin,
          child: ListTileTheme(
            dense: dense,
            child: Column(
              children: showDivider
                  ? ListTile.divideTiles(
                      context: context,
                      tiles: childrenAndHeader,
                    ).toList(growable: false)
                  : childrenAndHeader,
            ),
          ),
        );
      case TargetPlatform.iOS:
        return CupertinoListSection.insetGrouped(
          // to match android where default margin is here to show the drop shadow
          margin: margin ?? EdgeInsets.zero,
          hasLeading: hasLeading,
          children: [
            if (header != null)
              CupertinoListTile.notched(
                // see https://github.com/flutter/flutter/blob/7048ed95a5ad3e43d697e0c397464193991fc230/packages/flutter/lib/src/cupertino/list_tile.dart#L24 for base value
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10.0,
                ),
                title: header!,
                trailing: onHeaderTap != null
                    ? const Icon(CupertinoIcons.forward)
                    : null,
                onTap: onHeaderTap,
              ),
            ...children,
          ],
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
