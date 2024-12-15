import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/styles/styles.dart';

/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({super.key, required this.androidBuilder, required this.iosBuilder});

  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return androidBuilder(context);
      case TargetPlatform.iOS:
        return iosBuilder(context);
      default:
        assert(false, 'Unexpected platform ${Theme.of(context).platform}');
        return const SizedBox.shrink();
    }
  }
}

typedef ConsumerWidgetBuilder = Widget Function(BuildContext context, WidgetRef ref);

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
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return androidBuilder(context, ref);
      case TargetPlatform.iOS:
        return iosBuilder(context, ref);
      default:
        assert(false, 'Unexpected platform ${Theme.of(context).platform}');
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
    this.borderRadius,
    this.elevation,
    this.color,
    this.shadowColor,
    this.clipBehavior,
  });

  final Widget child;
  final bool semanticContainer;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final Color? shadowColor;
  final Clip? clipBehavior;

  /// The empty space that surrounds the card.
  ///
  /// Defines the card's outer [Container.margin].
  ///
  /// If this property is null then default [Card.margin] is used on android and
  /// [EdgeInsets.zero] on iOS.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: kCardTextScaleFactor,
      child:
          Theme.of(context).platform == TargetPlatform.iOS
              ? Card(
                margin: margin ?? EdgeInsets.zero,
                elevation: elevation ?? 0,
                color: color ?? Styles.cupertinoCardColor.resolveFrom(context),
                shadowColor: shadowColor,
                shape:
                    borderRadius != null
                        ? RoundedRectangleBorder(borderRadius: borderRadius!)
                        : const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                semanticContainer: semanticContainer,
                clipBehavior: clipBehavior,
                child: child,
              )
              : Card(
                shape:
                    borderRadius != null
                        ? RoundedRectangleBorder(borderRadius: borderRadius!)
                        : const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                color: color,
                shadowColor: shadowColor,
                semanticContainer: semanticContainer,
                elevation: elevation,
                margin: margin,
                clipBehavior: clipBehavior,
                child: child,
              ),
    );
  }
}
