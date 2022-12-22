import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A choice picker component that displays a [Card] with [ListTile] as items.
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
  Widget build(context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaleFactor: math.min(
          mediaQueryData.textScaleFactor,
          1.64,
        ),
      ),
      child: Card(
        elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0 : null,
        margin: EdgeInsets.zero,
        shape: defaultTargetPlatform == TargetPlatform.iOS
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))
            : null,
        color: defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoDynamicColor.resolve(
                CupertinoColors.secondarySystemBackground, context)
            : null,
        child: Column(
          children: ListTile.divideTiles(
              context: context,
              tiles: choices.map((value) {
                return ListTile(
                  trailing:
                      selectedItem == value ? const Icon(Icons.check) : null,
                  title: titleBuilder(value),
                  subtitle: subtitleBuilder?.call(value),
                  onTap: () => onSelectedItemChanged(value),
                );
              })).toList(growable: false),
        ),
      ),
    );
  }
}
