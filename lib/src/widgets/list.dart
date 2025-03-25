import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/widgets/platform.dart' show PlatformCard;

/// A platform agnostic list section.
///
/// Use to show a limited number of items.
class ListSection extends StatelessWidget {
  const ListSection({
    super.key,
    required this.children,
    this.header,
    this.headerTrailing,
    this.margin,
    this.hasLeading = false,
    this.showDividerBetweenTiles = false,
    this.dense = false,
    this.materialFilledCard = false,
    this.cupertinoAdditionalDividerMargin,
    this.backgroundColor,
    this.cupertinoBorderRadius,
    this.cupertinoClipBehavior = Clip.hardEdge,
  }) : _isLoading = false;

  ListSection.loading({
    required int itemsNumber,
    bool header = false,
    this.margin,
    this.hasLeading = false,
  }) : children = [for (int i = 0; i < itemsNumber; i++) const SizedBox.shrink()],
       headerTrailing = null,
       header = header ? const SizedBox.shrink() : null,
       showDividerBetweenTiles = false,
       dense = false,
       materialFilledCard = false,
       cupertinoAdditionalDividerMargin = null,
       backgroundColor = null,
       cupertinoBorderRadius = null,
       cupertinoClipBehavior = Clip.hardEdge,
       _isLoading = true;

  /// Usually a list of [PlatformListTile] widgets
  final List<Widget> children;

  /// Whether the iOS tiles have a leading widget.
  final bool hasLeading;

  /// Show a header above the children rows. Typically a [Text] widget.
  final Widget? header;

  /// A widget to show at the end of the header.
  final Widget? headerTrailing;

  final EdgeInsetsGeometry? margin;

  /// Only on android.
  final bool showDividerBetweenTiles;

  /// Whether the card should have a filled background. (Only on Android).
  final bool materialFilledCard;

  /// Use it to set [ListTileTheme.dense] property. Only on Android.
  final bool dense;

  /// See [CupertinoListSection.additionalDividerMargin].
  final double? cupertinoAdditionalDividerMargin;

  final Color? backgroundColor;

  final BorderRadiusGeometry? cupertinoBorderRadius;

  final Clip cupertinoClipBehavior;

  final bool _isLoading;

