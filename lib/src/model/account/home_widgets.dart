import 'package:lichess_mobile/l10n/l10n.dart';

/// Enum representing the editable widgets on the home screen.
enum HomeEditableWidget(
  /// True if the widget should always be enabled and cannot be disabled.
  final bool alwaysEnabled,

  /// True if the widget content renders its own section title, in which case the
  /// edit mode row must not repeat it.
  final bool showsOwnTitle,
) {
  hello(false, false),
  perfCards(false, false),
  friends(false, true),
  ongoingGames(true, true),
  blogCarousel(false, true),
  quickPairing(false, true),
  featuredTournaments(false, true),
  recentGames(false, true);

  String label(AppLocalizations l10n) => switch (this) {
    // not shown in the UI, so no need to localize
    HomeEditableWidget.ongoingGames => 'Ongoing Games',
    HomeEditableWidget.hello => l10n.mobileHello,
    // shown in edit mode only, hardcoded until it is worth localizing
    HomeEditableWidget.perfCards => 'Performance Cards',
    HomeEditableWidget.friends => l10n.friends,
    HomeEditableWidget.quickPairing => l10n.quickPairing,
    HomeEditableWidget.featuredTournaments => l10n.openTournaments,
    HomeEditableWidget.recentGames => l10n.recentGames,
    HomeEditableWidget.blogCarousel => l10n.blog,
  };
}
