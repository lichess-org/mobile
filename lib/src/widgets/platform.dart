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
  Widget build(context) {
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
    BuildContext context, WidgetRef ref);

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
  Widget build(context) {
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
class PlatformCard<T extends Enum> extends StatelessWidget {
  const PlatformCard({
    super.key,
    required this.child,
  });

  final Widget child;

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
        child: child,
      ),
    );
  }
}
