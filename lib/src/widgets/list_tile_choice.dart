import 'package:flutter/material.dart';
import 'platform.dart';

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
    return PlatformCard(
      child: Column(
        children: ListTile.divideTiles(
            context: context,
            tiles: choices.map((value) {
              return ListTile(
                selected: selectedItem == value,
                trailing:
                    selectedItem == value ? const Icon(Icons.check) : null,
                title: titleBuilder(value),
                subtitle: subtitleBuilder?.call(value),
                onTap: () => onSelectedItemChanged(value),
              );
            })).toList(growable: false),
      ),
    );
  }
}
