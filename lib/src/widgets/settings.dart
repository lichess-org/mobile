import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/styles.dart';

/// A platform agnostic tappable list tile that represents a settings value.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    this.icon,
    required this.settingsLabel,
    required this.settingsValue,
    required this.onTap,
    super.key,
  });

  final Icon? icon;
  final String settingsLabel;
  final String settingsValue;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final tile = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoListTile(
            leading: icon,
            title: Text(settingsLabel),
            additionalInfo: Text(settingsValue),
            onTap: onTap,
            trailing: const CupertinoListTileChevron(),
          )
        : ListTile(
            leading: icon,
            title: Text(settingsLabel),
            subtitle: Text(
              settingsValue,
              style:
                  TextStyle(color: textShade(context, Styles.subtitleOpacity)),
            ),
            onTap: onTap,
          );
    return Semantics(
      container: true,
      button: true,
      label: '$settingsLabel: $settingsValue',
      excludeSemantics: true,
      child: tile,
    );
  }
}

/// A platform agnostic choice picker.
class ChoicePicker<T extends Enum> extends StatelessWidget {
  const ChoicePicker({
    super.key,
    required this.choices,
    required this.selectedItem,
    required this.titleBuilder,
    this.subtitleBuilder,
    this.leadingBuilder,
    required this.onSelectedItemChanged,
    this.margin,
    this.notchedTile = false,
  });

  final List<T> choices;
  final Enum selectedItem;
  final Widget Function(T choice) titleBuilder;
  final Widget Function(T choice)? subtitleBuilder;
  final Widget Function(T choice)? leadingBuilder;
  final void Function(T choice) onSelectedItemChanged;
  final EdgeInsetsGeometry? margin;

  /// iOS only, for choosing the style of the tile.
  final bool notchedTile;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: choices.map((value) {
              return ListTile(
                selected: selectedItem == value,
                trailing:
                    selectedItem == value ? const Icon(Icons.check) : null,
                title: titleBuilder(value),
                subtitle: subtitleBuilder?.call(value),
                leading: leadingBuilder?.call(value),
                onTap: () => onSelectedItemChanged(value),
              );
            }),
          ).toList(growable: false),
        );
      case TargetPlatform.iOS:
        final tileConstructor =
            notchedTile ? CupertinoListTile.notched : CupertinoListTile.new;
        return CupertinoListSection.insetGrouped(
          additionalDividerMargin: notchedTile ? null : 6.0,
          hasLeading: leadingBuilder != null,
          margin: margin,
          children: choices.map((value) {
            return tileConstructor(
              trailing: selectedItem == value
                  ? const Icon(CupertinoIcons.check_mark_circled_solid)
                  : null,
              title: titleBuilder(value),
              subtitle: subtitleBuilder?.call(value),
              leading: leadingBuilder?.call(value),
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
