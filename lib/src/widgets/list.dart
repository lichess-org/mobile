import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/styles.dart';

const _kTitleMedium = TextStyle(
  fontSize: 18,
  letterSpacing: .25,
);

/// A platform agnostic list section.
///
/// Use to show a limited number of items.
class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.children,
    this.header,
    this.onHeaderTap,
    this.margin,
    this.hasLeading = false,
    this.showDivider = false,
    this.showDividerBetweenTiles = false,
    this.dense = false,
  });

  /// Usually a list of [PlatformListTile] widgets
  final List<Widget> children;

  /// Only useful on iOS
  final bool hasLeading;

  /// Show a header above the children rows. Typically a [Text] widget.
  final Widget? header;
  final GestureTapCallback? onHeaderTap;

  final EdgeInsetsGeometry? margin;

  /// Only on android.
  final bool showDividerBetweenTiles;

  /// Show a [Divider] at the bottom of the section. Only on android.
  final bool showDivider;

  /// Use it to set [ListTileTheme.dense] property. Only on Android.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null)
              ListTile(
                title: DefaultTextStyle(
                  style: _kTitleMedium,
                  child: header!,
                ),
                trailing: (onHeaderTap != null)
                    ? GestureDetector(
                        onTap: onHeaderTap,
                        child: const Icon(Icons.more_horiz),
                      )
                    : null,
              ),
            if (showDividerBetweenTiles)
              ...ListTile.divideTiles(
                context: context,
                tiles: children,
              )
            else
              ...children,
            if (showDivider)
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Divider(),
              ),
          ],
        );
      case TargetPlatform.iOS:
        return CupertinoListSection.insetGrouped(
          margin: margin,
          hasLeading: hasLeading,
          header: header != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    header!,
                    if (onHeaderTap != null)
                      GestureDetector(
                        onTap: onHeaderTap,
                        child: const Icon(CupertinoIcons.ellipsis),
                      ),
                  ],
                )
              : null,
          children: children,
        );
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// A tappable [ListTile] that represents a settings value.
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
