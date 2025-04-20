import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

/// A platform agnostic list section.
///
/// Use to show a limited number of items.
class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.children,
    this.header,
    this.onHeaderTap,
    this.headerTrailing,
    this.footer,
    this.margin,
    this.hasLeading = false,
    this.leadingIndent,
    this.dense = false,
    this.materialFilledCard = false,
    this.backgroundColor,
  }) : _isLoading = false;

  ListSection.loading({
    required int itemsNumber,
    bool header = false,
    this.margin,
    this.hasLeading = false,
  }) : children = [for (int i = 0; i < itemsNumber; i++) const SizedBox.shrink()],
       onHeaderTap = null,
       headerTrailing = null,
       header = header ? const SizedBox.shrink() : null,
       footer = null,
       dense = false,
       leadingIndent = null,
       materialFilledCard = false,
       backgroundColor = null,
       _isLoading = true;

  /// Usually a list of [ListTile] widgets
  final List<Widget> children;

  /// Whether the iOS tiles have a leading widget.
  final bool hasLeading;

  /// Cupertino leading indent.
  final double? leadingIndent;

  /// Show a header above the children rows. Typically a [Text] widget.
  final Widget? header;

  /// A callback to be called when the header is tapped.
  final VoidCallback? onHeaderTap;

  /// A widget to show at the end of the header (only if [onHeaderTap] is null).
  final Widget? headerTrailing;

  /// A widget to show at the end of the section.
  final Widget? footer;

  final EdgeInsetsGeometry? margin;

  /// Whether the card should have a filled background.
  final bool materialFilledCard;

  /// Use it to set [ListTileTheme.dense] property.
  final bool dense;

  final Color? backgroundColor;

  final bool _isLoading;

  static const double materialVerticalPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.64,
      child:
          _isLoading
              ? Column(
                children: [
                  (materialFilledCard == true ? Card.filled : Card.new)(
                    clipBehavior: Clip.hardEdge,
                    margin: margin ?? Styles.bodySectionPadding,
                    color: backgroundColor,
                    child: Column(
                      children: [
                        const SizedBox(height: materialVerticalPadding),
                        if (header != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            child: Container(
                              width: double.infinity,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                            ),
                          ),
                        for (int i = 0; i < children.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        const SizedBox(height: materialVerticalPadding),
                      ],
                    ),
                  ),
                ],
              )
              : Padding(
                padding: margin ?? Styles.bodySectionPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (header != null)
                      ListSectionHeader(
                        title: header!,
                        onTap: onHeaderTap,
                        trailing: headerTrailing,
                      ),
                    (materialFilledCard ? Card.filled : Card.new)(
                      clipBehavior: Clip.hardEdge,
                      color: backgroundColor,
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Theme.of(context).platform == TargetPlatform.iOS)
                            ..._divideTiles(
                              context: context,
                              tiles: children,
                              cupertinoHasLeading: hasLeading,
                              cupertinoLeadingIndent: leadingIndent,
                            )
                          else
                            ...children,
                        ],
                      ),
                    ),
                    if (footer != null) footer!,
                  ],
                ),
              ),
    );
  }

  static Iterable<Widget> _divideTiles({
    required BuildContext context,
    required Iterable<Widget> tiles,
    bool cupertinoHasLeading = false,
    double? cupertinoLeadingIndent,
  }) {
    tiles = tiles.toList();

    if (tiles.isEmpty || tiles.length == 1) {
      return tiles;
    }

    final List<Widget> result = [];
    for (int i = 0; i < tiles.length; i++) {
      result.add(tiles.elementAt(i));
      if (i != tiles.length - 1) {
        result.add(
          PlatformDivider(
            height: 0,
            cupertinoHasLeading: cupertinoHasLeading,
            cupertinoLeadingIndent: cupertinoLeadingIndent,
          ),
        );
      }
    }
    return result;
  }
}

/// A header for a [ListSection].
class ListSectionHeader extends StatelessWidget {
  const ListSectionHeader({super.key, required this.title, this.onTap, this.trailing});

  final Widget title;

  /// A callback to be called when the header is tapped.
  final VoidCallback? onTap;

  /// A widget to show at the end of the header (only if [onTap] is null).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: DefaultTextStyle.merge(style: Styles.sectionTitle, child: title)),
            if (onTap != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.more, style: TextStyle(color: ColorScheme.of(context).primary)),
                  Icon(Icons.chevron_right, size: 16, color: ColorScheme.of(context).primary),
                ],
              )
            else if (trailing != null)
              trailing!,
          ],
        ),
      ),
    );
  }
}

/// Platform agnostic divider widget.
///
/// Useful to show a divider between [ListTile] widgets when using the
/// [ListView.separated] constructor.
class PlatformDivider extends StatelessWidget {
  const PlatformDivider({
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.cupertinoHasLeading = false,
    this.cupertinoLeadingIndent,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  /// Set to true if the cupertino tiles have a leading widget, to adapt the
  /// divider margin.
  final bool cupertinoHasLeading;
  final double? cupertinoLeadingIndent;

  static const _defaultListTileLeadingWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? Divider(
          height: height,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: color,
        )
        : Divider(
          height: height,
          thickness: thickness ?? 0.0,
          indent:
              indent ??
              (cupertinoHasLeading
                  ? 16.0 + (cupertinoLeadingIndent ?? _defaultListTileLeadingWidth)
                  : 16.0),
          endIndent: endIndent,
          color: color,
        );
  }
}

typedef RemovedItemBuilder<T> =
    Widget Function(T item, BuildContext context, Animation<double> animation);

/// Keeps a Dart [List] in sync with an [AnimatedList] or [SliverAnimatedList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
class AnimatedListModel<E> {
  AnimatedListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
    int? itemsOffset,
  }) : _items = List<E>.from(initialItems ?? <E>[]),
       itemsOffset = itemsOffset ?? 0;

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;
  final int itemsOffset;

  AnimatedListState? get _animatedList => listKey.currentState;

  void prepend(E item) {
    _items.insert(0, item);
    _animatedList!.insertItem(itemsOffset);
  }

  void insert(int index, E item) {
    _items.insert(index - itemsOffset, item);
    _animatedList!.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index - itemsOffset);
    if (removedItem != null) {
      _animatedList!.removeItem(index, (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length + itemsOffset;

  E operator [](int index) => _items[index - itemsOffset];

  int indexOf(E item) => _items.indexOf(item) + itemsOffset;
}

/// Keeps a Dart [List] in sync with a [SliverAnimatedList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
class SliverAnimatedListModel<E> {
  SliverAnimatedListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
    int? itemsOffset,
  }) : _items = List<E>.from(initialItems ?? <E>[]),
       itemsOffset = itemsOffset ?? 0;

  final GlobalKey<SliverAnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;
  final int itemsOffset;

  SliverAnimatedListState? get _animatedList => listKey.currentState;

  void prepend(E item) {
    _items.insert(0, item);
    _animatedList!.insertItem(itemsOffset);
  }

  void insert(int index, E item) {
    _items.insert(index - itemsOffset, item);
    _animatedList!.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index - itemsOffset);
    if (removedItem != null) {
      _animatedList!.removeItem(index, (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length + itemsOffset;

  E operator [](int index) => _items[index - itemsOffset];

  int indexOf(E item) => _items.indexOf(item) + itemsOffset;
}
