import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

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
    this.showDivider = false,
    this.showDividerBetweenTiles = false,
    this.dense = false,
    this.cupertinoAdditionalDividerMargin,
    this.cupertinoBackgroundColor,
    this.cupertinoBorderRadius,
    this.cupertinoClipBehavior = Clip.hardEdge,
  }) : _isLoading = false;

  ListSection.loading({
    required int itemsNumber,
    bool header = false,
    this.margin,
  })  : children = [
          for (int i = 0; i < itemsNumber; i++) const SizedBox.shrink(),
        ],
        headerTrailing = null,
        header = header ? const SizedBox.shrink() : null,
        hasLeading = false,
        showDivider = false,
        showDividerBetweenTiles = false,
        dense = false,
        cupertinoAdditionalDividerMargin = null,
        cupertinoBackgroundColor = null,
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

  /// Show a [Divider] at the bottom of the section. Only on android.
  final bool showDivider;

  /// Use it to set [ListTileTheme.dense] property. Only on Android.
  final bool dense;

  /// See [CupertinoListSection.additionalDividerMargin].
  final double? cupertinoAdditionalDividerMargin;

  final Color? cupertinoBackgroundColor;

  final BorderRadiusGeometry? cupertinoBorderRadius;

  final Clip cupertinoClipBehavior;

  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return _isLoading
            ? Padding(
                padding: margin ?? Styles.sectionBottomPadding,
                child: Column(
                  children: [
                    if (header != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Padding(
                padding: margin ?? Styles.sectionBottomPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (header != null)
                      ListTile(
                        dense: true,
                        title: DefaultTextStyle.merge(
                          style: Styles.sectionTitle,
                          child: header!,
                        ),
                        trailing: headerTrailing,
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
                        child: Divider(thickness: 0),
                      ),
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
                        padding: const EdgeInsets.only(top: 10.0, bottom: 16.0),
                        child: Container(
                          width: double.infinity,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      height: children.length * 54,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            DefaultTextStyle.merge(
                              style: Styles.sectionTitle,
                              child: header!,
                            ),
                            if (headerTrailing != null) headerTrailing!,
                          ],
                        ),
                      ),
                    CupertinoListSection.insetGrouped(
                      clipBehavior: cupertinoClipBehavior,
                      backgroundColor: cupertinoBackgroundColor ??
                          CupertinoTheme.of(context).scaffoldBackgroundColor,
                      decoration: BoxDecoration(
                        color: cupertinoBackgroundColor ??
                            Styles.cupertinoCardColor.resolveFrom(context),
                        borderRadius: cupertinoBorderRadius ??
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      separatorColor:
                          Styles.cupertinoSeparatorColor.resolveFrom(context),
                      margin: EdgeInsets.zero,
                      hasLeading: hasLeading,
                      additionalDividerMargin: cupertinoAdditionalDividerMargin,
                      children: children,
                    ),
                  ],
                ),
              );
      default:
        assert(false, 'Unexpected platform ${Theme.of(context).platform}');
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
            color: color ?? CupertinoColors.separator.resolveFrom(context),
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
    this.cupertinoBackgroundColor,
    this.visualDensity,
    this.harmonizeCupertinoTitleStyle = false,
    super.key,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  final EdgeInsetsGeometry? padding;

  final Color? cupertinoBackgroundColor;

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
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return ListTile(
          leading: leading,
          title: title,
          iconColor: Theme.of(context).colorScheme.outline,
          subtitle: subtitle != null
              ? DefaultTextStyle.merge(
                  child: subtitle!,
                  style: TextStyle(
                    color: textShade(context, Styles.subtitleOpacity),
                  ),
                )
              : null,
          trailing: trailing,
          dense: dense,
          visualDensity: visualDensity,
          onTap: onTap,
          onLongPress: onLongPress,
          selected: selected,
          isThreeLine: isThreeLine,
          contentPadding: padding,
        );
      case TargetPlatform.iOS:
        return IconTheme(
          data: CupertinoIconThemeData(
            color: CupertinoColors.systemGrey.resolveFrom(context),
          ),
          child: GestureDetector(
            onLongPress: onLongPress,
            child: CupertinoListTile.notched(
              backgroundColor: cupertinoBackgroundColor,
              leading: leading,
              title: harmonizeCupertinoTitleStyle
                  ? DefaultTextStyle.merge(
                      // see: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/list_tile.dart
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                      child: title,
                    )
                  : title,
              subtitle: subtitle,
              trailing: trailing ??
                  (selected == true
                      ? const Icon(CupertinoIcons.check_mark_circled_solid)
                      : null),
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
    super.key,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: Theme.of(context).platform == TargetPlatform.iOS
              ? NoSplash.splashFactory
              : null,
        ),
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}

typedef RemovedItemBuilder<T> = Widget Function(
  T item,
  BuildContext context,
  Animation<double> animation,
);

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
  })  : _items = List<E>.from(initialItems ?? <E>[]),
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
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
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
  })  : _items = List<E>.from(initialItems ?? <E>[]),
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
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length + itemsOffset;

  E operator [](int index) => _items[index - itemsOffset];

  int indexOf(E item) => _items.indexOf(item) + itemsOffset;
}
