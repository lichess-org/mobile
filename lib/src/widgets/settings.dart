import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/list.dart';

/// A platform agnostic tappable list tile that represents a settings value.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    this.icon,
    required this.settingsLabel,
    required this.settingsValue,
    required this.onTap,
    this.additionalInfo,
    this.showCupertinoTrailingValue = true,
    super.key,
  });

  final Icon? icon;

  /// The label of the settings value, typically a [Text] widget.
  final Widget settingsLabel;

  final String settingsValue;
  final void Function() onTap;

  final String? additionalInfo;

  /// Whether to show the value in the trailing position on iOS.
  ///
  /// True by default, can be disabled for long settings names.
  final bool showCupertinoTrailingValue;

  @override
  Widget build(BuildContext context) {
    final tile = PlatformListTile(
      leading: icon,
      title: _SettingsTitle(
        title: settingsLabel,
        additionalInfo: additionalInfo,
      ),
      additionalInfo: showCupertinoTrailingValue ? Text(settingsValue) : null,
      subtitle: defaultTargetPlatform == TargetPlatform.android
          ? Text(
              settingsValue,
              style:
                  TextStyle(color: textShade(context, Styles.subtitleOpacity)),
            )
          : null,
      onTap: onTap,
      trailing: defaultTargetPlatform == TargetPlatform.iOS
          ? const CupertinoListTileChevron()
          : null,
    );
    return Semantics(
      container: true,
      button: true,
      label: '$settingsLabel: $settingsValue',
      excludeSemantics: true,
      child: additionalInfo != null
          ? _SettingsInfoTooltip(
              message: additionalInfo!,
              child: tile,
            )
          : tile,
    );
  }
}

class SwitchSettingTile extends StatelessWidget {
  const SwitchSettingTile({
    required this.title,
    this.subtitle,
    required this.value,
    this.additionalInfo,
    this.onChanged,
    this.leading,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final String? additionalInfo;
  final bool value;
  final void Function(bool value)? onChanged;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final tile = PlatformListTile(
      leading: leading,
      title: _SettingsTitle(
        title: title,
        additionalInfo: additionalInfo,
      ),
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
      ),
    );

    return additionalInfo != null
        ? _SettingsInfoTooltip(
            message: additionalInfo!,
            child: tile,
          )
        : tile;
  }
}

class _SettingsInfoTooltip extends StatelessWidget {
  const _SettingsInfoTooltip({
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      showDuration: const Duration(seconds: 4),
      child: child,
    );
  }
}

class _SettingsTitle extends StatelessWidget {
  const _SettingsTitle({
    required this.title,
    this.additionalInfo,
  });

  final Widget title;
  final String? additionalInfo;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      maxLines: 2,
      child: additionalInfo != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                title,
                const SizedBox(width: 5.0),
                Icon(
                  defaultTargetPlatform == TargetPlatform.iOS
                      ? CupertinoIcons.info
                      : Icons.info_outline,
                ),
              ],
            )
          : title,
    );
  }
}

/// A platform agnostic choice picker
class ChoicePicker<T extends Enum> extends StatelessWidget {
  const ChoicePicker({
    super.key,
    required this.choices,
    required this.selectedItem,
    required this.titleBuilder,
    this.subtitleBuilder,
    this.leadingBuilder,
    required this.onSelectedItemChanged,
    this.tileContentPadding,
    this.margin,
    this.notchedTile = false,
    this.showDividerBetweenTiles = false,
  });

  final List<T> choices;
  final T selectedItem;
  final Widget Function(T choice) titleBuilder;
  final Widget Function(T choice)? subtitleBuilder;
  final Widget Function(T choice)? leadingBuilder;
  final void Function(T choice) onSelectedItemChanged;

  /// Only on android.
  final bool showDividerBetweenTiles;

  /// Android tiles content padding.
  final EdgeInsetsGeometry? tileContentPadding;

  /// iOS margin.
  final EdgeInsetsGeometry? margin;

  /// iOS only, for choosing the style of the tile.
  final bool notchedTile;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final tiles = choices.map((value) {
          return ListTile(
            selected: selectedItem == value,
            trailing: selectedItem == value ? const Icon(Icons.check) : null,
            contentPadding: tileContentPadding,
            title: titleBuilder(value),
            subtitle: subtitleBuilder?.call(value),
            leading: leadingBuilder?.call(value),
            onTap: () => onSelectedItemChanged(value),
          );
        });
        return Column(
          children: [
            if (showDividerBetweenTiles)
              ...ListTile.divideTiles(
                context: context,
                tiles: tiles,
              )
            else
              ...tiles,
          ],
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
