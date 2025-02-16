import 'package:lichess_mobile/l10n/l10n.dart';

/// Represents the choice of a side as a player: white, black or random.
enum SideChoice {
  white,
  random,
  black;

  String label(AppLocalizations l10n) => switch (this) {
    SideChoice.white => l10n.white,
    SideChoice.random => l10n.randomColor,
    SideChoice.black => l10n.black,
  };
}
