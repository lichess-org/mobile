import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        return Card(
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

/// A platform agnostic choice picker composed of rows inside a card widget.
///
/// On android will be displayed inside a [Card].
/// On iOS a [CupertinoListSection.insetGrouped] will be used.
class CardChoicePicker<T extends Enum> extends StatelessWidget {
  const CardChoicePicker({
    super.key,
    required this.choices,
    required this.selectedItem,
    required this.titleBuilder,
    this.subtitleBuilder,
    required this.onSelectedItemChanged,
  });

  final List<T> choices;
  final Enum selectedItem;
  final Widget Function(T choice) titleBuilder;
  final Widget Function(T choice)? subtitleBuilder;
  final void Function(T choice) onSelectedItemChanged;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Card(
          child: Column(
            children: ListTile.divideTiles(
              context: context,
              tiles: choices.map((value) {
                return ListTile(
                  selected: selectedItem == value,
                  trailing: selectedItem == value
                      ? defaultTargetPlatform == TargetPlatform.iOS
                          ? const Icon(CupertinoIcons.checkmark_alt)
                          : const Icon(Icons.check)
                      : null,
                  title: titleBuilder(value),
                  subtitle: subtitleBuilder?.call(value),
                  onTap: () => onSelectedItemChanged(value),
                );
              }),
            ).toList(growable: false),
          ),
        );
      case TargetPlatform.iOS:
        return CupertinoListSection.insetGrouped(
          hasLeading: false,
          margin: EdgeInsets.zero,
          children: choices.map((value) {
            return CupertinoListTile.notched(
              trailing: selectedItem == value
                  ? defaultTargetPlatform == TargetPlatform.iOS
                      ? const Icon(CupertinoIcons.checkmark_alt)
                      : const Icon(Icons.check)
                  : null,
              title: titleBuilder(value),
              subtitle: subtitleBuilder?.call(value),
              onTap: () => onSelectedItemChanged(value),
            );
          }).toList(growable: false),
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
