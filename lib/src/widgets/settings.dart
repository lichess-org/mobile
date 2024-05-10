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
    this.explanation,
    this.showCupertinoTrailingValue = true,
    super.key,
  });

  final Icon? icon;

  /// The label of the settings value.
  final Text settingsLabel;

  final String settingsValue;
  final void Function() onTap;

  /// The optional explanation of the settings.
  final String? explanation;

  /// Whether to show the value in the trailing position on iOS.
  ///
  /// True by default, can be disabled for long settings names.
  final bool showCupertinoTrailingValue;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: '$settingsLabel: $settingsValue',
      excludeSemantics: true,
      child: PlatformListTile(
        leading: icon,
        title: _SettingsTitle(title: settingsLabel),
        additionalInfo: showCupertinoTrailingValue ? Text(settingsValue) : null,
        subtitle: Theme.of(context).platform == TargetPlatform.android
            ? Text(
                settingsValue,
                style: TextStyle(
                  color: textShade(context, Styles.subtitleOpacity),
                ),
              )
            : explanation != null
                ? Text(explanation!, maxLines: 5)
                : null,
        onTap: onTap,
        trailing: Theme.of(context).platform == TargetPlatform.iOS
            ? const CupertinoListTileChevron()
            : explanation != null
                ? _SettingsInfoTooltip(
                    message: explanation!,
                    child: const Icon(Icons.info_outline),
                  )
                : null,
      ),
    );
  }
}

class SwitchSettingTile extends StatelessWidget {
  const SwitchSettingTile({
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.leading,
    super.key,
  });

  final Text title;
  final Widget? subtitle;
  final bool value;
  final void Function(bool value)? onChanged;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: leading,
      title: _SettingsTitle(title: title),
      subtitle: subtitle,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        applyCupertinoTheme: true,
      ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).platform == TargetPlatform.iOS
          ? TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            )
          : null,
    );
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
      triggerMode: TooltipTriggerMode.tap,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      showDuration: const Duration(seconds: 4),
      child: child,
    );
  }
}

class _SettingsTitle extends StatelessWidget {
  const _SettingsTitle({required this.title});

  final Text title;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      // forces iOS default font size
      style: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontSize: 17.0,
              )
          : null,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      child: Text.rich(
        TextSpan(
          children: [
            title.textSpan ?? TextSpan(text: title.data),
          ],
        ),
      ),
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
    this.notchedTile = true,
    this.showDividerBetweenTiles = false,
  });

  final List<T> choices;
  final T selectedItem;
  final Widget Function(T choice) titleBuilder;
  final Widget Function(T choice)? subtitleBuilder;
  final Widget Function(T choice)? leadingBuilder;
  final void Function(T choice)? onSelectedItemChanged;

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
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        final tiles = choices.map((value) {
          return ListTile(
            selected: selectedItem == value,
            trailing: selectedItem == value ? const Icon(Icons.check) : null,
            contentPadding: tileContentPadding,
            title: titleBuilder(value),
            subtitle: subtitleBuilder?.call(value),
            leading: leadingBuilder?.call(value),
            onTap: onSelectedItemChanged != null
                ? () => onSelectedItemChanged!(value)
                : null,
          );
        });
        return Opacity(
          opacity: onSelectedItemChanged != null ? 1.0 : 0.5,
          child: Column(
            children: [
              if (showDividerBetweenTiles)
                ...ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                )
              else
                ...tiles,
            ],
          ),
        );
      case TargetPlatform.iOS:
        final tileConstructor =
            notchedTile ? CupertinoListTile.notched : CupertinoListTile.new;
        return Padding(
          padding: margin ?? Styles.bodySectionPadding,
          child: Opacity(
            opacity: onSelectedItemChanged != null ? 1.0 : 0.5,
            child: CupertinoListSection.insetGrouped(
              backgroundColor:
                  CupertinoTheme.of(context).scaffoldBackgroundColor,
              decoration: BoxDecoration(
                color: Styles.cupertinoCardColor.resolveFrom(context),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              separatorColor:
                  Styles.cupertinoSeparatorColor.resolveFrom(context),
              margin: EdgeInsets.zero,
              additionalDividerMargin: notchedTile ? null : 6.0,
              hasLeading: leadingBuilder != null,
              children: choices.map((value) {
                return tileConstructor(
                  trailing: selectedItem == value
                      ? const Icon(CupertinoIcons.check_mark_circled_solid)
                      : null,
                  title: titleBuilder(value),
                  subtitle: subtitleBuilder?.call(value),
                  leading: leadingBuilder?.call(value),
                  onTap: onSelectedItemChanged != null
                      ? () => onSelectedItemChanged!(value)
                      : null,
                );
              }).toList(growable: false),
            ),
          ),
        );
      default:
        assert(false, 'Unexpected platform ${Theme.of(context).platform}');
        return const SizedBox.shrink();
    }
  }
}
