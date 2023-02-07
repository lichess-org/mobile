import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lichess_mobile/src/common/styles.dart';

/// A platform agnostic list section.
class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.children,
    this.header,
    this.hasLeading = false,
  });

  /// Usually a list of [PlatformListTile] widgets
  final List<Widget> children;

  /// Only useful on iOS
  final bool hasLeading;

  /// Show a header above the children rows. Typically a [Text] widget.
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Padding(
          padding: Styles.sectionEdgePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (header != null) header!,
              ...ListTile.divideTiles(
                context: context,
                tiles: children,
              )
            ],
          ),
        );
      case TargetPlatform.iOS:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoListSection.insetGrouped(
              hasLeading: hasLeading,
              header: header,
              children: children,
            ),
          ],
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
    required this.icon,
    required this.settingsLabel,
    required this.settingsValue,
    required this.onTap,
    super.key,
  });

  final Icon icon;
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
            trailing: const Icon(Icons.keyboard_arrow_right),
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
