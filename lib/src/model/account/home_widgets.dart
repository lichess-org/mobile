import 'package:lichess_mobile/l10n/l10n.dart';

/// Enum representing the editable widgets on the home screen.
enum HomeEditableWidget(
  /// True if the widget should always be enabled and cannot be disabled.
  final bool alwaysEnabled,
) {
  hello(false),
  perfCards(false),
  friends(false),
  ongoingGames(true),
  puzzles(false),
  blogCarousel(false),
  quickPairing(false),
  featuredTournaments(false),
  recentGames(false);

  String label(AppLocalizations l10n) => switch (this) {
    // not shown in the UI, so no need to localize
    HomeEditableWidget.ongoingGames => 'Ongoing Games',
    HomeEditableWidget.hello => l10n.mobileHello,
    // not shown in the UI, so no need to localize
    HomeEditableWidget.perfCards => 'Performance Cards',
    HomeEditableWidget.friends => l10n.friends,
    HomeEditableWidget.puzzles => l10n.puzzlePuzzles,
    HomeEditableWidget.quickPairing => l10n.quickPairing,
    HomeEditableWidget.featuredTournaments => l10n.openTournaments,
    HomeEditableWidget.recentGames => l10n.recentGames,
    HomeEditableWidget.blogCarousel => l10n.blog,
  };
}
