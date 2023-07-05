import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';

part 'ping_rating.g.dart';

@riverpod
int pingRating(PingRatingRef ref) {
  final ping = ref.watch(averageLagProvider).inMicroseconds / 1000;

  return ping == 0
      ? 0
      : ping < 150
          ? 4
          : ping < 300
              ? 3
              : ping < 500
                  ? 2
                  : 1;
}

class PingRating extends ConsumerWidget {
  const PingRating({
    required this.size,
    super.key,
  });

  final double size;

  static const cupertinoLevels = {
    0: CupertinoColors.systemRed,
    1: CupertinoColors.systemYellow,
    2: CupertinoColors.systemGreen,
    3: CupertinoColors.systemGreen,
  };

  static const materialLevels = {
    0: Colors.red,
    1: Colors.yellow,
    2: Colors.green,
    3: Colors.green,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pingRating = ref.watch(pingRatingProvider);

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return SignalStrengthIndicator.bars(
          barCount: 4,
          minValue: 1,
          maxValue: 4,
          value: pingRating,
          size: size,
          inactiveColor: Colors.grey,
          levels: materialLevels,
        );
      case TargetPlatform.iOS:
        return SignalStrengthIndicator.bars(
          barCount: 4,
          minValue: 1,
          maxValue: 4,
          value: pingRating,
          size: size,
          inactiveColor: CupertinoColors.systemGrey2,
          levels: cupertinoLevels,
        );

      default:
        assert(false, 'Unexpected platform $defaultTargetPlatform');
        return const SizedBox.shrink();
    }
  }
}
