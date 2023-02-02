import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform.dart';

import '../utils/style.dart';

/// A platform agnostic choice picker component.
class ListTileChoice<T extends Enum> extends StatelessWidget {
  const ListTileChoice({
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
        return PlatformCard(
          child: Column(
            children: ListTile.divideTiles(
              color: dividerColor(context),
              context: context,
              tiles: choices.map((value) {
                return PlatformListTile(
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
