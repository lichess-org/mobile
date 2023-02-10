import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const EdgeInsetsDirectional _kDefaultInsetGroupedRowsMargin =
    EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 10.0);

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
    this.margin,
    this.notchedTile = false,
  });

  final List<T> choices;
  final Enum selectedItem;
  final Widget Function(T choice) titleBuilder;
  final Widget Function(T choice)? subtitleBuilder;
  final void Function(T choice) onSelectedItemChanged;
  final EdgeInsetsGeometry? margin;

  /// iOS only, for choosing the style of the tile.
  final bool notchedTile;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Card(
          margin: margin ?? _kDefaultInsetGroupedRowsMargin,
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
        final tileConstructor =
            notchedTile ? CupertinoListTile.notched : CupertinoListTile.new;
        return CupertinoListSection.insetGrouped(
          additionalDividerMargin: notchedTile ? null : 6.0,
          hasLeading: false,
          margin: margin,
          children: choices.map((value) {
            return tileConstructor(
              trailing: selectedItem == value
                  ? defaultTargetPlatform == TargetPlatform.iOS
                      ? const Icon(CupertinoIcons.check_mark_circled_solid)
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
