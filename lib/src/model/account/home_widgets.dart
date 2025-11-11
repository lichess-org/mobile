import 'package:lichess_mobile/l10n/l10n.dart';

/// Enum representing the editable widgets on the home screen.
enum HomeEditableWidget {
  hello(false),
  perfCards(false),
  ongoingGames(true),
  blogCarousel(false),
  quickPairing(false),
  featuredTournaments(false),
  recentGames(false);

  String label(AppLocalizations l10n) => switch (this) {
    HomeEditableWidget.ongoingGames => 'Ongoing Games',
    HomeEditableWidget.hello => 'Hello',
    HomeEditableWidget.perfCards => 'Performance Cards',
    HomeEditableWidget.quickPairing => l10n.quickPairing,
    HomeEditableWidget.featuredTournaments => l10n.openTournaments,
    HomeEditableWidget.recentGames => l10n.recentGames,
    HomeEditableWidget.blogCarousel => l10n.blog,
  };

  const HomeEditableWidget(this.alwaysEnabled);

  /// True if the widget should always be enabled and cannot be disabled.
  final bool alwaysEnabled;
}