  static const double materialVerticalPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
        return _isLoading
            ? Column(
              children: [
                PlatformCard(
                  filled: materialFilledCard,
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
            : PlatformCard(
              filled: materialFilledCard,
              clipBehavior: Clip.hardEdge,
              margin: margin ?? Styles.bodySectionPadding,
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: materialVerticalPadding),
                  if (header != null)
                    ListTile(
                      dense: true,
                      title: DefaultTextStyle.merge(style: Styles.sectionTitle, child: header!),
                      trailing: headerTrailing,
                    ),
                  if (showDividerBetweenTiles)
                    ...ListTile.divideTiles(context: context, tiles: children)
                  else
                    ...children,
                  const SizedBox(height: materialVerticalPadding),
                ],
              ),
            );
      case TargetPlatform.iOS:
        return _isLoading
            ? Padding(
              padding: margin ?? Styles.bodySectionPadding,
              child: Column(
                children: [
                  if (header != null)
                    // ignore: avoid-wrapping-in-padding
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                        width: double.infinity,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                  for (int i = 0; i < children.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          if (hasLeading) ...[
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: Container(
                              height: 46,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
            : Padding(
              padding: margin ?? Styles.bodySectionPadding,
              child: Column(
                children: [
                  if (header != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultTextStyle.merge(style: Styles.sectionTitle, child: header!),
                          if (headerTrailing != null) headerTrailing!,
                        ],
                      ),
                    ),
                  CupertinoListSection.insetGrouped(
                    clipBehavior: cupertinoClipBehavior,
                    backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
                    decoration: BoxDecoration(
                      color:
                          backgroundColor ??
                          theme.cardTheme.color ??
                          theme.colorScheme.surfaceContainerLow,
                      borderRadius:
                          cupertinoBorderRadius ?? const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    separatorColor: Styles.cupertinoSeparatorColor.resolveFrom(context),
                    margin: EdgeInsets.zero,
                    hasLeading: hasLeading,
                    additionalDividerMargin: cupertinoAdditionalDividerMargin,
                    children: children,
                  ),
                ],
              ),
            );
      default:
        assert(false, 'Unexpected platform ${theme.platform}');
        return const SizedBox.shrink();
    }
  }
}

/// Platform agnostic divider widget.
///
/// Useful to show a divider between [PlatformListTile] widgets when using the
/// [ListView.separated] constructor.
class PlatformDivider extends StatelessWidget {
  const PlatformDivider({
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.cupertinoHasLeading = false,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  /// Set to true if the cupertino tiles have a leading widget, to adapt the
  /// divider margin.
  final bool cupertinoHasLeading;

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
          // see:
          // https://github.com/flutter/flutter/blob/bff6b93683de8be01d53a39b6183f230518541ac/packages/flutter/lib/src/cupertino/list_section.dart#L53
          indent: indent ?? (cupertinoHasLeading ? 14 + 44.0 : 14.0),
          endIndent: endIndent,
          color: color,
        );
  }
}

/// Platform agnostic list tile widget.
///
/// Will use [ListTile] on android and [CupertinoListTile] on iOS.
class PlatformListTile extends StatelessWidget {
  const PlatformListTile({
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.additionalInfo,
    this.dense,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.isThreeLine = false,
    this.padding,
    this.backgroundColor,
    this.visualDensity,
    this.harmonizeCupertinoTitleStyle = false,
    super.key,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;

  /// only on iOS
  final Widget? additionalInfo;

  /// Useful on some screens where ListTiles with and without subtitle are mixed.
  final bool harmonizeCupertinoTitleStyle;

  final bool selected;

  // only on android
  final bool? dense;

  // only on android
  final bool isThreeLine;

  /// Only on android.
  final VisualDensity? visualDensity;

  final GestureTapCallback? onTap;

  // Only on android
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return ListTile(
          leading: leading,
          title: title,
          iconColor: colorScheme.onSurface.withValues(alpha: 0.7),
          subtitle:
              subtitle != null
                  ? DefaultTextStyle.merge(
                    child: subtitle!,
                    style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
                  )
                  : null,
          trailing: trailing,
          dense: dense,
          visualDensity: visualDensity,
          onTap: onTap,
          onLongPress: onLongPress,
          tileColor: backgroundColor,
          selected: selected,
          isThreeLine: isThreeLine,
          contentPadding: padding,
        );
      case TargetPlatform.iOS:
        final activatedColor = Styles.cupertinoListTileBackgroundActivated(context);
        return IconTheme(
          data: CupertinoIconThemeData(color: colorScheme.onSurface.withValues(alpha: 0.7)),
          child: GestureDetector(
            onLongPress: onLongPress,
            child: CupertinoListTile.notched(
              backgroundColor: selected == true ? activatedColor : backgroundColor,
              backgroundColorActivated: activatedColor,
              leading: leading,
              title:
                  harmonizeCupertinoTitleStyle
                      ? DefaultTextStyle.merge(
                        // see: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/list_tile.dart
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                        child: title,
                      )
                      : title,
              subtitle: subtitle,
              trailing:
                  trailing ??
                  (selected == true ? const Icon(CupertinoIcons.check_mark_circled_solid) : null),
              additionalInfo: additionalInfo,
              padding: padding,
              onTap: onTap,
            ),
          ),
        );

      default:
        assert(false, 'Unexpected platform ${Theme.of(context).platform}');
        return const SizedBox.shrink();
    }
  }
}

/// A [ListTile] that adapts to the platform.
///
/// Contrary to [PlatformListTile], this widget uses a [ListTile] on both iOS and
/// Android.
/// On Android the list tile will be displayed without modifications.
/// On iOS the list tile will have a custom splash factory to remove the splash
/// effect.
class AdaptiveListTile extends StatelessWidget {
  const AdaptiveListTile({
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isThreeLine = false,
    this.contentPadding,
    this.selected = false,
    this.dense,
    super.key,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final bool isThreeLine;
  final bool selected;
  final bool? dense;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        selected: selected,
        isThreeLine: isThreeLine,
        contentPadding: contentPadding,
        dense: dense,
      ),
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
