import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/account/account_preferences.dart';

/// A widget that knows if the user has enabled ratings in their settings.
class RatingPrefAware extends ConsumerWidget {
  /// Creates a widget that displays its child only if the user has enabled ratings
  /// in their settings.
  ///
  /// Optionally, a different [orElse] widget can be displayed if ratings are disabled.
  const RatingPrefAware({required this.child, this.orElse, super.key});

  final Widget child;
  final Widget? orElse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showRatingAsync = ref.watch(showRatingsPrefProvider);
    return showRatingAsync.maybeWhen(
      data: (showRatings) {
        if (!showRatings) {
          return orElse ?? const SizedBox.shrink();
        }
        return child;
      },
      orElse: () => orElse ?? const SizedBox.shrink(),
    );
  }
}
