import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/socket.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
final pingRatingProvider = Provider.autoDispose<int>((ref) {
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
});

class SocketPingRating extends ConsumerWidget {
  const SocketPingRating({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pingRating = ref.watch(pingRatingProvider);

    return LagIndicator(lagRating: pingRating, size: size, showLoadingIndicator: true);
  }
}
