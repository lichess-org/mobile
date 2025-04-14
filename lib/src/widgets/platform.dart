import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PlatformShareIcon extends StatelessWidget {
  const PlatformShareIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (_) => const Icon(Icons.share),
      iosBuilder: (_) => const Icon(Icons.ios_share),
    );
  }
}
