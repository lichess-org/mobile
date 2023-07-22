import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:lichess_mobile/src/model/auth/auth_socket.dart';

part 'ping_rating.g.dart';

const spinKit = SpinKitThreeBounce(
  color: Colors.grey,
  size: 15,
);

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

    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          SignalStrengthIndicator.bars(
            barCount: 4,
            minValue: 1,
            maxValue: 4,
            value: pingRating,
            size: size,
            inactiveColor: defaultTargetPlatform == TargetPlatform.iOS
                ? CupertinoDynamicColor.resolve(
                    CupertinoColors.systemGrey,
                    context,
                  ).withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            levels: defaultTargetPlatform == TargetPlatform.iOS
                ? cupertinoLevels
                : materialLevels,
          ),
          if (pingRating == 0) spinKit,
        ],
      ),
    );
  }
}
