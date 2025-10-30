import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/account/account_preferences.dart';

/// A widget that knows if the user has enabled ratings in their settings.
class RatingPrefAware extends ConsumerWidget {
  /// Creates a widget that displays its [child] only if the user has enabled ratings
  /// in their settings.
  ///
  /// Optionally, a different [orElse] widget can be displayed if ratings are disabled.
  ///
  /// If the user has chosen [ShowRatings.exceptInGame] in their settings,
  /// the [child] will be hidden if and only if [isActiveGameOfCurrentUser] is true.
  /// Set this to `true` if the widget is being used in a screen that shows an active game.
  const RatingPrefAware({
    required this.child,
    this.orElse = const SizedBox.shrink(),
    this.isActiveGameOfCurrentUser = false,
    super.key,
  });

  final Widget child;
  final Widget orElse;
  final bool isActiveGameOfCurrentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showRatingAsync = ref.watch(showRatingsPrefProvider);

    return switch (showRatingAsync) {
      AsyncData(value: ShowRatings.yes) => child,
      AsyncData(value: ShowRatings.exceptInGame) => isActiveGameOfCurrentUser ? orElse : child,
      _ => orElse,
    };
  }
}
