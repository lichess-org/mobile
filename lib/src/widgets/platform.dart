import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    super.key,
    required this.androidBuilder,
    required this.iosBuilder,
  });

  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

typedef ConsumerWidgetBuilder = Widget Function(
  BuildContext context,
  WidgetRef ref,
);

/// A widget that builds different things on different platforms with riverpod.
class ConsumerPlatformWidget extends StatelessWidget {
  const ConsumerPlatformWidget({
    super.key,
    required this.ref,
    required this.androidBuilder,
    required this.iosBuilder,
  });

  final WidgetRef ref;
  final ConsumerWidgetBuilder androidBuilder;
  final ConsumerWidgetBuilder iosBuilder;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return androidBuilder(context, ref);
      case TargetPlatform.iOS:
        return iosBuilder(context, ref);
      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}

/// A card with limited text scale factor and whose style is adapted to platforms.
class PlatformCard extends StatelessWidget {
  const PlatformCard({
    super.key,
    required this.child,
    this.margin,
    this.semanticContainer = true,
  });

  final Widget child;
  final bool semanticContainer;

  /// The empty space that surrounds the card.
  ///
  /// Defines the card's outer [Container.margin].
  ///
  /// If this property is null then default [Card.margin] is used on android and
  /// [EdgeInsets.zero] on iOS.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final cupertinoBrightness =
        CupertinoTheme.maybeBrightnessOf(context) ?? Brightness.light;
    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaleFactor: math.min(
          mediaQueryData.textScaleFactor,
          1.64,
        ),
      ),
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? Card(
              margin: margin ?? EdgeInsets.zero,
              elevation: 0,
              color: cupertinoBrightness == Brightness.light
                  ? CupertinoColors.systemBackground
                  : CupertinoColors.secondarySystemBackground
                      .resolveFrom(context),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              semanticContainer: semanticContainer,
              child: child,
            )
          : Card(
              semanticContainer: semanticContainer,
              margin: margin,
              child: child,
            ),
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
    this.selected = false,
    this.notched = true,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  /// only on iOS
  final Widget? additionalInfo;

  /// only on iOS, will use the [CupertinoListTile.notched] constructor
  final bool notched;

  // only on android
  final bool selected;

  // only on android
  final bool? dense;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          dense: dense,
          onTap: onTap,
          selected: selected,
        );
      case TargetPlatform.iOS:
        final theme = ListTileTheme.of(context);
        return (notched == false || theme.dense == true)
            ? CupertinoListTile(
                leading: leading,
                title: title,
                subtitle: subtitle,
                trailing: trailing,
                additionalInfo: additionalInfo,
                onTap: onTap,
              )
            : CupertinoListTile.notched(
                leading: leading,
                title: title,
                subtitle: subtitle,
                trailing: trailing,
                additionalInfo: additionalInfo,
                onTap: onTap,
              );

      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
