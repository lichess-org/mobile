import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';

/// Provider for managing the edit mode state of home widgets.
final homeWidgetsEditModeProvider = NotifierProvider.autoDispose<_EditModeNotifier, bool>(
  _EditModeNotifier.new,
  name: 'homeWidgetsEditModeProvider',
);

/// Enum representing the editable widgets on the home screen.
enum HomeEditableWidget {
  hello(false),
  perfCards(false),
  ongoingGames(true),
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
  };

  const HomeEditableWidget(this.alwaysEnabled);

  /// True if the widget should always be enabled and cannot be disabled.
  final bool alwaysEnabled;
}

class _EditModeNotifier extends AutoDisposeNotifier<bool> {
  @override
  bool build() => false;

  @override
  set state(bool value) {
    super.state = value;
  }
}
